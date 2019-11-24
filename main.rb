require 'sinatra'
require './comments'
require './students'

get '/about' do
    @title = "about page" 
    erb :about
end

get '/contact' do
    @title = "contact page" 
    erb :contact
end
#establishing connection to database
configure :production do
    set :database, {adapter: 'postgresql', encoding: 'unicode',database: 'main.db', pool: 2,username:'root',password:'root'}
end

configure :production do
DataMapper.setup(:default, ENV['DATABASE_URL']||"sqlite3://#{Dir.pwd}/main.db")  
end

#login session 
configure do
    enable :sessions
    set :session_secret, 'sess'
    set :username,'dk'
    set :password,'12345'
end
get '/' do 
    @title = "Login"
    erb :formlogin
end

#validating authorized user
post '/' do
    if params[:username] == settings.username &&
        params[:password] == settings.password
        session[:admin] = true
        erb :signedin
    else
        halt(401,'incorrect usrid/pswrd')
    end
end

#setting route handler
get '/logout' do 
    session[:admin] = false
    session.clear
    erb :signedout
end

get '/login' do 
    @title = "Login"
    erb :formlogin
end

get '/video' do 
    @title = "video page"
    erb :video
end


not_found do
    @title = "not found page"  
    erb :notfound, :layout => false
end