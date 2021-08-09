BUILD-FLAGS = --drafts --future
SERVE-FLAGS = $(BUILD-FLAGS)

.PHONY: all
all: build

.PHONY: build
build:
	bundle exec jekyll build $(BUILD-FLAGS)

.PHONY: serve
serve:
	bundle exec jekyll serve $(SERVE-FLAGS)

.PHONY: serve-local
serve-local:
	bundle exec jekyll serve $(SERVE-FLAGS) --host 0.0.0.0

.PHONY: clean
clean:
	bundle exec jekyll clean
