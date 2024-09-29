import pandas as pd
import numpy as np

# 1. 读取CSV数据
df = pd.read_csv('BJAQ.csv')

# 初始化一个空列表用于存储每列的频率信息
frequency_info = []

# 遍历每一列数据
for column in df.columns:
    if df[column].dtype in [np.int64, np.float64]:  # 确保列数据类型是数值型
        # 计算直方图频率信息
        data = df[column]
        hist, bin_edges = np.histogram(data, bins=10)  # bins设置直方图的箱数
        
        # 将频率信息存储为元组并添加到列表中
        column_info = {
            'column_name': column,
            'histogram': hist.tolist(),
            'bin_edges': bin_edges.tolist()
        }
        frequency_info.append(column_info)

# 打印每列的频率信息数组
bins = 10
for info in frequency_info:
    print(f"\n{'-' * 15*bins}")
    for i in range(len(info['histogram'])):
        if i < len(info['bin_edges']) - 1:
            frequency_str = f"{info['histogram'][i]:=10}"
            # range_str = f"{info['bin_edges'][i]:.2f}-{info['bin_edges'][i+1]:.2f}"
            print(f"| {frequency_str} ",end="")
    print()
    # print(f"{'-' * 15*bins}")

    for i in range(len(info['histogram'])):
        if i < len(info['bin_edges']) - 1:
            # frequency_str = f"{info['histogram'][i]:>9}"
            range_str = f"{info['bin_edges'][i]:5.1f}~{info['bin_edges'][i+1]:5.1f}"
            print(f"| {range_str} ",end="")