import '../models/app_user.dart';
import '../models/creation.dart';
import 'creation_service.dart';

/// Publishes a small evolution tree authored by [author] so the feed,
/// profile and lineage screens can be tried before the Part 2 editor exists:
///
/// ```text
/// Neon Snake ──► Rainbow Snake ──► Rainbow Snake Turbo
/// Particle Fountain ──► Particle Rain (gravity)
/// Focus Timer
/// ```
class DemoSeed {
  DemoSeed(this._creations);

  final CreationService _creations;

  Future<void> run(AppUser author) async {
    Future<Creation> publish(
      String title,
      String description,
      String code,
      CreationCategory category, {
      Creation? parent,
    }) async {
      final id = await _creations.publish(
        author: author,
        title: title,
        description: description,
        code: code,
        category: category,
        tags: [category.name, 'demo'],
        parent: parent,
      );
      return (await _creations.fetch(id))!;
    }

    final snake = await publish(
      'Neon Snake',
      'Classic snake. Tap the left or right half of the screen to turn.',
      _snake(rainbow: false, speedMs: 140),
      CreationCategory.game,
    );
    final rainbow = await publish(
      'Rainbow Snake',
      'Evolution: the snake now cycles through every colour.',
      _snake(rainbow: true, speedMs: 140),
      CreationCategory.game,
      parent: snake,
    );
    await publish(
      'Rainbow Snake Turbo',
      'Evolution of an evolution: twice as fast.',
      _snake(rainbow: true, speedMs: 70),
      CreationCategory.game,
      parent: rainbow,
    );
    final fountain = await publish(
      'Particle Fountain',
      'Tap anywhere to spray glowing particles.',
      _particles(gravity: 0),
      CreationCategory.simulation,
    );
    await publish(
      'Particle Rain',
      'Evolution: adds gravity so particles fall and bounce.',
      _particles(gravity: 0.25),
      CreationCategory.simulation,
      parent: fountain,
    );
    await publish(
      'Focus Timer',
      'A tiny 25/5 Pomodoro timer with a progress ring.',
      _timer,
      CreationCategory.tool,
    );
  }

  static String _snake({required bool rainbow, required int speedMs}) =>
      '''
<!doctype html><html><head><meta name="viewport" content="width=device-width,initial-scale=1,user-scalable=no">
<style>html,body{margin:0;height:100%;background:#0b0f1a;overflow:hidden;font-family:sans-serif;color:#fff}
canvas{display:block;margin:0 auto}#s{position:fixed;top:12px;width:100%;text-align:center;font-size:20px}</style></head>
<body><div id="s">0</div><canvas id="c"></canvas><script>
const RAINBOW=$rainbow,SPEED=$speedMs,N=20,c=document.getElementById('c'),x=c.getContext('2d');let W,S;
function rs(){W=Math.min(innerWidth,innerHeight)-24;S=W/N;c.width=c.height=W;c.style.marginTop=((innerHeight-W)/2)+'px'}
rs();addEventListener('resize',rs);let sn,d,f,sc,t=0;
function reset(){sn=[{x:10,y:10},{x:9,y:10},{x:8,y:10}];d={x:1,y:0};sc=0;food()}
function food(){f={x:Math.floor(Math.random()*N),y:Math.floor(Math.random()*N)};if(sn.some(p=>p.x==f.x&&p.y==f.y))food()}
function turn(r){d=r?{x:-d.y,y:d.x}:{x:d.y,y:-d.x}}
addEventListener('pointerdown',e=>turn(e.clientX>innerWidth/2));
function step(){const h={x:(sn[0].x+d.x+N)%N,y:(sn[0].y+d.y+N)%N};
if(sn.some(p=>p.x==h.x&&p.y==h.y)){reset();return}sn.unshift(h);
if(h.x==f.x&&h.y==f.y){sc++;food()}else sn.pop();document.getElementById('s').textContent=sc}
function draw(){x.fillStyle='#111827';x.fillRect(0,0,W,W);x.fillStyle='#f43f5e';x.beginPath();
x.arc((f.x+.5)*S,(f.y+.5)*S,S*.4,0,7);x.fill();sn.forEach((p,i)=>{
x.fillStyle=RAINBOW?'hsl('+((t*4+i*18)%360)+',90%,60%)':'#22d3ee';x.fillRect(p.x*S+1,p.y*S+1,S-2,S-2)})}
reset();setInterval(()=>{t++;step();draw()},SPEED);
</script></body></html>''';

  static String _particles({required double gravity}) =>
      '''
<!doctype html><html><head><meta name="viewport" content="width=device-width,initial-scale=1,user-scalable=no">
<style>html,body{margin:0;height:100%;background:#05060a;overflow:hidden}</style></head>
<body><canvas id="c"></canvas><script>
const G=$gravity,c=document.getElementById('c'),x=c.getContext('2d');let P=[];
function rs(){c.width=innerWidth;c.height=innerHeight}rs();addEventListener('resize',rs);
function burst(px,py){for(let i=0;i<60;i++){const a=Math.random()*6.283,s=1+Math.random()*5;
P.push({x:px,y:py,vx:Math.cos(a)*s,vy:Math.sin(a)*s,l:120+Math.random()*80,h:Math.random()*360})}}
addEventListener('pointerdown',e=>burst(e.clientX,e.clientY));
setInterval(()=>burst(innerWidth/2,innerHeight/2),900);
(function loop(){x.fillStyle='rgba(5,6,10,.25)';x.fillRect(0,0,c.width,c.height);
P=P.filter(p=>p.l-->0);P.forEach(p=>{p.vy+=G;p.x+=p.vx;p.y+=p.vy;
if(p.y>c.height){p.y=c.height;p.vy*=-.7}if(p.x<0||p.x>c.width)p.vx*=-1;
x.fillStyle='hsl('+p.h+',100%,60%)';x.beginPath();x.arc(p.x,p.y,2.5,0,7);x.fill()});
requestAnimationFrame(loop)})();
</script></body></html>''';

  static const _timer = '''
<!doctype html><html><head><meta name="viewport" content="width=device-width,initial-scale=1,user-scalable=no">
<style>html,body{margin:0;height:100%;background:#0f172a;color:#e2e8f0;font-family:sans-serif;
display:flex;align-items:center;justify-content:center;flex-direction:column}
svg{width:240px;height:240px;transform:rotate(-90deg)}#t{position:absolute;font-size:48px;font-weight:500;font-variant-numeric:tabular-nums}
.w{position:relative;display:flex;align-items:center;justify-content:center}
button{margin:24px 4px 0;padding:12px 24px;border:1px solid #334155;border-radius:10px;font-size:16px;background:transparent;color:#e2e8f0}
#b{background:#ef4c3c;border-color:#ef4c3c;color:#fff}
#m{margin-top:16px;opacity:.7}</style></head><body>
<div class="w"><svg viewBox="0 0 100 100"><circle cx="50" cy="50" r="44" stroke="#1e293b" stroke-width="8" fill="none"/>
<circle id="r" cx="50" cy="50" r="44" stroke="#ef4c3c" stroke-width="8" fill="none" stroke-linecap="round"
stroke-dasharray="276.5" stroke-dashoffset="0"/></svg><div id="t">25:00</div></div>
<div id="m">Focus</div><div><button id="b">Start</button><button id="z">Reset</button></div><script>
let focus=true,total=1500,left=total,timer=null;const r=document.getElementById('r');
function render(){const m=String(Math.floor(left/60)).padStart(2,'0'),s=String(left%60).padStart(2,'0');
document.getElementById('t').textContent=m+':'+s;r.style.strokeDashoffset=276.5*(1-left/total);
document.getElementById('m').textContent=focus?'Focus':'Break'}
function tick(){if(--left<0){focus=!focus;total=focus?1500:300;left=total}render()}
document.getElementById('b').onclick=e=>{if(timer){clearInterval(timer);timer=null;e.target.textContent='Start'}
else{timer=setInterval(tick,1000);e.target.textContent='Pause'}};
document.getElementById('z').onclick=()=>{focus=true;total=1500;left=total;render()};render();
</script></body></html>''';
}
