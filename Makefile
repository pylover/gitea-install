.PHONY: all
all: install


.PHONY: install
install:
	./install.sh


.PHONY: post-install
post-install:
	./post-install.sh


.PHONY: clean
clean::
	rm -rf dl/*
