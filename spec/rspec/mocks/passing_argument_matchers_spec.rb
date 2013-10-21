require 'spec_helper'

module RSpec
  module Mocks
    describe "Passing argument matchers" do
      let(:test_double) { double }

      after(:each) do
        verify test_double
      end

      context "handling argument matchers" do
        it "accepts true as boolean()" do
          expect(test_double).to receive(:random_call).with(boolean())
          test_double.random_call(true)
        end

        it "accepts false as boolean()" do
          expect(test_double).to receive(:random_call).with(boolean())
          test_double.random_call(false)
        end

        it "accepts fixnum as kind_of(Numeric)" do
          expect(test_double).to receive(:random_call).with(kind_of(Numeric))
          test_double.random_call(1)
        end

        it "accepts float as an_instance_of(Numeric)" do
          expect(test_double).to receive(:random_call).with(kind_of(Numeric))
          test_double.random_call(1.5)
        end

        it "accepts fixnum as instance_of(Fixnum)" do
          expect(test_double).to receive(:random_call).with(instance_of(Fixnum))
          test_double.random_call(1)
        end

        it "does NOT accept fixnum as instance_of(Numeric)" do
          expect(test_double).to_not receive(:random_call).with(instance_of(Numeric))
          test_double.random_call(1)
        end

        it "does NOT accept float as instance_of(Numeric)" do
          expect(test_double).to_not receive(:random_call).with(instance_of(Numeric))
          test_double.random_call(1.5)
        end

        it "accepts string as anything()" do
          expect(test_double).to receive(:random_call).with("a", anything(), "c")
          test_double.random_call("a", "whatever", "c")
        end

        it "matches duck type with one method" do
          expect(test_double).to receive(:random_call).with(duck_type(:length))
          test_double.random_call([])
        end

        it "matches duck type with two methods" do
          expect(test_double).to receive(:random_call).with(duck_type(:abs, :div))
          test_double.random_call(1)
        end

        it "matches no args against any_args()" do
          expect(test_double).to receive(:random_call).with(any_args)
          test_double.random_call()
        end

        it "matches one arg against any_args()" do
          expect(test_double).to receive(:random_call).with(any_args)
          test_double.random_call("a string")
        end

        it "matches no args against no_args()" do
          expect(test_double).to receive(:random_call).with(no_args)
          test_double.random_call()
        end

        it "matches hash with hash_including same hash" do
          expect(test_double).to receive(:random_call).with(hash_including(:a => 1))
          test_double.random_call(:a => 1)
        end

        it "matches array with array_including same array" do
          expect(test_double).to receive(:random_call).with(array_including(1,2))
          test_double.random_call([1,2])
        end
      end

      context "handling non-matcher arguments" do
        it "matches non special symbol (can be removed when deprecated symbols are removed)" do
          expect(test_double).to receive(:random_call).with(:some_symbol)
          test_double.random_call(:some_symbol)
        end

        it "matches string against regexp" do
          expect(test_double).to receive(:random_call).with(/bcd/)
          test_double.random_call("abcde")
        end

        it "matches regexp against regexp" do
          expect(test_double).to receive(:random_call).with(/bcd/)
          test_double.random_call(/bcd/)
        end

        it "matches against a hash submitted and received by value" do
          expect(test_double).to receive(:random_call).with(:a => "a", :b => "b")
          test_double.random_call(:a => "a", :b => "b")
        end

        it "matches against a hash submitted by reference and received by value" do
          opts = {:a => "a", :b => "b"}
          expect(test_double).to receive(:random_call).with(opts)
          test_double.random_call(:a => "a", :b => "b")
        end

        it "matches against a hash submitted by value and received by reference" do
          opts = {:a => "a", :b => "b"}
          expect(test_double).to receive(:random_call).with(:a => "a", :b => "b")
          test_double.random_call(opts)
        end
      end
    end
  end
end
