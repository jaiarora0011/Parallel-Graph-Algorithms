# COV880: Parallel Graph Algorithms

## Algorithms Implemented

1. Sequential BFS
2. Shared Memory BFS
3. Distributed Memory BFS 1D

## I/O Specs

### Input Format

Each file in `input/` should have the format:
```
n m r undirected
u_1 v_1 uv_1
...
u_m v_m uv_m

Here
    n               :   Number of unique nodes in the graph
    m               :   Number of edges in the graph
```

### Output format
Each file in `output/` has the format:
```
u  d_u
```


## Usage

#### Build all the binaries

```bash
make
```

#### Preprocessing

This will take all files in `datasets/` and preprocess each of them. Preprocessed files are stored in `input/`

```bash
make preprocess
```

To manually preprocess a specific file:
```bash
./run.sh preprocess <input_file> <output_file> <undir>
```
Here, `undir` = 1 for an undirected graph, 0 otherwise.

#### Running all Tests

```bash
make test_seq
make test_omp T=<num_threads>
make test_mpi P=<num_procs>
```
This will take all input files in `input/` and run the three algorithms on them. By default, OpenMP is run with 8 threads and MPI is run with 4 processes. The output files are generated in `output/`

#### Running a specific algorithm on an input

```bash
./run.sh seq <input_file> <output_file>
./run.sh omp <input_file> <output_file> <num_threads>
./run.sh mpi <input_file> <output_file> <num_procs>
```

#### Validating the outputs

```bash
make cmp_omp
make cmp_mpi
```
These will check if the Parallel versions match with the sequential versions
