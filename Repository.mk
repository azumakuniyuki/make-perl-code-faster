# make-perl-code-faster/Repository.mk
#  ____                      _ _                               _    
# |  _ \ ___ _ __   ___  ___(_) |_ ___  _ __ _   _   _ __ ___ | | __
# | |_) / _ \ '_ \ / _ \/ __| | __/ _ \| '__| | | | | '_ ` _ \| |/ /
# |  _ <  __/ |_) | (_) \__ \ | || (_) | |  | |_| |_| | | | | |   < 
# |_| \_\___| .__/ \___/|___/_|\__\___/|_|   \__, (_)_| |_| |_|_|\_\
#           |_|                              |___/                  
# -----------------------------------------------------------------------------
SHELL := /bin/sh
GIT   ?= git
CP    := cp
V      = neko

.DEFAULT_GOAL = git-status

# -----------------------------------------------------------------------------
.PHONY: clean

git-status:
	$(GIT) status

git-push:
	@ for v in `$(GIT) remote show | grep -v origin`; do \
		printf "[%s]\n" $$v; \
		$(GIT) push --tags $$v `$(MAKE) -f Repository.mk git-current-branch`; \
	done

git-tag-list:
	$(GIT) tag -l

git-diff:
	$(GIT) diff -w

git-branch:
	$(GIT) branch -a

git-branch-delete:
	$(GIT) branch --merged | grep '^ ' | grep -v 'master' | xargs $(GIT) branch -d

git-commit-amend:
	$(GIT) commit --amend

git-current-branch:
	@$(GIT) branch --contains=HEAD | grep '*' | awk '{ print $$2 }'

git-follow-log:
	$(GIT) log --follow -p $(V) || \
		printf "\nUsage:\n %% make -f Repository.mk $@ V=<filename>\n"

git-branch-tree:
	$(GIT) log --graph \
		--pretty='format:%C(yellow)%h%Creset %s %Cgreen(%an)%Creset %Cred%d%Creset'

git-rm-cached:
	$(GIT) rm -f --cached $(V) || \
		printf "\nUsage:\n %% make -f Repository.mk $@ V=<filename>\n"

git-reset-soft:
	$(GIT) reset --soft HEAD^

clean:

