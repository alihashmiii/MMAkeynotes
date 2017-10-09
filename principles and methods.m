(* From Robby Villegas's presentation *)

(* Structural elements are your friends; they work well on unevaluated expressions. *)
(* FLATTEN *)
Attributes[f] = HoldAll;
f[Xor[elems___]] := Replace[Sort@Flatten[Hold[elems],Infinity,Xor],
Hold[args___] :> HoldForm[CirclePlus@args]];
f[Xor[Xor[1==1,Xor[0==1]], Xor[Xor[2==1,1==0], 2==0]]]
(* (0==1)\[CirclePlus](1==0)\[CirclePlus](1==1)\[CirclePlus](2==0)\[CirclePlus](2==1) *)

(* a function that automatically flattens multiple levels of itself *)
ClearAll[f];
SetAttributes[f, HoldAll];
f[args___] /; MemberQ[Unevaluated[{args}], _f] := Flatten[Unevaluated[f[args]], Infinity, f];
f[singleton_] := singleton;
f[elems___]:= Hold[elems];

f[f[1, 2, 3], f[4], f[6^5, f[7, 8, 9]]] 
(* Hold[1, 2, 3, 4, 6^5, 7, 8, 9] *)
