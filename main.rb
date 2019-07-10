require './mastermind.rb'
require 'sinatra'
require 'sinatra/reloader' if development?

game = Mastermind.new

get '/' do
  redirect '/player' if params["choice"]=="Code Breaker"
  redirect '/computer' if params["choice"]=="Code Maker"
  erb :index
end

get '/player' do
  result = ""
  if (params["input"]!=nil) && (params["input"]!="") && game.tries!=0
    hint = game.play params["input"]
    result+= "#{hint['places']} number(s) in right place(s)."
    result+= "<br>#{hint['digits']} number(s) right but in wrong place(s)."
  end
  result = "Out of tries<br>GAME OVER!!!" if game.tries==0
  erb :player, :locals=>{:result=>result}
end

get '/computer' do
  erb :computer
end
