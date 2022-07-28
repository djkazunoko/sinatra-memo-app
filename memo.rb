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
  maxid = 0
  memos.each_key do |key|
    if key.to_i > maxid
      maxid = key.to_i
    end
  end
  id = maxid + 1
  memos["#{id}"] = {"title" => @title, "content" => @content}
  File.open("public/memos.json", 'w') { |file| JSON.dump(memos, file) }

  redirect '/'
end

get '/memos/:id' do |n|
  @memos = File.open("public/memos.json") { |file| JSON.load(file) }
  @title = @memos[n]["title"]
  @content = @memos[n]["content"]
  erb :show
end
