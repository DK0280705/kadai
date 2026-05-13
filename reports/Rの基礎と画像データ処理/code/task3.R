library(imager)

convolve2d <- function(img, kernel) {
  rows   <- nrow(img)
  cols   <- ncol(img)
  kr     <- nrow(kernel)
  kc     <- ncol(kernel)
  pad_r  <- (kr - 1) %/% 2
  pad_c  <- (kc - 1) %/% 2
  padded <- matrix(0, nrow = rows + 2 * pad_r, ncol = cols + 2 * pad_c)
  padded[(pad_r + 1):(pad_r + rows), (pad_c + 1):(pad_c + cols)] <- img
  out <- matrix(0, nrow = rows, ncol = cols)
  for (i in seq_len(rows)) {
    for (j in seq_len(cols)) {
      out[i, j] <- sum(padded[i:(i + kr - 1), j:(j + kc - 1)] * kernel)
    }
  }
  out
}

# Image is 3d array (height * width * channels)
convolve_img <- function(img, kernel) {
  if (length(dim(img)) == 2) dim(img) <- c(dim(img), 1)
  out <- img
  for (ch in seq_len(dim(img)[3])) {
    out[,,ch] <- convolve2d(img[,,ch], kernel)
  }
  out
}

load_img <- function(path) {
  as.array(load.image(path))[,,1,]
}

save_img <- function(img, path) {
  d <- dim(img)
  imager::save.image(as.cimg(array(img, c(d[1], d[2], 1, d[3]))), path)
}

# 5x5 Gaussian blur kernel 
gaussian_kernel <- matrix(
  c(1,  4,  7,  4, 1,
    4, 16, 26, 16, 4,
    7, 26, 41, 26, 7,
    4, 16, 26, 16, 4,
    1,  4,  7,  4, 1),
  nrow = 5, ncol = 5, byrow = TRUE
)

gaussian_kernel <- gaussian_kernel / sum(gaussian_kernel)
# 3x3 sharpening kernel
sharpen_kernel <- matrix(
  c( 0, -1,  0,
    -1,  5, -1,
     0, -1,  0),
  nrow = 3, ncol = 3, byrow = TRUE
)

# 3x3 edge-detection kernel
laplacian_kernel <- matrix(
  c( 0,  1,  0,
     1, -4,  1,
     0,  1,  0),
  nrow = 3, ncol = 3, byrow = TRUE
)

base_dir <- "images"
frame_ids <- c("05", "15", "25")

for (fid in frame_ids) {
  src <- file.path(base_dir, paste0("frame_", fid, ".png"))
  arr <- load_img(src)

  blurred   <- convolve_img(arr, gaussian_kernel)
  sharpened <- convolve_img(arr, sharpen_kernel)
  edges     <- convolve_img(arr, laplacian_kernel)

  save_img(blurred,   file.path(base_dir, paste0("frame_", fid, "_blur.png")))
  save_img(sharpened, file.path(base_dir, paste0("frame_", fid, "_sharp.png")))
  save_img(edges,     file.path(base_dir, paste0("frame_", fid, "_edge.png")))
}
