-module(navistats).

-ifdef(TEST).
% -include_lib("proper/include/proper.hrl").
-include_lib("eunit/include/eunit.hrl").
-endif.

-export([start/0]).

% API

-export([
    new/0,
    notify/2,
    get_metric_value/1,
    histogram_timed_begin/1,
    histogram_timed_notify/1,
    get_histogram_statistics/1
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

notify(Metric, Param) ->
    folsom_metrics:notify(Metric, Param).

get_metric_value(Metric) ->
    folsom_metrics:get_metric_value(Metric).

histogram_timed_begin(Metric) ->
    folsom_metrics:histogram_timed_begin(Metric).

histogram_timed_notify(Begin) ->
    folsom_metrics:histogram_timed_notify(Begin).

get_histogram_statistics(Metric) ->
    folsom_metrics:get_histogram_statistics(Metric).

%%%===================================================================
%%% Tests
%%%===================================================================

-ifdef(TEST).

new_test() ->
    ?assertEqual([], navistats:new()).

-endif.
