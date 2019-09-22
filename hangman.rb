require 'sinatra'
require 'sinatra/reloader'



get '/' do
  erb :index
end


get '/newgame' do
  # set_variables
  redirect '/'
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