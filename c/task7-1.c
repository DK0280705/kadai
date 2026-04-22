#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdlib.h>
#include <unistd.h>

typedef struct
{
    size_t size; //number of data, use 8 bytes;
    size_t capacity; // dynamic array allocated capacity
    double* numbers; // Array of numbers;
} data_t;

data_t data_init()
{
    data_t data;
    data.size = 0;
    data.capacity = 0;
    data.numbers = NULL;
    return data;
}

data_t data_destroy(data_t* data)
{
    if (data->numbers) free(data->numbers);
}

// Reserve an amount of capacity, the capacity grows exponentially
int data_reserve(data_t* data, size_t new_capacity)
{
    if (new_capacity <= data->capacity) return 0;
    double *tmp = realloc(data->numbers, new_capacity * sizeof(double));
    if (!tmp) return -1;

    data->numbers = tmp;
    data->capacity = new_capacity;
    return 0;
}

int data_push(data_t* data, double value)
{
    if (data->size == data->capacity) {
        size_t new_capacity = data->capacity ? data->capacity * 2 : 1;
        if (data_reserve(data, new_capacity) != 0) return -1;
    }
    data->numbers[data->size++] = value;
    return 0;
}

int data_read_all(data_t* data, FILE* fp)
{
    fread(&data->size, sizeof(size_t), 1, fp);
    if (data->size == 0) return 0;

    char buffer[4096];

    data->capacity = 1;
    while (data->capacity < data->size) data->capacity *= 2;

    double* tmp = realloc(data->numbers, data->capacity * sizeof(double));
    if (!tmp) return -1;
    data->numbers = tmp;

    size_t nread = fread(data->numbers, sizeof(double), data->size, fp);
    if (nread != data->size) {
        perror("data is invalid!");
        return -1;
    }
    return 0;
}

int main() {
    FILE* fp;
    data_t data = data_init();
    // Initializes and check if file not exist.
    if (!(fp = fopen("data7_3", "rb+"))) {
        fp = fopen("data7_3", "wb+");
        fwrite(&data.size, sizeof(size_t), 1, fp);
    } else if (data_read_all(&data, fp) == -1) {
        perror("realloc failed!");
        exit(-1);
    }

    puts("File data:");
    printf("size(%ld): ", data.size);
    for (int i = 0; i < data.size; ++i) {
        printf("%lf ", data.numbers[i]);
    }
    puts("\n");

    size_t last_size = data.size;

    char buffer[64];
    char* ret;
    do {
        printf("Input data: ");
        if (ret = fgets(buffer, 64, stdin)) {
            double d;
            int ns = sscanf(buffer, "%lf", &d);
            if (ns != 1) fprintf(stderr, "Invalid data!\n");
            else if (data_push(&data, d) == -1) {
                perror("realloc failed!");
                exit(-1);
            };
        }
    } while (ret);

    puts("\n");

    puts("File data:");
    printf("size(%ld): ", data.size);
    for (int i = 0; i < data.size; ++i) {
        printf("%lf ", data.numbers[i]);
    }
    puts("\n");

    rewind(fp);
    fwrite(&data.size, sizeof(size_t), 1, fp);
    fseek(fp, last_size * 8, SEEK_CUR); 
    // Written with sizeof double must be read with size of double
    // otherwise use htonl for writing and ntohl for reading (Big Endian)
    // crazy stuff happens when you ignore endianness
    fwrite(data.numbers + last_size, sizeof(double), data.size - last_size, fp);
    
    data_destroy(&data);
    fclose(fp);
}
