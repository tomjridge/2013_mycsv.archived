all:
	cd build && $(MAKE)

install:
	mkdir -p ${out}/bin
	cp build/mycsv.native ${out}/bin/mycsv

clean:
	cd build && $(MAKE) clean
