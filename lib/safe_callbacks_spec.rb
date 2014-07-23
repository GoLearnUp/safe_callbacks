
module SafeCallbacks
  CALLBACK_METHODS = [
    :after_create,
    :after_destroy,
    :after_save,
    :after_validation,
    :before_create,
    :before_destroy,
    :before_save,
    :before_update,
    :before_validation,
  ]

  class << self
    def extended(mod)
      SafeCallbacks::CALLBACK_METHODS.each do |callback_method_name|
        unsafe_callback_method_name = :"unsafe_#{callback_method_name}"

        if mod.respond_to?(callback_method_name) && !mod.respond_to?(unsafe_callback_method_name)
          (class << mod; self; end).instance_eval do
            alias_method unsafe_callback_method_name, callback_method_name
          end
        end
      end

      mod.extend ClassMethods
    end

    def included(mod)
      mod.extend self
    end
  end

  module ClassMethods
    CALLBACK_METHODS.each do |callback_method_name|
      define_method callback_method_name do |method_name, options={}|
        safe_method_name = :"safe_#{method_name}"

        super safe_method_name, options

        define_method safe_method_name do
          self.send(method_name)
          true
        end

        private safe_method_name
      end
    end
  end
end
