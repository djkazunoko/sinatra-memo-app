require 'sinatra'
require 'sinatra/reloader'
require 'json'

get '/' do
  @memos = File.open("public/memos.json") { |file| JSON.load(file) }
  erb :index
end

get '/memos/new' do
  erb :new
end

post '/memos' do
  @title = params[:title]
  @content = params[:content]

  memos = File.open("public/memos.json") { |file| JSON.load(file) }
  memos["99"] = {"title" => @title, "content" => @content}
  File.open("public/memos.json", 'w') { |file| JSON.dump(memos, file) }

  redirect '/'
end

get '/memos/:id' do |n|
  @memos = File.open("public/memos.json") { |file| JSON.load(file) }
  @title = @memos[n]["title"]
  @content = @memos[n]["content"]
  erb :show
end
