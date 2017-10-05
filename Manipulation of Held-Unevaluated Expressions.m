(* In order to map a functions to arguments inside held expression without evaluation *)
func/@Unevaluated/@Hold[arg1,arg2,arg3]
(* Hold[ func[Unevaluated@arg1],func[Unevaluated@arg2],func[Unevaluated@arg3] ] *)
