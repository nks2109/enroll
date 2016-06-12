module Importers
  class ConversionEmployerPlanYearCommon
    NewHireCoveragePolicy = Struct.new(:kind, :offset)

    include ActiveModel::Validations
    include ActiveModel::Model

    HIRE_COVERAGE_POLICIES = {
      "date of hire equal to effective date" => NewHireCoveragePolicy.new("date_of_hire", 0),
      "first of the month following 30 days" => NewHireCoveragePolicy.new("first_of_month", 30),
      "first of the month following 60 days" => NewHireCoveragePolicy.new("first_of_month", 60),
      "first of the month following date of hire" => NewHireCoveragePolicy.new("first_of_month", 0)
    }

    attr_reader :fein, :plan_selection, :carrier

    attr_accessor :action,
      :enrolled_employee_count,
      :new_coverage_policy,
      :default_plan_year_start,
      :most_common_hios_id,
      :single_plan_hios_id,
      :reference_plan_hios_id,
      :coverage_start

    attr_reader :warnings

    include ::Importers::ConversionEmployerCarrierValue

    def initialize(opts = {})
      super(opts)
      @warnings = ActiveModel::Errors.new(self)
    end

    include ValueParsers::OptimisticSsnParser.on(:fein)

    def new_coverage_policy=(val)
      if val.blank?
        @new_coverage_policy = nil
        return val
      end
      @new_coverage_policy = HIRE_COVERAGE_POLICIES[val.strip.downcase]
    end

    def plan_selection=(val)
      @plan_selection = (val.to_s =~ /single plan/i) ? "single_plan" : "single_carrier"
    end
  end
end
