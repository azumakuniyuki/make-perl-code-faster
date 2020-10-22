# make-perl-code-faster/Developers.mk
#  ____                 _                                       _    
# |  _ \  _____   _____| | ___  _ __   ___ _ __ ___   _ __ ___ | | __
# | | | |/ _ \ \ / / _ \ |/ _ \| '_ \ / _ \ '__/ __| | '_ ` _ \| |/ /
# | |_| |  __/\ V /  __/ | (_) | |_) |  __/ |  \__ \_| | | | | |   < 
# |____/ \___| \_/ \___|_|\___/| .__/ \___|_|  |___(_)_| |_| |_|_|\_\
#                              |_|                                   
# -----------------------------------------------------------------------------
SHELL := /bin/sh
TIME  := $(shell date '+%F')
NAME  := make-perl-code-faster
PERL  ?= perl
CPANM := http://cpanmin.us/
CPM   := https://git.io/cpm
WGET  := wget -c 
CURL  := curl -L
CHMOD := chmod
PROVE := prove -Ilib --timer
MINIL := minil
CP    := cp
RM    := rm -f

.DEFAULT_GOAL = git-status
REPOS_TARGETS = git-status git-push git-commit-amend git-tag-list git-diff \
				git-reset-soft git-rm-cached git-branch

# -----------------------------------------------------------------------------
.PHONY: clean
cpanm:
	$(WGET) -O ./$@ $(CPANM) || $(CURL) -o ./$@ $(CPANM)
	test -f ./$@ && $(CHMOD) a+x ./$@

cpm:
	$(CURL) -s --compressed $(CPM) > ./$@
	test -f ./$@ && $(CHMOD) a+x ./$@

install-from-cpan:
	curl -L https://cpanmin.us | $(PERL) - -M https://cpan.metacpan.org -n $(NAME)

install-from-local: cpanm
	./cpanm --sudo . || ( make cpm && ./cpm install --sudo -v . )

$(REPOS_TARGETS):
	$(MAKE) -f Repository.mk $@

diff push branch:
	@$(MAKE) git-$@
fix-commit-message: git-commit-amend
cancel-the-latest-commit: git-reset-soft
remove-added-file: git-rm-cached

clean:
	$(MAKE) -f Repository.mk clean
	$(MAKE) -f Benchmarks.mk clean

