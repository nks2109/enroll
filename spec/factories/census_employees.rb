FactoryGirl.define do
  factory :census_employee do
    first_name "Eddie"
    sequence(:last_name) {|n| "Vedder#{n}" }
    dob "1964-10-23".to_date
    gender "male"
    employee_relationship "self"
    hired_on "2015-04-01".to_date
    sequence(:ssn) { |n| 222222220 + n }
    is_business_owner  false
    association :address, strategy: :build
    association :email, strategy: :build
    association :employer_profile, strategy: :build

    before(:create) do |instance|
      FactoryGirl.create(:application_event_kind,:out_of_pocket_notice)
    end

    transient do
      benefit_group { build(:benefit_group) }
      renewal_benefit_group { build(:benefit_group) }
    end

    trait :owner do
      is_business_owner  true
    end

    trait :termination_details do
      # aasm_state "employment_terminated"
      employment_terminated_on {TimeKeeper.date_of_record.last_month}
      coverage_terminated_on {TimeKeeper.date_of_record.last_month.end_of_month}
    end

    trait :with_enrolled_census_employee do
      aasm_state :eligible
    end

    trait :general_agency do
      transient do
        general_agency_traits []
        general_agency_attributes { {} }
      end

      before :create do |organization, evaluator|
        organization.office_locations.push FactoryGirl.build :office_location, :primary
      end

      after :create do |organization, evaluator|
        FactoryGirl.create :general_agency_profile, *Array.wrap(evaluator.general_agency_traits) + [:with_staff], evaluator.general_agency_attributes.merge(organization: organization)
      end
    end

    factory :census_employee_with_active_assignment do
      after(:create) do |census_employee, evaluator|
        create(:benefit_group_assignment, benefit_group: evaluator.benefit_group, census_employee: census_employee) 
      end
    end

    factory :census_employee_with_active_and_renewal_assignment do
      after(:create) do |census_employee, evaluator|
        create(:census_employee_with_active_assignment)
        create(:benefit_group_assignment, benefit_group: evaluator.renewal_benefit_group, census_employee: census_employee, is_active: false)
      end
    end
  end
end
