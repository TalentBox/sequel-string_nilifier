module Sequel
  module Plugins
    module StringNilifier
      # Set blob columns as skipping nilifying when plugin is loaded.
      def self.configure(model)
        model.instance_variable_set(:@skipped_string_nilifier_columns, [])
        model.send(:set_skipped_string_nilifying_columns)
      end

      module ClassMethods
        # Copy skipped nilifying columns from superclass into subclass.
        def inherited(subclass)
          subclass.instance_variable_set(:@skipped_string_nilifier_columns, @skipped_string_nilifier_columns.dup)
          super
        end

        # Set blob columns as skipping nilifying when plugin is loaded.
        def set_dataset(*)
          res = super
          set_skipped_string_nilifying_columns
          res
        end

        # Skip nilifying for the given columns.
        def skip_string_nilifying(*columns)
          @skipped_string_nilifier_columns.concat(columns).uniq!
        end

        # Return true if the column should not have values stripped.
        def skip_string_nilifying?(column)
          @skipped_string_nilifier_columns.include?(column)
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

      module InstanceMethods
        # Strip value if it is a non-blob string and the model hasn't been set
        # to skip nilifying for the column, before attempting to assign
        # it to the model's values.
        def nil_string?(k,str)
          str.is_a?(String) && !str.is_a?(SQL::Blob) && str.strip.empty? && !model.skip_string_nilifying?(k)
        end

        def []=(k, v)
          v = nil if nil_string? k, v
          super(k, v)
        end
      end
    end
  end
end

