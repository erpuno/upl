
% Card Processing Language
% Copyright (c) 2014 Synrc Research Center s.r.o.

Nonterminals Card Rules Rule Currency Amount.

Terminals id_ int_ long_ double_ float_ percent_ atom_ str1_ str2_
    card limit grace accounts
    rate penalty fee deposit unknown
    transaction cashin cashout wire
    pos ballance country system
    daily monthly annual each
    target local type name
    amount dept credit limit
    and or not xor
	'->' '::' '\\' '=>'
	';' '.' ',' '[' '|' ']' '{' '}' '='
	'<<' '>>' '@' '(' ')'
	'<' '<=' '>' '>=' '==' '/='
	'+' '-' '*' '/'
	'+.' '-.' '*.' '/.'
	docstr_.

Rootsymbol Card.

Card -> card id_ Currency Rules : {card,line('$1'),{name,id('$2')},{currency,'$3'},'$4'}.

Currency -> '$empty' : default.
Currency -> id_ : id('$1').

Rules -> '$empty' : [].
Rules -> Rule Rules : ['$1'|'$2'].

Rule -> limit Amount : {limit,line('$1'),'$2'}.
Amount -> unknown : unknown.
Amount -> int_ : '$1'.

Erlang code.

line([T|_]) -> line(T);
line({_,Line}) -> Line;
line({id_,_,Line}) -> Line;
line({int_,_,Line}) -> Line;
line({long_,_,Line}) -> Line;
line({float_,_,Line}) -> Line;
line({double_,_,Line}) -> Line;
line({atom_,_,Line}) -> Line;
line({str1_,_,Line}) -> Line;
line({str2_,_,Line}) -> Line;
line(T) when is_tuple(T) -> element(2, T);
line(Any) -> io:format("Error: no line info: ~p\n", [Any]), 0.

id({id_,Id,_Line}) -> Id.

var({id_,'_',Line}) -> {under,Line};
var({id_,Id,Line}) -> {var,Line,Id}.

value({int_,N,_}) -> N;
value({long_,N,_}) -> N;
value({double_,F,_}) -> F;
value({float_,F,_}) -> F;
value({atom_,A,_}) -> A;
value({str1_,S,_}) -> S;
value({str2_,S,_}) -> S;
value({docstr_,S,_}) -> S.

op({Op,_}) -> Op.

%%EOF
