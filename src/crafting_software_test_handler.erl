-module(crafting_software_test_handler).

%% API
-export([init/3]).
-export([handle/2]).
-export([terminate/3]).

init(_Type, Req, []) ->
    {ok, Req, undefined}.

handle(Req, State) ->
    {ok, Body, Req2} = cowboy_req:body(Req),
    {Path, Req3} = cowboy_req:path(Req2),
    Data = jsone:decode(Body, [{object_format, map}]),
    {Code, Headers, Reply} = dispatch(Path, Data),
    {ok, Req4} = cowboy_req:reply(Code, Headers, Reply, Req3),
    {ok, Req4, State}.

terminate(_Reason, _Req, _State) ->
    ok.

%%%===================================================================
%%% Internal functions
%%%===================================================================

dispatch(<<"/api/sort">>, Data) ->
    {Code, Reply} = case crafting_software_test_logic:sort(Data) of
        {ok, Response} ->
            {200, jsone:encode(Response)};
        {error, Reason} ->
            Response = #{
                <<"error">> => Reason
            },
            {400, jsone:encode(Response)}
    end,
    Headers = [
        {<<"content-type">>, <<"application/json">>}
    ],
    {Code, Headers, Reply};
dispatch(<<"/api/script">>, Data) ->
    {Code, Reply} = case crafting_software_test_logic:script(Data) of
        {ok, Response} ->
            {200, Response};
        {error, Reason} ->
            Response = #{
                <<"error">> => Reason
            },
            {400, jsone:encode(Response)}
    end,
    Headers = [
        {<<"content-type">>, <<"text/plain">>}
    ],
    {Code, Headers, Reply};
dispatch(_, _Data) ->
    Response = #{
        <<"error">> => <<"wrong path">>
    },
    Headers = [
        {<<"content-type">>, <<"application/json">>}
    ],
    Reply = jsone:encode(Response),
    {404, Headers, Reply}.
