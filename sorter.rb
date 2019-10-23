require 'fileutils'
SubmissionType = Struct.new(:name, :match_phrases) do

  def match?(filename)
    match_phrases.each do |phrase|
      return false unless File.foreach(filename).grep(phrase).any?
    end
    true
  end

end

def put_in_unsorted(filenames)
  File.open("sorted/unsorted.txt", 'w') do |txt_file|
    filenames.each do |file|
      txt_file.puts(file)
    end
  end
end

def put_in_sorted(filenames)
  File.open("sorted/sorted.txt", 'w') do |txt_file|
    filenames.each do |file|
      txt_file.puts(file)
    end
  end
end

def put_all_txt_files_in_unsorted
  all_files = Dir["./txt/*.txt"]
  put_in_unsorted(all_files)
end

def get_unsorted
  File.readlines("sorted/unsorted.txt")
end

def get_sorted
  File.readlines("sorted/sorted.txt")
end

def online_submission?(filename)
  online_submission = SubmissionType.new(
    'online', [
      /Your submission to Zero Carbon Bill/,
      /Reference no:/,
      /Submitter Type:/
    ]
  )

  if online_submission.match?(filename)
    FileUtils.cp(filename, "./sorted/online/")
    return true
  else
    return false
  end
end

def important_because_submission?(filename)
  important_because = SubmissionType.new(
    'important_because', [
      /A climate law like the Zero Carbon Act is/,
      /important because.../
    ]
  )

  if important_because.match?(filename)
    FileUtils.cp(filename, "./sorted/important_because/")
    return true
  else
    return false
  end
end

def important_to_me_because_submission?(filename)
  important_because = SubmissionType.new(
    'important_because', [
      /A Zero Carbon Act is important to me/,
      /because.../
    ]
  )

  if important_because.match?(filename)
    FileUtils.cp(filename, "./sorted/important_to_me_because/")
    return true
  else
    return false
  end
end

def form_builder_submission?(filename)
  form_builder = SubmissionType.new(
    'form_builder', [
      /noreply@123formbuilder.io/
    ]
  )

  if form_builder.match?(filename)
    FileUtils.cp(filename, "./sorted/form_builder/")
    return true
  else
    return false
  end
end

def email_from_mfe?(filename)
  email_from_mfe = SubmissionType.new(
    'form_builder', [
      /Sender: ZCB.Submissions@mfe.govt.nz/
    ]
  )

  if email_from_mfe.match?(filename)
    FileUtils.cp(filename, "./sorted/email_from_mfe/")
    return true
  else
    return false
  end
end


def sort_unsorted_files
  sorted_files = get_sorted
  unsorted_files = get_unsorted

  start_sorted_length = sorted_files.length
  puts "starting with #{unsorted_files.length} unsorted files"
  puts "starting with #{start_sorted_length} sorted files"

  unsorted_files.each do |filename|
    clean_filename = filename.gsub!(/\n/,'')
    if online_submission?(clean_filename)
      sorted_files << clean_filename
      unsorted_files = unsorted_files - [filename]
      puts "sorted #{clean_filename} as 'online submission'"
    elsif important_because_submission?(clean_filename)
      sorted_files << clean_filename
      unsorted_files = unsorted_files - [filename]
      puts "sorted #{clean_filename} as 'important because'"
    elsif form_builder_submission?(clean_filename)
      sorted_files << clean_filename
      unsorted_files = unsorted_files - [filename]
      puts "sorted #{clean_filename} as 'formbuilder'"
    elsif email_from_mfe?(clean_filename)
      sorted_files << clean_filename
      unsorted_files = unsorted_files - [filename]
      puts "sorted #{clean_filename} as 'email from mfe'"
    elsif important_to_me_because_submission?(clean_filename)
      sorted_files << clean_filename
      unsorted_files = unsorted_files - [filename]
      puts "sorted #{clean_filename} as 'important to me because'"
    end
  end

  puts "ending with #{unsorted_files.length} unsorted files"
  puts "ending with #{sorted_files.length} sorted files"

  put_in_sorted(sorted_files.sort)
  put_in_unsorted(unsorted_files.sort)
end

sort_unsorted_files
