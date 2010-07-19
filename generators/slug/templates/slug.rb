class Slug < ActiveRecord::Base
  include SlugBug::Slug

  belongs_to :sluggable, :polymorphic => true

	def to_s
		name
	end
end
