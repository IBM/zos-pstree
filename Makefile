all: pstree

ME:=$(firstword $(MAKEFILE_LIST))

pstree: pstree.go bpx.s $(ME)
	go build -o pstree
	-goz-util -c pstree

clean:
	-@ [ -x pstree ] && rm pstree

check:
	@echo no checks yet

install:
	mkdir -p $(PREFIX)/bin
	install $(BINS) $(PREFIX)/bin
