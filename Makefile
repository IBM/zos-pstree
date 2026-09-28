BINS:=pstree

all: $(BINS)

ME:=$(firstword $(MAKEFILE_LIST))

VERSION ?= $(ZOSPSTREE_VERSION)
ifeq ($(strip $(VERSION)),)
VERSION := $(shell git describe --tags --always --dirty 2>/dev/null || echo dev-$(shell date +%Y%m%d_%H%M%S))
endif
LDFLAGS := -X main.version=$(VERSION)

pstree: pstree.go bpx.s $(ME)
	go build -ldflags "$(LDFLAGS)" -o pstree
	-goz-util -c pstree

clean:
	-@ [ -x pstree ] && rm pstree

check:
	@echo no checks yet

install:
	mkdir -p $(PREFIX)/bin
	install $(BINS) $(PREFIX)/bin
