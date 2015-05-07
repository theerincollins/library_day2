class Patron
  attr_reader(:name, :id)

  def initialize (attributes)
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id)
  end

  def save
    result = DB.exec("INSERT INTO patrons (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first().fetch("id").to_i
  end

  def self.all
    all_patrons = []
    returned_patrons = DB.exec("SELECT * FROM patrons;")
    returned_patrons.each do |patron|
      name = patron.fetch("name")
      id = patron.fetch("id").to_i
      all_patrons.push(Patron.new({:name => name, :id => id}))
    end
    all_patrons
  end

  def == (other_patron)
    self.id() == other_patron.id()
  end

  def update (attributes)
    @name = attributes.fetch(:name, @name)
    @id = self.id()
    DB.exec("UPDATE patrons SET name = '#{@name}' WHERE id = #{@id};")

    attributes.fetch(:checked_out_books, []).each() do |book_id|
      DB.exec("INSERT INTO checked_out (book_id, patron_id) VALUES (#{book_id}, #{@id});")
    end
  end

  def books
    results = DB.exec("SELECT book_id FROM checked_out WHERE patron_id = #{self.id()};")
    books = []
    results.each do |id|
      book_id = id.fetch("book_id").to_i
      book = DB.exec("SELECT * FROM books WHERE id = #{book_id};")
      title = book.first().fetch('title')
      author = book.first().fetch('author')
      books.push(Book.new({:title => title, :author => author, :id => book_id}))
    end
    books
  end


  def delete
    DB.exec("DELETE FROM patrons WHERE id = #{self.id()};")
    DB.exec("DELETE FROM checked_out WHERE patron_id = #{self.id()};")
  end




end
