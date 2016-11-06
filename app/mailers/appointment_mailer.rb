class AppointmentMailer < ApplicationMailer
  default from: 'tjsuqyershoushu@126.com'

  def appointment_email(user, book, time)
    require 'time'
    @user = user
    @book = book
    @time = Time.parse(time)
    mail(to: @user.email, subject: "预约提醒邮件通知")
  end
end
