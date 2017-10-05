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



