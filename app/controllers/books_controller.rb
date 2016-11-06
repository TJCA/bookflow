class BooksController < ApplicationController
  load_and_authorize_resource

  def new 
  end

  def show
    now = Time.new
    @occasion_list = Array.new
    iter = Time.mktime(now.year, now.month, now.day)
    if now.sunday?
      iter += 24 * 60 * 60
      while iter.wday <= 5
        iter += 12 * 60 * 60
        @occasion_list << [iter.strftime('%m-%d %H:%M'), iter]
        iter += 6 * 60 * 60
        @occasion_list << [iter.strftime('%m-%d %H:%M'), iter]
        iter += 6 * 60 * 60
      end
      tday = @occasion_list.pop
      tday[1] += 2 * 24 * 60 * 60
      @occasion_list << [tday[1].strftime('%m-%d %H:%M'), tday[1]]
    else
      until iter.sunday?
        iter += 24 * 60 * 60
      end
      iter += 18 * 60 * 60
      @occasion_list << [iter.strftime('%m-%d %H:%M'), iter]
      iter += 6 * 60 * 60
      while iter.wday <= 5
        iter += 12 * 60 * 60
        @occasion_list << [iter.strftime('%m-%d %H:%M'), iter]
        iter += 6 * 60 * 60
        @occasion_list << [iter.strftime('%m-%d %H:%M'), iter]
        iter += 6 * 60 * 60
      end
      @occasion_list.pop
    end
  end

  def create
    status = Book.create_book(book_params, params[:user], current_user.school_id)
    case status
    when :add_book
      redirect_to new_book_url, flash: { success: "新增库存，图书入库成功" }
    when :add_stock
      redirect_to new_book_url, flash: { warning: "已有库存，图书入库成功" }
    when :no_user
      redirect_to new_book_url, flash: { error: "捐书人ID不存在" }
    else
      redirect_to profile_url, flash: { error: "未知错误" }
    end
  end

  def index
    if params[:page] and params[:page].to_i > 0
      @books = Book.where("lower(title) LIKE ? AND stock>0", "%#{searchtod(params[:q])}%").
          paginate(:page => params[:page].to_i, :per_page => 10)
    else
      @books = Book.where("lower(title) LIKE ? AND stock>0", "%#{searchtod(params[:q])}%").
          paginate(:page => 1, :per_page => 10)
    end
  end

  def increment
    book_id = params.require(:book).permit(:id)[:id]
    status = Book.increment_book book_id, params[:owner], current_user.school_id
    case status
    when :success
      redirect_to book_url(book_id), flash: { success: "图书入库成功" }
    when :no_book
      redirect_to books_url, flash: { error: "图书入库失败" }
    when :no_user
      redirect_to new_book_url, flash: { error: "捐书人ID不存在" }
    else
      redirect_to profile_url, flash: { error: "未知错误" }
    end
  end

  def out
    book_id = params.require(:book).permit(:id)[:id]
    status = Book.out_book book_id, params[:owner], current_user.school_id
    case status
    when :ok
      redirect_to book_url(book_id), flash: { success: "图书出库成功" }
    when :not_enough
      redirect_to book_url(book_id), flash: { error: "用户积分余额不足" }
    when :no_book
      redirect_to book_url(book_id), flash: { error: "尚无此书库存" }
    when :no_user
      redirect_to profile_url, flash: { error: "用户不存在" }
    else
      redirect_to book_url(book_id), flash: { error: "出库失败" }
    end
  end

  private
    def searchtod(q)
      if q.nil?
        nil
      else
        q.downcase
      end
    end

    def book_params
      params.require(:book).permit(:field, :title, :isbn, :ori_price,
                                   :ratio, :stock, :remark)
    end 
end
