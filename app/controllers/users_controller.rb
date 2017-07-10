class UsersController < BaseController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  def index
    authorize User
    @users = User.all
  end

  # GET /users/1
  def show
    authorize User
  end

  # GET /users/new
  def new
    authorize User
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    authorize User
  end

  # POST /users
  def create
    authorize User
    @user = User.new(user_params)

    if @user.save
      redirect_to @user, notice: 'User was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /users/1
  def update
    authorize User
    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /users/1
  def destroy
    authorize User
    @user.destroy
    redirect_to users_url, notice: 'User was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.fetch(:user, {}).permit(:email, :admin)
    end
end
