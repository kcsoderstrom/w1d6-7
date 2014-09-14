class Game
  attr_reader :dictionary

  def initialize(file_name='dictionary.txt')
    @dictionary = import_dictionary(file_name)
  end

  def import_dictionary(file_name)
    dictionary_array = File.readlines(file_name).map(&:chomp)
  end


end