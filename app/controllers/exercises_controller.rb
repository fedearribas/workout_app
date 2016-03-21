class ExercisesController < ApplicationController
  
  before_action :authenticate_user!
  before_action :set_exercise, except: [:index, :new, :create]
  
  def index
    @exercises = current_user.exercises.all
    @hash_grouped = @exercises.group(:workout_date).sum(:duration_in_min)
    @max_date = @exercises.maximum(:workout_date)
    @min_date = @exercises.minimum(:workout_date)
    @min_date.upto(@max_date) do |d|
      if !@hash_grouped.has_key?(d)
        @hash_grouped[d] = 0
      end
    end
    @exer_grouped = Array.new
    @hash_grouped.each do |k, v|
      @exer_grouped << @hash_grouped = {:workout_date => k, :duration_in_min => v }
    end
  end
  
  def show
    
  end
  
  def new
    @exercise = current_user.exercises.new
  end
  
  def create
    @exercise = current_user.exercises.new(exercise_params)
    if @exercise.save
      flash[:success] = "Exercise has been created"
      redirect_to [current_user, @exercise]
    else
      flash[:danger] = "Exercise has not been created"
      render :new
    end
  end
  
  def edit
    
  end
  
  def update
    if @exercise.update(exercise_params)
      flash[:success] = "Exercise has been updated"
      redirect_to [current_user, @exercise]
    else
      flash[:danger] = "Exercise has not been updated"
      render :edit
    end
  end
  
  def destroy
    @exercise.destroy
    flash[:success] = "Exercise has been deleted"
    redirect_to user_exercises_path(current_user)
  end
  
  private
    def exercise_params
      params.require(:exercise).permit(:duration_in_min, :workout, :workout_date, :user_id)
    end
    
    def set_exercise
      @exercise = current_user.exercises.find(params[:id])
    end
  
end
