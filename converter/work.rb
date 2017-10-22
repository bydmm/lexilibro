require 'spreadsheet'
require 'json'
require 'pry'

class DicDocToJson
  def initialize
  end

  def parse_dictionaries
    dictionaries = []
    File.readlines('dic.txt').each do |line|
      next unless line.split('[').count > 1
      rank = 0
      line.split('|')
      line.split('|').each do |word|
        simplingua = word.split('[').first.strip.downcase
        type = word.scan(/\[.?\]/)
        next if type.count < 1
        type = type.join(' ')
        translations = []
        word.split(/\[.?\]/).each_with_index do |translation, index|
          next if index == 0
          next if translation == ''
          translations += translation.split('；').map { |t| t.gsub(/[①,②,③,④]/, '').strip }
        end
        translation = translations.join("\n")
        root = ''
        entry = {
          simplingua: simplingua,
          type: type,
          rank: rank,
          explain: translation,
          root: root
        }
        dictionaries.push entry
        rank += 1
      end
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

dic_json = DicDocToJson.new
dic_json.run
