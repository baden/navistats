-module(navistats_SUITE).

-include_lib("common_test/include/ct.hrl").
-include_lib("eunit/include/eunit.hrl").

-compile(export_all).

suite() ->
    [{timetrap,{minutes,1}}].

all() -> [ application_start_supervisor, database ].

init_per_suite(Config) ->
    error_logger:tty(false),
    {ok, Modules} = application:ensure_all_started(navistats),
    [{modules, Modules} | Config].

end_per_suite(Config) ->
    Modules = ?config(modules, Config),
    [application:stop(Module) || Module <- lists:reverse(Modules)],
    application:unload(navistats),
    error_logger:tty(true),
    ok.

application_start_supervisor(_) ->
    ?assertNotMatch(undefined, whereis(navistats_sup)),
    ?assertNotMatch(undefined, whereis(navistats_worker)),
    ok.

database(_) ->
    % Вообще-то это неправильная проверка. Нужно вычислить путь.
    ?assertEqual(true, filelib:is_dir("stats")),
    ?assertMatch({ok, _}, {ok, <<"some">>}),
    ok.
