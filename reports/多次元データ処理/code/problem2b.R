library(rTensor)

bulb_positions <- c(1, 6, 11, 16, 20, 23, 26, 29, 34, 40, 41, 47, 51, 53, 60, 62)

B <- array(0, dim = c(4,4,4))

# Set 1 on specified indices.
for (pos in bulb_positions) {
  rem1 <- pos - 1
  i3 <- rem1 %/% 16 + 1
  rem2 <- rem1 %% 16
  i2 <- rem2 %/% 4 + 1
  i1 <- rem2 %% 4 + 1
  B[i1, i2, i3] <- 1
}

B <- as.tensor(B)
B_1sum <- modeSum(B, 1, drop=TRUE)
B_2sum <- modeSum(B, 2, drop=TRUE)
B_3sum <- modeSum(B, 3, drop=TRUE)

cat("> B_1sum\n"); print(B_1sum)
cat("> B_2sum\n"); print(B_2sum)
cat("> B_3sum\n"); print(B_3sum)
check1 <- all(B_1sum@data == 1)
check2 <- all(B_2sum@data == 1)
check3 <- all(B_3sum@data == 1)
cat("上→下 (1-mode) 全点灯:", check1, "\n")
cat("左→右 (2-mode) 全点灯:", check2, "\n")
cat("前→後 (3-mode) 全点灯:", check3, "\n")
cat("全方向全点灯:", all(check1, check2, check3), "\n")