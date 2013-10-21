require 'spec_helper'

module RSpec
  module Mocks
    describe "at_most" do
      let(:test_double) { double }

      it "passes when at_most(n) is called exactly n times" do
        expect(test_double).to receive(:do_something).at_most(2).times
        test_double.do_something
        test_double.do_something
        verify test_double
      end

      it "passes when at_most(n) is called less than n times" do
        expect(test_double).to receive(:do_something).at_most(2).times
        test_double.do_something
        verify test_double
      end

      it "passes when at_most(n) is never called" do
        expect(test_double).to receive(:do_something).at_most(2).times
        verify test_double
      end

      it "passes when at_most(:once) is called once" do
        expect(test_double).to receive(:do_something).at_most(:once)
        test_double.do_something
        verify test_double
      end

      it "passes when at_most(:once) is never called" do
        expect(test_double).to receive(:do_something).at_most(:once)
        verify test_double
      end

      it "passes when at_most(:twice) is called once" do
        expect(test_double).to receive(:do_something).at_most(:twice)
        test_double.do_something
        verify test_double
      end

      it "passes when at_most(:twice) is called twice" do
        expect(test_double).to receive(:do_something).at_most(:twice)
        test_double.do_something
        test_double.do_something
        verify test_double
      end

      it "passes when at_most(:twice) is never called" do
        expect(test_double).to receive(:do_something).at_most(:twice)
        verify test_double
      end

      it "returns the value given by a block when at_most(:once) method is called" do
        expect(test_double).to receive(:to_s).at_most(:once) { "testing" }
        expect(test_double.to_s).to eq "testing"
        verify test_double
      end

      it "fails fast when at_most(n) times method is called n plus 1 times" do
        expect(test_double).to receive(:do_something).at_most(2).times
        test_double.do_something
        test_double.do_something
        expect {
          test_double.do_something
        }.to raise_error(/expected: at most 2 times.*received: 3 times/m)
      end

      it "fails fast when at_most(:once) and is called twice" do
        expect(test_double).to receive(:do_something).at_most(:once)
        test_double.do_something
        expect {
          test_double.do_something
        }.to raise_error(/expected: at most 1 time.*received: 2 times/m)
      end

      it "fails fast when at_most(:twice) and is called three times" do
        expect(test_double).to receive(:do_something).at_most(:twice)
        test_double.do_something
        test_double.do_something
        expect {
          test_double.do_something
        }.to raise_error(/expected: at most 2 times.*received: 3 times/m)
      end
    end
  end
end
