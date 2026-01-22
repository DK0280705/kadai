#!/usr/bin/env python3
#
# program1-7.py
# "+"の記号をSense HAT上に表示する
#

from sense_hat import SenseHat
import time

sense = SenseHat()

# 色設定
r = [255, 0, 0]   # 赤

# 画面をクリア
sense.clear()

# “+”の中心を基準にLEDを点灯
# 中心は (3,3) と (4,4) の間あたりなので、行・列の4番目を使うと見やすい
for x in range(8):
    sense.set_pixel(3, x, r)   # 縦棒
    sense.set_pixel(x, 3, r)   # 横棒

# 少し表示してから消灯
time.sleep(3)
sense.clear()

