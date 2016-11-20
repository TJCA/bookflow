class Book < ActiveRecord::Base
  has_many :appointments
  validates :title, presence: true
  validates :ratio, :ori_price, numericality: { greater_than: 0.0 }
  # validates :ratio, numericality: { less_than_or_equal_to: 1.0  }

  def self.create_book(pr, owner, operator)
    book = Book.where(isbn: pr[:isbn], title: pr[:title],
                      ori_price: pr[:price], ratio: pr[:ratio]).first
    if book
      book.update(stock: book.stock + 1)
      status = :add_book
    else
      book = Book.create(pr)
      status = :add_stock
    end
    user = User.find_by school_id: owner
    if user.nil?
      status = :no_user
    else
      Record.create_book owner, book.id, operator
      user.update credit: (user.credit + pr[:ratio].to_f * pr[:ori_price].to_f)
    end
    status
  end

  def self.increment_book(book_id, owner, operator)
    book = Book.find_by id: book_id
    user = User.find_by school_id: owner
    if user
      if book
        book.update(stock: book.stock + 1)
        Record.create_book owner, book_id, operator
        user.update credit: (user.credit + book.ratio * book.ori_price)
        :success
      else
        :no_book
      end
    else
      :no_user
    end
  end

  def self.out_book(book_id, owner, operator)
    book = Book.find_by id: book_id
    user = User.find_by school_id: owner
    if user
      if book and book.stock > 0
        if user.credit < book.ori_price * book.ratio
          :not_enough
        else
          user.update credit: user.credit - book.ori_price * book.ratio
          Record.out_book owner, book_id, operator
          book.update stock: book.stock - 1
          :ok
        end
      else
        :no_book
      end
    else
      :no_user
    end
  end
end
