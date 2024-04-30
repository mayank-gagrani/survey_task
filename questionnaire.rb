require "pstore" # https://github.com/ruby/pstore

STORE_NAME = "tendable.pstore"
store = PStore.new(STORE_NAME)

QUESTIONS = {
  "q1" => "Can you code in Ruby?",
  "q2" => "Can you code in JavaScript?",
  "q3" => "Can you code in Swift?",
  "q4" => "Can you code in Java?",
  "q5" => "Can you code in C#?"
}.freeze


def normalize_answer(ans)
  ans.strip.downcase == 'yes' || ans.strip.downcase == 'y'
end


# TODO: FULLY IMPLEMENT
def do_prompt(store)
  yes_count = 0
  total_questions = QUESTIONS.length
  answers = {}

  # Ask each question and get an answer from the user's input.
  QUESTIONS.each_key do |question_key|
    print QUESTIONS[question_key]
    ans = gets.chomp
    
    if normalize_answer(ans)
      yes_count += 1
      answers[question_key] = 'yes'
    else
      answers[question_key] = 'no'
    end
  end


  # Calculate the score for this run
  score = 100 * yes_count / total_questions.to_f

  # Store the result in the PStore
  store.transaction do
    store[:runs] ||= []
    store[:runs] << score
    store[:answers] ||= []
    store[:answers] << answers
  end

  score
end

def do_report(store, current_score)
  total_runs = 0
  total_score = 0.0

  store.transaction do
    if store[:runs]
      total_runs = store[:runs].length
      total_score = store[:runs].sum
    end
  end

  if total_runs > 0
    average_score = total_score / total_runs
    puts "\nYour score for this run: #{current_score.round(2)}%"
    puts "Your average score for all runs: #{average_score.round(2)}%"
  else
    puts "\nNo previous runs found."
  end
end

store.transaction do
  # Clear the PStore file for demonstration purposes
  store[:runs] = []
  store[:answers] = []
end

current_score = do_prompt(store)
do_report(store, current_score)
