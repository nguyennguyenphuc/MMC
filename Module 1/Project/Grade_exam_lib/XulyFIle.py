import os
#Module này dùng để xử lý file
def read_file(filename, dir = '.\\Data Files', ext = '.txt'):
  '''
  Đọc file từ filename mới tham số dir và ext mặc định
  '''
  try:
    filename = os.path.join(dir, filename+ext)
    with open(filename, 'r') as f:
      #mở file thành công in ra thông báo
      print(f"Successfully opened {filename}")
      print("**** ANALYZING ****")
      #phân tích cấu trúc của file
      valid_lines=[]
      total_valid_lines = 0
      total_invalid_lines = 0
      #duyệt qua từng dòng của file
      for line in f:
        #bỏ ký tự \n cuối cùng của từng line
        line=line.rstrip("\n")
        #tách line ra 1 list str theo ký tự ,
        str = line.split(",")
        if len(str) == 26 and str[0][0] == "N" and str[0][1:].isdigit() and len(str[0])==9:
          #nếu lst str chứa 26 phần từ, ký tự đầu tiên của phần từ đầu tiên là N, 8 ký tự tiếp theo của phần từ đâu tiên là số, kích thước của phần tử đầu tiên là 9
          total_valid_lines += 1
          #đẩy dòng đúng và list valid_lines
          valid_lines.append(line)
        else:
          #nếu dòng bị sai cấu trúc 
          total_invalid_lines += 1
          if len(str) != 26: 
            #nếu hàng không chưa đúng 26 phần tử thì in ra thông báo
            print("Invalid line of data: does not contain exactly 26 values:")
          else: 
            #nếu phân tử đầu tiên không đùng format
            print("Invalid line of data: N# is invalid:")
          #in ra dòng sai
          print(line)
      if total_valid_lines==0 : 
        #nếu không có dòng nào sai in ra thông báo
        print("No errors found!")
      print("**** REPORT ****")
      #in ra thống kê tổng dòng, số dòng đúng, số dòng sai
      print(f"Total lines: {total_invalid_lines + total_valid_lines}")
      print(f"Valid lines: {total_valid_lines}")
      print(f"Invalid lines: {total_invalid_lines}")
      return valid_lines
  except FileNotFoundError:
    #nếu file không tồn tại thì in ra lỗi
    print(f"File '{filename}' cannot be found.")
    return None
def write_file(file_name,lines, scores):
  '''
  xuất bảng điểm ra file
  '''
  with open(file_name+"_grades.txt", 'w+') as f:
    for i in range(len(lines)):
      #xuất ra file mã học sinh và điểm.
      f.write(f"{lines[i][0:9]},{scores[i]}\n")