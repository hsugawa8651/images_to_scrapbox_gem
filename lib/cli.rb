require "images_to_scrapbox"
require "thor"

module ImagesToScrapbox

  class CLI < Thor

    no_commands do
      def helper_add_paths(*globs)
        if globs.length > 0
          globs.each do |glob|
            ImagesToScrapbox::Converter.add(glob)
          end
        else
          while glob=$stdin.gets
            ImagesToScrapbox::Converter.add(glob.chomp)
          end
        end
      end
    end

    class_option :help, :type => :boolean, :aliases => '-h', :desc => 'help message.'
    default_task :help

    class_option :unique, :type => :boolean, :aliases => '-u',
      :default => true, :desc => 'unique files'
    class_option :sort, :type => :string, :aliases => '-s',
      :default => "numbers", :desc => 'sort files by `none`, `names`, or `numbers`'
    class_option :ascending, :type => :boolean, :aliases => '-a',
      :default => true, :desc => "sort in ascending order, or descending"

    method_option :image, type: :boolean, aliases: '-i',
      :default => true, desc: 'register images'
    method_option :larger, type: :boolean, aliases: '-l',
      :default => false, desc: 'larger image'
    method_option :timestamp, :type => :string, :aliases => '-t',
      :default => "mtime", :desc => "file timestamp: `atime`, `ctime`, or `mtime`"
    method_option :toc, type: :boolean, aliases: '-t',
      :default => true, desc: 'creates table-of-contents'
    method_option :whole, type: :boolean, aliases: '-w',
      :default => true, desc: 'creates a page occipied by whole images'

    desc 'convert FILES [options]', 'Convert images files to scrapbox-json'
    def convert(*globs)
      helper_add_paths(globs)
      ImagesToScrapbox::Converter.perform(true, options)
    end

    desc 'list FILES [options]', 'List images files to be processed'
    def list(*globs)
      helper_add_paths(globs)
      ImagesToScrapbox::Converter.perform(FALSE, options)
    end

    desc 'version', 'version'
    def version
      p ImagesToScrapbox::VERSION
    end


  end
end
