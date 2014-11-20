# See LICENSE for licensing information.

PROJECT = navistats

ERLC_OPTS ?= +debug_info +warn_export_all +warn_export_vars \
	+warn_shadow_vars +warn_obsolete_guard +warn_missing_spec

CT_OPTS += -spec test.spec -cover test/cover.spec -erl_args -config test/test.config
PLT_APPS = crypto public_key

# Dependencies.

DEPS = jsxn folsom bear

dep_jsx = git git://github.com/baden/jsx.git develop
dep_jsxn = git git://github.com/talentdeficit/jsxn.git v2.1.1
dep_folsom = git https://github.com/baden/folsom.git patch-1
dep_bear = git git://github.com/baden/bear.git master

# TEST_DEPS = gun
# dep_ct_helper = git https://github.com/extend/ct_helper.git master

include erlang.mk

# Also dialyze the tests.
# DIALYZER_OPTS += --src -r test

test-shell: app
	erl -pa ebin -pa deps/*/ebin -pa test -s navistats -config test/test.config
