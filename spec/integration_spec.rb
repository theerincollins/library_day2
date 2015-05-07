require('capybara/rspec')
require('./app')
require('spec_helper')
Capybara.app = Sinatra::Application
set(:show_exceptions, false)

describe('librarian link path', {:type => :feature}) do
  it('bring you to the librarian page') do
    visit('/')
    click_link('Click Here!')
    expect(page).to have_content('Hi Librarian')
    fill_in('title', :with => 'Hi There')
    fill_in('author', :with => 'Smart T. Pants')
    click_button('Add Book!')
    expect(page).to have_content("Hi There")
  end
end

describe('book info link', {:type => :feature}) do
  it('show book details for a particular book') do
    new_book = Book.new({:title => "This and That", :author => "This Girl", :id => nil})
    new_book.save()
    visit("/book/#{new_book.id()}")
    expect(page).to have_content(new_book.title())
  end
end
