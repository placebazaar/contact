CMD_PREFIX=bundle exec

# You want latexmk to *always* run, because make does not have all the info.
# Also, include non-file targets in .PHONY so they are run regardless of any
# file of the given name existing.
.PHONY: all test lint clean setup ruby run packages preprocess

# The first rule in a Makefile is the one executed by default ("make"). It
# should always be the "all" rule, so that "make" and "make all" are identical.
all: test lint

# CUSTOM BUILD RULES
test:
	$(CMD_PREFIX) ruby -I lib:test:. -e "Dir.glob('**/*_test.rb') { |f| require(f) }"
lint:
	$(CMD_PREFIX) rubocop

clean:
	$(CMD_PREFIX) rake db:drop
	$(CMD_PREFIX) rake db:create
	$(CMD_PREFIX) rake db:migrate

run:
	$(CMD_PREFIX) foreman start

##
# Set up the project for building
setup: ruby packages

ruby:
	bundle install

packages:
	sudo apt install ruby
