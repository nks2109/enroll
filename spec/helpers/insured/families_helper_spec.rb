require "rails_helper"

RSpec.describe Insured::FamiliesHelper, :type => :helper do
  describe "#generate_options_for_effective_on_kinds" do
    it "it should return blank array" do
      options = helper.generate_options_for_effective_on_kinds([], TimeKeeper.date_of_record)
      expect(options).to eq []
    end

    it "it should return options" do
      options = helper.generate_options_for_effective_on_kinds(['date_of_event', 'fixed_first_of_next_month'], TimeKeeper.date_of_record)
      date = TimeKeeper.date_of_record
      expect(options).to eq [[date.to_s, 'date_of_event'], [(date.end_of_month+1.day).to_s, 'fixed_first_of_next_month']]
    end
  end

  describe "#admin_permitted_sep_effective_dates" do
    let(:family) { FactoryGirl.build(:family, :with_primary_family_member) }

    it "it should return an array of effective dates" do
      sep = FactoryGirl.build(:special_enrollment_period, :with_admin_permitted_sep_effective_dates)
      qle = FactoryGirl.build(:qualifying_life_event_kind, _id: sep.qualifying_life_event_kind_id )
      family.special_enrollment_periods << sep
      person = family.person
      allow(person).to receive(:primary_family).and_return(family)
      allow(family).to receive(:special_enrollment_periods).and_return(family.special_enrollment_periods)
      expect(helper.admin_permitted_sep_effective_dates(person, qle)).to eq [sep.option1_date, sep.option2_date, sep.option3_date]
    end

    it "it should return a blank array" do
      sep = FactoryGirl.build(:special_enrollment_period, :with_admin_permitted_sep_effective_dates)
      qle = FactoryGirl.build(:qualifying_life_event_kind )
      family.special_enrollment_periods << sep
      person = family.person
      allow(person).to receive(:primary_family).and_return(family)
      allow(family).to receive(:special_enrollment_periods).and_return(family.special_enrollment_periods)
      expect(helper.admin_permitted_sep_effective_dates(person, qle)).to eq []
    end

  end

  describe "#show_employer_panel" do
    let(:person) {FactoryGirl.build(:person)}
    let(:employee_role) {FactoryGirl.build(:employee_role)}
    let(:hbx_enrollment) {HbxEnrollment.new}
    let(:hbx_enrollments) {double}

    it "should return false without person" do
      expect(helper.show_employer_panel?(nil, [])).to eq false
    end

    it "should return false with person who has no active employee_role" do
      allow(person).to receive(:has_active_employee_role?).and_return false
      expect(helper.show_employer_panel?(person, [])).to eq false
    end

    context "with person who has active_employee_roles" do
      before :each do
        allow(person).to receive(:has_active_employee_role?).and_return true
        allow(person).to receive(:active_employee_roles).and_return [employee_role]
      end

      it "should return true without hbx_enrollments" do
        expect(helper.show_employer_panel?(person, [])).to eq true
      end

      it "should return true with hbx_enrollments which has no shop_market" do
        allow(hbx_enrollments).to receive(:shop_market).and_return []
        expect(helper.show_employer_panel?(person, hbx_enrollments)).to eq true
      end

      it "should return false with hbx_enrollments which employee_role is include person's employee_role" do
        allow(hbx_enrollments).to receive(:shop_market).and_return hbx_enrollments
        allow(hbx_enrollments).to receive(:entries).and_return [hbx_enrollment]
        allow(hbx_enrollment).to receive(:employee_role_id).and_return employee_role.id
        expect(helper.show_employer_panel?(person, hbx_enrollments)).to eq false
      end

      it "should return true with hbx_enrollments which employee_role is not include person's employee_role" do
        allow(hbx_enrollments).to receive(:shop_market).and_return hbx_enrollments
        allow(hbx_enrollments).to receive(:entries).and_return [hbx_enrollment]
        allow(hbx_enrollment).to receive(:employee_role_id).and_return "123"
        expect(helper.show_employer_panel?(person, hbx_enrollments)).to eq true
      end
    end
  end
end
