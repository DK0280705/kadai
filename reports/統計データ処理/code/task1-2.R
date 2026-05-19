data <- read.csv("demodata.csv")

ai <- (data$tc - data$hdlc) / data$hdlc
ai <- ai[!is.na(ai)]

dir.create("images", showWarnings = FALSE)
png("images/hist_ai.png", width = 800, height = 640, res = 150)
par(mar = c(4, 4, 2.5, 1))
hist(ai, breaks = 30,
     main = NULL,
     xlab = "AI",
     ylab = "度数",
     col = "steelblue", border = "white")
rug(ai, col = "red", lwd = 0.3)
dev.off()

png("images/boxplot_ai.png", width = 800, height = 640, res = 150)
par(mar = c(2.5, 4, 2.5, 1))
boxplot(ai,
        main = NULL,
        ylab = "AI",
        col = "steelblue", horizontal = FALSE)
dev.off()