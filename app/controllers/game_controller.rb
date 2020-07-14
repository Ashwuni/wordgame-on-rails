class GameController < ApplicationController
  def win
  end

  def lose
  end

  def show
  end

  def new
  end

  def create
      letter = params[:max_number].to_s[0]

      if @max_number.guess_illegal_argument? letter || ! @max_number.guess letter # enter the guess here
        flash[:message] = "Must enter a number 0 or larger."
      elsif @max_number == nil #default
        @max_number =7
      end
      
      word = params[:word] || WordGame.get_random_word
      @game = WordGame.new word
      redirect_to game_show_path 
  end

  def guess
    letter = params[:guess].to_s[0]
    
    if @game.guess_illegal_argument? letter
        flash[:message] = "Invalid guess."
    elsif ! @game.guess letter # enter the guess here
        flash[:message] = "You have already used that letter."
    end
    
    if @game.check_win_or_lose == :win
        redirect_to game_win_path
    elsif @game.check_win_or_lose == :lose
        redirect_to game_lose_path
    else    
        redirect_to game_show_path
    end
  end
    
  def store_game_in_session
    session[:game] = @game.to_yaml
  end  
    
  def get_game_from_session
    if !session[:game].blank? 
      @game = YAML.load(session[:game])
    else
      @game = WordGame.new('')
    end
  end
    
  before_action :get_game_from_session
  after_action :store_game_in_session
end
