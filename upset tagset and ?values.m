
ClearAll["Global`*"]

(* UPSET/UPSETDELAYED *)
D[\[Psi][x_], x_] ^:= derivativeOf\[Psi][x];
?? \[Psi]
(* Global`\[Psi] *)

\!\(
\*SubscriptBox[\(\[PartialD]\), \(x_\)]\(\[Psi][x_]\)\)^:=derivativeOf\[Psi][x]

D[\[Psi][arg], arg]
(* derivativeOf\[Psi][arg] *)

Integrate[transparentFunction[f_], x_] ^:= transparentFunction[Integrate[f, x]];

?? transparentFunction

(* Global`transparentFunction 
\[Integral]transparentFunction[f_]\[DifferentialD]x_^:=transparentFunction[\[Integral]f \[DifferentialD]x] *)

Integrate[transparentFunction[Sin[x]], x]
(* transparentFunction[-Cos[x]] *)

head_[headAndArgument[arg_]] ^:= {head, arg}
?? headAndArgument

(* Global`headAndArgument 
head_[headAndArgument[arg_]]^:={head,arg} *)

testHead[headAndArgument[testArg]]
(* {testHead, testArg} *)

(* If an expression has several arguments at the first level, by using Upset \
and UpsetDelayed in function definition, Mathematica associates the \
corresponding information with each of these arguments. This correspondence \
(upvalues) work only for arguments at the first level *)

(* TAGSET/TAGSETDELAYED *)

(* for a function with several arguments, the function definition can be \
associated with a certain prescribed argument rather than with all arguments \
at the first level. This association is done with Tagset/TagsetDelayed *)

x /: f[x, y_] := y;
?? f
(* Global`f *)

?? x
(* Global`x
f[x,y_]^:=y *)

f[x, 3] (* if the expr has the form f[x,something], the rule above is applied*)
(* 3 *)

f[3, x] (* if first argument is not x then nothing happens*)
(* f[3, x] *)

outside /: outside[middle[inside[xFix]]] = xFixOutside;

middle /: outside[middle[inside[xFix]]] = xFixMiddle;

inside /: outside[middle[inside[xFix]]] = xFixInside;

(* During evaluation of In[246]:= TagSet::tagpos: Tag inside in outside[middle[inside[xFix]]] is too deep\
for an assigned rule to be found. *)

xFix /: outside[middle[inside[xFix]]] = xFixInside;
(* During evaluation of In[245]:= TagSet::tagpos: Tag xFix in outside[middle[inside[xFix]]] is too deep\
for an assigned rule to be found. *)

Clear[func];
func /: D[func[x_], {x_, n_}] := derivativeOfFunc[{x, n}];
?? func
(* Global`func

func/:\!\(
\*SubscriptBox[\(\[PartialD]\), \({x_, n_}\)]\(func[x_]\)\):=derivativeOfFunc[{x,n}] *)

D[func[y], {y, 23}]
(* derivativeOfFunc[{y, 23}] *)

g /: Plus[g, g] := 5
Plus[g, g]
(* 5 *)

(* If both an upvalue and a downvalue are defined for a given symbol, the \
definition associated with upvalues is used before the downvalue definition *)

Clear[a, b, c, d];
a[b] = c;
a[b] ^= d;
?? a
(* Global`a 
a[b]=c *)

?? b
(* Global`b 
a[b]^=d *)

a[b]
(* d *)

Clear[a, b, c, d, e];
a[b][c][d] = e;
?? a
(* Global`a
a[b][c][d]=e
*)
?? b
(* Global`b *)
?? c
(* Global`c *)
?? d
(* Global`d *)
?? e
(* Global`e *)
SubValues[a]
(* {HoldPattern[a[b][c][d]] :> e} *)

Clear[a, b, c, d, e];
a[b][c][d] ^= e; (* With Upset the definition is automatically assigned to 'd' as upvalues i.e. argument at Level 1 *)
?? a
(* Global`a *)
?? b
(* Global`b *)
?? c
(* Global`c *)
?? d
(* Global`d 
a[b][c][d]^=e *)

UpValues[d]
(* {HoldPattern[a[b][c][d]] :> e} *)

ClearAll[a, b, c, d, e]; (* with Tagset, user can assign definition to 'a' as SubValues or to 'd' as Upvalues *)
d /: a[b][c][d] = e;
UpValues[d]
(* {HoldPattern[a[b][c][d]] :> e} *)

ClearAll[a, b, c, d, e];
a /: a[b][c][d] = e;
SubValues[a]
(* {HoldPattern[a[b][c][d]] :> e} *)

ClearAll[a, b, c, d, e];
b /: a[b][c][d] = e;
(* During evaluation of In[321]:= TagSet::tagpos: Tag b in a[b][c][d] is too deep for an assigned rule to be found. *)

