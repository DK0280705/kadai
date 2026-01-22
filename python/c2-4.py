import numpy as np

with open("data_exam.txt", "r") as file_exam:
    eng_scores, math_scores = np.loadtxt(file_exam, dtype=int, unpack=True)
    # calculate and print correlation coefficient between 2 list
    correlation = np.corrcoef(eng_scores, math_scores)
    print("Correlation coefficient:", correlation[0, 1])