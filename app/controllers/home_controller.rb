class HomeController < BaseController

  def index
  end

  def users
    authorize User
    @users = User.all
  end

end