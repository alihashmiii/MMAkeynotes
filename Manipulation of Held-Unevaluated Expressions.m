(* In order to map a functions to arguments inside held expression without evaluation *)
func/@Unevaluated/@Hold[arg1,arg2,arg3]
(* Hold[ func[Unevaluated@arg1],func[Unevaluated@arg2],func[Unevaluated@arg3] ] *)

(* if you want to prevent the function/arguments of a user-defined function from evaluating, we can create a temporary Holding
Function *)
Split[Hold[Print[1], Print[2 + 3], 0 + 1, 1 + 2, 2 + 3, 0*1, 1*2*3, 4^4],
Function[{e1,e2}, Head[Unevaluated@e1]===Head[Unevaluated@e2] ,HoldAll]]
(* Hold[Hold[Print[1], Print[2 + 3]], Hold[0 + 1, 1 + 2, 2 + 3], Hold[0 1, 2 3], Hold[4^4]] *)

Function[e, MemberQ[Unevaluated[e],0],HoldFirst]/@Unevaluated[{x*y,u*0*v,1*2*0}]
(* {False,True,True} *)

Map[Function[e, DeleteCases[Unevaluated[e],0],HoldFirst],
Unevaluated[{x*y,u*0*v,1*2*0}]
]
(* {x y, u v, 2} *)



(* Replace is one of the easiest methods for transforming a structure *)
Replace[Hold[1+2, Print[3,4], D[x^2,x]],
h_[elems___]:> {h,elems},{1}]
(* Hold[{Plus,1,2},{Print,3,4},{D,x^2,x}] *)

patts = Replace[Unevaluated[{1 + 2, Print[3, 4], D[x^2, x]}], h_[___] :> _h, {1}]
(* {_Plus, _Print, _D} *)

n = 79301169838123235887500;
held = Hold[Evaluate@FactorInteger[n]];
(* Hold[{{2,2},{3,3},{5,5},{7,7},{11,11}}] *)
Replace[held, {p_,a_}:> p^a,{2}]
(* Hold[{2^2,3^3,5^5,7^7,11^11}] *)
Replace[%, Hold[{elems___}]:>MakeBoxes[Times@elems,TraditionalForm]]
(* RowBox[{SuperscriptBox["2", "2"], " ", SuperscriptBox["3", "3"], " ", 
  SuperscriptBox["5", "5"], " ", SuperscriptBox["7", "7"], " ", 
  SuperscriptBox["11", "11"]}] *)
  DisplayForm[%]
 (* \!\(TagBox[RowBox[{SuperscriptBox["2", "2"], " ", SuperscriptBox["3", "3"], " ", 
SuperscriptBox["5", "5"], " ", SuperscriptBox["7", "7"], " ",SuperscriptBox["11", "11"]}], DisplayForm]\) *)



(* Function and With can stuff values into expression including held ones *)
With[{p = 2, a = 2, q = 5, b = 5},
 MakeBoxes[p^a*q^b] // DisplayForm
 ]
 (* \!\(TagBox[RowBox[{SuperscriptBox["2", "2"], " ", SuperscriptBox["5", "5"]}],DisplayForm]\) *)
 
 Function[{p, a, q, b}, DisplayForm@MakeBoxes[p^a*q^b]][2, 2, 5, 5]
 (* \!\(TagBox[RowBox[{SuperscriptBox["2", "2"], " ", SuperscriptBox["5", "5"]}],DisplayForm]\) *)
 
