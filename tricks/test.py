import pandas as pd
import numpy as np




def calculate_entropy(value):
    """计算伪信息熵"""
    return (value + 0.5) * np.log(value)

def three_variables_mutual_info(card, ndvs):
    ndv1, ndv2, ndv3 = ndvs[0], ndvs[1], ndvs[2]
    # card = 1069
    # ndv1, ndv2 = 21, 62
    f1 = card / ndv1
    f2 = card / ndv2
    f3 = card / ndv3

    swr1 = card - f1
    swr2 = card - f2
    swr3 = card - f3
    swr12 = card - f1 - f2
    swr13 = card - f1 - f3
    swr23 = card - f2 - f3
    swr123 = card - f1 - f2 - f3

    e1 = calculate_entropy(swr1)
    e2 = calculate_entropy(swr2)
    e3 = calculate_entropy(swr3)
    e12 = calculate_entropy(swr12)
    e13 = calculate_entropy(swr13)
    e23 = calculate_entropy(swr23)
    e123 = calculate_entropy(swr123)
    e4 = calculate_entropy(card)
    print(e1, e2, e3, e12, e13, e23, e123, e4)
    print(e1 + e2 + e3 - e12 - e13 - e23 + e123 - e4)

    mi = np.exp(e1 + e2 + e3 - e12 - e13 - e23 + e123 - e4)
    print(mi)
    # mi = np.exp(e1 + e2  - e12  - e4)
    
    return abs(1 - mi) * ndv1 * ndv2 * ndv3
    # return (1 - mi) * ndv1 * ndv2

# if __name__ == "__main__":
#     card = float(input("Enter card: "))
#     ndv1 = float(input("Enter ndv1: "))
#     ndv2 = float(input("Enter ndv2: "))
#     ndv3 = float(input("Enter ndv3: "))

# 1. 读取CSV数据
df = pd.read_csv('BJAQ.csv')
card = len(df)
ndvs = []
for column in df.columns:
    if df[column].dtype in [np.int64, np.float64]:  # 确保列数据类型是数值型
        # 计算直方图频率信息
        data = df[column]
        ndv = len(data.unique())
        ndvs.append(ndv)

print(ndvs)
result = three_variables_mutual_info(card, ndvs)
print(f"Joint NDV for n variables: {result}")

print(f"总行数: {card}")
unique_rows_count = df.drop_duplicates().shape[0]
print(f"不同行的个数：{unique_rows_count}")
