require 'spec_helper'
require 'mongo_mapper'

describe SafeCallbacks do
  before do
    @class = Class.new do
      include MongoMapper::Document
      include SafeCallbacks
    end
  end

  it "should create a safe_* method name which returns true" do
    @class.class_eval do
      before_validation :foo

      def foo
        false
      end
    end

    obj = @class.new
    obj.send(:safe_foo).should == true
  end

  it "should use the correct method name" do
    @class.class_eval do
      before_validation :bar

      def bar
        false
      end
    end

    obj = @class.new
    obj.send(:safe_bar).should == true
  end

  it "should execute the code in the callback" do
    executed = false

    @class.class_eval do
      before_validation :bar

      define_method :bar do
        executed = true
      end
    end

    obj = @class.new
    obj.valid?

    executed.should == true
  end

  it "should not halt the execution chain if a value returned is false" do
    executed = false

    @class.class_eval do
      before_validation :first
      before_validation :second

      def first
        false
      end

      define_method :second do
        executed = true
      end
    end

    obj = @class.new
    obj.valid?

    executed.should == true
  end

  it "should create the safe method as private" do
    @class.class_eval do
      before_validation :foo
    end

    @class.private_instance_methods.should include(:safe_foo)
  end

  it "should be able to call the old validation method with unsafe_" do
    one_executed = false
    two_executed = false

    @class.class_eval do
      unsafe_before_validation :one
      unsafe_before_validation :two

      define_method :one do
        one_executed = true
        false
      end

      define_method :two do
        two_executed = true
        false
      end
    end

    obj = @class.new
    obj.valid?
    one_executed.should == true
    two_executed.should == false
  end

  it "should not define new methods when unsafe_* is called" do
    @class.class_eval do
      unsafe_before_validation :foo
    end

    obj = @class.new
    obj.should_not respond_to(:safe_foo)
  end

  it "should pass the options onto the validation methods" do
    executed = false

    @class.class_eval do
      before_validation :foo, :on => :update

      define_method :foo do
        executed = true
      end
    end

    obj = @class.new
    obj.valid?
    executed.should == false
  end

  it "should work for all filter methods" do
    SafeCallbacks::CALLBACK_METHODS.each do |callback_method|
      @class.should respond_to("unsafe_#{callback_method}")
    end
  end

  it "should be able to extend Mongomapper::Documents automatically" do
    SafeCallbacks.extend_mongo_mapper!

    klass = Class.new do
      include MongoMapper::Document
    end

    klass.should respond_to("unsafe_before_save")
  end
end