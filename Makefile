BUILD-FLAGS = --drafts
SERVE-FLAGS = $(BUILD-FLAGS)

.PHONY: all
all: build

.PHONY: build
build:
	bundle exec jekyll build $(BUILD-FLAGS)

.PHONY: serve
serve:
	bundle exec jekyll serve $(SERVE-FLAGS)

.PHONY: clean
clean:
	bundle exec jekyll clean
