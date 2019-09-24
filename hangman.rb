# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'

enable :sessions

get '/' do
  redirect '/newgame' if session[:secret_word].nil? || game_over?
  set_instance_variables
  erb :index
end

get '/newgame' do
  set_session_variables
  redirect '/'
end

get '/win' do
  erb :win
end

get '/loose' do
  erb :loose
end

post '/' do
  check_guess(params['guess'].downcase)
  redirect '/'
end

helpers do
  def set_session_variables
    session[:secret_word] = read_from_file.sample
    session[:turns] = 7
    session[:display] = Array.new(session[:secret_word].length, '_')
    session[:missed_letters] = []
  end

  def set_instance_variables
    @secret_word = session[:secret_word]
    @display = session[:display]
    @missed_letters = session[:missed_letters]
    @turns = session[:turns]
  end

  def read_from_file
    words = []
    File.open('5desk.txt', 'r') do |f|
      f.each_line do |line|
        line.gsub!(/[^a-zA-Z]/, '')
        if line.length >= 5 && line.length <= 12
          words << line.downcase
        end
      end
    end
    words
  end

  def check_guess(letter)
    return unless valid_input?(letter)

    if session[:secret_word].include?(letter)
      session[:display].each_index do |i|
        if letter == session[:secret_word][i]
          session[:display][i] = letter
        end
      end
    else
      session[:missed_letters] << letter
      session[:turns] -= 1
    end
  end

  def valid_input?(letter)
    letter.match?(/[a-z]/) &&
      letter.length == 1 &&
      !session[:missed_letters].include?(letter)
  end

  def game_over?
    game_won? || out_of_turns?
  end

  def game_won?
    if session[:secret_word] == session[:display].join
      redirect '/win'
      true
    end
  end

  def out_of_turns?
    if session[:turns].zero?
      redirect '/loose'
      true
    end
  end
end
