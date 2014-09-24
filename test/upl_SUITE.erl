-module(upl_SUITE).
-include_lib("common_test/include/ct.hrl").
-compile(export_all).


suite() -> [{timetrap,{seconds,30}}].
all() -> [{group, samples}].
groups() -> [{samples, [], [universal,deposit,platinum]}].
init_per_suite(Config) -> Config.
end_per_suite(_Config) -> ok.
init_per_group(samples, Config) -> Config.
end_per_group(_, _) -> ok.

universal(Config) -> process(Config,"PB-UNIVERSAL.card").
deposit(Config)   -> process(Config,"PB-DEPOSIT-PLUS.card").
platinum(Config)  -> process(Config,"Platinum-Debit.card").

process(Config,Name) ->
    FileName = ?config(data_dir,Config) ++ "../../samples/programs/" ++ Name,
    {ok,Bin} = file:read_file(FileName),
    Source = binary_to_list(Bin),
    ct:log("-> upl ~p ~p", [Name,Source]),
    {ok,AST} = upl:run(Source),
    ct:log("-> upl AST: ~p", [AST]),
    ok.
