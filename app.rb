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
  @allpatrons = Patron.all()
  erb(:patron_welcome)
end

get('/patron/:id') do
  @patron = Patron.find(params.fetch("id").to_i)
  erb(:patron)
end

get('/process_patron') do
  patron_id = params.fetch("patron")
  redirect("/patron/#{patron_id}")
end

get('/search/author') do
  @author = params.fetch("author")
  @books = Book.find_author(@author)
  @patron_id = params.fetch("id").to_i
  erb(:books_by_author)
end

post('/checkout/success') do
  @patron = Patron.find(params.fetch("id").to_i())
  @book_id = params.fetch("book_id").to_i
  @patron.update({:checked_out_books => [@book_id]})
  erb(:patron)
end

get('/books') do
  @books = Book.all()
  erb(:books)
end

post('/patrons/new') do
  name = params.fetch("name")
  Patron.new({:name => name, :id => nil}).save()
  @patrons = Patron.all()
  erb(:patrons)
end

get('/patrons') do
  @patrons = Patron.all()
  erb(:patrons)
end

delete('/books') do
  book = Book.find_id(params.fetch("id").to_i)
  book.delete()
  @books = Book.all()
  erb(:books)
end

delete('/patrons') do
  patron = Patron.find(params.fetch("id").to_i)
  patron.delete()
  @patrons = Patron.all()
  erb(:patrons)
end
