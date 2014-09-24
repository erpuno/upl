-module(upl).
-compile(export_all).

main([]) -> help();
main([File]) -> process(File).

process(FileName) ->
	case file:read_file(FileName) of
		{ok,Bin} -> run(binary_to_list(Bin));
		{error,enoent} -> io:format("Error: ~s not found\n", [FileName]) end.

run(Source) ->
    case tokenize(Source) of
         {ok,Tokens} -> parse(Tokens);
                   E -> E end.

tokenize(Source) ->
	case upl_lexer:string(Source) of
	     {ok,Tokens,_} -> {ok,Tokens};
	                 E -> E end.

parse(Tokens) ->
    io:format("Tokens: ~p~n",[Tokens]),
	case upl_parser:parse(Tokens) of
	     {ok,Card} -> compile(Card), {ok,Card};
	             E -> io:format("Error ~p",[E]) end.

compile(Card) -> io:format("Card ~80p~n",[Card]).

help() ->
    io:format("Universal Processing Language 1.0~n"),
    io:format("     upl filename.card  ~n"),
    halt().
