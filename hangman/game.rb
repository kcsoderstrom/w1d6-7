require 'set'

class Game
  attr_reader :revealed, :wrong_guesses, :master, :guesser

  MAX_WRONG_GUESSES = 8

  def initialize(master = ComputerPlayer.new, guesser = ComputerPlayer.new)
    @master = master
    @guesser = guesser
  end


  def play
    initialize_word_blanks(master.set_secret_word_length)
    while true
      prompt
      guess = guesser.guess(self.revealed)
      guess_type = parse(guess)

      case guess_type
      when :single_letter
        self.reveal_letters(guess)
        if wrong_guesses.count > MAX_WRONG_GUESSES
          self.lost(:too_many_tries)
          return
        end
      when :full_word
        master.correct?(guess) ? self.won(guess) : self.lost(:single_guess)
        return
      when :give_up
        self.lost(:give_up)
        return
      end
    end
  end

  def parse(guess)
    return :give_up if guess == :give_up
    return :single_letter if guess.length == 1
    return :full_word if guess.length > 1
  end

  def initialize_word_blanks(length)
    @revealed = Array.new(length)
    @wrong_guesses = Set.new
  end

  def reveal_letters(guess)
    letter_locations = master.letter_locations(guess)
    wrong_guesses << guess if letter_locations.empty?
    letter_locations.each { |i| revealed[i] = guess }
  end

  def display_word
    print self.revealed.map{ |letter| letter || '_' }.join
  end

  def prompt
    print 'So far: '
    self.display_word
    print "\t"
    puts "Remaining lives: #{MAX_WRONG_GUESSES - wrong_guesses.count + 1}"
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

  def won(final_word)
    puts "#{guesser.name} won! The word was #{final_word}."
    if play_again?
      self.guesser.clear_values
      self.play
    end
  end

  def lost(losing_condition)
    master.end_game(losing_condition)
    if play_again?
      self.guesser.clear_values
      self.play
    end
  end

end
