require 'uri'
class StaticPagesController < ApplicationController
	def welcome
		if (current_user.nil? and !(session[:logged_out] ==true) )
			@user = User.new
			foundFlag = false
			userName = ""
			while !foundFlag
				adjectives=["abhorrent","ablaze","abnormal","abrasive","acidic","alluring","ambiguous","amuck","apathetic","aquatic","auspicious","axiomatic","barbarous","bawdy","belligerent","berserk","bewildered","billowy","boorish","brainless","bustling","cagey","calculating","callous","capricious","ceaseless","chemical","chivalrous","cloistered","coherent","colossal","combative","cooing","cumbersome","cynical","daffy","damaged","deadpan","deafening","debonair","decisive","defective","defiant","demonic","delerious","deranged","devilish","didactic","diligent","direful","disastrous","disillusioned","dispensable","divergent","domineering","draconian","dynamic","earsplitting","earthy","eatable","efficacious","elastic","elated","elfin","elite","enchanted","endurable","erratic","ethereal","evanescent","exuberant","exultant","fabulous","fallacious","fanatical","fearless","feeble","feigned","fierce","flagrant","fluttering","frantic","fretful","fumbling","furtive","gainful","gamy","garrulous","gaudy","glistening","grandiose","grotesque","gruesome","guiltless","guttural","habitual","hallowed","hapless","harmonious","hellish","hideous","highfalutin","hissing","holistic","hulking","humdrum","hypnotic","hysterical","icky","idiotic","illustrious","immense","immenent","incandescent","industrious","infamous","inquisitive","insidious","invincible","jaded","jazzy","jittery","judicious","jumbled","juvenile","kaput","keen","knotty","knowing","lackadaisical","lamentable","languid","lavish","lewd","longing","loutish","ludicrous","lush","luxuriant","lyrical","macabre","maddening","mammoth","maniacal","meek","melodic","merciful","mere","miscreant","momentous","nappy","nebulous","nimble","nippy","nonchalant","nondescript","noxious","numberless","oafish","obeisant","obsequious","oceanic","omniscient","onerous","optimal","ossified","overwrought","paltry","parched","parsimonious","penitent","perpetual","picayune","piquant","placid","plucky","prickly","probable","profuse","psychedelic","quack","quaint","quarrelsome","questionable","quirky","quixotic","quizzical","rabbid","rambunctious","rampat","raspy","recondite","resolute","rhetorical","ritzy","ruddy","sable","sassy","savory","scandalous","scintillating","sedate","shaggy","shrill","smogggy","somber","sordid","spiffy","spurious","squalid","statuesque","steadfast","stupendous","succinct","swanky","sweltering","taboo","tacit","tangy","tawdry","tedious","tenuous","testy","thundering","tightfisted","torpid","trite","truculent","ubiquitous","ultra","unwieldy","uppity","utopian","utter","vacuous","vagabond","vengeful","venomous","verdant","versed","victorious","vigorous","vivacious","voiceless","volatile","voracious","vulgar","wacky","waggish","wakeful","warlike","wary","whimsical","whispering","wiggly","wiry","wistful","woebegone","woozy","wrathful","wretched","wry","xenial","xenophilic","yummy","yappy","yielding","zany","zazzy","zealous","zesty","zippy","zoetic","zoic"]
				foods=["asparagus","avocado","beans","beet","cabbage","carrot","cauliflower","celery","corn","cucumber","garlic","greenbeans","lettuce","mushrooms","onion","pea","potato","pumpkin","radish","rice","squash","sweetpotato","turnip","apple","apricot","banana","berry","cantaloupe","cherry","coconut","fruit","grapefruit","grape","lemon","lime","orange","peach","pear","pineapple","plum","prune","raisin","raspberry","strawberry","tomato","watermelon","bacon","beef","chicken","fish","ham","hamburger","hotdogs","lamb","meat","pork","meatloaf","roast","sausage","turkey","bone","bread","butter","candy","cake","catsup","cereal","cheese","chocolate","cookie","cottagecheese","dessert","egg","flour","honey","icecream","jam","jelly","macaroni","mayonnaise","mustard","noodle","nut","oil","peanut","pepper","pie","roll","salad","saladdressing","salt","sandwich","sauce","spaghetti","sugar","vanilla","vinegar","coffee","coke","cream","ice","juice","lemonade","milk","orangejuice","tea","water","wine"]
				userName = (adjectives.sample.capitalize+foods.sample.capitalize)
				foundFlag = User.find_by_username(userName).nil?
			end
			@user.username= (adjectives.sample.capitalize+foods.sample.capitalize)
			@user.password = ""
			@user.human = false
			@user.admin = false
			@user.default_list = Playlist.create(:playlist_name => "default list")
			flash[:instant_account] = 'new';
			if (@user.save)
				session[:remember_token] = @user.remember_token	
				ub1 = @user.default_list.user_bookmarks.build
				ub.name = "Two Really Hot Italian Soccer Fans Wrestle it out."
				bu1 = BookmarkUrl.find(62)
				ub1.bookmark_url = bu1;
				ub1.save
				ub2 = @user.default_list.user_bookmarks.build
				ub.name = "Wholesome-looking Mormon girl gets it."
				bu2 = BookmarkUrl.find(63)
				ub2.bookmark_url= bu2
				ub2.save
				redirect_to username_path(@user)
			end
		elsif (current_user)
			if request.referer
				if URI.split(request.referer)[2] == 'www.vrepo.com' or URI.split(request.referer)[2] == 'vrepo.com' or URI.split(request.referer)[2] == 'www.fapperkeeper.com' or URI.split(request.referer)[2] == 'fapperkeeper.com' or URI.split(request.referer)[2] == 'localhost'
					@user = current_user
					@playlist = @user.default_list
					@user_bookmark = @playlist.user_bookmarks.build
					@bookmark_url = BookmarkUrl.new
					render 'welcome'
				end
			else
				redirect_to username_path(current_user)
			end
		else #implictly, logged_out == true and is actually logged out
			@user = User.new
			respond_to do |format|
				format.html {render 'welcome'}
			end
		end
	end

	def how
	end

	def info
		
	end

	def privacy
	end

	def about
	end

	def usernotfound
		render 'usernotfound'
	end

end