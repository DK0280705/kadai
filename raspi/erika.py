from sense_hat import SenseHat

sense = SenseHat()

X = [255, 0, 0]  # Red
O = [255, 255, 255]  # White
L = [0, 0, 0]

question_mark = [
X, X, X, X, X, X, X, X,
X, L, O, O, L, L, L, X,
X, L, O, O, L, O, O, X,
X, L, L, L, L, O, O, X,
X, O, O, L, L, L, L, X,
X, O, O, L, O, O, L, X,
X, L, L, L, O, O, L, X,
X, X, X, X, X, X, X, X
]

sense.set_pixels(question_mark)

