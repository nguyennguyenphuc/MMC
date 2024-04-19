from .statistics import *
def grade_exam(lines, answer_key):
  '''
  hàm chấm điểm
  '''
  #tách answer_key thành list 
  answer_key=answer_key.split(",")
  question_skip=[0]*25
  question_incorrect=[0]*25
  scores=[0]*len(lines)
  for num,line in enumerate(lines):
    #tách từng line thành list
    answer=line.split(",")
    #print(answer)
    #lặp theo từng câu trả lời
    for i in range(1,len(answer)):
      if answer[i]=="":
        #nếu câu trả lời là rỗng thì tăng số lượng bỏ qua của câu đó lên 1
        question_skip[i-1]+=1
        #print(f"{answer[i]}, {answer_key[i-1]}: skip 0")
      elif answer[i] == answer_key[i-1]:
              #nếu câu trả lời đúng với đáp án tăng điểm lên 4
              scores[num] += 4
              #print(f"{answer[i]}, {answer_key[i-1]}: +4")
      else: 
        #nếu câu trả lời sai với đáp án giarm điểm đi 1
        scores[num] -= 1
        question_incorrect[i-1]+=1
        #print(f"{answer[i]}, {answer_key[i-1]}: -1")
  #tính các giá trị thống kê của điểm
  count_high_scores, mean_score, highest_score, lowest_score, range_scores, median_score=statistics(scores)
  print(f"Total student of high scores: {count_high_scores}")
  print(f"Mean (average) score: {mean_score}")
  print(f"Highest score: {highest_score}")
  print(f"Lowest score: {lowest_score}")
  print(f"Range of scores:{range_scores}")
  print(f"Median score: {median_score}")
  #tìm các câu bị bỏ qua nhiều nhất
  position_question_skip=find_max_indices(question_skip)
  #tìm các câu bị trả lời sai nhiều nhất
  position_question_incorrect=find_max_indices(question_incorrect)
  #print(question_skip)
  print("Question that most people skip:",end="")
  for i in position_question_skip:
    print(f"{i} ",end="")
  print(f"- {max(question_skip)} -",end="")
  print(max(question_skip)/len(lines))
  #print(question_incorrect)
  print("Question that most people answer incorrectly:",end="")
  
  for i in position_question_incorrect:
    print(f"{i} ",end="")
  print(f"- {max(question_incorrect)} -",end="")
  print(max(question_incorrect)/len(lines))
  return scores
