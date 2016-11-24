require 'watir'


describe "Tumblr" do 

	before(:all) do
		@browser = Watir::Browser.new :chrome
		@url = "https://www.tumblr.com"
	end

	before(:each) do
		if logged_in?
			@browser.goto "#{@url}/dashboard"
		else
			login()
		end
	end

	it 'should login in with valid credentials' do
		sleep 1
		expect(@browser.url).to include "dashboard"
	end

	it "should be able to make a new post" do
		@browser.i(class: "icon_post_text").click
		sleep 1
		@browser.div(class: "editor-plaintext").send_keys "Test"
		@browser.div(class: "editor-richtext").send_keys "hello there"
		@browser.button(class: "button-area create_post_button").click
		sleep 2
		@browser.goto "https://www.tumblr.com/blog/sdet-hero"
		sleep 1
		expect((@browser.divs(class: "post_title")[0]).text).to include "Test"
	end



end
