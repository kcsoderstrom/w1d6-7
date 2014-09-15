require 'set'

class WordChainer
  attr_reader :dictionary, :n_length_dictionary, :current_words, :all_seen_words

  def initialize(file_name = 'dictionary.txt')
    @dictionary = Set.new(File.readlines(file_name).map(&:chomp))
    @n_length_dict
  end

  def run(source, target)
    @current_words = [source]
    @all_seen_words = Set.new([source])

    until self.current_words.empty?
      explore_current_words
    end


  end


  def explore_current_words
    new_current_words = []
    self.current_words.each do |current_word|
      adjacent_words(current_word).each do |adj_word|
        unless self.all_seen_words.include?(adj_word)
          @all_seen_words << adj_word
          new_current_words << adj_word
        end
      end
    end
    puts new_current_words
    @current_words = new_current_words
  end


  def set_length(word_length)
    @n_length_dict = @dictionary.select do |word|
      word.length == word_length
    end
  end

  def adjacent_words(word)
    set_length(word.length)

    adjacent_words = []

    @n_length_dict.each do |entry|
      mis_matches = 0

      word.split(//).each_index do |i|
        mis_matches += 1 unless word[i] == entry[i]
        break if mis_matches > 1
      end

      adjacent_words << entry if mis_matches == 1
    end

    adjacent_words
  end

end