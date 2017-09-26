
begin
  @data_hash = {}
  #use the report generated initially for 17688.
  CSV.foreach('uqhp_projected_eligibility_notice_report.csv',:headers =>true).each do |d|
    if @data_hash[d["family.id"]].present?
      hbx_ids = @data_hash[d["family.id"]].collect{|r| r['policy.subscriber.person.hbx_id']}
      next if hbx_ids.include?(d["policy.subscriber.person.hbx_id"])
      @data_hash[d["family.id"]] << d
    else
      @data_hash[d["family.id"]] = [d]
    end
  end
rescue Exception => e
  puts "Unable to open file #{e}"
end

file_name = "#{Rails.root}/uqhp_notice_batch_2_#{TimeKeeper.date_of_record.strftime('%m_%d_%Y')}.csv"

CSV.open(file_name, "w", force_quotes: true) do |csv|
  csv << ["family.id",  "policy.id", "policy.subscriber.coverage_start_on", "policy.aasm_state",  "policy.plan.coverage_kind", "policy.plan.metal_level", "policy.plan.plan_name", "policy.subscriber.person.hbx_id", "policy.subscriber.person.is_incarcerated", "policy.subscriber.person.citizen_status", "new_citizen_status", "policy.subscriber.person.is_dc_resident?",  "is_dependent"]
  @data_hash.each do |family_id , members|
    if (members.any?{ |m| (m["policy.subscriber.person.citizen_status"] == "non_native_not_lawfully_present_in_us") || (m["policy.subscriber.person.citizen_status"] == "not_lawfully_present_in_us")})
      members.each do |member|
        person = Person.where(:hbx_id => member["policy.subscriber.person.hbx_id"]).first
        csv << [member["family.id"], member["policy.id"], member["policy.subscriber.coverage_start_on"], member["policy.aasm_state"], member["policy.plan.coverage_kind"], member["policy.plan.metal_level"], member["policy.plan.plan_name"], member["policy.subscriber.person.hbx_id"], member["policy.subscriber.person.is_incarcerated"], member["policy.subscriber.person.citizen_status"], person.citizen_status, member["policy.subscriber.person.is_dc_resident?"], member["is_dependent"]]
      end
    end
  end
end
