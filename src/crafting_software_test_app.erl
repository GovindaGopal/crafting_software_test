-module(crafting_software_test_app).

-export([start/0]).
-export([stop/1]).

start() ->
    {ok, _} = application:ensure_all_started(cowboy),
    Dispatch = cowboy_router:compile([
        {'_', [
            {"/[...]", crafting_software_test_handler, []}
        ]}
    ]),
    {ok, _} = cowboy:start_http(http, 100, [{port, 8080}], [
        {env, [{dispatch, Dispatch}]}
    ]),
    crafting_software_test_sup:start_link().

stop(_State) ->
	ok.
