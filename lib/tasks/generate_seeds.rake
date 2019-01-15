task generate_seeds: :environment do
  class ApplicationRecord < ActiveRecord::Base
    def self.generate_output_seed!
      file_name = Rails.root.join('db', 'seeds', "#{self.name.underscore}s_seed.rb")
      File.open(file_name, 'wb') do |file|
        self.order(:id).each do |model|
          file.puts model.as_seed_code
        end
      end
    end

    def as_seed_code
      "#{self.class}.find_or_create_by(#{seed_attrs})"
    end

    def seed_attrs
      self.attributes.map do |attr, value|
        next if ['created_at', 'updated_at', 'id'].include?(attr)
        next if value.nil?
        "#{attr}: #{parse_value(value)}"
      end.compact.join(', ')
    end

    def parse_value(value)
      if String == value.class
        new_value = value.gsub('"', "\\\"")
        "\"#{new_value}\""
      elsif ActiveSupport::TimeWithZone == value.class
        "DateTime.parse(\"#{value}\")"
      else
        "#{value}"
      end
    end
  end
  model_classes = ActiveRecord::Base.connection.tables.map do |model|
    model.capitalize.singularize.camelize
  end - ['SchemaMigration', "ArInternalMetadatum"]

  model_classes.each do |klass|
    puts "Seeding #{klass}s"
    klass.constantize.generate_output_seed!
  end
end
