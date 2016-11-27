require "watir"
require "rspec"

EMAIL = "dlake@spartaglobal.co\n"
PASSWORD = "Sdet-Hero\n"
IMAGE = "http://bit.ly/2aI3Nw4\n"
BLOG = "https://www.tumblr.com/blog/sdet-hero"

def login
  @browser.goto "#{@url}/login"
  @browser.text_field(id:"signup_determine_email").send_keys EMAIL
  Watir::Wait.until { @browser.button(id: "login-signin").exists? }
  @browser.button(id: "login-signin").click
  Watir::Wait.until { @browser.text_field(id: "login-passwd").visible? }
  @browser.text_field(id: "login-passwd").send_keys PASSWORD
  Watir::Wait.until { @browser.body(id: 'dashboard_index').exists? }
end

def logged_in?
  @browser.body.class_name.include? "logged_in"
end

def logout
  @browser.goto "#{@url}/logout"
end

def make_post #this will become an api post for fast set up
  Watir::Wait.until { @browser.body(id: 'dashboard_index').exists? }
  @browser.i(class: "icon_post_text").click
  Watir::Wait.until { @browser.div(class: 'post').exists? }
  @browser.div(class: "editor-plaintext").send_keys "Test"
  @browser.div(class: "editor-richtext").send_keys "this is a test"
  @browser.button(class: "button-area create_post_button").click
  sleep 2
  @browser.goto BLOG
  Watir::Wait.until { @browser.ol(id: 'posts').exists? }
  return @browser.lis(class: "post_container")[1].attribute_value("data-pageable")
end

def delete_post #this will become an api delete for fast teardown
  @browser.goto "https://www.tumblr.com/blog/sdet-hero"
  Watir::Wait.until { @browser.lis(class: "post_container")[0].present? }
  @browser.ol(id: 'posts').lis[1].div(class: 'creator').click
  Watir::Wait.until { @browser.div(class: 'post_controls_inner').div(class: 'active').present? }
  @browser.ol(id: 'posts').ul(class: 'popover_inner').lis[1].click
  sleep 1
  @browser.button(class: 'blue').click
end

def find_post
  @browser.lis(class: "post_container").each do |check|
    if check.attribute_value('data-pageable') == @id
      return true
    else
      return false
    end
  end
end


RSpec.configure do |config|
  config.filter_run :focus => true
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
