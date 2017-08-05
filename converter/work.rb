require 'spreadsheet'
require 'json'
require 'pry'

class DicXlsToJson
  def initialize
  end

  def book
    @book ||= Spreadsheet.open 'simplingua.xls'
  end

  def dictionary_sheet
    book.worksheet(0)
  end

  def parse_dictionaries
    dictionaries = []
    dictionary_sheet.each_with_index do |row, index|
      next if index == 0
      entry = {
        simplingua: row[1],
        type: row[2],
        rank: row[3],
        explain: row[4],
        root: row[0]
      }
      dictionaries.push entry
    end
    dictionaries
  end

  def data_in_json
    data = {
      dictionaries: parse_dictionaries
    }
    data.to_json
  end

  def write_to_json_file(json)
    f = File.new("dictionaries.json", "w")
    f.syswrite(json)
    f.close
  end

  def run
    write_to_json_file(data_in_json)
  end
end

dic_json = DicXlsToJson.new
dic_json.run
