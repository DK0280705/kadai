#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdlib.h>
#include <errno.h>

#pragma pack(push, 1) // Disable padding

#define WIDTH 1000
#define HEIGHT 1000

typedef struct {
    uint16_t type;       // Signature "BM"
    uint32_t size;       // File size in bytes
    uint32_t reserved;   // Reserved, must be 0
    uint32_t off_bits;   // Offset to pixel data
} bitmap_file_header_t;

typedef struct {
    uint32_t size;                  // Size of this header (40 bytes)
    int32_t  width;                 // Width of bitmap in pixels
    int32_t  height;                // Height of bitmap in pixels
    uint16_t planes;                // Number of color planes (must be 1)
    uint16_t bits_per_pixel;        // Bits per pixel (24 for True Color RGB (R (8) + G (8) + B (8)))
    uint32_t compression;           // Compression type (0 = BI_RGB)
    uint32_t image_size;            // Size of pixel data (can be 0 if no compression)
    int32_t  x_pixels_per_meter;    // Horizontal resolution
    int32_t  y_pixels_per_meter;    // Vertical resolution
    uint32_t colors_used;           // Number of colors in palette (0 = all)
    uint32_t important_colors;      // Important colors (0 = all)
} bitmap_info_header_t;

// Should be RGB order but little endian forced us to do this
typedef struct {
    uint8_t blue;
    uint8_t green;
    uint8_t red;
} pixel_data_t;

typedef struct {
    bitmap_file_header_t file_header;
    bitmap_info_header_t info_header;
    // if bits per pixel less than 8, this space should be a color_table_t
    pixel_data_t* pixel_data;
} bitmap_t;

size_t get_padded_row_size(int width)
{
    // Add padding to each row according to bitmap specifications
    // int width_in_bytes = width * 3; // 1 bit for each R, G, and B
    // int padding_size = (4 - width_in_bytes % 4) % 4;

    // This is the simpler way:
    // rounded = (x + (n - 1)) & ~(n-1)
    // by dividing a number with 4, because the remainder would be the last 2 bits.
    // so remove the last 2 bits
    return (width * 3 + 3) & (~3);
}

bitmap_t bitmap_init(int width, int height)
{
    int padded_row = get_padded_row_size(width);
    int image_size = padded_row * height;
    int off_bits = sizeof(bitmap_file_header_t) + sizeof(bitmap_info_header_t);

    bitmap_t bitmap;
    // Literally "BM" to 0x4D (M) 0x42 (B) (little endian)
    bitmap.file_header.type = 0x4D42;
    bitmap.file_header.size = off_bits + image_size;
    bitmap.file_header.reserved = 0;
    bitmap.file_header.off_bits = off_bits;

    bitmap.info_header.size = sizeof(bitmap_info_header_t);
    bitmap.info_header.width = width;
    bitmap.info_header.height = height;
    bitmap.info_header.planes = 1;
    bitmap.info_header.bits_per_pixel = 24;
    bitmap.info_header.compression = 0;
    bitmap.info_header.image_size = image_size;
    bitmap.info_header.x_pixels_per_meter = 0;
    bitmap.info_header.y_pixels_per_meter = 0;
    bitmap.info_header.colors_used = 0;
    bitmap.info_header.important_colors = 0;    

    return bitmap;
}

void bitmap_destroy(bitmap_t* bitmap)
{
    if (bitmap->pixel_data)
        free(bitmap->pixel_data);
}

#pragma pack(pop)

int bitmap_read_file(bitmap_t* bitmap, FILE* fp)
{
    fread(&bitmap->file_header, sizeof(bitmap_file_header_t), 1, fp);
    fread(&bitmap->info_header, sizeof(bitmap_info_header_t), 1, fp);

    if (bitmap->file_header.type != 0x4D42) {
        fprintf(stderr, "Invalid file header");
        return -1;
    }

    if (bitmap->info_header.bits_per_pixel != 24) {
        fprintf(stderr, "Only supports 8 bit rgb without transparency");
        return -1;
    }

    int width = bitmap->info_header.width;
    int height = bitmap->info_header.height;

    bitmap->pixel_data = malloc(sizeof(pixel_data_t) * width * height);
    if (!bitmap->pixel_data) return -1;
    
    if (fseek(fp, bitmap->file_header.off_bits, SEEK_SET) != 0) return -1;
    
    size_t padded_row_size = get_padded_row_size(width);
    uint8_t* row_buffer = calloc(padded_row_size, sizeof(uint8_t));
    if (!row_buffer) return -1;
    // just in case if height is reversed
    int y_start = (height > 0) ? height - 1 : 0;
    int y_step  = (height > 0) ? -1 : 1;

    for (int y = y_start; (y >= 0 && y < height);y += y_step) {
        if (fread(row_buffer, 1, padded_row_size , fp) != padded_row_size) {
            free(row_buffer);
            return -1;
        }
        memcpy(bitmap->pixel_data + y * width, row_buffer, sizeof(pixel_data_t) * width);
    }

    free(row_buffer);
    rewind(fp);

    return 0;
}

int bitmap_write_file(bitmap_t* bitmap, FILE* fp)
{
    int width = bitmap->info_header.width;
    int height = bitmap->info_header.height;

    size_t padded_row_size = get_padded_row_size(width);
    uint8_t* row_buffer = calloc(padded_row_size, sizeof(uint8_t));
    if (!row_buffer) return -1;

    // Write the header first
    fwrite(&bitmap->file_header, sizeof(bitmap_file_header_t), 1, fp);
    fwrite(&bitmap->info_header, sizeof(bitmap_info_header_t), 1, fp);

    int y_start = (height > 0) ? height - 1 : 0;
    int y_step  = (height > 0) ? -1 : 1;

    // Then write the pixels
    for (int y = y_start; (y >= 0 && y < height); y += y_step) {
        memcpy(row_buffer, bitmap->pixel_data + y * width, sizeof(pixel_data_t) * width);
        if (fwrite(row_buffer, 1, padded_row_size, fp) != padded_row_size) {
            free(row_buffer);
            return -1;
        }
    }

    free(row_buffer);

    return 0;
}

void bitmap_fill(bitmap_t* bitmap, pixel_data_t const pixel)
{
    int width = bitmap->info_header.width;
    int height = bitmap->info_header.height;

    for (int i = 0; i < width * height; ++i) {
        memcpy(bitmap->pixel_data + i, &pixel, 3);
    }
}

int main(int argc, const char** argv)
{
    if (argc < 5) {
        fprintf(stderr, "USAGE: %s <FILENAME:path> <R:int> <G:int> <B:int>\n", argv[0]);
        exit(-1);
    }

    bitmap_t bitmap = bitmap_init(WIDTH, HEIGHT);
    char* p_end;
    const char* filename = argv[1];
    int r = strtol(argv[2], &p_end, 10);
    if (argv[2] == p_end) {
        fprintf(stderr, "Invalid value on R\n");
        fprintf(stderr, "USAGE: %s <FILENAME:path> <R:int> <G:int> <B:int>\n", argv[0]);
        exit(-1);
    }
    int g = strtol(argv[3], &p_end, 10);
    if (argv[3] == p_end) {
        fprintf(stderr, "Invalid value on G\n");
        fprintf(stderr, "USAGE: %s <FILENAME:path> <R:int> <G:int> <B:int>\n", argv[0]);
        exit(-1);
    }
    int b = strtol(argv[4], &p_end, 10);
    if (argv[4] == p_end) {
        fprintf(stderr, "Invalid value on B\n");
        fprintf(stderr, "USAGE: %s <FILENAME:path> <R:int> <G:int> <B:int>\n", argv[0]);
        exit(-1);
    }

    FILE* fp;
    if ((fp = fopen(filename, "rb+"))) {
        puts("File exists, reading file...");
        if (bitmap_read_file(&bitmap, fp) == -1) {
            if (errno) fprintf(stderr, "Error: %s\n", strerror(errno));
            exit(-1);
        }
    } else if ((fp = fopen(filename, "wb+"))) {
        puts("File not exist, creating file...");
        bitmap.pixel_data = malloc(sizeof(pixel_data_t) * WIDTH * HEIGHT);
    } else {
        fprintf(stderr, "Failed to create file: %s\n", strerror(errno));
        exit(-1);
    }

    pixel_data_t const pixel = { b, g, r };
    bitmap_fill(&bitmap, pixel);
    if (bitmap_write_file(&bitmap, fp) == -1) {
        fprintf(stderr, "Error while writing file: %s\n", strerror(errno));
        exit(-1);
    };

    // Cleanup
    bitmap_destroy(&bitmap);
    fclose(fp);

    puts("done");

    return 0;
}
