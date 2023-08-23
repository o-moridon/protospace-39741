class PrototypesController < ApplicationController
  before_action :set_prototype, only: [:edit, :show, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :move_to_index, only: [:edit]

  def index
    @prototypes = Prototype.includes(:user)
  end

  def new
    @prototype = Prototype.new
  end

  def edit
  end

  def create
    @prototype = Prototype.new(prototype_params)
    if @prototype.save
      redirect_to '/'
    else
      render :new
      @prototype = Prototype.new
    end
  end

  def show
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user)
  end

  def update
    if @prototype.update(prototype_params)
      redirect_to prototype_path(prototype.id)
    else
      redirect_to action: :edit
    end
  end

  def destroy
    prototype.destroy
    redirect_to root_path
  end

  private 

  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
  end

  def set_prototype
    @prototype = Prototype.find(params[:id])
  end
  
  def move_to_index
    prototype = Prototype.find(params[:id])
    unless current_user.id == prototype.user_id
      redirect_to action: :index
    end
  end

end
