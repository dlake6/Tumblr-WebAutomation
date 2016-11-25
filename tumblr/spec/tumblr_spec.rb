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
		sleep 1
		expect(@browser.url).to include "dashboard"
	end

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
		@browser.text_field(id:"signup_determine_email").send_keys "dlake@spartaglobal.co\n"
  	sleep 2

  	@browser.button(id: "login-signin").click
  	sleep 1
  	@browser.text_field(id: "login-passwd").send_keys "hello\n"

    Watir::Wait.until { @browser.div(id: 'mbr-login-error').visible? }
    expect(@browser.div(id: 'mbr-login-error').text).to eq 'Invalid password. Please try again.'
  end

	it "should be able to make a new post and delete" do
		@id = make_post
		sleep 1
		expect((@browser.divs(class: "post_title")[0]).text).to include "Test"
		expect((@browser.divs(class: "post_body")[0]).text).to include "this is a test"
		sleep 1
		delete_post
		sleep 1
		expect(find_post).to eq false
	end

	it "should be able to post images" do
		@browser.i(class: "icon_post_photo").click
		sleep 1
		@browser.div(class: 'dropzone-add-url-icon').click
		sleep 1
		@browser.div(class: 'editor-plaintext').send_keys "http://bit.ly/2aI3Nw4\n"
		sleep 3
		@browser.button(class: 'create_post_button').click
		sleep 3
		@browser.goto BLOG
		sleep 1
		expect(@browser.lis(class: "post_container")[1].exists?).to eq true
		delete_post
	end

end
