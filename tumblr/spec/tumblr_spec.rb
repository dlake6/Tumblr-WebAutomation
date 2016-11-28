require 'watir'

describe "Tumblr", :focus do 

	before(:all) do
		@browser = Watir::Browser.new :chrome
		@url = "https://www.tumblr.com"
	end

	before(:each) do
		if logged_in?
			@browser.goto "#{@url}/dashboard"
		else
			login
		end
	end
	

	it 'should login in with valid credentials' do
		expect(@browser.url).to include "dashboard"
	end

	#negative testing
  it 'should fail to log in with invalid email' do
    logout
    expect(@browser.url).to eq "#{@url}/login"
    @browser.input(id: 'signup_determine_email').send_keys "hello\n"
    Watir::Wait.until { @browser.li(class: 'error').visible? }
    expect(@browser.li(class: 'error').text).to eq 'That\'s not a valid email address. Please try again.'
    5.times { @browser.input(id: 'signup_determine_email').send_keys :backspace }
  end

	it 'should fail to log in with invalid password' do
    logout
    expect(@browser.url).to eq "#{@url}/login"
		@browser.text_field(id:"signup_determine_email").send_keys EMAIL
  	Watir::Wait.until { @browser.button(id: "login-signin").exists? }
		@browser.button(id: "login-signin").click
  	Watir::Wait.until { @browser.text_field(id: "login-passwd").visible? }
  	@browser.text_field(id: "login-passwd").send_keys "hello\n"
		Watir::Wait.until { @browser.div(id: 'mbr-login-error').visible? }
    expect(@browser.div(id: 'mbr-login-error').text).to eq 'Invalid password. Please try again.'
  end

  #next set making posts
	it "should be able to make a new post" do
		#making post through website
		Watir::Wait.until { @browser.body(id: 'dashboard_index').exists? }
		@browser.i(class: "icon_post_text").click
  	Watir::Wait.until { @browser.div(class: 'post').exists? }
  	@browser.div(class: "editor-plaintext").send_keys "Test"
  	@browser.div(class: "editor-richtext").send_keys "this is a test"
  	@browser.button(class: "button-area create_post_button").click
  	#wait before redirection to blog
		Watir::Wait.until { @browser.url.include? "dashboard" } 
		#check post is now visible on blog
		@browser.goto BLOG
		Watir::Wait.until { @browser.ol(id: 'posts').exists? }
		expect((@browser.divs(class: "post_title")[0]).text).to include "Test"
		expect((@browser.divs(class: "post_body")[0]).text).to include "this is a test"
		#Teardown - This will be an api delete
		delete_post
	end
	
	it "should be able to delete a post" do
		#Set up will be an api post
		@id = make_post
		#delete through website
		@browser.ol(id: 'posts').lis[1].div(class: 'creator').click
  	Watir::Wait.until { @browser.div(class: 'post_controls_inner').div(class: 'active').present? }
  	@browser.ol(id: 'posts').ul(class: 'popover_inner').lis[1].click
  	Watir::Wait.until { @browser.div(id: 'dialog_0').exists? }
  	@browser.button(class: 'blue').click
  	#check post no longer exists on blog
		expect(find_post).to eq false
	end

	it "should be able to post images" do
		@browser.i(class: "icon_post_photo").click
		@browser.div(class: 'dropzone-add-url-icon').click
		@browser.div(class: 'editor-plaintext').send_keys IMAGE
		Watir::Wait.until { @browser.button(class: 'create_post_button').enabled? }
		@browser.button(class: 'create_post_button').click
		#wait before redirection to blog
		Watir::Wait.until { @browser.url.include? "dashboard" }
		#check image is now visible on blog
		@browser.goto BLOG
		Watir::Wait.until { @browser.ol(id: 'posts').exists? }
		expect(@browser.lis(class: "post_container")[1].exists?).to eq true
		#Teardown - will be an api delete
		delete_post
	end

end
