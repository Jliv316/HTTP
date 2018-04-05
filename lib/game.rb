#The game will work like this:

# When a player starts a new game, the server picks a 
#random number between 0 and 100.
require 'pry'
class Game

    def initialize
        @random_number = rand(0..100)
    end
    
    #take in path 

    def guess_checker
        #if the guess is higher than @random_number
        if guess == @random_number
            puts "Horah! You've done it! Congratulations you guessed the correct number!"
        if guess > @random_number 
            puts "Your guess was too high, try again."
        elsif guess < @random_number
            puts "Your guess was too low, try again."
        end
    end

    

end








# The player can make a new guess by sending a POST 
#request containing the number they want to guess.
# When the player requests the game path, the server should
# show some information about the game including how many 
#guesses have been made, what the most recent guess was, 
#and whether it was too high, too low, or correct.

#GAME INFO: number_of_guesses, previous_guess, 
