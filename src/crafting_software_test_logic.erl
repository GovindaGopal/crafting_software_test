-module(crafting_software_test_logic).

%% API
-export([sort/1]).
-export([script/1]).

sort(#{<<"tasks">> := Tasks}) ->
    SortedTasks = sort_tasks(Tasks),
    {ok, #{<<"tasks">> => SortedTasks}};
sort(_) ->
    {error, <<"wrong format">>}.

script(#{<<"tasks">> := Tasks}) ->
    SortedTasks = sort_tasks(Tasks),
    Script = make_script(SortedTasks),
    {ok, Script};
script(_) ->
    {error, <<"wrong format">>}.

%%%===================================================================
%%% Internal functions
%%%===================================================================

sort_tasks([]) ->
    [];
sort_tasks(Tasks) ->
    PreSortFun = fun
        (#{<<"name">> := Name1}, #{<<"name">> := Name2}) ->
            Name1 < Name2
    end,
    PreSortedTasks = lists:sort(PreSortFun, Tasks),
    sort_tasks(PreSortedTasks, []).

sort_tasks([], SortedTasks) ->
    lists:reverse(SortedTasks);
sort_tasks([Task | Tasks], SortedTasks) ->
    {RestTasks, UpSortedTasks} = maybe_add_required([Task], Tasks, SortedTasks),
    sort_tasks(RestTasks, UpSortedTasks).

maybe_add_required([], NotRequiredTasks, SortedTasks) ->
    {NotRequiredTasks, SortedTasks};
maybe_add_required([#{<<"requires">> := Requires} = Task | RequiredTasks], Tasks, SortedTasks) ->
    PartitionFun = fun
        (#{<<"name">> := Name}) ->
            lists:member(Name, Requires)
    end,
    {NewRequiredTasks, NotRequiredTasks} = lists:partition(PartitionFun, Tasks),
    {RestTasks, UpSortedTasks} = maybe_add_required(NewRequiredTasks, NotRequiredTasks, SortedTasks),
    ResponseTask = maps:with([<<"name">>, <<"command">>], Task),
    maybe_add_required(RequiredTasks, RestTasks, [ResponseTask | UpSortedTasks]);
maybe_add_required([Task | RequiredTasks], NotRequiredTasks, SortedTasks) ->
    ResponseTask = maps:with([<<"name">>, <<"command">>], Task),
    maybe_add_required(RequiredTasks, NotRequiredTasks, [ResponseTask | SortedTasks]).

make_script(SortedTasks) ->
    Init = <<"#!/usr/bin/env bash">>,
    make_script(SortedTasks, Init).

make_script([], Script) ->
    Script;
make_script([#{<<"command">> := Cmd} | Tasks], Script) ->
    UpScript = <<Script/binary, "\n", Cmd/binary>>,
    make_script(Tasks, UpScript).