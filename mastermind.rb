#ATTENTION!!!!!!Still working on the code as could not figure out how to get the mastermind code to work in this environment. 

require 'sinatra'
require 'sinatra/reloader' if development?

enable :sessions
set :session_secret, ENV['SESSION_KEY']
set :session_secret, SecureRandom.hex(64) if development?
set :sessions, :expire_after => 259200


NUMBER = rand(100)
GUESSES_REMAINING = 10

get '/' do
  guess = params["guess"].to_i
  message = check_guess(guess)
  GUESSES_REMAINING -= 1
  evaluate_guesses(guess)

  erb :index, :locals => {:number => NUMBER,
                          :guess => params["guess"],
                          :message     => message,
                          :color_response => @color_response,
                          :guesses_remaining => GUESSES_REMAINING,
                          :game_response => @game_response
                        }
end


def evaluate_guesses(guess)
  if guess == NUMBER
    reset_game
    @game_response = "You cracked the code!! -- A new number has been generated and game reset."
  end

  if GUESSES_REMAINING == 0
    reset_game
    @game_response = "You lost, try harder next time!! -- A new number has been generated and game is reset."
  end
end

def reset_game
  GUESSES_REMAINING
  NUMBER
end


def check_guess(guess)

  if guess == " ".to_i
      "Please enter a number"
  elsif guess > NUMBER
    if guess > NUMBER + 10
      @color_response = "response__paragraph--far"
      "Way too High!"
    else
      @color_response = "response__paragraph--near"
      "Near but too High"
    end

  elsif guess < NUMBER
    if guess < NUMBER - 10
      @color_response = "response__paragraph--far"
      "Way too Low!"
    else
      @color_response = "response__paragraph--near"
      "Near but too Low"
    end
  elsif guess == NUMBER
    @color_response = "response__paragraph--correct"
    "The secret number is #{NUMBER}"

  end

end
