class Record < ActiveRecord::Base
  belongs_to :user

  enum verb: [
    :new_book_in,
    :book_out,
    :new_appointment,
    :cancel_appointment,
    :change_power,
    :finish_appointment
  ]


  def self.create_book(user, book, operator)
    self.create(subject: user, verb: :new_book_in, object: book, adverb: operator)
  end

  def self.out_book(user, book, operator)
    self.create(subject: user, verb: :book_out, object: book, adverb: operator)
  end
end
