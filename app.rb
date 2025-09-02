require 'sqlite3'
require 'sinatra'
require 'rubygems'
require 'sinatra/reloader'

db = SQLite3::Database.new 'barbershop.db'
db.results_as_hash = true

configure do
	db.execute 'CREATE TABLE IF NOT EXISTS
	"Users" (
	 	"id" INTEGER PRIMARY KEY AUTOINCREMENT,
	 	"name" TEXT,
	 	"phone" TEXT,
	 	"datestamp" TEXT, 
	 	"barber" TEXT, 
	 	"color" TEXT);'
end

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/about' do
	erb :about
end

get '/visit' do
	erb :visit
end

post '/visit' do

	@username = params[:username]
	@phone = params[:phone]
	@datetime = params[:datetime]
	@barber = params[:barber]
	@color = params[:color]

	hh = { 	:username => 'Введите имя',
			:phone => 'Введите телефон',
			:datetime => 'Введите дату и время' }

	@error = hh.select {|key,_| params[key] == ""}.values.join(", ")

	if @error != ''
		return erb :visit
	end

	db.execute 'INSERT INTO 
		"Users" (
			name, 
			phone, 
			datestamp, 
			barber, 
			color
			) 
		VALUES (?, ?, ?, ?, ?)',  [@username, @phone, @datetime, @barber, @color]

	erb "OK, username is #{@username}, #{@phone}, #{@datetime}, #{@barber}, #{@color}"

end

get '/contacts' do
	erb :contacts	
end

post '/contacts' do 
	@name = params[:name]
	@email = params[:email]
	@message = params[:message]

	hh = {
		:name => "Enter name",
		:email => "Enter email",
		:message => "Enter message" }

	@error = hh.select {|key,_| params[key] == ""}.values.join(", ")

	if @error != ""
		return erb :contacts
	else
		return erb "Message sent successfully"
	end

end

get '/showusers' do
	@users = db.execute 'SELECT * FROM Users ORDER BY id DESC --'
	erb :showusers 
end