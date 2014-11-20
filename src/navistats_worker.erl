%% @doc Statistic collector worker.
-module(navistats_worker).
-author("Batrak Deins").

-behaviour(gen_server).
-define(SERVER, ?MODULE).
-define(APP, navistats).

%% ------------------------------------------------------------------
%% API Function Exports
%% ------------------------------------------------------------------

-export([start_link/0]).

%% ------------------------------------------------------------------
%% gen_server Function Exports
%% ------------------------------------------------------------------

-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-record(
    state, {
        collect_interval :: integer(),
        collect_path     :: list(),
        meter_table      :: term()
    }
).
-type state() :: #state{}.

%% ------------------------------------------------------------------
%% API Function Definitions
%% ------------------------------------------------------------------

-spec start_link() -> {ok, pid()}.
start_link() ->
    {ok, CollectInterval} = application:get_env(?APP, collect_interval),
    {ok, CollectPath} = application:get_env(?APP, collect_path),
    {ok, MeterTable} = application:get_env(?APP, meter_table),

    gen_server:start_link({local, ?SERVER}, ?MODULE, {CollectInterval, CollectPath, MeterTable}, []).

%% ------------------------------------------------------------------
%% gen_server Function Definitions
%% ------------------------------------------------------------------
% TODO: Говорят что init должен быть максимально быстрым и не крашиться.
%       Возможно стоит вынести filelib:ensure_dir отсюда?
-spec init({number(), list(), term()}) -> {ok, state()} | {stop, term()}.
init({CollectInterval, CollectPath, MeterTable}) ->
    Interval = trunc(CollectInterval * 1000 + 0.5),
    erlang:send_after(Interval, self(), flush_metrics),
    case filelib:ensure_dir(CollectPath) of
        ok -> ok;
        {error, Reason} ->
            FullDirName = filename:absname(CollectPath),
            erlang:error(Reason, [FullDirName])
    end,
    {ok, #state{
        collect_interval = Interval,
        collect_path = CollectPath,
        meter_table = MeterTable
    }}.

%% @doc Handle synchronous requests.
-spec handle_call(term(), {pid(), term()}, state()) -> {stop, term(), state()}.
handle_call(_Request, _From, State) ->
    % {reply, ok, State}.
    {stop, unknown_call, State}.

%% @doc Handle asynchronous requests.
-spec handle_cast(term(), state()) -> {stop, term(), state()}.
handle_cast(_Msg, State) ->
    % {noreply, State}.
    {stop, unknown_cast, State}.

%% @doc Plain message handling callback.
-spec handle_info(term(), state()) -> {stop, term(), state()} | {noreply, state()}.
handle_info(
    flush_metrics,
    #state{
        collect_interval = Interval,
        collect_path = CollectPath,
        meter_table = _MeterTable
    } = State
) ->
    Dumpfile = filename:join(CollectPath, "meters.txt"),
    Timestamp = timer:now_diff(os:timestamp(), {0,0,0}) div 1000,

    Metric = prepare(folsom_metrics:get_metric_value(point_meter)),
    ok = file:write_file(Dumpfile, [io_lib:format("~p: ~p~n", [Timestamp, Metric])], [append]),
    % lists:foreach(
    %     fun({Tag, FileName}) ->
    %         Dumpfile = filename:join(CollectPath, FileName),
    %         MetricsValues = folsom_metrics:get_metrics_value(Tag),
    %         case dump_to_file(MetricsValues, Dumpfile) of
    %             ok ->
    %                 ok;
    %             Reason ->
    %                 error(unknown, io_lib:format("Failed to dump metrics to file ~p with reason ~p",[Dumpfile, Reason]))
    %         end
    %     end, MetricsTags
    % ),
    erlang:send_after(Interval, self(), flush_metrics),
    {noreply, State};

handle_info(_Info, State) ->
    % {noreply, State}.
    {stop, unknown_info, State}.

%% @doc Termination callback.
-spec terminate(term(), state()) -> ok.
terminate(_Reason, _State) ->
    ok.

%% @doc Code change callback.
-spec code_change(term(), state(), term()) -> {ok, state()}.
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% ------------------------------------------------------------------
%% Internal Function Definitions
%% ------------------------------------------------------------------

prepare(Metric) ->
    jsx:encode(Metric).
