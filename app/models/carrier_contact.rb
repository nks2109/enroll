class CarrierContact
  include Mongoid::Document
  include Mongoid::Timestamps
  
  embedded_in :carrier_profile
  
  field :kind, type: String
  field :country_code, type: String, default: ""
  field :area_code, type: String, default: ""
  field :number, type: String, default: ""
  field :extension, type: String, default: ""
  field :full_phone_number, type: String, default: ""
  
  before_validation :save_phone_components
  
  before_save :set_full_phone_number
  
  def blank?
    [:full_phone_number, :area_code, :number, :extension].all? do |attr|
      self.send(attr).blank?
    end
  end
  
  def save_phone_components
    phone_number = filter_non_numeric(self.full_phone_number).to_s
    if !phone_number.blank?
      length=phone_number.length
      if length>10
        self.area_code = phone_number[0,3]
        self.number = phone_number[3,7]
        self.extension = phone_number[10,length-10]
      elsif length==10
        self.area_code = phone_number[0,3]
        self.number = phone_number[3,7]
      end
    end
  end
  
  def full_phone_number=(new_full_phone_number)
   super filter_non_numeric(new_full_phone_number)
   save_phone_components
  end

  def area_code=(new_area_code)
   super filter_non_numeric(new_area_code)
  end

  def number=(new_number)
   super filter_non_numeric(new_number)
  end

  def extension=(new_extension)
   super filter_non_numeric(new_extension)
  end

  def to_s
    full_number = (self.area_code + self.number).to_i
    if self.extension.present?
      full_number.to_s(:phone, area_code: true, extension: self.extension)
    else
      full_number.to_s(:phone, area_code: true)
    end
  end

  def set_full_phone_number
    self.full_phone_number = to_s
  end
  
  def number_to_phone(number, options = {})
    return unless number
    options = options.symbolize_keys

    parse_float(number, true) if options.delete(:raise)
    ERB::Util.html_escape(ActiveSupport::NumberHelper.number_to_phone(number, options))
  end
  
  def us_formatted_number
    number_to_phone(full_phone_number, country_code: country_code)
  end

private
  def filter_non_numeric(str)
    str.to_s.gsub(/\D/,'') if str.present?
  end
  
end