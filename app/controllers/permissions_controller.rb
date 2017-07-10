class PermissionsController < BaseController
  before_action :set_permission, only: [:show, :edit, :update, :destroy]

  # GET /permissions
  def index
    authorize Permission
    @permissions = Permission.all
  end

  # GET /permissions/1
  def show
    authorize Permission
  end

  # GET /permissions/new
  def new
    authorize Permission
    @permission = Permission.new
  end

  # GET /permissions/1/edit
  def edit
    authorize Permission
  end

  # POST /permissions
  def create
    authorize Permission
    @permission = Permission.new(permission_params)

    if @permission.save
      redirect_to @permission, notice: 'Permission was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /permissions/1
  def update
    authorize Permission
    if @permission.update(permission_params)
      redirect_to @permission, notice: 'Permission was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /permissions/1
  def destroy
    authorize Permission
    @permission.destroy
    redirect_to permissions_url, notice: 'Permission was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_permission
      @permission = Permission.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def permission_params
      params.fetch(:permission, {}).permit(:email, :admin)
    end
end
