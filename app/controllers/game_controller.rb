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
      word = params[:word] || WordGame.get_random_word
      @game = WordGame.new word
      redirect_to game_show_path 
  end

  def guess
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
