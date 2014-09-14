class Game
  attr_reader :dictionary, :secret_word, :revealed

  def initialize(file_name='dictionary.txt')
    @dictionary = import_dictionary(file_name)
    @secret_word = self.dictionary.sample
    @revealed = Array.new(self.secret_word.length)
  end

  def import_dictionary(file_name)
    dictionary_array = File.readlines(file_name).map(&:chomp)
  end

  def play

  end

  def update_word(guess)
    raise 'Guess a letter.' unless guess.is_a?(String) && guess.length == 1
    self.secret_word.split(//).each_with_index do |letter, i|
      self.revealed[i] = guess if letter == guess
    end
  end

  def display_word
    puts self.revealed.map{ |letter| letter || '_' }.join
  end

end