module Forms
  class ConsumerIdentity
    include ActiveModel::Model
    include ActiveModel::Validations

    attr_accessor :first_name, :middle_name, :last_name
    attr_accessor :name_pfx, :name_sfx
    attr_accessor :gender, :ssn, :date_of_birth
    attr_reader :ssn

    attr_accessor :user_id

    validates_presence_of :first_name, :allow_blank => nil
    validates_presence_of :last_name, :allow_blank => nil
    include Validations::USDate.on(:date_of_birth)

    validates :ssn,
              length: { minimum: 9, maximum: 9, message: "SSN must be 9 digits" },
              numericality: true
   
    def dob
      Date.strptime(date_of_birth, "%m/%d/%Y") rescue nil
    end

    def ssn=(new_ssn)
      if !new_ssn.blank?
        @ssn = new_ssn.to_s.gsub(/\D/, '')
      end
    end

    def match_census_employees
      EmployerCensus::Employee.where({
        :dob => dob,
        :ssn => ssn        
      })
    end

    def match_person
      Person.where({
        :dob => dob,
        :ssn => ssn        
      }).first
    end

    def persisted?
      false
    end
  end
end
