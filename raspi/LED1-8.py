#!/usr/bin/env python3
#
# program1-8.py
# "×" の記号を Sense HAT 上に表示する
#

from sense_hat import SenseHat
import time

sense = SenseHat()

# 色設定
r = [255, 0, 0]   # 赤

# 画面クリア
sense.clear()

# “×” を描く
# 左上→右下 と 右上→左下 の斜め線を描く
for i in range(8):
    sense.set_pixel(i, i, r)           # 左上→右下の斜め線
    sense.set_pixel(7 - i, i, r)       # 右上→左下の斜め線

# 3秒表示
time.sleep(3)

# 消灯
sense.clear()


