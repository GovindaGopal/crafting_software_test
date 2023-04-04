-module(crafting_software_test_logic_tests).

-include_lib("eunit/include/eunit.hrl").

-define(TASKS1, #{
    <<"tasks">> => [
        #{
            <<"name">> => <<"task-4">>,
            <<"command">> => <<"rm /tmp/file1">>,
            <<"requires">> => [
                <<"task-2">>,
                <<"task-3">>
            ]
        },
        #{
            <<"name">> => <<"task-1">>,
            <<"command">> => <<"touch /tmp/file1">>
        },
        #{
            <<"name">> => <<"task-2">>,
            <<"command">> => <<"cat /tmp/file1">>,
            <<"requires">> => [
                <<"task-3">>
            ]
        },
        #{
            <<"name">> => <<"task-3">>,
            <<"command">> => <<"echo 'Hello World!' > /tmp/file1">>,
            <<"requires">> => [
                <<"task-1">>
            ]
        }
    ]
}).
-define(TASKS2, #{
    <<"tasks">> => [
        #{
            <<"name">> => <<"task-2">>,
            <<"command">> => <<"cat /tmp/file1">>,
            <<"requires">> => [
                <<"task-3">>
            ]
        },
        #{
            <<"name">> => <<"task-4">>,
            <<"command">> => <<"rm /tmp/file1">>,
            <<"requires">> => [
                <<"task-2">>,
                <<"task-3">>
            ]
        },
        #{
            <<"name">> => <<"task-3">>,
            <<"command">> => <<"echo 'Hello World!' > /tmp/file1">>,
            <<"requires">> => [
                <<"task-1">>
            ]
        },
        #{
            <<"name">> => <<"task-1">>,
            <<"command">> => <<"touch /tmp/file1">>
        }
    ]
}).
-define(TASKS3, #{
    <<"tasks">> => [
        #{
            <<"name">> => <<"task-2">>,
            <<"command">> => <<"cat /tmp/file1">>,
            <<"requires">> => [
                <<"task-3">>
            ]
        },
        #{
            <<"name">> => <<"task-4">>,
            <<"command">> => <<"rm /tmp/file1">>,
            <<"requires">> => [
                <<"task-2">>,
                <<"task-3">>
            ]
        },
        #{
            <<"name">> => <<"task-10">>,
            <<"command">> => <<"ls">>
        },
        #{
            <<"name">> => <<"task-3">>,
            <<"command">> => <<"echo 'Hello World!' > /tmp/file1">>,
            <<"requires">> => [
                <<"task-1">>
            ]
        },
        #{
            <<"name">> => <<"task-1">>,
            <<"command">> => <<"touch /tmp/file1">>
        }
    ]
}).
-define(TASKS4, #{
    <<"tasks">> => [
        #{
            <<"name">> => <<"task-02">>,
            <<"command">> => <<"cat /tmp/file1">>,
            <<"requires">> => [
                <<"task-03">>
            ]
        },
        #{
            <<"name">> => <<"task-04">>,
            <<"command">> => <<"rm /tmp/file1">>,
            <<"requires">> => [
                <<"task-02">>,
                <<"task-03">>
            ]
        },
        #{
            <<"name">> => <<"task-10">>,
            <<"command">> => <<"ls">>
        },
        #{
            <<"name">> => <<"task-03">>,
            <<"command">> => <<"echo 'Hello World!' > /tmp/file1">>,
            <<"requires">> => [
                <<"task-01">>
            ]
        },
        #{
            <<"name">> => <<"task-01">>,
            <<"command">> => <<"touch /tmp/file1">>
        }
    ]
}).

crafting_software_test_() ->
    [
        sort_test(),
        script_test()
    ].

sort_test() ->
    SortedTasks1 = #{
        <<"tasks">> => [
            #{
                <<"command">> => <<"touch /tmp/file1">>,
                <<"name">> => <<"task-1">>
            },
            #{
                <<"command">> => <<"echo 'Hello World!' > /tmp/file1">>,
                <<"name">> => <<"task-3">>
            },
            #{
                <<"command">> => <<"cat /tmp/file1">>,
                <<"name">> => <<"task-2">>
            },
            #{
                <<"command">> => <<"rm /tmp/file1">>,
                <<"name">> => <<"task-4">>
            }
        ]
    },
    SortedTasks2 = #{
        <<"tasks">> => [
            #{
                <<"command">> => <<"touch /tmp/file1">>,
                <<"name">> => <<"task-1">>
            },
            #{
                <<"command">> => <<"echo 'Hello World!' > /tmp/file1">>,
                <<"name">> => <<"task-3">>
            },
            #{
                <<"command">> => <<"cat /tmp/file1">>,
                <<"name">> => <<"task-2">>
            },
            #{
                <<"command">> => <<"rm /tmp/file1">>,
                <<"name">> => <<"task-4">>
            },
            #{
                <<"command">> => <<"ls">>,
                <<"name">> => <<"task-10">>
            }
        ]
    },
    SortedTasks3 = #{
        <<"tasks">> => [
            #{
                <<"command">> => <<"touch /tmp/file1">>,
                <<"name">> => <<"task-01">>
            },
            #{
                <<"command">> => <<"echo 'Hello World!' > /tmp/file1">>,
                <<"name">> => <<"task-03">>
            },
            #{
                <<"command">> => <<"cat /tmp/file1">>,
                <<"name">> => <<"task-02">>
            },
            #{
                <<"command">> => <<"rm /tmp/file1">>,
                <<"name">> => <<"task-04">>
            },
            #{
                <<"command">> => <<"ls">>,
                <<"name">> => <<"task-10">>
            }
        ]
    },
    [
        ?_assertEqual({ok, SortedTasks1}, crafting_software_test_logic:sort(?TASKS1)),
        ?_assertEqual({ok, SortedTasks1}, crafting_software_test_logic:sort(?TASKS2)),
        ?_assertNotEqual({ok, SortedTasks2}, crafting_software_test_logic:sort(?TASKS3)),
        ?_assertEqual({ok, SortedTasks3}, crafting_software_test_logic:sort(?TASKS4)),
        ?_assertEqual({error, <<"wrong format">>}, crafting_software_test_logic:sort(#{}))
    ].

script_test() ->
    Script =
        <<"#!/usr/bin/env bash\n"
        "touch /tmp/file1\n"
        "echo 'Hello World!' > /tmp/file1\n"
        "cat /tmp/file1\n"
        "rm /tmp/file1">>,
    [
        ?_assertEqual({ok, Script}, crafting_software_test_logic:script(?TASKS1)),
        ?_assertEqual({ok, Script}, crafting_software_test_logic:script(?TASKS2)),
        ?_assertEqual({error, <<"wrong format">>}, crafting_software_test_logic:script(#{}))
    ].
