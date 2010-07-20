class Slug < ActiveRecord::Base
  include SlugBug::Slug

  belongs_to :sluggable, :polymorphic => true

	validates_presence_of :name
	validates_uniqueness_of :name

	def to_s
		name
	end
end
