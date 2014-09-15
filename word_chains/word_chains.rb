require 'set'

class WordChainer
  attr_reader :dictionary, :n_length_dict, :current_words, :all_seen_words

  def initialize(file_name = 'dictionary.txt')
    @dictionary = Set.new(File.readlines(file_name).map(&:chomp))
    @n_length_dict
  end

  def run(source, target)
    @current_words = Set.new([source])
    @all_seen_words = Hash.new
    @all_seen_words[source] = nil

    until self.current_words.empty?
      @current_words = explore_current_words(target)
      break if self.current_words.include?(target)
    end

    path = build_path(target)
    print build_path(target) unless path.length == 1
    print "No path exists." if path.length == 1
  end

  def build_path(target)
    return [] if target == nil
    path = build_path(self.all_seen_words[target]) + [target]
  end


  def explore_current_words(target)
    new_current_words = []

    self.current_words.each do |current_word|

      adjacent_words(current_word).each do |adj_word|

        unless self.all_seen_words.has_key?(adj_word)
          @all_seen_words [adj_word] = current_word
          new_current_words << adj_word

          return new_current_words if adj_word == target
        end
      end
    end

    new_current_words
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