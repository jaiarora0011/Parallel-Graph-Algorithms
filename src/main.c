#include <util.h>

int main(int argc, char* argv[]){
  char* filename = argv[1];
  int n = 0, src;
  vec_int* adjList = read_dataset(filename, &n, &src);

  for (int i = 0; i < n; ++i) {
    printf("%d: ", i);
    foreach(vec_int, &adjList[i], it){
      printf("%d ", *it.ref);
    }
    printf("\n");
  }
  return 0;
}
