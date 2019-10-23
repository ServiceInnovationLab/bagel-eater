# Submissions to the Zero Carbon Bill

This is a collection of scripts to download, convert, sort and clean [submissions to the Zero Carbon Bill](https://www.mfe.govt.nz/have-your-say-zero-carbon) so that they can be analysed.

There's a collection of Ruby and Python scripts here:

- `python download.py` to download the PDFs listed in urls.json
- `text.rb` to convert the PDFs in `pdfs/` to text
- `sorter.rb` to sort the text submissions into types
- `clean_text.rb` to turn submissions that follow the online submission format into json files

`pdfs` and `txt` folders are ignored from git, but the `sorted` folder is included.
