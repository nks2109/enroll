require 'rails_helper'

describe "insured/families/inbox.html.erb", dbclean: :after_each do
  let(:user) { FactoryGirl.build_stubbed(:user, person: person) }
  let(:person) { FactoryGirl.create(:person) }

  before :each do
    sign_in(user)
    assign(:person, person)
    assign(:current_user, user)
    assign(:provider, person)
    allow(person).to receive_message_chain("inbox.unread_messages.size").and_return(3)
  end

  context "as admin" do
    before :each do
      allow(view).to receive_message_chain("current_user.has_hbx_staff_role?").and_return(true)
    end

    it "should display the upload notices button" do
      render template: "insured/families/inbox.html.erb"
      expect(rendered).to match(/upload notices/i)
    end
    
    it "should display the download tax documents button if consumer has SSN" do
      allow(person).to receive(:ssn).and_return '123456789'
      render template: "insured/families/inbox.html.erb"
      expect(rendered).to match(/Download Tax Documents/i)
    end

    it "should not display the download tax documents button if consumer has no SSN" do
      render template: "insured/families/inbox.html.erb"
      expect(rendered).not_to match(/Download Tax Documents/i)
    end
  end

  context "as insured" do
    let(:consumer_role) { double('consumer_role', :is_active? => true)}
    before do
      allow(view).to receive_message_chain("current_user.has_hbx_staff_role?").and_return(false)
      allow(person).to receive(:consumer_role).and_return consumer_role
      stub_template "insured/families/_navigation.html.erb" => ""
    end

    it "should not display the upload notices button" do
      render template: "insured/families/inbox.html.erb"
      expect(rendered).to_not match(/upload notices/i)
    end

    it "should display the download tax documents button if consumer has SSN" do
      allow(person).to receive(:ssn).and_return '123456789'
      render template: "insured/families/inbox.html.erb"
      expect(rendered).to match(/Download Tax Documents/i)
    end


    it "should not display the download tax documents button if consumer has no SSN" do
      render template: "insured/families/inbox.html.erb"
      expect(rendered).to_not match(/Download Tax Documents/i)
    end
  end
end


