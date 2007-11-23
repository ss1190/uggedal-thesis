module Typeraker
  class Options
    class << self
      def defaults
        root_dir         = Dir.pwd
        source_dir       = 'src'
        build_dir        = 'tmp'
        distribution_dir = 'dist'
        template_file    = 'template.erb'
        base_file        = 'base'
        vendor_dir       = source_dir + '/vendor'
        graphics_dir     = source_dir + '/graphics'
        spell_dir        = source_dir
        spell_file       = 'dictionary.ispell'

        @defaults ||= {
          :root_dir         => root_dir,
          :source_dir       => source_dir,
          :build_dir        => build_dir,
          :distribution_dir => distribution_dir,
          :template_file    => template_file,
          :base_file        => base_file,
          :vendor_dir       => vendor_dir,
          :graphics_dir     => graphics_dir,
          :spell_dir        => spell_dir,
          :spell_file       => spell_file
        }
      end

      # Fetching options from a config file if present and merges it
      # with the defaults.
      def setup
        preference_file = "#{defaults[:root_dir]}/config.yml"
        preferences = {}
        if File.exists? preference_file
          require 'yaml'
          File.open(preference_file) { |file| preferences = YAML.load(file) }
          preferences = preferences[:typeraker] if preferences[:typeraker]
        end
        base_file_variations(absolute_paths(defaults.merge(preferences)))
      end

      def absolute_paths(options)
        relatives = %w(source_dir
                       build_dir
                       distribution_dir
                       template_file
                       vendor_dir
                       graphics_dir
                       spell_dir)
        relatives.each do |key|
          options[key.to_sym] = File.join(options[:root_dir],
                                          options[key.to_sym])
        end
        options
      end

      def base_file_variations(options)
        options[:base_latex_file]  = options[:base_file] + '.tex'
        options[:base_bibtex_file] = options[:base_file] + '.aux'
        options[:base_dvi_file]    = options[:base_file] + '.dvi'
        options[:base_ps_file]     = options[:base_file] + '.ps'
        options[:base_pdf_file]    = options[:base_file] + '.pdf'
        options
      end
    end
  end
end
