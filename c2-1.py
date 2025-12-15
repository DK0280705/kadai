with open("data_eng.txt", "r") as file_eng:
    with open("data_math.txt", "r") as file_math:
        for line_eng, line_math in zip(file_eng, file_math):
            print(line_eng.strip() + " " + line_math.strip())