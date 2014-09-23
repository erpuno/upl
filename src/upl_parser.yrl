
% Card Processing Language
% Copyright (c) 2014 Synrc Research Center s.r.o.

Nonterminals Card Rules Rule Currency Amount CreditRules CreditRulesBody CreditRule
             TransRules Limit AmountType ChargeRule DepositRule DepositRules
             Enabled AccountList Name DurationList Account Periodically ChargeRuleLimit
             TargetRule AmountRange CashoutRule CashoutRules CountryRange
             TargetCase.

Terminals id_ int_ long_ double_ float_ percent_ atom_ str1_ str2_
          auto final from move to version include
          days withdraw charge duration range
          program limit grace accounts account
          rate penalty fee deposit unknown
          transaction cashin cashout wire
          pos ballance country system
          daily monthly annual each
          target local type name
          amount debt credit debit status of
          and or not xor min max disabled enabled
	      '+' '-' '*' '/' '->' '..' '_'
	      '::' '\\' '=>'
	      ';' '.' ',' '[' '|' ']' '{' '}' '='
	      '<<' '>>' '@' '(' ')'
	      '<' '<=' '>' '>=' '==' '/='
	      '+.' '-.' '*.' '/.'
	      docstr_.

Rootsymbol Card.

Card -> program id_ Currency Rules : {program,line('$1'),{name,id('$2')},{currency,'$3'},'$4'}.

Currency -> '$empty' : default.
Currency -> id_ : id('$1').

Rules -> '$empty' : [].
Rules -> Rule Rules : ['$1'|'$2'].


Rule -> limit    Amount       : {limit,'$2'}.
Rule -> include  str1_        : upl:process(val('$2')).
Rule -> grace    Amount days  : {grace,'$2'}.
Rule -> credit   CreditRules  : {credit,'$2'}.
Rule -> penalty  Periodically : {penalty,'$2'}.
Rule -> rate     ChargeRule   : {rate,'$2'}.
Rule -> rate     CreditRulesBody  : {rate,'$2'}.
Rule -> version  Amount       : {version,'$2'}.
Rule -> deposit  DepositRules : {deposit,'$2'}.
Rule -> accounts AccountList  : {accounts,'$2'}.

Amount -> unknown  : unknown.
Amount -> debt     : {keyword,debt}.
Amount -> '_'      : {keyword,'_'}.
Amount -> int_     : {fixed,val('$1')}.
Amount -> float_   : {fixed,val('$1')}.
Amount -> percent_ : {percent,'$1'}.
Amount -> int_ '+' percent_    : {fixed,val('$1'),percent,val('$3')}.

DepositRules -> '$empty' : [].
DepositRules -> DepositRule DepositRules : ['$1'|'$2'].

CreditRules -> '$empty' : undefined.
CreditRules -> CreditRulesBody : '$1'.
CreditRulesBody -> CreditRule CreditRules : ['$1'|'$2'].

ChargeRuleLimit -> Amount Limit : {charge,'$1','$2'}.
ChargeRuleLimit -> Amount of AmountType Limit : {charge,'$3','$1','$4'}.
ChargeRuleLimit -> Limit : '$1'.

ChargeRule -> ChargeRuleLimit                             : {fee,[],'$1'}.
ChargeRule -> ChargeRuleLimit name str1_                  : {fee,[{account,default},{name,val('$3')}],'$1'}.
ChargeRule -> ChargeRuleLimit to account str1_            : {fee,[{account,val('$4')},{name,[]}],'$1'}.
ChargeRule -> ChargeRuleLimit name str1_ to account str1_ : {fee,[{account,val('$6')},{name,val('$3')}],'$1'}.
ChargeRule -> ChargeRuleLimit to account str1_ name str1_ : {fee,[{account,val('$4')},{name,val('$6')}],'$1'}.

AccountList -> '$empty' : [].
AccountList -> Account AccountList : ['$1'|'$2'].

Account -> credit  str1_ : {credit,val('$2')}.
Account -> rate    str1_ : {rate,val('$2')}.
Account -> penalty str1_ : {penalty,val('$2')}.
Account -> deposit str1_ : {deposit,val('$2')}.

Periodically -> monthly Amount '->' ChargeRule : {monthly,'$2','$4'}.
Periodically -> monthly ChargeRule             : {monthly,1,'$2'}.
Periodically -> daily ChargeRule               : {daily,'$2'}.
Periodically -> annual ChargeRule              : {annual,'$2'}.

DepositRule -> duration Periodically        : {duration,['$2']}.
DepositRule -> duration range DurationList  : {duration,'$3'}.
DepositRule -> withdraw Enabled             : {withdraw,'$2'}.
DepositRule -> charge Enabled               : {charge,'$2',none}.
DepositRule -> charge Enabled Periodically  : {charge,'$2','$3'}.
DepositRule -> auto                         : {auto}.
DepositRule -> final move from id_ to id_   : {final,move,'$4','$6'}.
DepositRule -> fee ChargeRule               : '$1'.
DepositRule -> Periodically                 : '$1'.

CreditRule -> transaction TransRules : {transaction,'$2'}.
CreditRule -> status Enabled Amount  : {status,'$2','$3'}.
CreditRule -> Periodically           : '$1'.

TransRules -> '$empty' : [].
TransRules -> cashin CashoutRules TransRules     : [{cashin,'$2'}|'$3'].
TransRules -> cashout CashoutRules TransRules    : [{cashout,'$2'}|'$3'].
TransRules -> wire ChargeRule TransRules        : [{wire,'$2'}|'$3'].
TransRules -> wire target TargetRule ChargeRule TransRules : [{wire,'$3','$4'}|'$5'].

CashoutRules -> '$empty' : [].
CashoutRules -> CashoutRule CashoutRules : ['$1'|'$2'].

CashoutRule -> pos id_ Amount             : {pos,'$2','$3'}.
CashoutRule -> country range CountryRange : {country,{range,'$3'}}.
CashoutRule -> country id_ Amount         : {country,'$2','$3'}.
CashoutRule -> amount range AmountRange   : {range,'$3'}.
CashoutRule -> Amount                     : '$1'.

CountryRange -> '$empty' : [].
CountryRange -> unknown '->' Amount CountryRange : [{unknown,'$3'}|'$4'].
CountryRange -> id_ '->' Amount CountryRange : [{'$1','$3'}|'$4'].

AmountRange -> '$empty' : [].
AmountRange -> Amount '..' Amount '->' Amount AmountRange : [{'$1','$3','$4'}|'$5'].

TargetRule -> TargetCase : {target,'$1'}.
TargetRule -> TargetCase type str1_ : {target,'$1',type,'$3'}.

TargetCase -> local : local.
TargetCase -> unknown : unknown.
TargetCase -> str1_ : '$1'.

DurationList -> '$empty' : [].
DurationList -> Periodically DurationList : ['$1'|'$2'].

Enabled -> enabled  : enabled.
Enabled -> disabled : disabled.

AmountType -> debt    : debt.
AmountType -> deposit : deposit.
AmountType -> rate    : rate.
AmountType -> amount  : amount.
AmountType -> credit  : credit.

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
