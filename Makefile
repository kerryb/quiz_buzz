all: style dialyzer test docs
.PHONY: style dialyzer test
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
	cd assets && npm install && npm run deploy
	mix phx.digest
	SECRET_KEY_BASE="`mix phx.gen.secret`" MIX_ENV=prod mix release

start:
	MIX_ENV=prod APP_NAME=quiz_buzz PORT=4000 _build/prod/rel/quiz_buzz/bin/quiz_buzz start
