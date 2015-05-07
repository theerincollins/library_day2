require('spec_helper')

describe(Patron) do

  describe('.all') do
    it("returns all patrons in database") do
      test_patron = Patron.new({:name => "Bill", :id => nil})
      test_patron.save()
      expect(Patron.all).to(eq([test_patron]))
    end
  end

  describe('#update') do
    it("allow user to update name") do
      test_patron = Patron.new({:name => "Bob", :id => nil})
      test_patron.save()
      test_patron.update({:name => "Sally"})
      expect(test_patron.name()).to(eq("Sally"))
    end

    it("allow user to check out a books") do
      test_patron = Patron.new({:name => "Cheyanne", :id => nil})
      test_patron.save()
      book = Book.new({:title => "Oryx and Crake", :author => "Margaret Atwell", :id => nil})
      book.save()
      book2 = Book.new({:title => "Way of Kings", :author => "Brandon Sanderson", :id => nil})
      book2.save()
      test_patron.update({:checked_out_books => [book.id(), book2.id()]})
      expect(test_patron.books()).to(eq([book, book2]))
    end
  end

  describe('#books') do
    it("will return all books check out by a patron") do
      test_patron = Patron.new({:name => "Cheyanne", :id => nil})
      test_patron.save()
      book = Book.new({:title => "Oryx and Crake", :author => "Margaret Atwell", :id => nil})
      book.save()
      book2 = Book.new({:title => "Way of Kings", :author => "Brandon Sanderson", :id => nil})
      book2.save()
      test_patron.update({:checked_out_books => [book.id(), book2.id()]})
      expect(test_patron.books()).to(eq([book, book2]))
    end
  end

  describe('#delete') do
    it("will delete a patron and all checked out books by that patron") do
      test_patron = Patron.new({:name => "Rebecca", :id => nil})
      test_patron.save()
      test_patron.delete()
      expect(Patron.all()).to(eq([]))
    end
  end



end
