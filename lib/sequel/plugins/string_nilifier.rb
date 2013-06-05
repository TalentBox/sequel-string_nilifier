module Sequel
  module Plugins
    module StringNilifier
      def self.apply(model)
        model.plugin(:input_transformer, :string_nilifier) do |v|
          if v.is_a?(String) && !v.is_a?(SQL::Blob) && v.strip.empty?
            nil
          else
            v
          end
        end
      end

      # Set blob columns as skipping nilifying when plugin is loaded.
      def self.configure(model)
        model.instance_eval{set_skipped_string_nilifying_columns if @dataset}
      end

      module ClassMethods
        Plugins.after_set_dataset(self, :set_skipped_string_nilifying_columns)

        # Skip nilifying for the given columns.
        def skip_string_nilifying(*columns)
          skip_input_transformer(:string_nilifier, *columns)
        end

        # Return true if the column should not have values stripped.
        def skip_string_nilifying?(column)
          skip_input_transformer?(:string_nilifier, column)
        end

        private

        # Automatically skip nilifying of blob columns
        def set_skipped_string_nilifying_columns
          if @db_schema
            blob_columns = @db_schema.map{|k,v| k if v[:type] == :blob}.compact
            skip_string_nilifying(*blob_columns)
          end
        end
      end
    end
  end
end

