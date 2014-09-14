class Player
  def set_secret_word_length
  end
  def guess
  end
  def letter_locations
  end
  def end_game
  end
end

class ComputerPlayer < Player
  attr_reader :secret_word, :dictionary, :name

  def initialize(name = 'Kasih', file_name='./dictionary.txt')
    @name = name
    @dictionary = import_dictionary(file_name)
  end

  def inspect
    "Initialized."
  end

  def import_dictionary(file_name)
    dictionary_array = File.readlines(file_name).map(&:chomp)
  end

  def set_secret_word_length
    set_secret_word
    self.secret_word.length
  end

  def set_secret_word
    begin
      @secret_word = self.dictionary.sample
    end until self.secret_word.length > 1
  end

  def guess
    letter = ('a'..'z').to_a.sample
    puts "#{name} guessed #{letter}."
    letter
  end

  def letter_locations(guess)
    indices = (0...secret_word.length).to_a
    indices.select { |i| secret_word[i] == guess }
  end

  def correct?(guess)
    guess == self.secret_word
  end

  def end_game(losing_condition)
    if losing_condition == :single_guess
      puts "No, the word was #{secret_word}."
    elsif losing_condition == :too_many_tries
      puts "You took too many tries. The word was #{secret_word}."
    end
  end

end

class HumanPlayer < Player

  attr_reader :name

  def initialize(name = 'KC')
    @name = name
  end

  def guess
    gets.chomp
  end

  def set_secret_word_length
    puts "#{name}, how many letters long is your word?"
    print '> '
    Integer(gets.chomp)
  end

  def letter_locations(guess)
    puts "#{name}, where is #{guess} in your word?"
    print '> '
    gets.chomp.split(',').map(&:strip).map(&:to_i) #could regex but no
                                            #should be using Integer()
  end

  def correct?(guess)
    puts "Is #{guess} your word?"
    print '> '
    self.yes?
  end

  def yes?
    reply = gets.chomp
    reply.downcase == 'y' || reply.downcase == 'yes'
  end

  def end_game(losing_condition)
    puts "#{name} won!"
  end

end
