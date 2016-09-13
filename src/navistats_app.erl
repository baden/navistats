-module(navistats_app).

-behaviour(application).

%% Application callbacks
-export([start/0, start/2, start_phase/3, stop/1]).

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

start_phase(init_metrics, _Type, _Args) ->
    % TODO: Метрики
    ok = folsom_metrics:new_counter(point),
    ok = folsom_metrics:new_meter(point_meter),
    ok = folsom_metrics:new_counter(point_error),
    ok = folsom_metrics:new_counter(point_error_crc),
    ok = folsom_metrics:new_counter(point_error_data),

    % Статистика примерно по последним 1028 запросам
    % ok = folsom_metrics:new_histogram(point_duration),

    % Статистика за последнюю минуту
    % ok = folsom_metrics:new_histogram(point_duration, slide_uniform),

    % Статистика точно по последним 1028 запросам
    ok = folsom_metrics:new_histogram(point_duration, slide_sorted),
    % ok = folsom_metrics:new_histogram(point_duration2),
    % ok = folsom_metrics:new_duration(point_duration),
    ok.

-spec stop(any()) -> ok.
stop(_State) ->
    ok.
