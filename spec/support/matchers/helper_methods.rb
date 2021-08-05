RSpec::Matchers.define :has_helper_method do |mthd|
  match do |object|
    object._helper_methods.include? mthd.to_sym
  end
end
