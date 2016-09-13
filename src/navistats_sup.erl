%% @doc Root supervisor for navistats.
-module(navistats_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

%% Helper macro for declaring children of supervisor
-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).

%% ===================================================================
%% API functions
%% ===================================================================

%% @doc Start the root supervisor navistats_sup.
-spec start_link() -> {ok, pid()}.
start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

%% @doc Supervisor behaviour entry point.
-spec init(term()) ->
    {
        ok,
        {
            {
                supervisor:strategy(),
                non_neg_integer(),
                non_neg_integer()
            },
            [supervisor:child_spec()]
        }
    }.
init([]) ->
    Worker = ?CHILD(navistats_worker, worker),
    {ok, { {one_for_one, 5, 10}, [Worker]} }.
