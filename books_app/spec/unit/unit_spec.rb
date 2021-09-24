# location: spec/unit/unit_spec.rb
require 'rails_helper'

RSpec.describe Book, type: :model do
  # create
  subject do
    described_class.new(
        title: 'harry potter',
        author: 'Jk Rowling',
        price: 3.00,
        published_date: Date.yesterday
    )
  end

  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end

  it 'is not valid without a title' do
    subject.title = nil
    expect(subject).not_to be_valid
  end

  it 'is not valid without an author' do
    subject.author = nil
    expect(subject).not_to be_valid
  end

  it 'is not valid without a price' do
    subject.price = nil
    expect(subject).not_to be_valid
  end

  it 'is not valid without a price as a number' do
    subject.price = 'hello'
    expect(subject).not_to be_valid
  end

  it 'is not valid without a published_date' do
    subject.price = nil
    expect(subject).not_to be_valid
  end

  it 'is not valid without a published_date as a date' do
    subject.price = 'hello there'
    expect(subject).not_to be_valid
  end

  it 'is not valid with published_date being today' do
    subject.published_date = Date.current
    expect(subject).not_to be_valid
  end

  # show
  it 'valid show a book' do
    book = described_class.new(
      title: 'harry potter',
      author: 'Jk Rowling',
      price: 3.00,
      published_date: Date.yesterday
    )
    book.save
    expect(Book.find(book.id)).to eq book
  end

  it 'invalid show a book' do
    expect{ Book.find(4) }.to raise_exception(ActiveRecord::RecordNotFound)
  end

  # edit
  it 'valid edit a book' do
    book = described_class.new(
      title: 'harry potter',
      author: 'Jk Rowling',
      price: 3.00,
      published_date: Date.yesterday
    )
    book.save
    foundBook = Book.find(book.id)
    expect(foundBook.update(:title => 'hermione granger')).to eq true
  end

  it 'valid repeat edit a book' do
    book = described_class.new(
      title: 'harry potter',
      author: 'Jk Rowling',
      price: 3.00,
      published_date: Date.yesterday
    )
    book.save
    foundBook = Book.find(book.id)
    expect(foundBook.update(:title => 'hermione granger')).to eq true
  end

  it 'invalid edit a book' do
    book = described_class.new(
      title: 'harry potter',
      author: 'Jk Rowling',
      price: 3.00,
      published_date: Date.yesterday
    )
    book.save
    foundBook = Book.find(book.id)
    expect(foundBook.update(:published_date => 3445)).to eq false
  end

  # destroy
  it 'valid destroy a book' do
    book = described_class.new(
      title: 'harry potter',
      author: 'Jk Rowling',
      price: 3.00,
      published_date: Date.yesterday
    )
    book.save
    expect { book.destroy }.to change { Book.count }
  end

  it 'invalid destroy a book' do
    expect { Book.destroy(4) }.to raise_exception(ActiveRecord::RecordNotFound)
  end
end