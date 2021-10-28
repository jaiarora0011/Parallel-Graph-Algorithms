IDIR=include
CC=gcc
CFLAGS=-I$(IDIR)
LIBS=-fopenmp
PYTHON=python3
PREPROC=src/preprocess.py

T=8
P=4


SOURCES = $(wildcard src/*.c)
OBJECTS = $(patsubst src/%.c, obj/%.o, $(SOURCES))
TARGETS = $(patsubst src/%.c, bin/%, $(SOURCES))

DEPS = $(wildcard $(IDIR)/*.h)
DATASETS = $(wildcard datasets/*.txt)
PROCESSED = $(patsubst datasets/%.txt, input/%.txt, $(DATASETS))

INPUTS = $(wildcard input/*.txt)
OUTPUT_SEQ = $(patsubst input/%.txt, output/%_seq.txt, $(INPUTS))
OUTPUT_OMP = $(patsubst input/%.txt, output/%_omp.txt, $(INPUTS))
OUTPUT_MPI = $(patsubst input/%.txt, output/%_mpi.txt, $(INPUTS))

CMP_OMP = $(patsubst output/%_omp.txt, %_omp-cmp, $(OUTPUT_OMP))
CMP_MPI = $(patsubst output/%_mpi.txt, %_mpi-cmp, $(OUTPUT_MPI))

.PHONY: all clean compiler linker preprocess

all: $(TARGETS)


clean:
	@rm -rf obj/*.o bin/* output/*


compile: $(OBJECTS)


linker: $(TARGETS)


preprocess: $(PROCESSED) $(PREPROC)

obj/%.o: src/%.c $(DEPS)
	@$(CC) -c $< -o $@ $(CFLAGS)

bin/%: obj/%.o
	@$(CC) $< -o $@ $(LIBS)

obj/bfs_mpi.o: src/bfs_mpi.c $(DEPS)
	@mpicc -c $< -o $@ $(CFLAGS)

bin/bfs_mpi: obj/bfs_mpi.o
	@mpicc $< -o $@

input/%.txt: datasets/%.txt
	@$(PYTHON) $(PREPROC) $< $@ 0


.PHONY: test_seq

test_seq: bin/bfs_seq $(OUTPUT_SEQ)

output/%_seq.txt: input/%.txt bin/bfs_seq
	@./run.sh seq $< | tee -i $@

.PHONY: test_omp

test_omp: bin/bfs_omp $(OUTPUT_OMP)

output/%_omp.txt: input/%.txt bin/bfs_omp
	@./run.sh omp $< $(T) | tee -i $@

.PHONY: cmp_omp

cmp_omp: $(CMP_OMP)

%_omp-cmp: output/%_omp.txt output/%_seq.txt
	@cmp --silent $^  && (echo 'omp output matches seq') || echo '---- FAIL omp ----'


.PHONY: test_mpi

test_mpi: bin/bfs_mpi $(OUTPUT_MPI)

output/%_mpi.txt: input/%.txt bin/bfs_mpi
	@./run.sh mpi $< $(P) | tee -i $@

.PHONY: cmp_mpi

cmp_mpi: $(CMP_MPI)

%_mpi-cmp: output/%_mpi.txt output/%_seq.txt
	@cmp --silent $^  && (echo 'mpi output matches seq') || echo '---- FAIL mpi ----'
