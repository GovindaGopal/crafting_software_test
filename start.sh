#!/bin/sh

exec erl -pa ebin/ deps/*/ebin -s crafting_software_test_app
exit 0
