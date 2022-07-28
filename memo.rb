require 'sinatra'
require 'sinatra/reloader'
require 'json'

get '/' do
  redirect '/memos'
end

get '/memos' do
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
  memos.each_key do |id|
    if id.to_i > maxid
      maxid = id.to_i
    end
  end
  id = maxid + 1
  memos["#{id}"] = {"title" => @title, "content" => @content}
  File.open("public/memos.json", 'w') { |file| JSON.dump(memos, file) }

  redirect '/memos'
end

get '/memos/:id' do |n|
  @memos = File.open("public/memos.json") { |file| JSON.load(file) }
  @title = @memos[n]["title"]
  @content = @memos[n]["content"]
  erb :show
end

delete '/memos/:id' do |n|
  memos = File.open("public/memos.json") { |file| JSON.load(file) }
  memos.delete(n)
  File.open("public/memos.json", 'w') { |file| JSON.dump(memos, file) }

  redirect '/memos'
end

get '/memos/:id/edit' do |n|
  memos = File.open("public/memos.json") { |file| JSON.load(file) }
  @title = memos[n]["title"]
  @content = memos[n]["content"]
  erb :edit
end

patch '/memos/:id' do |n|
  @title = params[:title]
  @content = params[:content]

  memos = File.open("public/memos.json") { |file| JSON.load(file) }
  memos[n] = {"title" => @title, "content" => @content}
  File.open("public/memos.json", 'w') { |file| JSON.dump(memos, file) }

  redirect "/memos/#{n}"
end
