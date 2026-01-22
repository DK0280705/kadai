import numpy as np
import matplotlib.pyplot as plt

sel = int(input("Select city (Kumamoto, Aso, Amakusa): "))
if sel not in [0, 1, 2]:
    print("Invalid selection")
    exit()

sel_city = ["Kumamoto", "Aso", "Amakusa"][sel]

with open("Temperature2022.txt", "r") as temp_csv:
    data = np.genfromtxt(temp_csv, delimiter=",", names=True, dtype=None, encoding="utf-8")

    dates = data["Date"]

    unique_dates = np.unique(dates)
    filtered_max = [max(data[(data["Date"] == date)][sel_city]) for date in unique_dates]
    filtered_min = [min(data[(data["Date"] == date)][sel_city]) for date in unique_dates]

    fig, ax = plt.subplots()
    x_pos = np.arange(len(unique_dates))
    ax.plot(x_pos, filtered_max, label="Max", color="red")
    ax.plot(x_pos, filtered_min, label="Min", color="blue")

    ax.set_xticks(x_pos)
    ax.set_xticklabels(unique_dates, rotation=90)
    ax.set_xlabel("Date")
    ax.set_ylabel(f"{sel_city} Temperature (°C)")
    ax.legend(loc="lower right")
    
    plt.show()
