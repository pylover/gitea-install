.PHONY: all
all: install


.PHONY: install
install:
	./install.sh



.PHONY: clean
clean::
	rm -rf dl/*