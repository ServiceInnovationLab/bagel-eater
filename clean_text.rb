require 'json'

@clauses = []
@positions = []

class OnlineSubmission
  def initialize(text)
    @text = text
  end

  def clauses
    return @clauses if @clauses
    @clauses = @text.split(/Clause\n/).map do |clause|
      clause.start_with?(/\s{0,10}\d/) ? Clause.new(clause) : nil
    end
    @clauses.compact!
  end

  def reference_number
    @text.scan(/Reference no: (\d{1,5})\n/).flatten.first
  end
end

class Clause
  def initialize(text)
    @text = text.strip
  end

  def question
    return nil unless @text.include?('Position')
    @question ||= @text.split(/Position\n/)[0]
  end

  def answer
    return nil unless @text.include?('Position') && @text.include?('Notes')
    @answer ||= @text.split(/Position\n/)[1].split(/Notes\n/)[0]
  end

  def notes
    return nil unless @text.include?('Position') && @text.include?('Notes')
    @notes ||= @text.split(/Position\n/)[1].split(/Notes\n/)[1]
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
    @answer
  end

  def find_or_add_question

  end

  def find_or_add_answer
  end
end

def check_and_populate_existing_answers(q)
  # if i = @clauses.index(q[:clause])
  #   q[:clause] = i
  # else
  #   @clauses << q[:clause]
  #   q[:clause] = @clauses.index(q[:clause])
  # end
  #
  # if i = @positions.index(q[:position])
  #   q[:position] = i
  # else
  #   @positions << q[:position]
  #   q[:position] = @positions.index(q[:position])
  # end

  q
end

def clean_whitespace(text)
  text.gsub!(/\s/, ' ').strip!
end

files = Dir["./txt/*.txt"]

files.each do |file|
  puts "reading #{file}"
  filename = file.split('./txt/')[1]
  text = File.read(file)
  answered_questions = text.scan(/^Clause\n(.*?)\nPosition\n(.*?)\nNotes\n(.*?)\n/m)

  parsed_questions = []

  answered_questions.each do |question|
    q = {
      clause: clean_whitespace(question[0]),
      position: clean_whitespace(question[1]),
      notes: clean_whitespace(question[2])
    }
    q = check_and_populate_existing_answers(q)
    parsed_questions.push(q)
  end


  File.open("txt_cleaned/#{filename}", 'w') do |txt_file|
    txt_file.puts(parsed_questions.to_json)

    # text.match(/Position([\w\d\s]*)Notes/)
    #
    # text.gsub!(/Notes\n\n\n\n/, '')
    # text.gsub!('Your submission to Zero Carbon Bill', '')
    # text.gsub!(/\nClause\n/, '')
    # txt_file.puts(text)
    puts "cleaned #{file}"
  end
end


File.open("txt_cleaned/key.txt", 'w') do |txt_file|
  txt_file.puts({clauses: @clauses}.to_json)
  txt_file.puts({positions: @positions}.to_json)
end
