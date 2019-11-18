class Computer
  attr_reader :word
  def initialize
    @word = ''
  end

  def word_selection
    word_list = File.readlines "word_list.txt"
    until @word.length >= 5 && @word.length <= 12 do
      @word = word_list[rand(word_list.length)] 
    end
    @word.chomp.downcase
  end
end

class Player
  attr_reader :guess
  def initialize(size)
    @guess = Array.new(size, "_")
  end
end

class Game
    attr_reader :answer
    attr_reader :guess
  def initialize
    @answer = Computer.new.word_selection
    @guess = Player.new(answer.length).guess
  end
  
  def play
    puts "Would you like to play a (n)ew game or (l)oad a saved one?"
    choice = gets.chomp
    if choice == 'l'
      print "Enter a filename: "
      filename = gets.chomp
      loaded_game = File.readlines("saved_games/#{filename}")
        loaded_game.each do |line|
         p line   
      end
    else
      round = 1
      stick_man = 0
      missed = Array.new
    
      until stick_man == 6
        puts "Round #{round}"
        puts
        puts guess.join(" ")
        puts
        puts "Missed:"
        puts missed.join(", ")
        puts
        puts "(enter '*' if you'd like to save and quit)"
        print "Enter your guess: "
      
        letter = gets.chomp
        puts
        if answer.include?(letter) && !guess.include?(letter)
          answer.chars.each_with_index do |x, index|
            if letter == x
              guess[index] = letter
            end
          end
          round += 1
          puts "Correct..."
        elsif letter == '*'
          print "Enter filename: "
          filename = "#{gets.chomp}.csv"
          Dir.mkdir("saved_games") unless Dir.exists? "saved_games"
          File.open("saved_games/#{filename}", 'w') do |file|

              file.puts "guess: #{guess}"
              file.puts "answer: #{answer}"
              file.puts "stick_man: #{stick_man}"
              file.puts "round: #{round}"
              file.puts "missed: #{missed}"

          end
          puts "#{filename} SAVED!"
          break
        elsif !missed.include?(letter) && !guess.include?(letter)
          stick_man += 1
          missed << letter
          round += 1
          puts "Wrong..."
        else
          puts "You already guessed that one!"
        end
        if answer.chars == guess
          puts "You win! It was '#{answer}!'"
          break
        elsif stick_man == 6
          puts "LOSER!" 
          puts "It was '#{answer}'!"
        else
          puts "You've got #{6 - stick_man} wrong answers left..."
          puts
        end
      end
    end
  end

end

Game.new.play

#probably break up the play method into a few other methods