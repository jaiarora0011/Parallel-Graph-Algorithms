IDIR=include
CC=gcc
CFLAGS=-I$(IDIR)
PYTHON=python3
PREPROC=src/modify_edge_file.py


SOURCES = $(wildcard src/*.c)
OBJECTS = $(patsubst src/%.c, obj/%.o, $(SOURCES))
TARGETS = $(patsubst src/%.c, bin/%, $(SOURCES))

DEPS = $(wildcard $(IDIR)/*.h)
DATASETS = $(wildcard datasets/*.txt)
PROCESSED = $(patsubst datasets/%.txt, input/%.txt, $(DATASETS))

.PHONY: all clean compiler linker preprocess

all: $(TARGETS)


clean:
	@rm -rf obj/*.o bin/*


compile: $(OBJECTS)


linker: $(TARGETS)


preprocess: $(PROCESSED) $(PREPROC)

obj/%.o: src/%.c $(DEPS)
	@$(CC) -c $< -o $@ $(CFLAGS)

bin/%: obj/%.o
	@$(CC) $< -o $@

input/%.txt: datasets/%.txt
	@$(PYTHON) $(PREPROC) $< $@
