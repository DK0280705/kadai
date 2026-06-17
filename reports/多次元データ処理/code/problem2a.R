library(rTensor)
set.seed(1000 + 4347)
A <- as.tensor(array(sort(sample(1:100, 3*3*3)), dim=c(3,3,3)))

I1 <- dim(A)[1]
I2 <- dim(A)[2]
I3 <- dim(A)[3]

A1_unfold <- unfold(A, row_idx=1, col_idx=c(3,2))
A1_manual <- matrix(0, nrow=I1, ncol=I2*I3)
for (i1 in 1:I1) {
  for (i2 in 1:I2) {
    for (i3 in 1:I3) {
      col_idx <- (i2 - 1) * I3 + i3
      A1_manual[i1, col_idx] <- A@data[i1, i2, i3]
    }
  }
}

A2_unfold <- unfold(A, row_idx=2, col_idx=c(1,3))
A2_manual <- matrix(0, nrow=I2, ncol=I1*I3)
for (i1 in 1:I1) {
  for (i2 in 1:I2) {
    for (i3 in 1:I3) {
      col_idx <- (i3 - 1) * I1 + i1
      A2_manual[i2, col_idx] <- A@data[i1, i2, i3]
    }
  }
}

A3_unfold <- unfold(A, row_idx=3, col_idx=c(1,2))
A3_manual <- matrix(0, nrow=I3, ncol=I1*I2)
for (i1 in 1:I1) {
  for (i2 in 1:I2) {
    for (i3 in 1:I3) {
      col_idx <- (i2 - 1) * I1 + i1
      A3_manual[i3, col_idx] <- A@data[i1, i2, i3]
    }
  }
}

cat("1-mode match:", all(A1_manual == A1_unfold@data), "\n")
cat("2-mode match:", all(A2_manual == A2_unfold@data), "\n")
cat("3-mode match:", all(A3_manual == A3_unfold@data), "\n")
