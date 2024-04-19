## Đề bài
Viết một chương trình để tính toán điểm thi cho nhiều lớp với sĩ số hàng nghìn học sinh. Mục đích của chương trình giúp giảm thời gian chấm điểm. Ap dụng các functions (hàm) khác nhau trong Python để viết chương trình với các tác vụ sau:
* Mở các tập tin văn bản bên ngoài được yêu cầu với exception-handling
* Quét từng dòng của câu trả lời bài thi để tìm dữ liệu hợp lệ và cung cấp báo cáo tương ứng
* Chấm điểm từng bài thi dựa trên tiêu chí đánh giá (rubric) được cung cấp và báo cáo
* Tạo tập tin kết quả được đặt tên thích hợp
### Task 1:

1.1. Tạo một chương trình Python mới có tên “lastname_firstname_grade_the_exams.py.”

1.2. Viết hàm cho phép người dùng nhập tên của một tệp và truy cập đọc.

1.3. Nếu tệp tồn tại, bạn có thể in ra một thông báo xác nhận. Nếu tệp không tồn tại, hiển thị không thể tìm thấy tệp và yêu cầu nhập lại.

1.4. Sử dụng try/except để thực hiện việc này (đừng chỉ sử dụng một loạt câu lệnh “if”):

Đây là một mẫu kết quả sau khi chạy chương trình:

```
Enter a class file to grade (i.e. class1 for class1.txt): foobar
File cannot be found.
Enter a class file to grade (i.e. class1 for class1.txt): class1
Successfully opened class1.txt
```

### Task 2

Tiếp theo, bạn sẽ cần phân tích dữ liệu có trong tệp bạn vừa mở để đảm bảo rằng nó ở đúng định dạng. Mỗi tệp dữ liệu chứa một loạt câu trả lời của học sinh ở định dạng sau:
```
N12345678,B,A,D,D,C,B,D,A,C,C,D,B,A,B,A,C,B,D,A,C,A,A,B,D,D
```

hoặc

```
N12345678,B,A,D,D,C,B,D,A,C,C,D,B,A,B,A,C,B,D,A,C,A,A,B,D,D,A,B,C,D,E
```

Nhiệm vụ của bạn cho phần này của chương trình là thực hiện như sau:

2.1. Báo cáo tổng số dòng dữ liệu được lưu trữ trong tệp.

2.2. Báo cáo tổng số dòng dữ liệu không hợp lệ trong tệp.

Một dòng hợp lệ chứa danh sách 26 giá trị được phân tách bằng dấu phẩy
N# cho một học sinh là mục đầu tiên trên dòng. Nó phải chứa ký tự “N” theo sau là 8 ký tự số.
2.3. Nếu một dòng dữ liệu không hợp lệ, bạn nên báo cáo cho người dùng bằng cách in ra một thông báo lỗi.

**Gợi ý:** Sử dụng phương pháp split để tách dữ liệu ra khỏi tệp.

Đây là một mẫu chạy chương trình
```
Enter a class to grade (i.e. class1 for class1.txt): class1
Successfully opened class1.txt
**** ANALYZING ****
No errors found!
**** REPORT ****
Total valid lines of data: 20
Total invalid lines of data: 0
Enter a class to grade (i.e. class1 for class1.txt): class2
Successfully opened class2.txt
**** ANALYZING ****
Invalid line of data: does not contain exactly 26 values:
N00000023,,A,D,D,C,B,D,A,C,C,,C,,B,A,C,B,D,A,C,A,A
Invalid line of data: N# is invalid
N0000002,B,A,D,D,C,B,D,A,C,D,D,D,A,,A,C,D,,A,C,A,A,B,D,D
Invalid line of data: N# is invalid
NA0000027,B,A,D,D,,B,,A,C,B,D,B,A,,A,C,B,D,A,,A,A,B,D,D
Invalid line of data: does not contain exactly 26 values:
N00000035,B,A,D,D,B,B,,A,C,,D,B,A,B,A,A,B,D,A,C,A,C,B,D,D,A,A
**** REPORT ****
Total valid lines of data: 21
Total invalid lines of data: 4
```

### Task 3

Chương trình sẽ sử dụng những câu trả lời này để tính điểm cho mỗi dòng dữ liệu hợp lệ. Điểm có thể được tính như sau:

* +4 điểm cho mỗi câu trả lời đúng
* 0 điểm cho mỗi câu trả lời bị bỏ qua
* -1 điểm cho mỗi câu trả lời sai

Chúng ta cũng cần thống kê các yêu cầu sau:
* Đếm số lượng học sinh đạt điểm cao (>80).

* Điểm trung bình.

* Điểm cao nhất.

* Điểm thấp nhất.

* Miền giá trị của điểm (cao nhất trừ thấp nhất).

* Giá trị trung vị (Sắp xếp các điểm theo thứ tự tăng dần. Nếu # học sinh là số lẻ, bạn có thể lấy giá trị nằm ở giữa của tất cả các điểm (tức là [0, 50, 100] — trung vị là 50). Nếu # học sinh là chẵn bạn có thể tính giá trị trung vị bằng cách lấy giá trị trung bình của hai giá trị giữa (tức là [0, 50, 60, 100] — giá trị trung vị là 55)).

* Trả về các câu hỏi bị học sinh bỏ qua nhiều nhất theo thứ tự: số thứ tự câu hỏi - số lượng học sinh bỏ qua -  tỉ lệ bị bỏ qua (nếu có cùng số lượng cho nhiều câu hỏi bị bỏ thì phải liệt kê ra đầy đủ).

* Trả về các câu hỏi bị học sinh sai qua nhiều nhất theo thứ tự: số thứ tự câu hỏi - số lượng học sinh trả lời sai - tỉ lệ bị sai (nếu có cùng số lượng cho nhiều câu hỏi bị sai thì phải liệt kê ra đầy đủ).

*Lưu ý: các giá trị số thực làm tròn 3 chữ số thập phân*

Đây là một mẫu chạy chương trình của bạn cho hai tệp dữ liệu đầu tiên:
```
Enter a class to grade (i.e. class1 for class1.txt): class1
Successfully opened class1.txt
**** ANALYZING ****
No errors found!
**** REPORT ****
Total valid lines of data: 20
Total invalid lines of data: 0

Total student of high scores: 6
Mean (average) score: 75.60
Highest score: 91
Lowest score: 59
Range of scores: 32
Median score: 73

Question that most people skip: 3 - 4 - 0.2 , 5 - 4 - 0.2 , 23 - 4 - 0.2

Question that most people answer incorrectly: 10 - 4 - 0.20, 14 - 4 - 0.20, 16 - 4 - 0.20, 19 - 4 - 0.20, 22 - 4 - 0.20

Enter a class to grade (i.e. class1 for class1.txt): class2
Successfully opened class2.txt
**** ANALYZING ****
Invalid line of data: does not contain exactly 26 values:
N00000023,,A,D,D,C,B,D,A,C,C,,C,,B,A,C,B,D,A,C,A,A
Invalid line of data: N# is invalid
N0000002,B,A,D,D,C,B,D,A,C,D,D,D,A,,A,C,D,,A,C,A,A,B,D,D
Invalid line of data: N# is invalid
NA0000027,B,A,D,D,,B,,A,C,B,D,B,A,,A,C,B,D,A,,A,A,B,D,D
Invalid line of data: does not contain exactly 26 values:
N00000035,B,A,D,D,B,B,,A,C,,D,B,A,B,A,A,B,D,A,C,A,C,B,D,D,A,A
**** REPORT ****
Total valid lines of data: 21
Total invalid lines of data: 4
Total student of high scores: 7
Mean (average) score: 78.00
Highest score: 100
Lowest score: 66
Range of scores: 34
Median score: 76
Question that most people skip: 22 - 6 - 0.29
Question that most people answer incorrectly: 18 - 5 - 0.24
```


### Task 4:
Cuối cùng, yêu cầu chương trình là tạo một tệp “kết quả” chứa các kết quả chi tiết cho từng học sinh trong lớp. Mỗi dòng của tệp này phải chứa số ID của học sinh, dấu phẩy và sau đó là điểm của họ. Bạn nên đặt tên tệp này dựa trên tên tệp gốc được cung cấp — ví dụ: nếu người dùng chọn “class1.txt”, bạn nên lưu trữ kết quả trong tệp có tên “class1_grades.txt”.

Đây là một mẫu chạy chương trình của bạn cho hai tệp dữ liệu đầu tiên:
```
# this is what class1_grades.txt should look like                               
N00000001,59
N00000002,70
N00000003,84
N00000004,73
N00000005,83
N00000006,66
N00000007,88
N00000008,67
N00000009,86
N00000010,73
N00000011,86
N00000012,73
N00000013,73
N00000014,78
N00000015,72
N00000016,91
N00000017,66
N00000018,78
N00000019,78
N00000020,68
# this is what class2_grades.txt should look like
N00000021,68
N00000022,76
N00000024,73
N00000026,72
N00000028,73
N00000029,87
N00000030,82
N00000031,76
N00000032,87
N00000033,77
N00000034,69
N00000036,77
N00000037,75
N00000038,73
N00000039,66
N00000040,73
N00000041,91
N00000042,100
N00000043,86
N00000044,90
N00000045,67
```


### Task 5 (nâng cao)

Chỉ sử dụng pandas và numpy, triển khai task 1 đến task 4.

# Tiêu chí đánh giá điểm

## Yêu cầu cơ bản
![image](https://github.com/nguyennguyenphuc/MMC/assets/69141879/54e1728e-ebab-4625-96f6-89f5c536062a)


## Yêu cầu Phi chức năng
![image](https://github.com/nguyennguyenphuc/MMC/assets/69141879/c526fd01-528a-44fa-860b-f694ac0bdbc2)


## Yêu cầu nâng cao
![image](https://github.com/nguyennguyenphuc/MMC/assets/69141879/f56e4df5-9b7a-4cd3-b285-0c074dfe5387)

