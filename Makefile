all: style dialyzer test docs
.PHONY: outdated update-deps style dialyzer test docs release
outdated:
	mix hex.outdated --all | grep -v 'Up-to-date'
update-deps:
	mix deps.update --all
	cd assets && rm -f yarn.lock && yarn install
style:
	mix format --check-formatted
	mix credo
dialyzer:
	mix dialyzer
test:
	mix coveralls.html
docs:
	mix docs
release:
	mix phx.digest
	SECRET_KEY_BASE="`mix phx.gen.secret`" MIX_ENV=prod mix release
start:
	MIX_ENV=prod APP_NAME=quiz_buzz PORT=4000 _build/prod/rel/quiz_buzz/bin/quiz_buzz start
