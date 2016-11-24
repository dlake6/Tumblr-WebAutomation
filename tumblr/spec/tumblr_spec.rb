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

	

	it "should be able to make a new post" do
		make_post
		sleep 2
		@browser.goto "https://www.tumblr.com/blog/sdet-hero"
		sleep 1
		expect((@browser.divs(class: "post_title")[0]).text).to include "Test"
		expect((@browser.divs(class: "post_body")[0]).text).to include "this is a test"
	end

	it 'should delete posts' do
		@id = make_post
		delete_post
		sleep 1
		expect(find_post).to eq false
	end

end
