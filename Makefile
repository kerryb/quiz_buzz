all: style dialyzer test
.PHONY: style dialyzer test
test:
	mix coveralls.html
style:
	mix format --check-formatted
	mix credo
dialyzer:
	mix dialyzer
