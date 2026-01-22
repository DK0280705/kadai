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
    hours = data["Hour"]
    
    x_pos = np.arange(len(dates))

    fig, ax = plt.subplots(figsize=(12, 6))
    ax.plot(x_pos, data[sel_city], label=sel_city, color="tab:blue")
    # Tick each day once while the data still uses hour-level points
    unique_dates, day_change = np.unique(dates, return_index=True) 
    ax.set_xticks(day_change)
    ax.set_xticklabels(unique_dates, rotation=90)

    ax.set_xlabel("Date")
    ax.set_ylabel("Temperature (°C)")
    ax.legend(loc="lower right")

    plt.show()