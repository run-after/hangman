
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
    attr_reader :computer
    attr_reader :human
  def initialize
    @computer = Computer.new.word_selection
    @human = Player.new(@computer.length).guess
  end
  
  def play
    round = 1
    man = 0
    missed = Array.new
    
    until man == 6
      if computer.chars == human
        puts "You win! It was '#{computer}!'"
        break
      end
      puts "Round #{round}"
      puts
      puts @human.join(" ")
      puts
      puts "Missed:"
      puts missed.join(", ")
      puts
      print "Guess? "
      letter = gets.chomp
      
      if @computer.include?(letter) && !@human.include?(letter)
        @computer.chars.each_with_index do |x, index|
          if letter == x
            @human[index] = letter
          end
        end
        round += 1
      elsif !missed.include?(letter) && !@human.include?(letter)
        man += 1
        missed << letter
        round += 1
      else
        puts "You already guessed that one!"
      end
      if man == 6
        puts "LOSER!" 
        puts "It was '#{computer}'!"
      else
        puts "OK... man @ #{man}, #{6 - man} left..."
      end
    end

  end

end

game = Game.new
game.play

#probably break up the play method into a few other methods