# -*- coding: utf-8 -*-
import re

# # 读取输入文件
input_filename = 'tmp3.json'
output_filename = 'tmp3.json'

with open(input_filename, 'r') as file:
    input_string = file.read().strip()

# input_string = input()

# 删除第一个 { 之前的内容
input_string = re.sub(r'^.*?\{', '{', input_string, 1)

# 删除最后一个 )
input_string = re.sub(r'\)$', '', input_string, 1)

num2str_pattern = re.compile(r'(?<!")(\b\d+\b)(?!")')

input_string = num2str_pattern.sub(r'"\1"', input_string)



# 使用正则表达式查找每个冒号前的字段名，并加上引号
output_string = re.sub(r'([a-z_]+):', r'"\1":', input_string)

# 将处理后的结果写入输出文件
with open(output_filename, 'w') as file:
    file.write(output_string)

print(output_string)


# 将处理后的结果写入输出文件
# with open(output_filename, 'w') as file:
#     file.write(output_string)

# # print(f'处理后的结果已写入到 {output_filename} 文件中。')
