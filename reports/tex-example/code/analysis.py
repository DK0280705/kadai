#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Load temperature data from Temperature2022.txt,
run statistical analysis, and produce charts.

Usage:
    python code/analysis.py
"""

import os
import numpy as np
import matplotlib
import matplotlib.pyplot as plt

# Japanese font configuration (adjust to your environment)
# If Noto CJK is installed:  'Noto Sans CJK JP'
# If IPA fonts are installed: 'IPAGothic'
# Comment out this block if neither font is available
try:
    matplotlib.rcParams['font.family'] = 'IPAGothic'
except Exception:
    pass


# ============================================================
# Data Loading
# ============================================================
def load_temperature(filepath: str):
    """
    Load temperature data from a text file.

    Parameters
    ----------
    filepath : str
        Path to the data file (one line = date, temperature)

    Returns
    -------
    dates : list of str
        List of date strings
    temps : numpy.ndarray
        Array of daily mean temperatures (°C)
    """
    dates = []
    temps = []
    with open(filepath, 'r', encoding='utf-8') as f:
        for line in f:
            line = line.strip()
            # Skip blank lines and comment lines
            if not line or line.startswith('#'):
                continue
            parts = line.split()
            if len(parts) >= 2:
                dates.append(parts[0])
                temps.append(float(parts[1]))
    return dates, np.array(temps)


# ============================================================
# Statistics
# ============================================================
def calc_statistics(temps: np.ndarray) -> dict:
    """
    Compute basic descriptive statistics.

    Parameters
    ----------
    temps : numpy.ndarray
        Temperature data

    Returns
    -------
    dict
        Dictionary of statistic name → value
    """
    return {
        'Mean':           np.mean(temps),
        'Std Dev':        np.std(temps),
        'Max':            np.max(temps),
        'Min':            np.min(temps),
        'Median':         np.median(temps),
        '1st Quartile':   np.percentile(temps, 25),
        '3rd Quartile':   np.percentile(temps, 75),
    }


# ============================================================
# Plotting
# ============================================================
def plot_temperature(dates: list, temps: np.ndarray,
                     output: str = 'images/temperature.png') -> None:
    """
    Draw a line chart and histogram of temperature data and save as PNG.

    Parameters
    ----------
    dates : list
        List of date strings
    temps : numpy.ndarray
        Array of daily mean temperatures (°C)
    output : str
        Output file path
    """
    os.makedirs(os.path.dirname(output) or '.', exist_ok=True)

    fig, axes = plt.subplots(2, 1, figsize=(11, 8))
    fig.suptitle('2022年 気温データ解析', fontsize=16, fontweight='bold')

    # ---- 折れ線グラフ ----
    axes[0].plot(range(len(temps)), temps,
                 color='steelblue', linewidth=0.8, label='日別平均気温')
    axes[0].axhline(np.mean(temps), color='crimson', linestyle='--',
                    linewidth=1.2,
                    label=f'年平均: {np.mean(temps):.1f}℃')
    axes[0].fill_between(range(len(temps)), temps, np.mean(temps),
                         where=(temps >= np.mean(temps)),
                         alpha=0.15, color='coral', label='平均以上')
    axes[0].set_title('日別平均気温の推移')
    axes[0].set_xlabel('日数（1月1日からの経過日数）')
    axes[0].set_ylabel('気温 (℃)')
    axes[0].legend(loc='upper left')
    axes[0].grid(True, alpha=0.3)

    # ---- ヒストグラム ----
    axes[1].hist(temps, bins=20, color='coral',
                 edgecolor='darkred', alpha=0.78, label='度数')
    axes[1].axvline(np.mean(temps), color='navy', linestyle='--',
                    linewidth=1.5,
                    label=f'平均: {np.mean(temps):.1f}℃')
    axes[1].set_title('気温の度数分布')
    axes[1].set_xlabel('気温 (℃)')
    axes[1].set_ylabel('日数')
    axes[1].legend()
    axes[1].grid(True, alpha=0.3)

    plt.tight_layout()
    plt.savefig(output, dpi=150, bbox_inches='tight')
    print(f"Chart saved: {output}")
    plt.close()


# ============================================================
# Entry Point
# ============================================================
def main():
    """Main routine: load data → compute statistics → generate charts"""

    # Path to the data file — adjust if the script is moved
    data_path = os.path.join(os.path.dirname(__file__),
                             '..', '..', 'python', 'Temperature2022.txt')
    data_path = os.path.normpath(data_path)

    if os.path.exists(data_path):
        dates, temps = load_temperature(data_path)
        print(f"Data loaded: {len(temps)} records")
    else:
        print(f"Warning: data file not found ({data_path})")
        print("Generating synthetic sample data (seasonal sine wave)...\n")
        # Synthetic data: sinusoidal seasonal pattern plus random noise
        np.random.seed(42)
        day = np.linspace(0, 2 * np.pi, 365)
        temps = 15 + 14 * np.sin(day - np.pi / 2) + np.random.normal(0, 3, 365)
        dates = [f'2022-{str(i + 1).zfill(3)}' for i in range(365)]

    # Compute and print statistics
    stats = calc_statistics(temps)
    print("=== Statistical Analysis Results ===")
    for key, val in stats.items():
        print(f"  {key:<12}: {val:>7.2f} ℃")

    # Save the chart next to this script's parent images/ directory
    out_dir = os.path.join(os.path.dirname(__file__), '..', 'images')
    out_path = os.path.join(out_dir, 'temperature.png')
    plot_temperature(dates, temps, output=out_path)

    print("\nAnalysis complete.")


if __name__ == '__main__':
    main()
