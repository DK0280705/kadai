import numpy as np

with open("data_exam.txt", "r") as file_exam:
    eng_scores, math_scores = np.loadtxt(file_exam, dtype=int, unpack=True)
    print("English average:", np.mean(eng_scores))
    print("Math average:", np.mean(math_scores))