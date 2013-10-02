Feature: Using an object double

  `object_double` can be used to create a double from an existing "template"
  object, from which it verifies that any stubbed methods on the double also
  exist on the template. This is useful for objects that are readily
  constructable, but may have far-reaching side-effects such as talking to a
  database or external API. In this case, using a double rather than the real
  thing allows you to focus on the communication patterns of the object's
  interface without having to worry about accidentally causing side-effects.

  It can also be used to replace specific constant values, as shown below. This
  is for niche situations, such as when dealing with singleton objects.

  In constrast to instance and class doubles, `object_double` will always
  behave the same whether or not supporting files are loaded. By definition, it
  is created using an existing object, so it must have already been loaded!

  Scenario: doubling an existing object
    Given a file named "spec/user_spec.rb" with:
      """ruby
      class User
        # Don't want to accidentally trigger this!
        def save; sleep 100; end
      end

      def save_user(user)
        "saved!" if user.save
      end

      describe '#save_user' do
        it 'renders message on success' do
          user = object_double(User.new, save: true)
          expect(save_user(user)).to eq("saved!")
        end
      end
      """
    When I run `rspec spec/user_spec.rb`
    Then the examples should all pass


  Scenario: doubling a constant object
    Given a file named "spec/token_spec.rb" with:
      """ruby
      TOKEN = "abc123"

      def valid_token?
        TOKEN.length <= 6
      end

      describe 'valid_token?' do
        it 'is invalid when TOKEN is too long' do
          object_double("TOKEN", length: 7).as_stubbed_const
          expect(valid_token?).to eq(false)
        end
      end
      """
    When I run `rspec spec/token_spec.rb`
    Then the examples should all pass
