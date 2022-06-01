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
	$(ENV_VARIABLES) bundle exec jekyll build $(BUILD_FLAGS)

.PHONY: serve
serve:
	$(ENV_VARIABLES) bundle exec jekyll serve $(SERVE_FLAGS)

.PHONY: serve-local
serve-local:
	$(ENV_VARIABLES) bundle exec jekyll serve $(SERVE_FLAGS) --host 0.0.0.0

.PHONY: clean
clean:
	bundle exec jekyll clean
