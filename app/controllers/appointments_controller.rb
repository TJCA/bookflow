class AppointmentsController < ApplicationController
  load_and_authorize_resource

  # all appointments (managers only)
  def index
  end

  def user_index
    @appointments = Appointment.joins(:book).where(school_id: current_user.school_id, status: 2)
                        .order(updated_at: :desc)
                        .paginate(:page => (params[:page]) ? params[:page].to_i : 1, :per_page => 10)
  end

  def create
    current_book = Book.find_by id: appointments_params[:id]
    case Appointment.make_appointment(appointments_params[:id], current_user, params[:time])
    when :success
      AppointmentMailer.appointment_email(current_user, current_book, params[:time]).deliver_now
      redirect_to :back, flash: { success: "预约成功" }
    when :not_enough
      redirect_to :back, flash: { warning: "积分余额不够啦" }
    when :not_found
      redirect_to books_url, flash: { warning: "没有对应的库存" }
    else
      redirect_to books_url, flash: { error: "未知错误" }
    end
  end

  def edit
  end

  def update
    current_book_appointment = Appointment.find_by id: params[:id]
    if current_book_appointment.status == "ready"
      current_book_appointment.update status: Appointment.issued
      Record.create(subject: current_user.id, verb: Record.finish_appointment,
                    object: current_book_appointment.id, adverb: current_book_appointment.user)
      redirect_to :back, flash: { success: "预约处理成功" }
    else
      redirect_to :back, flash: { error: "第%d号预约已经被处理过" % current_book_appointment.id }
    end
  end

  private
    def appointments_params
      params.require(:book).permit(:id)
    end
end