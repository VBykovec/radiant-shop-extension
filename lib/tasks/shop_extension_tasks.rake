namespace :radiant do
  namespace :extensions do
    namespace :shop do
      
      desc "Runs the migration of the Shop extension"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        
        # Migrate required extensions first
        ['Settings','Images','Forms','Users','DragOrder'].each do |name|
          extension = "#{name}Extension".pluralize.classify.constantize
          extension.migrator.migrate
        end
        
        version = ENV["VERSION"] ? ENV["VERSION"].to_i : nil
        ShopExtension.migrator.migrate(version)
        
        Rake::Task['db:schema:dump'].invoke
      end
      
      desc "Runs the migration of the Shop extension"
      task :seed => :environment do
        load "#{ShopExtension.root}/db/seed.rb"
      end
      
      desc "Copies public assets of the Shop to the instance public/ directory."
      task :update => :environment do
        is_svn_or_dir = proc {|path| path =~ /\.svn/ || File.directory?(path) }
        puts "Copying assets from ShopExtension"
        Dir[ShopExtension.root + "/public/**/*"].reject(&is_svn_or_dir).each do |file|
          path = file.sub(ShopExtension.root, '')
          directory = File.dirname(path)
          mkdir_p RAILS_ROOT + directory, :verbose => false
          cp file, RAILS_ROOT + path, :verbose => false
        end
        unless ShopExtension.root.starts_with? RAILS_ROOT # don't need to copy vendored tasks
          puts "Copying rake tasks from ShopExtension"
          local_tasks_path = File.join(RAILS_ROOT, %w(lib tasks))
          mkdir_p local_tasks_path, :verbose => false
          Dir[File.join ShopExtension.root, %w(lib tasks *.rake)].each do |file|
            cp file, local_tasks_path, :verbose => false
          end
        end
      end  
      
      desc "Syncs all available translations for this ext to the English ext master"
      task :sync => :environment do
        # The main translation root, basically where English is kept
        language_root = ShopExtension.root + "/config/locales"
        words = TranslationSupport.get_translation_keys(language_root)
        
        Dir["#{language_root}/*.yml"].each do |filename|
          next if filename.match('_available_tags')
          basename = File.basename(filename, '.yml')
          puts "Syncing #{basename}"
          (comments, other) = TranslationSupport.read_file(filename, basename)
          words.each { |k,v| other[k] ||= words[k] }  # Initializing hash variable as empty if it does not exist
          other.delete_if { |k,v| !words[k] }         # Remove if not defined in en.yml
          TranslationSupport.write_file(filename, basename, comments, other)
        end
      end
    end
  end
end
