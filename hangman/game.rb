class Game
  attr_reader :revealed, :wrong_guesses, :master, :guesser

  MAX_WRONG_GUESSES = 8

  def initialize(master = ComputerPlayer.new, guesser = ComputerPlayer.new)
    @master = master
    @guesser = guesser
  end


  def play
    initialize_word_blanks(master.set_secret_word_length)
    until self.won?
      prompt
      guess = guesser.guess
      self.reveal_letters(guess) if guess.length == 1

      if guess.length > 1
        guess == master.correct?(guess) ? self.won : self.lost(:single_guess)
        return
      end

      if wrong_guesses.count > MAX_WRONG_GUESSES
        self.lost(:too_many_tries)
        return
      end
    end

    self.won
  end

  def initialize_word_blanks(length)
    @revealed = Array.new(length)
    @wrong_guesses = []
  end

  def reveal_letters(guess)
    letter_locations = master.letter_locations(guess)
    wrong_guesses << guess if letter_locations.empty?
    letter_locations.each { |i| revealed[i] = guess }
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
    !self.revealed.include?(nil)
  end

  def play_again?
    puts "Play again?"
    print '> '
    y_or_n = gets.chomp
    y_or_n == 'y'
  end

  def won
    puts "#{guesser.name} won! The word was #{self.revealed.join}."
    self.play if play_again?
  end

  def lost(losing_condition)
    master.end_game(losing_condition)
    self.play if play_again?
  end

end
