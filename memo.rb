require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'cgi'

FILE_PATH = "public/memos.json"

def get_memos(file_path)
  File.open(file_path) { |f| JSON.load(f) }
end

def set_memos(file_path, memos)
  File.open(file_path, 'w') { |f| JSON.dump(memos, f) }
end

get '/' do
  redirect '/memos'
end

get '/memos' do
  @memos = get_memos(FILE_PATH)
  erb :index
end

get '/memos/new' do
  erb :new
end

post '/memos' do
  @title = params[:title]
  @content = params[:content]

  memos = get_memos(FILE_PATH)
  maxid = 0
  memos.each_key do |id|
    if id.to_i > maxid
      maxid = id.to_i
    end
  end
  id = (maxid + 1).to_s
  memos[id] = {"title" => @title, "content" => @content}
  set_memos(FILE_PATH, memos)
  redirect '/memos'
end

get '/memos/:id' do |n|
  @memos = get_memos(FILE_PATH)
  @title = @memos[n]["title"]
  @content = @memos[n]["content"]
  erb :show
end

delete '/memos/:id' do |n|
  memos = get_memos(FILE_PATH)
  memos.delete(n)
  set_memos(FILE_PATH, memos)

  redirect '/memos'
end

get '/memos/:id/edit' do |n|
  memos = get_memos(FILE_PATH)
  @title = memos[n]["title"]
  @content = memos[n]["content"]
  erb :edit
end

patch '/memos/:id' do |n|
  @title = params[:title]
  @content = params[:content]

  memos = get_memos(FILE_PATH)
  memos[n] = {"title" => @title, "content" => @content}
  set_memos(FILE_PATH, memos)

  redirect "/memos/#{n}"
end
