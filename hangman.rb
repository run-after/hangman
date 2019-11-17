
class Board
  def initialize
    
  end
end

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

    round = 1
    stick_man = 0
    missed = Array.new
    
    until stick_man == 6
      if answer.chars == guess
        puts "You win! It was '#{answer}!'"
        break
      end
      puts "Round #{round}"
      puts
      puts guess.join(" ")
      puts
      puts "Missed:"
      puts missed.join(", ")
      puts
      print "Guess? "
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
      elsif !missed.include?(letter) && !guess.include?(letter)
        stick_man += 1
        missed << letter
        round += 1
        puts "Wrong..."
      else
        puts "You already guessed that one!"
      end
      if stick_man == 6
        puts "LOSER!" 
        puts "It was '#{answer}'!"
      else
        puts "You've got #{6 - stick_man} guesses left..."
        puts
      end
    end
  end

  def play_round


  end

end

Game.new.play

#probably break up the play method into a few other methods
#move the correct... youve got x guesses left so if you win it doesn't show