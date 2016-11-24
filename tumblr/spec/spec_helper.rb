require "watir"
require "rspec"

#@user_name = 'sdet-hero'


def logged_in?
  @browser.body.class_name.include? "logged_in"
end

def login
  @browser.goto "#{@url}/login"
  @browser.text_field(id:"signup_determine_email").send_keys "dlake@spartaglobal.co\n"
  sleep 1
  @browser.button(id: "login-signin").click
  sleep 1
  @browser.text_field(id: "login-passwd").send_keys "Acad3my1\n"
end 

def logout
  @browser.goto "#{@url}/logout"
end

def make_post
  sleep 1
  @browser.i(class: "icon_post_text").click
  sleep 1
  @browser.div(class: "editor-plaintext").send_keys "Test"
  @browser.div(class: "editor-richtext").send_keys "this is a test"
  @browser.button(class: "button-area create_post_button").click
  sleep 1
  @browser.goto "https://www.tumblr.com/blog/sdet-hero"
  sleep 1
  return @browser.lis(class: "post_container")[1].attribute_value("data-pageable")
end

def delete_post
  sleep 1
  @browser.goto "https://www.tumblr.com/blog/sdet-hero"
  Watir::Wait.until { @browser.lis(class: "post_container")[0].present? }
  @browser.ol(id: 'posts').lis[1].div(class: 'creator').click
  Watir::Wait.until { @browser.div(class: 'post_controls_inner').div(class: 'active').present? }
  @browser.ol(id: 'posts').ul(class: 'popover_inner').lis[1].click
  sleep 1
  @browser.button(class: 'blue').click
end

def find_post
  if @id == @browser.lis(class: "post_container")[1].attribute_value("data-pageable")
    return true
  else
    return false
  end
end

RSpec.configure do |c|
  c.filter_run :focus => true
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
