.PHONY: all
all: build

.PHONY: build
build:
	bundle exec jekyll build

.PHONY: serve
serve:
	bundle exec jekyll serve

.PHONY: clean
clean:
	jekyll clean
