-module(navistats).

-ifdef(TEST).
% -include_lib("proper/include/proper.hrl").
-include_lib("eunit/include/eunit.hrl").
-endif.

-export([start/0]).

% API

-export([
    new/0
]).

%% @doc Start the navistats application.
-spec start() -> ok.
start() ->
    ok = application:start(fog).
    % navistats_app:start().

%% @doc Fake method.
-spec new() -> [].
new() ->
    [].

%%%===================================================================
%%% Tests
%%%===================================================================

-ifdef(TEST).

new_test() ->
    ?assertEqual([], navistats:new()).

-endif.
