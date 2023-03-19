const fns = "^⌹⍳⍴!%*+,-<=>?|~⊢⊣⌷≤≥≠∨∧÷×∊↑↓○⌈⌊⊂⊃∩∪⊥⊤⍱⍲⍒⍋⍉⌽⊖⍟⍕⍎⍪≡≢⍷⍸⊆⊇⍧⍮√ϼ…";
const mop = "¨⍨⌸⍁⍩ᑈᐵ⌶&";
const dop = ".@∘⌺⍫⍣⍢⍤⍛⍡⍥⍠";

function parseRec(str, i) {
  let tks = []; // contains objects with 't' property being 'a':array 'f':function 'm':monadic-op 'd':dyadic-op '/':schizo
  const dig = (c) => c>='0'&c<='9';
  while(i<str.length) {
    let c = str[i++];
    if (c==')') { i--; break; }
    else if (c=='(') {
      let {res, e} = parseRec(str, i);
      if (str[e] != ')') throw "Mismatched parentheses";
      tks.push(res);
      i = e+1;
    } else if (dig(c)) {
      let p = i-1;
      while (dig(str[i])) i++;
      tks.push({t:'a',x:'const',v:parseInt(str.substring(p, i))});
    } else if (c==' ') continue;
    else if (fns.includes(c)) tks.push({t:'f',x:'const',v:c});
    else if (mop.includes(c)) tks.push({t:'m',x:'const',v:c});
    else if (dop.includes(c)) tks.push({t:'d',x:'const',v:c});
    else if ("/\\⍀⌿".includes(c)) tks.push({t:'/',x:'const',v:c});
    else throw "Unknown char "+c;
  }
  
  let {peek, next, has} = (()=>{
    let peek = () => tks.length? tks[tks.length-1] : {t:'⋄'};
    let next = () => tks.pop();
    let has = () => tks.length!=0;
    
    let value = () => { // strands
      let arr = [next()];
      if (arr[0].t=='a') while (peek().t=='a') arr.push(next());
      return arr.length==1? arr[0] : {t:'a', x:'list', v:arr.reverse()};
    }
    
    let fn = () => {
      let c = value();
      
      if (c.t=='m' || c.t=='/' && peek().t=='f') { // monadic operator deriving
        return {t:'f', x:'derive mop', m:c, f:fn()};
      }
      
      if (peek().t=='d') { // dyadic operator deriving
        let m = value();
        let f = fn();
        if (f.t=='d' && f.v=='∘') return {t:'f', x:'table', g:c}; // ∘. special-case
        return {t:'f', x:'derive dop', f, m, g:c};
      }
      
      return c;
    };
    let curr = fn();
    return {
      has: () => curr.t!='⋄',
      peek: () => curr,
      next: () => [curr,curr=has()? fn() : {t:'⋄'}][0] // just being fancy
    };
  })();
  
  let res = next();
  if (res.t=='a') { // regular evaluation parsing
    while(has()) {
      let c = next();
      if (peek().t=='a') res = {t:'a',x:'dyadic call', f:c, a:next(), w:res};
      else res = {t:'a',x:'monadic call', f:c, w:res};
    }
  } else if (res.t=='f') { // train parsing
    while (has()) {
      let g = next();
      if (has()) res = {t:'f', x:'fork', f:next(), g, h:res};
      else res = {t:'f', x:'atop', g, h:res};
    }
  } else throw res;
  
  return {res, e:i};
}
function parse(str) {
  let {res, e} = parseRec(str, 0);
  if (e != str.length) throw "Mismatched parentheses";
  return res;
}







let pad = (x,p="  ")=>p+" "+x.replace(/\n/g, "\n   ");
let list = (x) => x.map(c=>pad(fmt(c))).join('\n');
function fmt(x) {
  switch(x.x) {
    case 'const': return "const "+x.v;
    case 'list': return "list\n"+list(x.v);
    case 'res': return "res\n"+pad(fmt(x.res));
    case 'table': return "table\n"+pad(fmt(x.g));
    case 'monadic call': return "monadic call\n"+pad(fmt(x.f),'∇ ')+'\n'+pad(fmt(x.w),'⍵ ');
    case 'dyadic call': return "dyadic call\n"+pad(fmt(x.f),'∇ ')+'\n'+pad(fmt(x.a),'⍺ ')+'\n'+pad(fmt(x.w),'⍵ ');
    case 'derive mop': return "derive mop\n"+pad(fmt(x.m),'∇∇')+'\n'+pad(fmt(x.f),'⍺⍺');
    case 'derive dop': return "derive dop\n"+pad(fmt(x.m),'∇∇')+'\n'+pad(fmt(x.f),'⍺⍺')+'\n'+pad(fmt(x.g),'⍵⍵');
    case 'atop': return "atop\n"+                        pad(fmt(x.g),'g ')+'\n'+pad(fmt(x.h),'h ');
    case 'fork': return "fork\n"+pad(fmt(x.f),'f ')+'\n'+pad(fmt(x.g),'g ')+'\n'+pad(fmt(x.h),'h ');
    default: return 'unknown x '+JSON.stringify(x);
  }
}

function test(str) {
  let r = parse(str);
  console.log(str+":\n"+pad(fmt(r))+"\n");
}

test("2 + ÷2×2");
test("(2 + ÷2×23) × 5");
test("(+/÷≢) 2 + 1 2 9");
test("(⊢+⊢×⊢)5");
test("⍒⍤1∘.=⍨⍳10");
test("⍒⍤1 2∘.=⍨⍳5 6");
test("+/1 2 3/4 5 6");
test("1∘+ 4");
test("+∘1 4");
test("+∘1⊢4");
test("(+∘1)4");