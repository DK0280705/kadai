data <- read.csv("demodata.csv")
vars <- c("wt", "sbp", "dbp", "fbs", "ha1c", "got", "gpt", "ggt")

dir.create("images", showWarnings = FALSE)

for (v in vars) {
  x <- data[[v]]
  x <- x[!is.na(x)]

  hist_file <- paste0("images/hist_", v, ".png")
  png(hist_file, width = 800, height = 640, res = 150)
  par(mar = c(4, 4, 2.5, 1))
  h <- hist(x, breaks = 30, plot = FALSE)
  hist(x, breaks = 30,
       main = NULL,
       xlab = paste0("data$", v),
       ylab = "度数",
       col = "steelblue", border = "white")
  rug(x, col = "red", lwd = 0.3)
  dev.off()

  box_file <- paste0("images/boxplot_", v, ".png")
  png(box_file, width = 800, height = 640, res = 150)
  par(mar = c(2.5, 4, 2.5, 1))
  boxplot(x,
          main = NULL,
          ylab = paste0("data$", v),
          col = "steelblue", horizontal = FALSE)
  dev.off()
}