#!/usr/bin/env python3
#
# https://projects.raspberrypi.org/en/projects/getting-started-with-the-sense-hat/4
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

# 乱数関係の命令を使えるようにする
import random

#----------------------------------------------------------
# LEDの色を変える例
#----------------------------------------------------------

sense.clear()

r = [255, 0, 0]              # 赤色の数値を変数rにセット
g = [0, 255, 0]              # 緑色の数値を変数gにセット
b = [0, 0, 255]              # 青色の数値を変数gにセット

# 赤色のドットを座標(0,0)から(7,0)まで点灯させる
for x in range(8):
    sense.set_pixel(x, 0, r)
    time.sleep(0.25)

# 緑色のドットを座標(0,0)から(0,7)まで点灯させる
for y in range(8):
    sense.set_pixel(0, y, g)
    time.sleep(0.25)

# 青色のドットをランダムな場所に20個点灯させる
# (厳密には、既に青色点灯済の座標を2回以上点灯する場合もあるため、
#  点灯箇所は20個より少なくなる場合がある)
for i in range(20):
    sense.set_pixel(random.randint(0, 7), random.randint(0, 7), b)
    time.sleep(0.05)

# 画面消灯
sense.clear()

