# See LICENSE for licensing information.
.SILENT:

PROJECT = navistats

# ERLC_OPTS ?= +debug_info +warn_export_all +warn_export_vars \
# 	+warn_shadow_vars +warn_obsolete_guard +warn_missing_spec
ERLC_OPTS := +warn_unused_vars +warn_export_all +warn_shadow_vars
ERLC_OPTS += +warn_unused_import +warn_unused_function +warn_bif_clash
ERLC_OPTS += +warn_unused_record +warn_deprecated_function +warn_obsolete_guard
ERLC_OPTS += +strict_validation +warn_export_vars +warn_exported_vars
ERLC_OPTS += +warn_missing_spec +warn_untyped_record +debug_info

CT_OPTS += -spec test.spec -cover test/cover.spec -erl_args -config test/test.config
PLT_APPS = crypto public_key

# Dependencies.

DEPS = jsx folsom
#  bear

dep_jsx = git git://github.com/baden/jsx.git develop
#dep_jsxn = git git://github.com/talentdeficit/jsxn.git v2.1.1
dep_folsom = git https://github.com/baden/folsom.git 0.8.1-erlang.mk
# dep_bear = git git://github.com/baden/bear.git master

TEST_DEPS = xref_runner

BUILD_DEPS = elvis_mk
DEP_PLUGINS = elvis_mk
dep_elvis_mk = git https://github.com/inaka/elvis.mk.git 1.0.0

# TEST_DEPS = gun
# dep_ct_helper = git https://github.com/extend/ct_helper.git master

EDOC_DIRS := ["src"]
EDOC_OPTS := {preprocess, true}, {source_path, ${EDOC_DIRS}}, nopackages, {subpackages, true}

include erlang.mk

# Also dialyze the tests.
# DIALYZER_OPTS += --src -r test

test-shell: app
	erl -pa ebin -pa deps/*/ebin -pa test -s navistats -config test/test.config
