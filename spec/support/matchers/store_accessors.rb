RSpec::Matchers.define :has_store_accessors do |field, *accessors|
  match do |model|
    return unless (acs = model.stored_attributes[field.to_sym])

    accessors.all? { |ac| acs.include?(ac.to_sym) }
  end
end
