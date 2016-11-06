class Appointment < ActiveRecord::Base
  belongs_to :book
  #belongs_to :user
  enum status: { issued: 0, cancelled: 1, ready: 2 }

  def self.make_appointment(book_id, user, time)
    dest_book = Book.where("id = ? AND stock >= 1", book_id).first
    if dest_book
      credit_to_deduct = dest_book.ratio * dest_book.ori_price
      if user.credit >= credit_to_deduct
        user.credit -= credit_to_deduct
        user.save
        dest_book.update(stock: dest_book.stock - 1)
        self.create(school: user.school_id, book_id: dest_book.id, status: 2, promise_date: time)
        Record.create(subject: user.school_id, verb: 2, object: dest_book.id)
        :success
      else
        :not_enough
      end
    else
      :not_found
    end
  end
end
