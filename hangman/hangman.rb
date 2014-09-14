if __FILE__ == $PROGRAM_NAME
  require_relative 'player'
  require_relative 'game'

  setup_done = false
  begin
    puts "Who is playing today?"
    print '> '
    players = gets.chomp.split(',').map(&:strip)
    if players.count == 2
      begin
        puts "Who is master today?"
        print '> '
        master_name = gets.chomp
        unless players.include?(master_name)
          puts "Is that #{players[0]} or #{players[1]}?"
        end
      end until players.include?(master_name)
      guesser_name = players.delete(master_name)[0]

      master = HumanPlayer.new(master_name)
      guesser = HumanPlayer.new(guesser_name)

      setup_done = true
      hangman = Game.new(master,guesser)

    elsif players.count == 1
      puts "Would you like to be master or guesser today?"
      print '> '
      begin
        role = gets.chomp.downcase
        unless ['master','guesser'].include?(role)
          puts "Is that master or guesser?"
        end
      end until ['master','guesser'].include?(role)

      human = HumanPlayer.new(players[0])
      computer = ComputerPlayer.new
      master, guesser = human, computer if role == 'master'
      master, guesser = computer, human unless role == 'master'

      setup_done = true
      hangman = Game.new(master,guesser)

    elsif players.count == 0
      puts "Pit two computer players against each other?"
      print '> '
      response = gets.chomp

      setup_done = response.downcase == 'y' || response.downcase == 'yes'
      setup_done ? hangman = Game.new : next

    else
      puts "Two players or two teams only! That is the nature of hangman!"
    end
  end until setup_done

  hangman.play
end