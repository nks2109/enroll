  class SsaVerificationResponse 
    include Mongoid::Document
    include Mongoid::Timestamps

    field :response_code,  type: String
    field :response_text, type: String
    field :ssn_verification_failed, type: String
    field :ssn_verified, type: String
    field :death_confirmation, type: String
    field :citizenship_verified, type: String
    field :incarcerated, type: String
    
    embedded_in :lawful_presence_determination

  end
