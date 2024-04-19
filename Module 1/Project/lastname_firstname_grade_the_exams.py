
from Grade_exam_lib import *
def main():
  
  filename = input("Enter a class file to grade (i.e. class1 for class1.txt): ")
  valid_lines = read_file(filename=filename)
  if not(valid_lines is None):
    answer_key="B,A,D,D,C,B,D,A,C,C,D,B,A,B,A,C,B,D,A,C,A,A,B,D,D"
    scores=grade_exam(valid_lines,answer_key)
    write_file(filename,valid_lines, scores)

main()