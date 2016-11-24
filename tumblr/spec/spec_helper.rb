require "watir"


def logged_in?
  @browser.body.class_name.include? "logged_in"
end

def login
  @browser.goto "#{@url}/login"
  @browser.text_field(id:"signup_determine_email").send_keys "dlake@spartaglobal.co\n"
  sleep 1
  @browser.button(id: "login-signin").click
  sleep 1
  @browser.text_field(id: "login-passwd").set "Acad3my1\n"
end 

def logout
  @browser.goto "#{@url}/logout"
end







RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end


  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

end
