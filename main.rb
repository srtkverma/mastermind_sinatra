require './mastermind.rb'
require 'sinatra'
require 'sinatra/reloader' if development?

get '/' do
  erb :index
end
