class Exercise < ActiveRecord::Base
  belongs_to :user
  
  validates :duration_in_min, presence: true
  validates :duration_in_min, numericality: {only_integer: true}
  validates :workout, presence: true
  validates :workout_date, presence: true
  validates :user_id, presence: true
  
  default_scope { where('workout_Date > ?', 7.days.ago).order(workout_date: :desc) }
  
  def self.all_grouped_for_graph
    if !all.empty?
      @hash_grouped = all.group(:workout_date).sum(:duration_in_min)
      @max_date = all.maximum(:workout_date)
      @min_date = all.minimum(:workout_date)
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
    return @exer_grouped
  end
  
end
