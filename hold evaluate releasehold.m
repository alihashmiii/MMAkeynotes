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
