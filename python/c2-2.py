with open("data_eng.txt", "r") as file_eng:
    with open("data_math.txt", "r") as file_math:
        with open("data_exam.txt", "w") as file_combined:
            for line_eng, line_math in zip(file_eng, file_math):
                file_combined.write(line_eng.strip() + " " + line_math.strip() + "\n")