require 'activerecord'

module VentureHacks
	module SlugBug
		def self.included(base)
			base.extend ClassMethods
		end

		module ClassMethods
			def slug_bug(slug_source = :title, options = {})
				if slug_source.is_a? Hash
					write_inheritable_attribute :slug_source, :title
					options = slug_source
				else
					write_inheritable_attribute :slug_source, slug_source.to_sym
				end
				class_inheritable_reader :slug_source

				has_one :slug, {:as => :sluggable, :dependent => :destroy}.merge(options)
				include VentureHacks::SlugBug::InstanceMethods
				extend VentureHacks::SlugBug::SingletonMethods

				before_create :create_slug_before_create
			end
		end

		# This module contains class methods
		module SingletonMethods
			# Helper class method to lookup object from slug
			def find_by_slug(slug)
				slug = Slug.find_by_name(slug)
				slug.sluggable
			end
		end

		# This module contains instance methods
		module InstanceMethods
			def create_slug_before_create
				if slug_source && respond_to?(slug_source)
					url_slug = send(slug_source).parameterize

					idx = 0
					done_creating_slug = false
					begin
						slug_name = "#{url_slug}#{idx > 0 ? '-'+idx.to_s : ''}"
						unless Slug.exists?(:name => slug_name)
							build_slug :name => slug_name
							done_creating_slug = true
						end
						idx = idx + 1
					end while !done_creating_slug
				end
			end

			def slug_url(only_path=false)
				domain = VentureHacks::SlugBugConfig.domain
				url = "#{domain && !only_path ? domain : ''}/#{slug.name}"
			end
		end
	end
end

ActiveRecord::Base.send(:include, VentureHacks::SlugBug)