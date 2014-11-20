-module(navistats_app).

-behaviour(application).

%% Application callbacks
-export([start/0, start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

% Manual start or start over -s flag
-spec start() -> ok.
start() ->
    ok = application:start(navistats).

-spec start(any(), any()) -> {ok, pid()}.
start(_StartType, _StartArgs) ->
    navistats_sup:start_link().

-spec stop(any()) -> ok.
stop(_State) ->
    ok.
