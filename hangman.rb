require "yaml"

class progress

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

    attr_reader :progress
  def initialize
    @answer = Computer.new.word_selection
    @guess = Player.new(@answer.length).guess
    @progress = {'answer' => @answer, 'guess' => @guess, 'round' => 1, 
    'stick_man' => 0, 'missed' => Array.new}
  end

  def load_file
    print "Enter a filename: "
    filename = gets.chomp
    output = File.new("saved_games/#{filename}.yml", 'r')
    @progress = YAML.load(output.read)
    output.close
  end
  
  def play
    puts "Type 'load' if you want to load a game or press any key"
    choice = gets.chomp
    if choice == 'load'
      load_file()
    end
        round = progress['round']
        stick_man = progress['stick_man']
        missed = progress['missed']
        guess = progress['guess']
        answer = progress['answer']
    
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
          @progress = {'guess' => guess, 'answer' => answer, 
                        'round' => round, 'stick_man' => stick_man, 
                        'missed' => missed}
          print "Enter filename: "
          filename = "#{gets.chomp}.yml"
          Dir.mkdir("saved_games") unless Dir.exists? "saved_games"
          output = File.open("saved_games/#{filename}", 'w')
            output.puts YAML.dump(@progress)
            output.close

          
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

Game.new.play

#works great... but would like to clean it up a bit like try to save a
#class instead of a hash