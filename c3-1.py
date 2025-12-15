import numpy as np
import matplotlib.pyplot as plt

with open("Temperature2022.txt", "r") as temp_csv:
    data = np.genfromtxt(temp_csv, delimiter=",", names=True, dtype=None, encoding="utf-8")

    dates = data["Date"]
    hours = data["Hour"]
    kuma_temp = data["Kumamoto"]
    aso_temp = data["Aso"]
    ama_temp = data["Amakusa"]

    x_pos = np.arange(len(dates))

    fig, ax = plt.subplots(figsize=(12, 6))
    ax.plot(x_pos, kuma_temp, label="Kumamoto", color="tab:blue")
    ax.plot(x_pos, aso_temp, label="Aso", color="tab:orange")
    ax.plot(x_pos, ama_temp, label="Amakusa", color="tab:green")

    # Tick each day once while the data still uses hour-level points
    unique_dates, day_change = np.unique(dates, return_index=True) 
    ax.set_xticks(day_change)
    ax.set_xticklabels(unique_dates, rotation=90)

    ax.set_xlabel("Date")
    ax.set_ylabel("Temperature (°C)")
    ax.legend(loc="lower right")

    plt.show()