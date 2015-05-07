require('spec_helper')

describe(Book) do

  describe('.all') do
    it("returns all books in database") do
      test_book = Book.new({:title => "Going Up", :author => "Shel Silverstein", :id => nil})
      test_book.save()
      expect(Book.all).to(eq([test_book]))
  end
end

  describe('#title') do
    it("returns tile of a book") do
      test_book = Book.new({:title => "Going Up", :author => "Shel Silverstein", :id => nil})
      test_book.save()
      expect(test_book.title()).to(eq("Going Up"))
    end
  end

  describe('#author') do
    it("returns author of a book") do
      test_book = Book.new({:title => "Going Up", :author => "Shel Silverstein", :id => nil})
      test_book.save()
      expect(test_book.author()).to(eq("Shel Silverstein"))
    end
  end

  describe('#id') do
    it("returns id of a book") do
      test_book = Book.new({:title => "Going Up", :author => "Shel Silverstein", :id => nil})
      test_book.save()
      expect(test_book.id()).to(be_an_instance_of(Fixnum))
    end
  end

  describe('#==') do
    it("is equal if book has the same author and title") do
      test_book = Book.new({:title => "Going Up", :author => "Shel Silverstein", :id => nil})
      test_book2 = Book.new({:title => "Going Up", :author => "Shel Silverstein", :id => nil})
      test_book.save()
      test_book2.save()
      expect(test_book).to(eq(test_book2))
    end
  end

  describe('.find_id') do
    it("will return a book by book id") do
      test_book = Book.new({:title => "Going Up", :author => "Shel Silverstein", :id => nil})
      test_book2 = Book.new({:title => "Pirate Book", :author => "Shel Pirate", :id => nil})
      test_book.save()
      test_book2.save()
      expect(Book.find_id(test_book2.id)).to(eq(test_book2))
    end
  end

  describe('.find_title') do
    it("will return a book by book title") do
      test_book = Book.new({:title => "Going Up", :author => "Shel Silverstein", :id => nil})
      test_book2 = Book.new({:title => "Going Up", :author => "Rob Lowe", :id => nil})
      test_book.save()
      test_book2.save()
      expect(Book.find_title(test_book2.title)).to(eq([test_book, test_book2]))
    end
  end

  describe('.find_author') do
    it("will return a book by book author") do
      test_book = Book.new({:title => "Going Up", :author => "Shel Silverstein", :id => nil})
      test_book2 = Book.new({:title => "Pirate Book", :author => "Shel Silverstein", :id => nil})
      test_book.save()
      test_book2.save()
      expect(Book.find_author(test_book.author)).to(eq([test_book, test_book2]))
    end
  end

  describe('#update') do
    it("lets you update books in the database") do
      test_book = Book.new({:title => "Going Up", :author => "Shel Silverstein", :id => nil})
      test_book.save()
      test_book.update({:title => "That Killer Book", :author => ""})
      expect(test_book.title()).to(eq("That Killer Book"))
    end
  end

  describe('#delete') do
    it("lets you delete books from the database") do
      test_book = Book.new({:title => "Going Up", :author => "Shel Silverstein", :id => nil})
      test_book.save()
      test_book.delete()
      expect(Book.all()).to(eq([]))
    end
  end

  describe('#copies') do
    it("returns number of copies") do
      test_book = Book.new({:title => "Sirens of Titan", :author => "Kurt Vonnegut", :id => nil})
      test_book.save()
      expect(test_book.copies()).to(eq(1))
    end
  end

  describe('#add_copies') do
    it("allows user to add copies already existing book") do
      test_book = Book.new({:title => "Sirens of Titan", :author => "Kurt Vonnegut", :id => nil})
      test_book.save()
      test_book.add_copies(2)
      expect(test_book.copies()).to(eq(3))
    end
  end

end
