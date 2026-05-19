data <- read.csv("demodata.csv")

# (1) 男女に分割
mdata <- data[data$sex == "m", ]
fdata <- data[data$sex == "f", ]

cat("男性:", nrow(mdata), "人\t女性:", nrow(fdata), "人\n\n")

vars <- c("ht", "wt", "sbp", "dbp")
labels <- c("ht" = "身長 (cm)", "wt" = "体重 (kg)",
            "sbp" = "収縮期血圧 (mmHg)", "dbp" = "拡張期血圧 (mmHg)")

dir.create("images", showWarnings = FALSE)

for (v in vars) {
  # 男性
  xm <- mdata[[v]]; xm <- xm[!is.na(xm)]
  png(paste0("images/hist_m_", v, ".png"),
      width = 800, height = 560, res = 150)
  par(mar = c(4, 4, 2.5, 1))
  hist(xm, breaks = 30, main = NULL,
       xlab = paste0("男性 ", labels[v]),
       ylab = "度数", col = "steelblue", border = "white")
  rug(xm, col = "red", lwd = 0.3)
  dev.off()

  # 女性
  xf <- fdata[[v]]; xf <- xf[!is.na(xf)]
  png(paste0("images/hist_f_", v, ".png"),
      width = 800, height = 560, res = 150)
  par(mar = c(4, 4, 2.5, 1))
  hist(xf, breaks = 30, main = NULL,
       xlab = paste0("女性 ", labels[v]),
       ylab = "度数", col = "tomato", border = "white")
  rug(xf, col = "red", lwd = 0.3)
  dev.off()
}

# (4)(5) 要約統計量
summary_stats <- function(x, name) {
  x <- x[!is.na(x)]
  q <- quantile(x, probs = c(0.25, 0.75))
  cat(sprintf("%-8s  n=%-5d  mean=%.2f  sd=%.2f  median=%.2f  Q1=%.2f  Q3=%.2f  IQR=%.2f\n",
              name, length(x), mean(x), sd(x), median(x), q[1], q[2], q[2]-q[1]))
}

cat("男性の要約統計量\n")
for (v in vars) summary_stats(mdata[[v]], paste0("M_", v))

cat("\n女性の要約統計量\n")
for (v in vars) summary_stats(fdata[[v]], paste0("F_", v))
