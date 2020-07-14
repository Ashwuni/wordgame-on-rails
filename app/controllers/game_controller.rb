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
      max_number = params[:max_number].to_s[0]
      word = params[:word] || WordGame.get_random_word

      
      if max_number == nil #default
          @game = WordGame.new word,7
          redirect_to game_show_path
      elsif max_number.to_i < 0 || max_number[/[^a-zA-Z]+/] != max_number
          flash[:message] = "Must enter a number 0 or larger."
          redirect_to game_new_path
      else
          @game = WordGame.new word,max_number
          redirect_to game_show_path
      end
      
      #redirect_to game_show_path 
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
