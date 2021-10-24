#include <util.h>

int main(int argc, char* argv[]){
  char* filename = argv[1];
  int n = 0, src;
  vec_int* adjList = read_dataset(filename, &n, &src);

  for (int i = 0; i < n; ++i) {
    printf("%d: ", i);
    int *arr = adjList[i].value;
    int s = adjList[i].size;
    for (int j = 0; j < s; ++j) {
      printf("%d ", arr[j]);
    }
    foreach(vec_int, &adjList[i], it){
      printf("%d ", *it.ref);
    }
    printf("\n");
  }
  return 0;
}
