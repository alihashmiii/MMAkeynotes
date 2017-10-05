SetAttributes[firstArgHoldingFunction, HoldFirst];
firstArgHoldingFunction[1 + 1, a + a] (* first argument is not evaluated *)
(* firstArgHoldingFunction[1 + 1, 2 a] *)

SetAttributes[restArgHoldingFunction, HoldRest];
restArgHoldingFunction[1 + 1, a + a, b + b] (* only the first argument is evaluated *)
(* restArgHoldingFunction[2, a + a, b + b] *)

SetAttributes[holdingFunction, HoldAll];
holdingFunction[1 + 1, a + a][1 + 1] (* all arguments of holdingFunction on hold *)
(* holdingFunction[1 + 1, a + a][2] *)

holdingFunction[Evaluate[1 + 1], a + a] (* Evaluate can force evaluation of an argument *)
(* holdingFunction[2, a + a] *)

Evaluate@holdingFunction[1 + 1, a + a] (* Evaluate NEEDS TO OPERATE ON THE HELD ARGUMENTS DIRECTLY to work *)
(* holdingFunction[1 + 1, a + a] *)

SetAttributes[strongHoldingFunction, HoldAllComplete];
strongHoldingFunction[Evaluate[1 + 1], Evaluate[a + a]] (* Evaluate does not operate when attribute is HoldAllComplete *)
(* strongHoldingFunction[Evaluate[1 + 1], Evaluate[a + a]] *)

(* ReleaseHold works when expression have the Head Hold or HoldForm *)

ReleaseHold@holdingFunction[Hold[1 + 1], Hold[a + a]] (* the head Hold from held expression is removed but \
argument remains unevaluated owing to HoldAll attribute *)
(* holdingFunction[1 + 1, a + a] *)

holdingFunction[1 + 1, ReleaseHold[Hold[a + a]]] (* this does not work because ReleaseHold is part of \
the held argument itself and therefore does not operate *)
(* holdingFunction[1 + 1, ReleaseHold[Hold[a + a]]] *)

ReleaseHold@notAHoldingFunction[Hold[1 + 1]] (* same as \[Rule] notAHoldingFunction[ReleaseHold@Hold[1+1]] *)
(* notAHoldingFunction[2] *)

notAHoldingFunction[Hold[1 + 1], ReleaseHold[Hold[a + a]]] (* ReleaseHold will work only on the expression that it encloses *)
(* notAHoldingFunction[Hold[1 + 1], 2 a] *)

ReleaseHold[notAHoldingFunction[Hold[1 + 1 + Hold[a + a]]]] (* works on the top level of the expression with nested Holds *)
(* notAHoldingFunction[2 + Hold[a + a]] *)


(* Sequence[] and Hold *)
Clear[a,b,g];

Hold[Sequence[a,b]] (* Sequence disappears inside Hold or any function with HoldAll, HoldFirst or HoldRest attribute *)
(* Hold[a,b] *)
HoldComplete[Sequence[a,b]] (* Sequence stays inside HoldComplete or a function with HoldAllComplete Attribute *)
(* HoldComplete[Sequence[a,b]] *)
Unevaluated[Sequence[a,b]] (* Unevaluated has a HoldAllComplete attribute *)
(* Unevaluated[Sequence[a,b]] *)

SetAttributes[g,HoldFirst];
g[g[Sequence[]], g[g[Sequence[]]]] (* Sequence is not automatically flattened when deep inside: notice for both the first and second*)
(* g[g[Sequence[]], g[g[Sequence[]]]] *)

(* Unevaluated *)
(* unevaluated blocks evaluation of arguments *)
Head@Unevaluated[1 + 3.5 + Pi + (3-I)^2] (* Unevaluated is not an actual datatype and vanishes once its purpose is fulfilled it is transparent to the outer function *)
(* Plus *)
Head@Hold[1 + 3.5 + Pi + (3-I)^2] (* this does not work because Hold does not vanish *)
(* Hold *)

(* if the head of an expression is Hold we can Map a function without evaluating the arguments of Hold *)
List@@(f/@ Unevaluated/@Hold[arg1,arg2,arg3])

(* Unevaluated persists when it is itself the outer argument *)
Unevaluated[Print[1]/2^3]
