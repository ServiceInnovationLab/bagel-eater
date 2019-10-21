require 'pdf-reader'

files = Dir["./pdfs/*.pdf"]

files.each do |file|
  puts "reading #{file}"
  filename = file.split('./pdfs/')[1]
  if(File.file?("txt/#{filename}.txt"))
    puts 'already parsed'
  else
    File.open("txt/#{filename}.txt", 'w') do |txt_file|
      reader = PDF::Reader.new(file)
      reader.pages.each do |page|
        text = page.text.gsub(/\t/, ' ')
        txt_file.puts(text)
      end
      puts "saved #{file}"
    end
  end
end
