prefix ?= /usr/local
bindir = $(prefix)/bin
libdir = $(prefix)/lib

run:
	@swift run

build:
	swift build -c release --disable-sandbox

install: build
	install ".build/release/declutter" "$(bindir)"
	cp .build/release/declutter /usr/local/bin/declutter
	
uninstall:
	rm -rf "$(bindir)/declutter"

clean:
	rm -rf .build

test:
	swift test

create_test_data: clean_test_data
	mkdir -p ./test_data/A/
	echo "a" > ./test_data/A/a.txt
	echo "b" > ./test_data/A/b.txt
	
	mkdir -p ./test_data/exact_copy_of_A/
	echo "a" > ./test_data/exact_copy_of_A/w.txt
	echo "b" > ./test_data/exact_copy_of_A/z.txt
	
	mkdir -p ./test_data/subset_of_A/
	echo "a" > ./test_data/subset_of_A/a.txt
	
	mkdir -p ./test_data/superset_of_A/
	echo "a" > ./test_data/superset_of_A/a.txt
	echo "b" > ./test_data/superset_of_A/bee.txt
	echo "c" > ./test_data/superset_of_A/c.txt
	

clean_test_data:
	rm -rf ./test_data/

.PHONY: build install uninstall clean
