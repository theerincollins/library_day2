require('sinatra')
require('sinatra/reloader')
require('./lib/book')
require('./lib/patron')
also_reload('lib/**/*.rb')
require('pg')
require('pry')

DB = PG.connect({:dbname => "library"})

get('/') do
  erb(:index)
end

get('/librarian') do
  @books = Book.all()
  erb(:librarian)
end

post('/books/new') do
  title = params.fetch("title")
  author = params.fetch("author")
  Book.new({:title => title, :author => author, :id => nil}).save()
  @books = Book.all()
  erb(:librarian)
end

get('/book/:id') do
  @book = Book.find_id(params.fetch("id").to_i())
  @number_of_copies = @book.copies()
  erb(:book)
end

patch('/book/:id') do
  @book = Book.find_id(params.fetch("id").to_i)
  @book.update({:title => params.fetch("title"), :author => params.fetch("author")})
  copies = params.fetch("add_copies").to_i
  @book.add_copies(copies)
  @number_of_copies = @book.copies
  erb(:book)
end

get('/patron') do
  greg = Patron.new({:name => "Greg", :id => nil}).save()
  sandy = Patron.new({:name => "Sandy", :id => nil}).save()
  @allpatrons = Patron.all()
  erb(:patron_welcome)
end
