require "sequel"
require "sequel/string_nilifier"

class << Sequel::Model
  attr_writer :db_schema
  alias orig_columns columns
  def columns(*cols)
    return super if cols.empty?
    define_method(:columns){cols}
    @dataset.send(:columns=, cols) if @dataset
    def_column_accessor(*cols)
    @columns = cols
    @db_schema = {}
    cols.each{|c| @db_schema[c] = {}}
  end
end

Sequel::Model.use_transactions = false
if Sequel.respond_to? :cache_anonymous_models=
  Sequel.cache_anonymous_models = false
end

db = Sequel.mock(:fetch=>{:id => 1, :x => 1}, :numrows=>1, :autoid=>proc{|sql| 10})
def db.schema(*) [[:id, {:primary_key=>true}]] end
def db.reset() sqls end
def db.supports_schema_parsing?() true end
Sequel::Model.db = MODEL_DB = db
