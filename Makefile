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
