# -*- coding: utf-8 -*-
import numpy as np

def kronecker_product(arrays):
    """计算多个数组的 Kronecker 积"""
    result = np.array([1.0])  # 初始值为 1
    for array in arrays:
        result = np.kron(result, array)
    return result

def main(N, arrays):
    # 1. 计算 Kronecker product
    kron_product = kronecker_product(arrays)

    # 2. 计算 (1 - 元素) 的 N 次方，并求和
    modified_elements = (1 - kron_product) ** N
    sum_of_modified_elements = np.sum(modified_elements)
    
    # 3. 计算每个数组的大小 D_i，并求其乘积
    size_product = np.prod([len(array) for array in arrays])
    
    # 4. 计算最终结果
    result = size_product - sum_of_modified_elements
    
    print(f"Kronecker Product: {kron_product}")
    print(f"Sum of (1 - element)^N: {sum_of_modified_elements}")
    print(f"Product of sizes D_i: {size_product}")
    print(f"Final Result: {result}")

if __name__ == "__main__":
    # Example input
    N = 100  # 你可以根据需求修改 N 的值
    arrays = [
        # np.array([0.1, 0.2, 0.7]),
        # np.array([0.8, 0.01, 0.02, 0.07, 0.1])
        np.array([0.1,0.3, 0.6]),
        np.array([0.01, 0.99]),
        np.array([0.05, 0.95])
    ]
    
    main(N, arrays)
