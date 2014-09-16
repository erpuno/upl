
% Card Processing Language
% Copyright (c) 2014 Synrc Research Center s.r.o.

Nonterminals Card Rules Rule Currency Amount FeeRules 
             TransRules Limit AmountType ChargeRule.

Terminals id_ int_ long_ double_ float_ percent_ atom_ str1_ str2_
          card limit grace accounts
          rate penalty fee deposit unknown
          transaction cashin cashout wire
          pos ballance country system
          daily monthly annual each
          target local type name
          amount debt credit limit status of
          and or not xor min max disabled
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
Rule -> fee FeeRules : {fee,line('$1'),'$2'}.

Amount -> unknown : unknown.
Amount -> int_ : {int,val('$1')}.
Amount -> percent_ : {percent,val('$1')}.

FeeRules -> '$empty' : [].
FeeRules -> transaction TransRules FeeRules : [{transaction,'$2'}|'$3'].
FeeRules -> monthly ChargeRule FeeRules     : [{monthly,'$2'}|'$3'].
FeeRules -> daily ChargeRule FeeRules       : [{daily,'$2'}|'$3'].
FeeRules -> status disabled Amount FeeRules : [{status,disabled,'$3'}|'$2'].

TransRules -> '$empty' : [].
TransRules -> cashin Amount TransRules   : [{cashin,'$2'}|'$3'].
TransRules -> wire ChargeRule TransRules : [{wire,'$2'}|'$3'].
TransRules -> cashout Amount TransRules  : [{cashout,'$2'}|'$3'].

ChargeRule -> Amount : {fixed,'$1'}.
ChargeRule -> Amount of AmountType Limit : {formula,'$3','$1','$4'}.

AmountType -> debt   : debt.
AmountType -> amount : amount.
AmountType -> credit : credit.

Limit -> '$empty' : undefined.
Limit -> limit min Amount max Amount : {limit,[{min,'$3'},{max,'$5'}]}.
Limit -> limit max Amount min Amount : {limit,[{max,'$3'},{min,'$5'}]}.
Limit -> limit min Amount : {limit,[{min,'$3'}]}.
Limit -> limit max Amount : {limit,[{max,'$3'}]}.

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

val({int_,N,_}) -> N;
val({long_,N,_}) -> N;
val({double_,F,_}) -> F;
val({float_,F,_}) -> F;
val({percent_,F,_}) -> F;
val({atom_,A,_}) -> A;
val({str1_,S,_}) -> S;
val({str2_,S,_}) -> S;
val({docstr_,S,_}) -> S.

op({Op,_}) -> Op.

%%EOF
