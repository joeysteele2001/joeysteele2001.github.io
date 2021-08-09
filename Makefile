BUILD-FLAGS = --drafts --incremental --future
SERVE-FLAGS = $(BUILD-FLAGS)
ENV_VARIABLES = JEKYLL_ENV=development

.PHONY: all
all: build

.PHONY: build
build:
	$(ENV_VARIABLES) bundle exec jekyll build $(BUILD-FLAGS)

.PHONY: serve
serve:
	$(ENV_VARIABLES) bundle exec jekyll serve $(SERVE-FLAGS)

.PHONY: serve-local
serve-local:
	$(ENV_VARIABLES) bundle exec jekyll serve $(SERVE-FLAGS) --host 0.0.0.0

.PHONY: clean
clean:
	bundle exec jekyll clean
