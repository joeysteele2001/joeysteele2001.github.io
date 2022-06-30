BUILD_FLAGS = --drafts --future
SERVE_FLAGS = $(BUILD_FLAGS)
ENV_VARIABLES = JEKYLL_ENV=development

ifdef incremental
BUILD_FLAGS += --incremental
endif

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
