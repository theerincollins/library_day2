class Book
attr_reader(:title, :author, :id)

  def initialize (attributes)
    @title = attributes.fetch(:title)
    @author = attributes.fetch(:author)
    @id = attributes.fetch(:id)
  end

  def save
    result = DB.exec("INSERT INTO books (title, author) VALUES ('#{@title}', '#{@author}') RETURNING id;")
    @id = result.first().fetch("id").to_i
    DB.exec("INSERT INTO copies (number_of_copies, book_id) VALUES (1, #{@id});")
  end

  def self.all
    all_books = []
    returned_books = DB.exec("SELECT * FROM books;")
    returned_books.each do |book|
      title = book.fetch("title")
      author = book.fetch("author")
      id = book.fetch("id").to_i
      all_books.push(Book.new({:title => title, :author => author, :id => id}))
    end
    all_books
  end

  def == (other_book)
    self.author() == other_book.author() && self.title() == other_book.title()
  end

  def self.find_id (given_id)
    found_book = nil
    result = DB.exec("SELECT * FROM books WHERE id = #{given_id};")
    result.each() do |book|
      title = book.fetch("title")
      author = book.fetch("author")
      found_book = (Book.new({:title => title, :author => author, :id => given_id}))
    end
    found_book
  end

  def self.find_title (given_title)
    found_books = []
    results = DB.exec("SELECT * FROM books WHERE title = '#{given_title}';")
    results.each() do |book|
      author = book.fetch("author")
      id = book.fetch("id").to_i()
      found_books.push(Book.new({:title => given_title, :author => author, :id => id}))
    end
    found_books
  end

  def self.find_author (given_author)
    found_books = []
    results = DB.exec("SELECT * FROM books WHERE author = '#{given_author}';")
    results.each() do |book|
      title = book.fetch("title")
      id = book.fetch("id").to_i()
      found_books.push(Book.new({:title => title, :author => given_author, :id => id}))
    end
    found_books
  end

  def update (attributes)
    if attributes.fetch(:title) == ""
      @title = @title
    else
      @title = attributes.fetch(:title)
    end

    if attributes.fetch(:author) == ""
      @author = @author
    else
      @author = attributes.fetch(:author)
    end
    @id = self.id()
    DB.exec("UPDATE books SET title = '#{@title}' WHERE id = #{@id};")
    DB.exec("UPDATE books SET author = '#{@author}' WHERE id = #{@id};")
  end

  def delete
    DB.exec("DELETE FROM books WHERE id = #{self.id()};")
    DB.exec("DELETE FROM copies WHERE book_id = #{self.id()};")
  end

  def copies
    result = DB.exec("SELECT number_of_copies FROM copies WHERE book_id = #{self.id};")
    result.first().fetch("number_of_copies").to_i
  end

  def add_copies (adding_copies)
    all_copies = self.copies() + adding_copies
    DB.exec("UPDATE copies SET number_of_copies = #{all_copies} WHERE book_id = #{self.id()};")
  end







end
