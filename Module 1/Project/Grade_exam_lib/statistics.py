def find_max_indices(lst):
    max_value = max(lst)
    return [i for i, x in enumerate(lst) if x == max_value]
def statistics(data):
  count_high_scores = sum(value > 80 for value in data)
  mean_score = sum(data) / len(data)
  highest_score = max(data)
  lowest_score = min(data)
  range_scores = highest_score - lowest_score
  sorted_data = sorted(data)
  if len(data) % 2 == 0:
    median_score = (sorted_data[len(data) // 2] + sorted_data[len(data) // 2 - 1]) / 2
  else:
    median_score = sorted_data[len(data) // 2]
  return count_high_scores, mean_score, highest_score, lowest_score, range_scores, median_score