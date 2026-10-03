const {spawn}=require('child_process');
const path=require('path');
const base=path.resolve(__dirname,'..');
const port=18788;
const child=spawn(process.execPath,['server.js'],{cwd:base,env:{...process.env,PORT:String(port)},stdio:['ignore','pipe','pipe']});
let logs=''; child.stdout.on('data',d=>logs+=d); child.stderr.on('data',d=>logs+=d);
const sleep=ms=>new Promise(r=>setTimeout(r,ms));
async function req(path,opts={}){if((opts.method||'GET')==='GET')delete opts.body; const r=await fetch(`http://127.0.0.1:${port}${path}`,opts);const text=await r.text();let body;try{body=JSON.parse(text)}catch{body=text}return {status:r.status,body};}
(async()=>{
 try{
  await sleep(500);
  let r=await req('/health');if(r.status!==200||!r.body.ok)throw Error('health');
  r=await req('/api/room/create',{method:'POST',headers:{'content-type':'application/json'},body:JSON.stringify({name:'A'})});if(r.status!==201||!r.body.token)throw Error('create');
  const code=r.body.code, t1=r.body.token;
  r=await req('/api/room/join',{method:'POST',headers:{'content-type':'application/json'},body:JSON.stringify({code,name:'B'})});if(r.status!==200||!r.body.token||r.body.playerIndex!==1)throw Error('join');
  const t2=r.body.token;
  r=await req('/api/room/'+code);if(r.status!==200||r.body.room.players.length!==2)throw Error('get');
  r=await req('/api/room/'+code,{method:'POST',headers:{'content-type':'application/json'},body:JSON.stringify({token:'bad',actor:0,state:{screen:'game',turn:0}})});if(r.status!==403)throw Error('bad token');
  r=await req('/api/room/'+code,{method:'POST',headers:{'content-type':'application/json'},body:JSON.stringify({token:t2,actor:0,state:{screen:'game',turn:0}})});if(r.status!==403)throw Error('bad actor');
  r=await req('/api/room/'+code,{method:'POST',headers:{'content-type':'application/json'},body:JSON.stringify({token:t1,actor:0,state:{screen:'game',turn:1}})});if(r.status!==409)throw Error('bad turn');
  r=await req('/api/room/'+code,{method:'POST',headers:{'content-type':'application/json'},body:JSON.stringify({token:t1,actor:0,state:{screen:'game',turn:0,level:1}})});if(r.status!==200)throw Error('good write');
  for(const legacy of ['/api/create-room','/api/join-room','/api/room/'+code+'/state','/api/room/'+code+'/message','/api/status','/status']){
    r=await req(legacy,{method:legacy.includes('/create')||legacy.includes('/join')||legacy.includes('/message')||legacy.endsWith('/state')?'POST':'GET',headers:{'content-type':'application/json'},body:JSON.stringify({})});
    if(r.status!==404)throw Error(`legacy endpoint ${legacy} returned ${r.status}`);
  }
  console.log('SERVER TEST: PASS');
 }catch(e){console.error('SERVER TEST: FAIL',e.message);process.exitCode=1}
 finally{child.kill('SIGTERM');await sleep(100)}
})()
