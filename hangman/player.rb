class Player
  def set_secret_word_length
  end
  def guess(revealed)
  end
  def letter_locations
  end
  def end_game
  end
end

class ComputerPlayer < Player
  attr_reader :secret_word, :dictionary, :name, :guessed_letters, :last_letter, :new_game
  #secret_word should not be readable by others!

  def initialize(name = 'Kasih', file_name='./dictionary.txt')
    @name = name
    @full_dictionary = import_dictionary(file_name)
    @dictionary = @full_dictionary.dup
    @guessed_letters = []                         #must reset at the end!
    @new_game = true
  end

  def inspect
    "Initialized."
  end

  def import_dictionary(file_name)
     File.readlines(file_name).map(&:chomp)
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

  def guess(revealed)
    if self.dictionary.empty?
      :give_up
    elsif self.dictionary.length == 1
      guess = self.dictionary[0]
      puts "#{name} guessed #{guess}."
      guess
    else
      self.update_dictionary(revealed, self.last_letter)
      letter = most_common_unguessed_letter
      puts "#{name} guessed #{letter}."

      guessed_letters << letter

      @last_letter = letter
      letter
    end
  end

  def letter_locations(guess)
    indices = (0...secret_word.length).to_a
    indices.select { |i| secret_word[i] == guess }
  end

  def correct?(guess)
    guess == self.secret_word
  end

  def end_game(losing_condition)
    case losing_condition
    when :single_guess
      puts "No, the word was #{secret_word}."
    when :too_many_tries
      puts "You took too many tries. The word was #{secret_word}."
    when :give_up
      puts "Fine. The word was #{secret_word}."
    end
  end

  def update_dictionary(revealed, last_letter)
    if self.new_game
      @dictionary.select! { |word| word.length == revealed.length }
      @new_game = false
    end

    unless last_letter.nil? || revealed.include?(last_letter)
      @dictionary.reject! { |word| word.include?(last_letter) }
    end

    revealed.length.times do |i|
      unless revealed[i].nil?
        @dictionary.reject! { |word| word[i] != revealed[i]}
      end
    end

  end

  def most_common_unguessed_letter
    counts = Hash.new{ |h,k| h[k] = 0 }
    dictionary.each do |word|
      word.split(//).each do |letter|
        counts[letter]+=1
      end
    end
    counts.reject! { |k,v| guessed_letters.include?(k) }

    return counts.max_by {|letter, freq| freq} [0] if counts.count > 0
    ('a'..'z').to_a.sample
  end

  def clear_values
    @dictionary = @full_dictionary.dup
    @guessed_letters = []
    @new_game = true
    @last_letter = nil
  end

end

class HumanPlayer < Player

  attr_reader :name

  def initialize(name = 'KC')
    @name = name
  end

  def guess(revealed)
    input = gets.chomp
    return :give_up if input.include?("give up")
    input
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
                                            #also, should be using Integer()
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
    case losing_condition
    when :give_up
      print "A surrender! "
    when :too_many_tries
      print "Too many guesses! "
    end
    puts "#{name} won!"
  end

  def clear_values
  end

end
