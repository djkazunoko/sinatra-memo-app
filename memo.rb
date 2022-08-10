# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'cgi'
require 'pg'

def get_connection
  PG.connect( dbname: 'testdb' )
end

get '/' do
  redirect '/memos'
end

get '/memos' do
  conn = get_connection
  result = conn.exec("SELECT * FROM memos")
  @memos = result
  erb :index
end

get '/memos/new' do
  erb :new
end

get '/memos/:id' do
  conn = get_connection
  result = conn.exec("SELECT * FROM memos WHERE id = #{params[:id]}")
  memo = result.tuple_values(0)
  @title = memo[1]
  @content = memo[2]
  erb :show
end

post '/memos' do
  @title = params[:title]
  @content = params[:content]

  memos = get_memos(FILE_PATH)
  id = (memos.keys.map(&:to_i).max + 1).to_s
  memos[id] = { 'title' => @title, 'content' => @content }
  set_memos(FILE_PATH, memos)
  redirect '/memos'
end

delete '/memos/:id' do
  memos = get_memos(FILE_PATH)
  memos.delete(params[:id])
  set_memos(FILE_PATH, memos)

  redirect '/memos'
end

get '/memos/:id/edit' do
  memos = get_memos(FILE_PATH)
  @title = memos[params[:id]]['title']
  @content = memos[params[:id]]['content']
  erb :edit
end

patch '/memos/:id' do
  @title = params[:title]
  @content = params[:content]

  memos = get_memos(FILE_PATH)
  memos[params[:id]] = { 'title' => @title, 'content' => @content }
  set_memos(FILE_PATH, memos)

  redirect "/memos/#{params[:id]}"
end
