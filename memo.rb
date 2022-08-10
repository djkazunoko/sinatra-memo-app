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
  title = params[:title]
  content = params[:content]

  conn = get_connection
  conn.exec_params("INSERT INTO memos(title, content) VALUES ($1, $2);", [title, content])

  redirect '/memos'
end

delete '/memos/:id' do
  memos = get_memos(FILE_PATH)
  memos.delete(params[:id])
  set_memos(FILE_PATH, memos)

  redirect '/memos'
end

get '/memos/:id/edit' do
  conn = get_connection
  result = conn.exec("SELECT * FROM memos WHERE id = #{params[:id]}")
  memo = result.tuple_values(0)
  @title = memo[1]
  @content = memo[2]
  erb :edit
end

patch '/memos/:id' do
  title = params[:title]
  content = params[:content]

  conn = get_connection
  conn.exec_params("UPDATE memos SET title = $1, content = $2 WHERE id = $3;", [title, content, params[:id]])

  redirect "/memos/#{params[:id]}"
end
