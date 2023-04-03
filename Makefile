PROJECT = crafting_software_test
PROJECT_DESCRIPTION = CraftingSoftware coding challenge for Erlang Engineer
PROJECT_VERSION = 0.1.0

DEPS = jsone
DEPS += cowboy

dep_jsone  = git https://github.com/sile/jsone.git       1.8.0
dep_cowboy = git https://github.com/ninenines/cowboy.git 1.1.2

include erlang.mk
