
# safe_callbacks

Tired of writing the following (or forgetting) ?

    class User
      before_validation :denormalize_a_bool

    private

      def denormalize_a_bool
        self.a_bool = something_is_true?
        true
      end
    end

Without that last 'true', the callback chain will be halted.

## Usage

    gem 'safe_callbacks'

and then:

    class MyClass
      include MongoMapper::Document
      include SafeCallbacks
    end

or:

    SafeCallbacks.extend_mongo_mapper!

for all models
