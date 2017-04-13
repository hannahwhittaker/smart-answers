require_relative "../../test_helper"

module SmartAnswer
  module Calculators
    class PayLeaveForParentsCalculatorTest < ActiveSupport::TestCase
      setup do
        @due_date = Date.parse('2015-1-1')
        @calculator = PayLeaveForParentsCalculator.new
        @calculator.due_date = @due_date
      end

      test "continuity_start_date" do
        expected = Date.parse('2014-3-29')
        assert_equal expected, @calculator.continuity_start_date
      end

      test "continuity_end_date" do
        expected = Date.parse('2014-9-14')
        assert_equal expected, @calculator.continuity_end_date
      end

      test "lower_earnings_start_date" do
        expected = Date.parse("2014-7-26")
        assert_equal expected, @calculator.lower_earnings_start_date
      end

      test "lower_earnings_end_date" do
        expected = Date.parse("2014-9-20")
        assert_equal expected, @calculator.lower_earnings_end_date
      end

      test "earnings_employment_start_date" do
        expected = Date.parse("2013-9-22")
        assert_equal expected, @calculator.earnings_employment_start_date
      end

      test "earnings_employment_end_date" do
        expected = Date.parse("2014-12-27")
        assert_equal expected, @calculator.earnings_employment_end_date
      end

      test "start_of_maternity_allowance" do
        @calculator.due_date = @due_date
        expected = Date.parse("2014-10-12")
        assert_equal expected, @calculator.start_of_maternity_allowance
      end

      test "earliest_start_mat_leave" do
        @calculator.due_date = @due_date
        expected = Date.parse("2014-10-12")
        assert_equal expected, @calculator.earliest_start_mat_leave
      end

      test "maternity_leave_notice_date" do
        @calculator.due_date = @due_date
        expected = Date.parse("2014-9-20")
        assert_equal expected, @calculator.maternity_leave_notice_date
      end

      test "paternity_leave_notice_date" do
        @calculator.due_date = @due_date
        expected = Date.parse("2014-9-20")
        assert_equal expected, @calculator.paternity_leave_notice_date
      end

      context "due date in 2013-2014 range" do
        setup do
          @date = Date.parse("2014-1-1")
          @calculator = PayLeaveForParentsCalculator.new
          @calculator.due_date = @date
        end

        should "be in 2013-2014 range" do
          assert_equal true, @calculator.in_2013_2014_fin_year?(@date)
        end

        should "return £ 109 for lower_earnings_amount" do
          assert_equal 109, @calculator.lower_earnings_amount
        end
      end

      context "due date in 2014-2015 range" do
        setup do
          @date = Date.parse("2015-1-1")
          @calculator = PayLeaveForParentsCalculator.new
          @calculator.due_date = @date
        end

        should "be in 2013-2014 range" do
          assert_equal true, @calculator.in_2014_2015_fin_year?(@date)
        end

        should "return £ 111 for lower_earnings_amount" do
          assert_equal 111, @calculator.lower_earnings_amount
        end
      end

      context "due date in 2015-2016 range" do
        setup do
          @date = Date.parse("2016-1-1")
          @calculator = PayLeaveForParentsCalculator.new
          @calculator.due_date = @date
        end

        should "be in 2015-2016 range" do
          assert_equal true, @calculator.in_2015_2016_fin_year?(@date)
        end

        should "return £ 112 for lower_earnings_amount" do
          assert_equal 112, @calculator.lower_earnings_amount
        end
      end

      context "due date in 2016-2017 range" do
        setup do
          @date = Date.parse("2017-01-01")
          @calculator = PayLeaveForParentsCalculator.new
          @calculator.due_date = @date
        end

        should "be in 2016-2017 financial year" do
          assert_equal true, @calculator.in_2016_2017_fin_year?(@date)
        end

        should "return £112 for lower_earnings_amount" do
          assert_equal 112, @calculator.lower_earnings_amount
        end
      end

      context "due date in 2017-2018 range" do
        setup do
          @date = Date.parse("2018-01-01")
          @calculator = PayLeaveForParentsCalculator.new
          @calculator.due_date = @date
        end

        should "be in 2017-2018 financial year" do
          assert_equal true, @calculator.in_2017_2018_fin_year?(@date)
        end

        should "return £113 for lower_earnings_amount" do
          assert_equal 113, @calculator.lower_earnings_amount
        end
      end

      context "due date outside all ranges" do
        setup do
          @date = Date.parse("2022-01-01")
          @calculator = PayLeaveForParentsCalculator.new
          @calculator.due_date = @date
        end

        should "return the latest_pay_leave known lower_earnings_amount" do
          assert_equal 113, @calculator.lower_earnings_amount
        end
      end
    end
  end
end
