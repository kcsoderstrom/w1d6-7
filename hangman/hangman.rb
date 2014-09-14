class Game
  attr_reader :dictionary, :secret_word, :revealed, :wrong_guesses

  MAX_WRONG_GUESSES = 8

  def initialize(file_name='./hangman/dictionary.txt')
    @dictionary = import_dictionary(file_name)
  end

  def set_secret_word
    begin
      @secret_word = self.dictionary.sample
    end until self.secret_word.length > 1

    @revealed = Array.new(self.secret_word.length)
    @wrong_guesses = []
  end

  def import_dictionary(file_name)
    dictionary_array = File.readlines(file_name).map(&:chomp)
  end

  def play
    self.set_secret_word
    until self.won?
      prompt
      guess = gets.chomp
      self.reveal_letters(guess) if guess.length == 1

      if guess.length > 1
        guess == self.secret_word ? self.won : self.lost_single_guess
        return
      end

      if wrong_guesses.count > MAX_WRONG_GUESSES
        self.lost_too_many_tries
        return
      end
    end

    self.won
  end

  def reveal_letters(guess)
    if secret_word.include?(guess)
      self.secret_word.each_char.with_index do |letter, i|
        self.revealed[i] = guess if letter == guess
      end
    else
      self.wrong_guesses << guess
    end
  end

  def display_word
    puts self.revealed.map{ |letter| letter || '_' }.join
  end

  def prompt
    print 'Secret word: '
    self.display_word
    print '> '
  end

  def won?
    self.revealed.join == self.secret_word
  end

  def play_again?
    puts "Play again?"
    print '> '
    y_or_n = gets.chomp
    y_or_n == 'y'
  end

  def won
    puts "You won! The word was #{self.secret_word}."
    self.play if play_again?
  end

  def lost_single_guess
    puts "No, the word was #{secret_word}."
    self.play if play_again?
  end

  def lost_too_many_tries
    puts "You took too many tries. The word was #{secret_word}."
    self.play if play_again?
  end

end