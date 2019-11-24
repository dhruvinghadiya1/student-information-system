require 'sinatra'
require 'dm-core'
require 'dm-migrations'
require'dm-timestamps'
require './main'

#establishing connection to database
DataMapper.setup(:default, ENV['DATABASE_URL']||"sqlite3://#{Dir.pwd}/main.db")  

#creating comment table
class Comment
    include DataMapper::Resource
    property :id, Serial
    property :name, String
    property :comment_txt, String
    property :created_at, DateTime
end
DataMapper.finalize
DataMapper.auto_upgrade!

#route handler 
get '/comment' do
    @title = "comment page" 
    @comments=Comment.all
    erb :comment
end

get '/comment/new' do
    @title = "comments page" 
    redirect to('/login') unless session[:admin]
    @comment=Comment.new
    erb :commentadd
end

get '/comment/:id' do
    @title = "comments page" 
    redirect to('/login') unless session[:admin]
    @comment=Comment.get(params[:id])
    erb :commentdisplay
end
#adding new comment 
post '/comment' do
    if !commentvalidation
        halt(406,'please enter valid data')
    end
    @comment=Comment.new
    @comment.id=params[:id]
    @comment.name=params[:name]
    @comment.comment_txt=params[:comment_txt]
    @comment.created_at=params[:created_at]
    @comment.save
    redirect to('/comment')
end

delete '/comment/:id' do
    Comment.get(params[:id]).destroy
    redirect to('/comment')
end
#validating proper comment data
def commentvalidation
    if params[:name] ==" || params[:comment_txt] == "
        false
    else
        true
    end
end
