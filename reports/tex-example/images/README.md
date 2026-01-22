# images フォルダ

このフォルダに画像ファイルを配置してください．

## 自動生成（推奨）

Python スクリプトを実行すると `temperature.png` をここに生成します:

```bash
# tex-example/ ディレクトリから実行
python3 code/analysis.py
```

または Makefile 経由:

```bash
make images
```

## 手動配置

任意の画像（PNG / JPEG / PDF）をここに置き，
`main.tex` の中で次のように挿入できます:

```latex
\begin{figure}[h]
  \centering
  \includegraphics[width=0.8\linewidth]{images/your_image.png}
  \caption{キャプション}
  \label{fig:your_label}
\end{figure}
```

## 対応フォーマット（LuaLaTeX）

| フォーマット | 拡張子 | 備考 |
|-------------|--------|------|
| PNG         | .png   | 推奨（ラスタ画像） |
| JPEG        | .jpg   | 写真向け |
| PDF         | .pdf   | ベクタ画像（TikZ出力など） |
| EPS         | .eps   | 非推奨（要変換） |
