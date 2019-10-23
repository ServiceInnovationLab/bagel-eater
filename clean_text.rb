require 'json'

@clauses = []
@positions = []

class OnlineSubmission
  def initialize(text, cohort)
    @text = text.split(/Supporting documents from your Submission/)[0]
    @cohort = cohort
  end

  def clauses
    return @clauses if @clauses
    @clauses = @text.split(/Clause\n/).map do |clause|
      if(clause.start_with?(/\s{0,10}\d/) || clause.start_with?(/\s{0,10}Do you have any other/))
        Clause.new(clause, @cohort)
      else
        nil
      end
    end
    @clauses.compact!
  end

  def reference_number
    @text.scan(/Reference no: (\d{1,5})\n/).flatten.first
  end

  def to_json
    JSON.pretty_generate({
      reference_number: reference_number,
      clauses: clauses.map { |e| e.details }
    })
  end
end

class Clause
  def initialize(text, cohort)
    @text = text.strip
    @cohort = cohort
  end

  def question
    @question ||= clean_whitespace(question_split[0])
  end

  def question_index
    @cohort.question_index(question)
  end

  def answer_index
    @cohort.answer_index(answer)
  end

  def answer
    return nil unless @text.include?('Position')
    @answer ||= clean_whitespace(question_split[1].split(/Notes/)[0])
  end

  def notes
    @notes ||= @text.split(/Notes/)[1]&.strip!
  end

  def details
    {
      question: question,
      question_index: question_index,
      answer: answer,
      answer_index: answer_index,
      notes: notes
    }
  end

  private

  def question_split
    if @text.include?('Position')
      @question_split ||= @text.split(/Position/)
    elsif @text.include?('Notes')
      @question_split ||= @text.split(/Notes/) #question 10 is notes only
    else
      @question_split ||= [nil, nil]
    end
  end

end

class SubmissionCohort
  def initialize
    @questions = []
    @answers = []
  end

  def questions
    @questions
  end

  def answers
    @answers
  end

  def question_index(question)
    @questions.index(question) || new_question_index(question)
  end

  def answer_index(answer)
    @answers.index(answer) || new_answer_index(answer)
  end

  def to_json
    JSON.pretty_generate({
      questions: @questions,
      answers: @answers
    })
  end

  private

  def new_question_index(question)
    @questions += [question]
    @questions.index(question)
  end

  def new_answer_index(answer)
    @answers += [answer]
    @answers.index(answer)
  end
end

def clean_whitespace(text)
  return nil unless text
  text.gsub!(/\s{1,5}/, ' ')
  text.gsub!(/\s{1,5}/, ' ')
  text.strip!
end

def run(source_folder:, destination_folder:)
  files = Dir["#{source_folder}/*.txt"]
  cohort = SubmissionCohort.new

  files.each do |file|
    puts "reading #{file}"
    filename = file.split("#{source_folder}/")[1]
    text = File.read(file)

    submission = OnlineSubmission.new(text, cohort)

    File.open("#{destination_folder}/#{filename}.json", 'w') do |txt_file|
      txt_file.puts(submission.to_json)
    end
  end

  File.open("#{destination_folder}/meta/key.json", 'w') do |txt_file|
    txt_file.puts(cohort.to_json)
  end
end

run(source_folder: "./sorted/online", destination_folder: "./txt_cleaned")
