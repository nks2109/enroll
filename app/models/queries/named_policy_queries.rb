module Queries
  class NamedPolicyQueries

    def self.all_outstanding_shop
      qs = ::Queries::PolicyAggregationPipeline.new
      qs.filter_to_shop.filter_to_active.with_effective_date({"$gt" => Date.new(2015,1,31)}).eliminate_family_duplicates
      enroll_pol_ids = []
      qs.evaluate.each do |r|
        enroll_pol_ids << r['hbx_id']
      end
      enroll_pol_ids
    end

    def quiet_period_enrollment(hbx_id)
      enrollment = HbxEnrollment.by_hbx_id(hbx_id)[0]
      plan_year = enrollment.benefit_group.plan_year
      quiet_period_end_on = plan_year.is_renewing? ? Settings.aca.shop_market.renewal_application.quiet_period_end_on : Settings.aca.shop_market.initial_application.quiet_period_end_on
      quiet_period_start_date = plan_year.open_enrollment_end_on + 1.day
      quiet_period_end_date = plan_year.start_on.prev_month + (quiet_period_end_on - 1).days

      (quiet_period_start_date.beginning_of_day..quiet_period_end_date.end_of_day).cover?(enrollment.submitted_at)
    end

    def self.shop_monthly_enrollments(feins, effective_on)
      qs = ::Queries::ShopMonthlyEnrollments.new(feins, effective_on)
      qs.query_families_with_active_enrollments
        .unwind_enrollments
        .query_active_enrollments
        .sort_enrollments
        .group_enrollments
        .project_enrollment_ids
      qs.evaluate.reject{|r| Queries::NamedPolicyQueries.new.quiet_period_enrollment(r['enrollment_hbx_id'])}.collect{|r| r['enrollment_hbx_id']}
    end


    def self.shop_monthly_terminations(feins, effective_on)
      qs = ::Queries::ShopMonthlyEnrollments.new(feins, effective_on)
      qs.query_families
        .unwind_enrollments
        .query_enrollments
        .sort_enrollments
        .group_enrollments
        .project_enrollment_ids

      qs.evaluate.group_by{|r| r["_id"]["employee_role_id"]}.inject([]) do |termed_enrollments, (subscriber, records)|
        prev_enrollments = records.select{|r| r["_id"]["effective_on"] < effective_on}

        termed_enrollments += prev_enrollments.select do |prev_e|
          records.none? do |r|
            prev_e["_id"]["coverage_kind"] == r["_id"]["coverage_kind"] && r["_id"]["effective_on"] == effective_on 
          end
        end.collect{|record| record['enrollment_hbx_id']}
      end
    end
  end
end
