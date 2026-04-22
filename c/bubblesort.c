#include <stdio.h>

int* bubble_sort(int arr[], int len) {
    for (int i = 0; i < len; ++i)
        for(int j = 0; j < len - i - 1; ++j)
            if (arr[j] > arr[j + 1]) {
                int temp = arr[j];
                arr[j] = arr[j + 1];
                arr[j + 1] = temp;
            }       
    return arr;
}

void print_array(int arr[], int len)
{
	for (int i = 0; i < len; i++)
		printf("%d ", arr[i]);
	printf("\n");
}


int main() {
	int arr[] = {64, 34, 25, 12, 22, 11, 90};
	int len = sizeof(arr) / sizeof(arr[0]);

	printf("original array:\n");
	print_array(arr, len);

	bubble_sort(arr, len);

	printf("sorted array:\n");
	print_array(arr, len);

	return 0;
}
