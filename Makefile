.PHONY: test

build:
	swift build

run: create_test_data
	swift run declutter test_data

release:
	swift build -c release

install: release
	cp .build/release/declutter /usr/local/bin/declutter
	
test:
	swift test

create_test_data: clean_test_data
	mkdir -p ./test_data/A/
	echo "a" > ./test_data/A/a.txt
	echo "b" > ./test_data/A/b.txt
	
	mkdir -p ./test_data/subset_of_A/
	echo "a" > ./test_data/subset_of_A/a.txt
	
	mkdir -p ./test_data/superset_of_A/
	echo "a" > ./test_data/superset_of_A/a.txt
	echo "b" > ./test_data/superset_of_A/bee.txt
	echo "c" > ./test_data/superset_of_A/c.txt
	

clean_test_data:
	rm -rf ./test_data/
