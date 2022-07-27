require 'sinatra'
require 'sinatra/reloader'
require 'json'

get '/' do
  File.open("public/memos.json") do |file|
    @hash = JSON.load(file)
  end
  erb :index
end

get '/memos/new' do
  erb :new
end

post '/memos' do
  @title = params[:title]
  erb :index
end
