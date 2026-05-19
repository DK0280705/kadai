data <- read.csv("minidata.csv")

cat("\n1. 身長150cm未満の行データ\n")
print(data[data$ht < 150, ])

cat("\n2. 身長150cm以上、170cm未満の行データ\n")
print(data[data$ht >= 150 & data$ht < 170, ])

cat("\n3. 身長150cm以上、170cm未満で女性の行データ\n")
print(data[data$ht >= 150 & data$ht < 170 & data$sex == "f", ])
