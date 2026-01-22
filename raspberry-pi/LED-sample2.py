#!/usr/bin/env python3
#
# APIリファレンス：
# https://pythonhosted.org/sense-hat/
#

#----------------------------------------------------------
# 初期設定
#----------------------------------------------------------

# SenseHATの機能を使えるようにする
from sense_hat import SenseHat
sense = SenseHat()

# time.sleep()命令を使えるようにする
import time

#----------------------------------------------------------
# LEDの色を変える例
#----------------------------------------------------------

# 赤色にする
sense.clear(255, 0, 0)
time.sleep(1)

# 緑色にする
sense.clear(0, 255, 0)
time.sleep(1)

# 青色にする
sense.clear(0, 0, 255)
time.sleep(1)

# 黄色にする
sense.clear(255, 255, 0)
time.sleep(1)

# 灰色にする
sense.clear(70, 70, 70)
time.sleep(1)

# 白色にする
sense.clear(255, 255, 255)
time.sleep(1)

# 消灯状態→赤色→消灯状態に遷移させる
for i in range(255):           # 0〜254まで繰り返す
    sense.clear(i, 0, 0)
for i in range(255, -1, -1):   # 255〜0まで繰り返す
    sense.clear(i, 0, 0)

# 画面消灯
sense.clear()

