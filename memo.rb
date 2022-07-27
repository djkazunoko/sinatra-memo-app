require 'sinatra'
require 'sinatra/reloader'
require 'json'

get '/' do
  File.open("public/memos.json") do |file|
    @memos = JSON.load(file)
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

get '/memos/:id' do |n|
  File.open("public/memos.json") do |file|
    @memos = JSON.load(file)
  end
  @title = @memos[n]["title"]
  @content = @memos[n]["content"]
  erb :show
end
