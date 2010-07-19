class SlugGenerator < Rails::Generator::Base
   def manifest
     record do |m|
       m.directory 'app/models'
       m.file 'slug.rb', 'app/models/slug.rb'
       m.migration_template "create_slugs.rb", "db/migrate"
     end
   end
   # ick what a hack.
   def file_name
     "create_slugs"
   end
 end
