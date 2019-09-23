require 'sinatra'
require 'sinatra/reloader'

enable :sessions


get '/' do
  @secret_word = session[:secret_word]
  @display = session[:display]
  @missed_letters = session[:missed_letters]
  erb :index
end

get '/newgame' do
  set_session_variables
  redirect '/'
end

post '/' do
  # check_guess(params["guess"].downcase)
  redirect '/'
end

helpers do
  def set_session_variables
    session[:secret_word] = read_from_file.sample
    session[:turns] = 7
    session[:display] = Array.new(session[:secret_word].length, "_")
    session[:missed_letters] = Array.new
  end

  def read_from_file
    words = Array.new
    File.open('5desk.txt', 'r') do |f|
      f.each_line do |line|
        line.gsub!(/[^a-zA-Z]/, "")
        if line.length >= 5 && line.length <= 12
          words << line.downcase
        end
      end
    end
    words
  end

end