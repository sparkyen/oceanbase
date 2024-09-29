import tempfile
import pyperclip
from pathlib import Path

# 创建一个临时文件
with tempfile.NamedTemporaryFile(mode='w+', delete=False) as temp_file:
    temp_file_path = Path(temp_file.name)
    print(f"临时文件的路径: {temp_file_path}")

    # 读取粘贴板中的输入，并写入临时文件
    clipboard_input = pyperclip.paste()
    temp_file.write(clipboard_input)

    # 重新定位文件指针到文件开始处，读取并处理文件内容
    temp_file.seek(0)
    file_content = temp_file.read()
    # 在这里进行你需要的处理操作，比如处理文本内容

    # 将处理后的内容重新写入临时文件
    temp_file.seek(0)
    temp_file.write("处理后的内容")
    temp_file.truncate()

    # 关闭临时文件
    temp_file.close()

    # 将处理后的内容复制到剪切板
    pyperclip.copy("处理后的内容")

# 在退出时删除临时文件
temp_file_path.unlink()
print("临时文件已删除")