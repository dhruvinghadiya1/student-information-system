require 'dm-core'
require 'dm-migrations'
require './main'

#establishing connection to database
DataMapper.setup(:default, ENV['DATABASE_URL']||"sqlite3://#{Dir.pwd}/main.db")  

#creating student table
class Student
    include DataMapper::Resource
    property :id, Serial
    property :firstname, String
    property :lastname, String
    property :address, String
    property :birthday, String
    property :scuid, String
end
DataMapper.finalize
DataMapper.auto_upgrade!

#setting route handlers
get '/students' do 
    @title = "Student"
    @student=Student.all
    erb :student
end

get '/students/new' do
    @title = "Student"
    redirect to('/login') unless session[:admin]
    @student=Student.new
    erb :studentadd
end

get '/students/:id' do
    @title = "Student"
    redirect to('/login') unless session[:admin]
    @student=Student.get(params[:id])
    erb :studentinfo
end

get '/students/:id/edit' do
    @title = "Student"
    redirect to('/login') unless session[:admin]
    @student=Student.get(params[:id])
    erb :studentupdate
end

#adding new student data
post '/students' do
    @student=Student.new
    @student.id=params[:id]
    @student.firstname=params[:firstname]
    @student.lastname=params[:lastname]
    @student.address=params[:address]
    @student.birthday=params[:birthday]
    @student.scuid=params[:scuid]
    if !validation
        halt(401,'please enter valid data')
    end
    @student.save
    redirect to('/students')
end

#upgrading student record
put '/students/:id' do
    @student=Student.get(params[:id])
    @student.id=params[:id]
    @student.firstname=params[:firstname]
    @student.lastname=params[:lastname]
    @student.address=params[:address]
    @student.birthday=params[:birthday]
    @student.scuid=params[:scuid]
    if !validation
        halt(401,'please enter valid data')
    end
    @student.save
    redirect to("/students/#{@student.id}")
end

delete '/students/:id' do
    Student.get(params[:id]).destroy
    redirect to('/students')
end

#validating proper student data
def validation
    if params[:id] ==" || params[:firstname] == " ||
    params[:lastname] ==" || params[:address] == " ||
    params[:birthday] ==" || params[:scuid] == " 
        false
    else
        true
    end
end



