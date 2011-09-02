a1 = User.find_or_initialize_by_email("lolowilou69@hotmail.fr")
a1.update_attributes(:role => "super_admin")
if ["production","staging"].include?(Rails.env)
  a1.update_attributes(:password => "$$wilou**")
else
  a1.update_attributes(:password => "password")
end
