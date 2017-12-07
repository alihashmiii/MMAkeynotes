data = {<|"company" -> "AAPL", "date" -> {2013, 12, 26}, "open" -> 80.2231|>, <|"company" -> "AAPL", 
    "date" -> {2013, 12, 27}, "open" -> 79.6268|>, <|"company" -> "AAPL", "date" -> {2013, 12, 30}, 
    "open" -> 78.7252|>, <|"company" -> "AAPL",  "date" -> {2013, 12, 31}, "open" -> 78.2626|>, <|
    "company" -> "AAPL", "date" -> {2014, 1, 2}, "open" -> 78.4701|>, <|"company" -> "AAPL", 
    "date" -> {2014, 1, 3}, "open" -> 78.0778|>, <|"company" -> "MSFT", "date" -> {2013, 12, 26}, 
    "open" -> 36.6635|>, <|"company" -> "MSFT", "date" -> {2013, 12, 27}, "open" -> 37.0358|>, <|
    "company" -> "MSFT", "date" -> {2013, 12, 30}, "open" -> 36.681|>, <|"company" -> "MSFT", 
    "date" -> {2013, 12, 31}, "open" -> 36.8601|>, <|"company" -> "MSFT", "date" -> {2014, 1, 2}, 
    "open" -> 36.8173|>, <|"company" -> "MSFT", "date" -> {2014, 1, 3}, "open" -> 36.6658|>, <|"company" -> "GE", 
    "date" -> {2013, 12, 26}, "open" -> 27.2125|>, <|"company" -> "GE", "date" -> {2013, 12, 27}, 
    "open" -> 27.3698|>, <|"company" -> "GE", "date" -> {2013, 12, 30}, "open" -> 27.3708|>, <|
    "company" -> "GE", "date" -> {2013, 12, 31}, "open" -> 27.4322|>, <|"company" -> "GE", "date" -> {2014, 1, 2}, 
    "open" -> 27.394|>, <|"company" -> "GE", "date" -> {2014, 1, 3}, "open" -> 27.0593|>};

(* lets create a nested Association from this data structure (List of Associations to Nested Associations) from user specified preferences
 i.e. {{"date",1},{"date",2},{"company"}} *)
 
keyWrap[x_Integer] := x;
keyWrap[x_String] := Key[x];

groupByFunc[key_String]:= groupByFunc[{key}];
groupByFunc[{keyPath__}]:= With[{keys = Sequence @@ Map[keyWrap, {keyPath}]},
    GroupBy[Part[#, keys] &]
   ];


(* we compose groupByFunc with Map in a recursive manner below. This enables groupByFunc's result to map
on a deeper level after each nesting *)
multiGroupBy[{}] := Identity;
multiGroupBy[specs : {_List ..}] := Map[multiGroupBy[Rest@specs]]@*groupByFunc[First@specs];

transform = multiGroupBy[{{"date", 1}, {"date", 2}, {"company"}}]; (* this produces groupByFunc which is mapped over the  *)

transform[data]
(* <|2013 -> <|12 -> <|"AAPL" -> {<|"company" -> "AAPL", 
        "date" -> {2013, 12, 26}, 
        "open" -> 80.2231|>, <|"company" -> "AAPL", 
        "date" -> {2013, 12, 27}, 
        "open" -> 79.6268|>, <|"company" -> "AAPL", 
        "date" -> {2013, 12, 30}, 
        "open" -> 78.7252|>, <|"company" -> "AAPL", 
        "date" -> {2013, 12, 31}, "open" -> 78.2626|>}, 
     "MSFT" -> {<|"company" -> "MSFT", "date" -> {2013, 12, 26}, 
        "open" -> 36.6635|>, <|"company" -> "MSFT", 
        "date" -> {2013, 12, 27}, 
        "open" -> 37.0358|>, <|"company" -> "MSFT", 
        "date" -> {2013, 12, 30}, 
        "open" -> 36.681|>, <|"company" -> "MSFT", 
        "date" -> {2013, 12, 31}, "open" -> 36.8601|>}, 
     "GE" -> {<|"company" -> "GE", "date" -> {2013, 12, 26}, 
        "open" -> 27.2125|>, <|"company" -> "GE", 
        "date" -> {2013, 12, 27}, 
        "open" -> 27.3698|>, <|"company" -> "GE", 
        "date" -> {2013, 12, 30}, 
        "open" -> 27.3708|>, <|"company" -> "GE", 
        "date" -> {2013, 12, 31}, "open" -> 27.4322|>}|>|>, 
 2014 -> <|1 -> <|"AAPL" -> {<|"company" -> "AAPL", 
        "date" -> {2014, 1, 2}, 
        "open" -> 78.4701|>, <|"company" -> "AAPL", 
        "date" -> {2014, 1, 3}, "open" -> 78.0778|>}, 
     "MSFT" -> {<|"company" -> "MSFT", "date" -> {2014, 1, 2}, 
        "open" -> 36.8173|>, <|"company" -> "MSFT", 
        "date" -> {2014, 1, 3}, "open" -> 36.6658|>}, 
     "GE" -> {<|"company" -> "GE", "date" -> {2014, 1, 2}, 
        "open" -> 27.394|>, <|"company" -> "GE", 
        "date" -> {2014, 1, 3}, "open" -> 27.0593|>}|>|>|> *)
