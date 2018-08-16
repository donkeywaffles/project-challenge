class DogsController < ApplicationController
  before_action :set_dog, only: [:show, :edit, :update, :destroy, :like, :unlike]

  # GET /dogs
  # GET /dogs.json
  def index
    if params['sorted']
      @sorted = true
      @dogs = Dog.last_hour.paginate(page: params[:page], per_page: 5)
    else
      @dogs = Dog.all.paginate(page: params[:page], per_page: 5)
    end
  end

  # GET /dogs/1
  # GET /dogs/1.json
  def show
  end

  # GET /dogs/new
  def new
    @dog = Dog.new
  end

  # GET /dogs/1/edit
  def edit
    if current_user.id != @dog.user_id
      redirect_to root_path, :alert => "That's not your dog!"
    end
  end

  # POST /dogs
  # POST /dogs.json
  def create
    @dog = Dog.new(dog_params)
    current_user.dogs << @dog
    respond_to do |format|
      if @dog.save

        if params[:dog][:images].present?
          params[:dog][:images].each do |image|
            @dog.images.attach(image)
          end
        end

        format.html { redirect_to @dog, notice: 'Dog was successfully created.' }
        format.json { render :show, status: :created, location: @dog }
      else
        format.html { render :new }
        format.json { render json: @dog.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dogs/1
  # PATCH/PUT /dogs/1.json
  def update
    respond_to do |format|
      if @dog.update(dog_params)

        if params[:dog][:images].present?
          params[:dog][:images].each do |image|
            @dog.images.attach(image)
          end
        end

        format.html { redirect_to @dog, notice: 'Dog was successfully updated.' }
        format.json { render :show, status: :ok, location: @dog }
      else
        format.html { render :edit }
        format.json { render json: @dog.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dogs/1
  # DELETE /dogs/1.json
  def destroy
    @dog.destroy
    respond_to do |format|
      format.html { redirect_to dogs_url, notice: 'Dog was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  ## GET /dogs/:id/like
  ## Adds Like to Dog
  def like
    Like.find_or_create_by(dog_id: @dog.id, user_id: current_user.id)
    redirect_to @dog
  end

  ## DELETE /dogs/:id/unlike
  ## Deletes Like from Dog
  def unlike
    Like.find_by(dog_id: @dog.id, user_id: current_user.id).delete
    redirect_to @dog
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dog
      @dog = Dog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def dog_params
      params.require(:dog).permit(:name, :description, :images)
    end
end
