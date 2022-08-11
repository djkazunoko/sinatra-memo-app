# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'cgi'
require 'pg'

configure do
  CONN = PG.connect( dbname: 'testdb' )
  result = CONN.exec("SELECT * FROM information_schema.tables WHERE table_name = 'memos'")
  if result.values.empty?
    CONN.exec("CREATE TABLE memos (id serial, title varchar(255), content text)")
  end
end

get '/' do
  redirect '/memos'
end

get '/memos' do
  result = CONN.exec("SELECT * FROM memos")
  @memos = result
  erb :index
end

get '/memos/new' do
  erb :new
end

get '/memos/:id' do
  result = CONN.exec("SELECT * FROM memos WHERE id = #{params[:id]}")
  memo = result.tuple_values(0)
  @title = memo[1]
  @content = memo[2]
  erb :show
end

post '/memos' do
  title = params[:title]
  content = params[:content]

  CONN.exec_params("INSERT INTO memos(title, content) VALUES ($1, $2);", [title, content])

  redirect '/memos'
end

get '/memos/:id/edit' do
  result = CONN.exec("SELECT * FROM memos WHERE id = #{params[:id]}")
  memo = result.tuple_values(0)
  @title = memo[1]
  @content = memo[2]
  erb :edit
end

patch '/memos/:id' do
  title = params[:title]
  content = params[:content]

  CONN.exec_params("UPDATE memos SET title = $1, content = $2 WHERE id = $3;", [title, content, params[:id]])

  redirect "/memos/#{params[:id]}"
end

delete '/memos/:id' do
  CONN.exec_params("DELETE FROM memos WHERE id = $1;", [params[:id]])

  redirect '/memos'
end
