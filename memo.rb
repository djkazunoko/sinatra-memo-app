# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'cgi'
require 'pg'

CONN = PG.connect(dbname: 'postgres')

configure do
  result = CONN.exec("SELECT * FROM information_schema.tables WHERE table_name = 'memos'")
  CONN.exec('CREATE TABLE memos (id serial, title varchar(255), content text)') if result.values.empty?
end

def read_memos
  CONN.exec('SELECT * FROM memos')
end

def read_memo(id)
  result = CONN.exec('SELECT * FROM memos WHERE id = $1;', [id])
  result.tuple_values(0)
end

def post_memo(title, content)
  CONN.exec_params('INSERT INTO memos(title, content) VALUES ($1, $2);', [title, content])
end

def edit_memo(title, content, id)
  CONN.exec_params('UPDATE memos SET title = $1, content = $2 WHERE id = $3;', [title, content, id])
end

def delete_memo(id)
  CONN.exec_params('DELETE FROM memos WHERE id = $1;', [id])
end

get '/' do
  redirect '/memos'
end

get '/memos' do
  @memos = read_memos
  erb :index
end

get '/memos/new' do
  erb :new
end

get '/memos/:id' do
  memo = read_memo(params[:id])
  @title = memo[1]
  @content = memo[2]
  erb :show
end

post '/memos' do
  title = params[:title]
  content = params[:content]
  post_memo(title, content)
  redirect '/memos'
end

get '/memos/:id/edit' do
  memo = read_memo(params[:id])
  @title = memo[1]
  @content = memo[2]
  erb :edit
end

patch '/memos/:id' do
  title = params[:title]
  content = params[:content]
  edit_memo(title, content, params[:id])
  redirect "/memos/#{params[:id]}"
end

delete '/memos/:id' do
  delete_memo(params[:id])
  redirect '/memos'
end
