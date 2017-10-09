(* From Robby Villegas's presentation *)

(* Structural elements are your friends; they work well on unevaluated expressions. *)
(* FLATTEN *)
Attributes[f] = HoldAll;
f[Xor[elems___]] := Replace[Sort@Flatten[Hold[elems],Infinity,Xor],
Hold[args___] :> HoldForm[CirclePlus@args]];
f[Xor[Xor[1==1,Xor[0==1]], Xor[Xor[2==1,1==0], 2==0]]]
(* (0==1)\[CirclePlus](1==0)\[CirclePlus](1==1)\[CirclePlus](2==0)\[CirclePlus](2==1) *)

(* *)
ClearAll[f];
SetAttributes[f, HoldAll];
f[args___] /; MemberQ[Unevaluated[{args}], _f] := Flatten[Unevaluated[f[args]], Infinity, f];
f[singleton_] := singleton;
