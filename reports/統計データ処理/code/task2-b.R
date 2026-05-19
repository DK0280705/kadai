library(dplyr)
options(crayon.enabled = FALSE)  # 出力のANSIエスケープシーケンスを無効化

users <- tibble(
  ユーザーID = 1:6,
  名前 = c("田中太郎", "鈴木花子", "佐藤次郎", "高橋明子", "伊藤健太", "山田一郎"),
  メールアドレス = paste0("user", 1:6, "@example.com"),
  作成日時 = as.Date(c(
    "2026-04-01", "2026-04-02",
    "2026-04-03", "2026-04-05",
    "2026-04-07", "2026-04-10"))
)

posts <- tibble(
  投稿ID = 1:8,
  ユーザーID = c(1, 1, 2, 3, 3, 4, 5, 5),
  投稿内容 = c(
    "R言語の勉強を始めました！",
    "dplyrはとても便利なパッケージです",
    "今日はggplot2でグラフを作成しました",
    "データ分析の基礎を学習中",
    "統計検定に合格しました！",
    "PythonもRもどちらも楽しい",
    "初めての投稿です！",
    "R Markdownでレポート作成中"
  ),
  投稿日時 = as.Date(c(
    "2026-05-01", "2026-05-02",
    "2026-05-03", "2026-05-04",
    "2026-05-05", "2026-05-06",
    "2026-05-07", "2026-05-07"))
)

likes <- tibble(
  いいねID = 1:10,
  ユーザーID = c(2, 3, 1, 4, 5, 2, 3, 1, 5, 4),
  投稿ID     = c(1, 1, 2, 3, 3, 4, 5, 5, 6, 7),
  いいね日時 = as.Date(c(
    "2026-05-01", "2026-05-01",
    "2026-05-02", "2026-05-03",
    "2026-05-03", "2026-05-04",
    "2026-05-05", "2026-05-05",
    "2026-05-06", "2026-05-07"))
)

cat("1. tibbleの作成 ═══\n")
print(users)
cat("\n")
print(posts)
cat("\n")
print(likes)
cat("\n\n")

cat("2. filter：ユーザーID=3の投稿のみ抽出\n")
posts_uid3 <- posts %>% filter(ユーザーID == 3)
print(posts_uid3)
cat("\n\n")

cat("3. select：投稿IDと投稿内容のみ選択\n")
posts_selected <- posts %>% select(投稿ID, 投稿内容)
print(posts_selected)
cat("\n\n")

cat("4. mutate：ユーザー名とメアドの文字数を追加\n")
users_extended <- users %>%
  mutate(名前_文字数 = nchar(名前),
         ドメイン = sub(".*@", "", メールアドレス))
print(users_extended)
cat("\n\n")

cat("5. group_by＋summarise：ユーザー別投稿数\n")
post_count <- posts %>%
  group_by(ユーザーID) %>%
  summarise(投稿数 = n())
print(post_count)
cat("\n")

cat("5. 各投稿の「いいね」数を集計：\n")
like_count <- likes %>%
  group_by(投稿ID) %>%
  summarise(いいね数 = n())
print(like_count)
cat("\n\n")

cat("6. arrange：投稿を新しい順に並べ替え\n")
posts_sorted <- posts %>% arrange(desc(投稿日時))
print(posts_sorted)
cat("\n\n")

cat("7. join：投稿にユーザー名を結合\n")
cat("  (a) inner_join：投稿があるユーザーのみ\n")
posts_with_user <- posts %>%
  inner_join(users %>% select(ユーザーID, 名前), by = "ユーザーID") %>%
  select(投稿ID, 名前, 投稿内容, 投稿日時)
print(posts_with_user)
cat("\n")

cat("  (b) left_join：全ユーザーを残す（投稿がない人は NA）\n")
users_with_posts <- users %>%
  left_join(posts %>% select(投稿ID, ユーザーID, 投稿内容, 投稿日時),
            by = "ユーザーID")
print(users_with_posts)
cat("\n\n")