const fs=require('fs'), vm=require('vm'), assert=require('assert');
const html=fs.readFileSync('app/src/main/assets/index.html','utf8');
const scripts=[...html.matchAll(/<script\b[^>]*>([\s\S]*?)<\/script>/gi)].map(m=>m[1]);
assert.strictEqual(scripts.length,2,'scripts != 2');
const listeners=new Map();
const dom=new Map();
const app={innerHTML:''};
const local={
  _m:new Map(),
  get length(){return this._m.size},
  key(i){return [...this._m.keys()][i]??null},
  getItem(k){return this._m.get(k)??null},
  setItem(k,v){this._m.set(String(k),String(v))},
  removeItem(k){this._m.delete(String(k))}
};
const document={
  readyState:'loading',visibilityState:'visible',
  addEventListener(n,f){listeners.set('document:'+n,f)},
  removeEventListener(n,f){if(listeners.get('document:'+n)===f)listeners.delete('document:'+n)},
  getElementById(id){return id==='app'?app:(dom.get(id)||null)},
  createElement(tag){
    const el={tag,id:'',className:'',innerHTML:'',style:{setProperty(){}},appendChild(child){if(child?.id)dom.set(child.id,child)},remove(){if(this.id)dom.delete(this.id)},setPointerCapture(){},addEventListener(){},querySelector(){return null},getBoundingClientRect(){return {left:0,top:0,width:100,height:100}}};
    return el;
  },
  body:{appendChild(el){if(el?.id)dom.set(el.id,el)}}
};
const windowObj={
  navigator:{onLine:true},
  addEventListener(n,f){let arr=listeners.get(n)||[];arr.push(f);listeners.set(n,arr)},
  removeEventListener(n,f){const arr=listeners.get(n)||[];listeners.set(n,arr.filter(x=>x!==f))},
  EnredadosImmersiveDice:{destroy(){},mountFromDOM(){}},
  matchMedia(){return {matches:false}},
  localStorage:local,
  setTimeout,clearTimeout,setInterval,clearInterval,
};
const crypto={randomUUID:()=>Math.random().toString(16).slice(2)};
const ctx={window:windowObj,document,navigator:windowObj.navigator,localStorage:local,crypto,console,
  setTimeout,clearTimeout,setInterval,clearInterval,requestAnimationFrame:()=>0,
  Math,Date,JSON,URL,URLSearchParams,encodeURIComponent,decodeURIComponent,Error,Promise,
  String,Number,Boolean,Array,Object,parseInt,parseFloat,Intl,fetch:async()=>{throw new Error('fetch disabled in local test')}};
vm.createContext(ctx);
for(const code of scripts) vm.runInContext(code,ctx,{timeout:10000});
function run(expr){return vm.runInContext(expr,ctx,{timeout:10000})}
run('S=normalize(blank())');
const names=run('NAMES.slice()');
const expectedGoals=run('Object.assign({}, {1:20,2:15,3:10,4:15,5:100,6:20,7:57,8:10,9:15,10:10})');

for(let n=1;n<=10;n++){
  run(`S=normalize(blank());S.p=['A','B'];S.score=[0,0];S.level=${n};S.turn=0;S.progress=0;S.screen='game';init(${n})`);
  const out=run('game()');
  const outer=(out.match(/<div class="screen visual-skin visual-skin-[^"]+">/g)||[]).length;
  const nested=(out.match(/<div class="screen">/g)||[]).length;
  assert.strictEqual(outer,1,`level ${n}: outer screen ${outer}`);
  assert.strictEqual(nested,0,`level ${n}: nested screen ${nested}`);
  assert.strictEqual(run(`goal(${n})`),expectedGoals[n],`level ${n}: goal mismatch`);
  console.log(`LEVEL ${n}: renderer OK · goal ${expectedGoals[n]}`);
}

// Campaign/Home/Prepare Game contract.
const setupMarkup=run("S=normalize(blank());S.screen='setup';setup()");
assert.ok(setupMarkup.includes('id="p1"')&&setupMarkup.includes('id="p2"'),'prepare local player inputs missing');
assert.ok(setupMarkup.includes('id="hostName"'),'prepare host input missing');
assert.ok(!setupMarkup.includes('startMinigame('),'campaign setup exposes minigame selector');
assert.ok(!setupMarkup.includes('selectorNivel'),'campaign setup exposes legacy selector');
dom.set('p1',{value:'Ana'});dom.set('p2',{value:'Luis'});
run("S=normalize(blank());S.screen='setup';S.p=['Jugador 1','Jugador 2'];beginLocal()");
assert.strictEqual(run('S.level'),1,'local game did not start at level 1');
assert.strictEqual(run('S.screen'),'game','local game did not enter game screen');
assert.strictEqual(JSON.stringify(run('S.p')),JSON.stringify(['Ana','Luis']),'local player names not preserved');
assert.strictEqual(run('S.room'),null,'local game unexpectedly has a room');
console.log('PREPARE GAME LOCAL FLOW: OK');

// Logo policy: HOME may show the logo name; level renderers must not inject it.
assert.ok(run("home()").toUpperCase().includes('ENREDADOS'),'home logo missing');
for(let n=1;n<=10;n++){
  run(`S=normalize(blank());S.p=['A','B'];S.score=[0,0];S.level=${n};S.turn=0;S.progress=0;S.screen='game';init(${n})`);
  const markup=run('game()');
  assert.ok(!/ENREDADOS/i.test(markup),`level ${n}: logo/brand leaked into level`);
}
console.log('LOGO ISOLATION: OK');

// In-app Back follows the campaign stack; minigames return to their own hub.
run("S=normalize(blank());S.p=['A','B'];S.score=[0,0];S.level=3;S.screen='game';S.progress=1;init(3);back()");
assert.strictEqual(run('S.screen'),'setup','game Back did not return to prepare screen');
run('back()');
assert.strictEqual(run('S.screen'),'home','setup Back did not return to Home');
run("S=normalize(blank());S.p=['A','B'];S.level=3;S.screen='home';startMinigame(3)");
run('back()');
assert.strictEqual(run('S.screen'),'minigames','minigame Back did not return to minigames');
console.log('NAVIGATION CONTRACT: OK');

// Linear campaign.
run("S=normalize(blank());S.level=1;S.screen='game';S.minigame=null;S.room=null;S.p=['A','B'];S.score=[0,0];S.turn=0;S.progress=0;init(1)");
for(let n=1;n<=9;n++){
  run('next()');
  assert.strictEqual(run('S.level'),n+1,`next ${n}->${n+1}`);
  assert.strictEqual(run('S.screen'),'game');
}
run('next()');
assert.strictEqual(run('S.screen'),'final','level 10 -> final');
console.log('CAMPAIGN LINEAR: OK');

// Minigame isolation/return.
run("S=normalize(blank());S.p=['A','B'];S.level=4;S.screen='game';S.score=[11,22];S.progress=7;init(4);startMinigame(5)");
assert.strictEqual(run('S.minigame.active'),true);
assert.strictEqual(run('S.level'),5);
assert.strictEqual(run('S.screen'),'game');
run('returnToMinigames()');
assert.strictEqual(run('S.screen'),'minigames');
assert.strictEqual(run('S.minigame'),null);
assert.strictEqual(run('S.level'),4);
assert.strictEqual(JSON.stringify(run('S.score.slice()')),JSON.stringify([11,22]));
console.log('MINIGAME ISOLATION: OK');

// Level 5 route must not reintroduce nested .screen and gyro listener must be removable.
run("S=normalize(blank());S.p=['A','B'];S.level=5;S.screen='game';S.route={phase:'explain',pawn:'♥',pos:0,visited:[0],steps:0,animating:false,timer:null,timerRunning:false,timerDone:false,timerStartedAt:0};route();");
let devListeners=listeners.get('deviceorientation')||[];
assert.strictEqual(devListeners.length,1,'gyro listener not bound');
run('stopActiveTimers()');
devListeners=listeners.get('deviceorientation')||[];
assert.strictEqual(devListeners.length,0,'gyro listener not unbound');
console.log('LEVEL 5 GYRO LIFECYCLE: OK');

// Turn-transition overlay must be torn down by central lifecycle cleanup before SPA navigation.
run("S=normalize(blank());S.p=['A','B'];S.score=[0,0];S.screen='game';S.level=3;S.turn=0;S.lock=true;showTurnTransition()" );
assert.ok(run("document.getElementById('turn-transition')!==null"),'turn transition overlay not created');
run('back()');
assert.strictEqual(run("document.getElementById('turn-transition')"),null,'turn transition overlay survived back navigation');
console.log('TURN TRANSITION NAVIGATION CLEANUP: OK');

console.log('MASTER RUNTIME STATIC/HARNESS TEST: PASS');
