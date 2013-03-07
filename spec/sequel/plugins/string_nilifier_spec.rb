require "spec_helper"

describe Sequel::Plugins::StringNilifier do
  before do
    @db = Sequel::Database.new
    @c = Class.new(Sequel::Model(@db[:test]))
    @c.columns :name, :b
    @c.db_schema[:b][:type] = :blob
    @c.plugin :string_nilifier
    @o = @c.new
  end

  it "should convert empty string to nil for all input strings" do
    @o.name = " \n"
    @o.name.should be_nil
  end

  it "should not convert non-empty string" do
    @o.name = "a \n"
    @o.name.should == "a \n"
  end

  it "should not affect other types" do
    @o.name = 1
    @o.name.should == 1
    @o.name = Date.today
    @o.name.should == Date.today
  end

  it "should not nilify strings for blob arguments" do
    v = Sequel.blob(" \n")
    @o.name = v
    @o.name.should equal(v)
  end

  it "should not nilify strings for blob columns" do
    @o.b = " \n"
    @o.b.should be_a_kind_of(Sequel::SQL::Blob)
    @o.b.should == Sequel.blob(" \n")
  end

  it "should allow skipping of columns using Model.skip_string_nilifying" do
    @c.skip_string_nilifying :name
    v = " \n"
    @o.name = v
    @o.name.should equal(v)
  end

  it "should work correctly in subclasses" do
    o = Class.new(@c).new
    o.name = " \n"
    o.name.should be_nil
    o.b = " \n"
    o.b.should be_a_kind_of(Sequel::SQL::Blob)
    o.b.should == Sequel.blob(" \n")
  end

  it "should work correctly for dataset changes" do
    c = Class.new(Sequel::Model(@db[:test]))
    c.plugin :string_nilifier
    def @db.schema(*) [[:name, {}], [:b, {:type=>:blob}]] end
    c.set_dataset(@db[:test2])
    o = c.new
    o.name = " \n"
    o.name.should be_nil
    o.b = " \n"
    o.b.should be_a_kind_of(Sequel::SQL::Blob)
    o.b.should == Sequel.blob(" \n")
  end
end
