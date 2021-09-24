# location: spec/feature/integration_spec.rb
require 'rails_helper'
# require 'selenium-webdriver'
# Selenium::WebDriver::Firefox::Binary.path='/opt/firefox92/firefox'

RSpec.describe 'Creating a book', type: :feature do
  scenario 'valid inputs' do
    date = Date.yesterday.strftime('%Y-%m-%d')
    visit new_book_path
    fill_in 'Title', with: 'harry potter'
    fill_in 'Author', with: 'Jk Rowling'
    fill_in 'Price', with: 3.00
    fill_in 'book[published_date]', with: date
    click_on 'Create Book'
    # expect(flash[:alert]).to eq('Book entered successfully.')
    visit books_path
    expect(page).to have_content('harry potter')
    expect(page).to have_content('Jk Rowling')
    expect(page).to have_content('3.00')
    expect(page).to have_content(date)
  end

  scenario 'valid inputs -- long price concatentated to price' do
    date = Date.yesterday.strftime('%Y-%m-%d')
    visit new_book_path
    fill_in 'Title', with: 'harry potter'
    fill_in 'Author', with: 'Jk Rowling'
    fill_in 'Price', with: 2.9913456
    fill_in 'book[published_date]', with: date
    click_on 'Create Book'
    # expect(flash[:alert]).to eq('Book entered successfully.')
    visit books_path
    expect(page).to have_content('harry potter')
    expect(page).to have_content('Jk Rowling')
    expect(page).to have_content('2.99')
    expect(page).to have_content(date)
  end

  scenario 'valid inputs -- short price expanded to price' do
    date = Date.yesterday.strftime('%Y-%m-%d')
    visit new_book_path
    fill_in 'Title', with: 'harry potter'
    fill_in 'Author', with: 'Jk Rowling'
    fill_in 'Price', with: 2
    fill_in 'book[published_date]', with: date
    click_on 'Create Book'
    # expect(flash[:alert]).to eq('Book entered successfully.')
    visit books_path
    expect(page).to have_content('harry potter')
    expect(page).to have_content('Jk Rowling')
    expect(page).to have_content('2.00')
    expect(page).to have_content(date)
  end

  scenario 'invalid inputs - missing every input' do
    visit new_book_path
    click_on 'Create Book'
    expect(page).to have_content("Title can't be blank")
    expect(page).to have_content("Author can't be blank")
    expect(page).to have_content("Price is not a number")
    expect(page).to have_content("Published date can't be blank")
    expect(page).to have_content("Published date must enter a date")
  end

  scenario 'invalid inputs - missing title' do
    date = Date.yesterday.strftime('%Y-%m-%d')
    visit new_book_path
    fill_in 'Author', with: 'Jk Rowling'
    fill_in 'Price', with: 3.00
    fill_in 'book[published_date]', with: date
    click_on 'Create Book'
    expect(page).to have_content("Title can't be blank")
    visit books_path
    expect(page).not_to have_content('Jk Rowling')
    expect(page).not_to have_content('3.00')
    expect(page).not_to have_content(date)
  end

  scenario 'invalid inputs - missing author' do
    date = Date.yesterday.strftime('%Y-%m-%d')
    visit new_book_path
    fill_in 'Title', with: 'harry potter'
    fill_in 'Price', with: 3.00
    fill_in 'book[published_date]', with: date
    click_on 'Create Book'
    expect(page).to have_content("Author can't be blank")
    visit books_path
    expect(page).not_to have_content('harry potter')
    expect(page).not_to have_content('3.00')
    expect(page).not_to have_content(date)
  end

  scenario 'invalid inputs - missing price' do
    date = Date.yesterday.strftime('%Y-%m-%d')
    visit new_book_path
    fill_in 'Title', with: 'harry potter'
    fill_in 'Author', with: 'Jk Rowling'
    fill_in 'book[published_date]', with: date
    click_on 'Create Book'
    expect(page).to have_content("Price is not a number")
    visit books_path
    expect(page).not_to have_content('harry potter')
    expect(page).not_to have_content('Jk Rowling')
    expect(page).not_to have_content(date)
  end

  scenario 'invalid inputs - missing published date' do
    visit new_book_path
    fill_in 'Title', with: 'harry potter'
    fill_in 'Author', with: 'Jk Rowling'
    fill_in 'Price', with: 3.00
    click_on 'Create Book'
    expect(page).to have_content("Published date must enter a date")
    expect(page).to have_content("Published date can't be blank")
    visit books_path
    expect(page).not_to have_content('harry potter')
    expect(page).not_to have_content('Jk Rowling')
    expect(page).not_to have_content("3.00")
  end

  scenario 'invalid inputs - published date too recent' do
    date = Date.today.strftime('%Y-%m-%d')
    visit new_book_path
    fill_in 'Title', with: 'harry potter'
    fill_in 'Author', with: 'Jk Rowling'
    fill_in 'Price', with: 3.00
    fill_in 'book[published_date]', with: date
    click_on 'Create Book'
    expect(page).to have_content("Published date must be before the current date")
    visit books_path
    expect(page).not_to have_content('harry potter')
    expect(page).not_to have_content('Jk Rowling')
    expect(page).not_to have_content("3.00")
    expect(page).not_to have_content(date)
  end
end

RSpec.describe 'Showing a book', type: :feature do
  scenario 'valid show' do
    date = Date.yesterday.strftime('%Y-%m-%d')
    visit new_book_path
    fill_in 'Title', with: 'harry potter'
    fill_in 'Author', with: 'Jk Rowling'
    fill_in 'Price', with: 3.00
    fill_in 'book[published_date]', with: date
    click_on 'Create Book'
    visit books_path
    click_on 'Show'
    expect(page).to have_content('harry potter')
    expect(page).to have_content('Jk Rowling')
    expect(page).to have_content('3.00')
    expect(page).to have_content(date)
  end

  scenario 'invalid show' do
    expect{ visit '/books/4' }.to raise_exception(ActiveRecord::RecordNotFound)
  end
end

RSpec.describe 'Editing a book', type: :feature do
  # most of the feauture are the same ass create
  # so mainly test the button
  scenario 'valid edit' do
    date = Date.yesterday.strftime('%Y-%m-%d')
    visit new_book_path
    fill_in 'Title', with: 'harry potter'
    fill_in 'Author', with: 'Jk Rowling'
    fill_in 'Price', with: 3.00
    fill_in 'book[published_date]', with: date
    click_on 'Create Book'
    visit books_path
    click_on 'Edit'
    fill_in 'Title', with: 'Herminone Granger'
    fill_in 'Author', with: 'Jk Rowling'
    fill_in 'Price', with: 3.00
    fill_in 'book[published_date]', with: date
    click_on 'Update Book'
    visit books_path
    expect(page).to have_content('Herminone Granger')
    expect(page).to have_content('Jk Rowling')
    expect(page).to have_content('3.00')
    expect(page).to have_content(date)
  end

  scenario 'invalid edit' do
    date = Date.yesterday.strftime('%Y-%m-%d')
    visit new_book_path
    fill_in 'Title', with: 'harry potter'
    fill_in 'Author', with: 'Jk Rowling'
    fill_in 'Price', with: 3.00
    fill_in 'book[published_date]', with: date
    click_on 'Create Book'
    visit books_path
    click_on 'Edit'
    fill_in 'book[published_date]', with: Date.today.strftime('%Y-%m-%d')
    click_on 'Update Book'
    expect(page).to have_content("Published date must be before the current date")
    visit books_path
    expect(page).to have_content('Jk Rowling')
    expect(page).to have_content('3.00')
    expect(page).to have_content(date)
  end
end

=begin
RSpec.describe 'Destroying a book', js: true, type: :feature do
  scenario 'approve delete' do
    visit('http://127.0.0.1:43007/books')
    page.accept_confirm do
      click_on 'Destroy'
    end
    expect(page).to have_content("Book was successfully destroyed.")
  end 

  scenario 'decline delete' do
    visit('http://127.0.0.1:43007/books')
    page.reject_confirm do
      click_on 'Destroy'
    end
    expect(page).not_to have_content("Book was successfully destroyed.")
  end 
end
=end