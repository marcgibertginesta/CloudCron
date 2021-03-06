.PHONY: help
# Add the following 'help' target to your Makefile
# And add help text after each target name starting with '\#\#'
# A category can be added with @category
# Code below from: https://gist.github.com/prwhite/8168133
HELP_FUN = \
    %help; \
    while(<>) { push @{$$help{$$2 // 'options'}}, [$$1, $$3] if /^([a-zA-Z\-]+)\s*:.*\#\#(?:@([a-zA-Z\-]+))?\s(.*)$$/ }; \
    print "usage: make [target]\n\n"; \
    for (sort keys %help) { \
    print "${WHITE}$$_:${RESET}\n"; \
    for (@{$$help{$$_}}) { \
    $$sep = " " x (32 - length $$_->[0]); \
    print "  ${YELLOW}$$_->[0]${RESET}$$sep${GREEN}$$_->[1]${RESET}\n"; \
    }; \
    print "\n"; }
help: ##@other Show this help.
	@perl -e '$(HELP_FUN)' $(MAKEFILE_LIST)

deps-update:
	PERL_CARTON_MIRROR=file://$(HOME)/src/cps-cpan/repo carton install

critique-file: ## critique $file
	carton exec perlcritic --severity=$(severity) ${file}

test-single: ## run test over $testfile
	carton exec perl -I local -I lib -I t/lib ${testfile}

tidy: ## run perltidy on $tidyfile
	carton exec perl -I local -I lib ./local/bin/perltidy ${tidyfile}

dists: dist-cloudcron dist-worker ## build all packages

dist-cloudcron: ## build cloudcron
	cp dist.ini-cloudcron dist.ini
	carton exec dzil build
dist-worker: ## build worker
	cp dist.ini-worker dist.ini
	carton exec dzil build
