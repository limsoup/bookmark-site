require 'open-uri'
require 'uri'
require 'nokogiri'
require 'image_size'


class UrlFormatValidation < ActiveModel::Validator
	def validate(record)
		parts = URI.split(record.url)
		unless parts[0] and parts [2]
			record.errors[:url] = "Sorry, that URL wasn't recognized as valid."
		end
	end
end

class BookmarkUrl < ActiveRecord::Base
  attr_accessible :url, :embed
  before_save :check_thumbnails_and_embed
  serialize :thumbnail_urls
  has_many :user_bookmarks
  has_many :playlists, :through => :user_bookmarks

	before_validation :regularize_url
	include ActiveModel::Validations
	validates_with UrlFormatValidation

		def regularize_url
			parts = URI.split(self.url)
			if parts[0].nil?
				self.url = 'http://'+self.url
				#maybe this will be where I strip away some stuff, not sure
			end
		end

		def embed_domains
			@embed_domains ||= ['xvideos.com','www.xvideos.com','video.xnxx.com','wwww.xnxx.com', 'xnxx.com', 'redtube.com','www.redtube.com','xhamster.com','www.xhamster.com','tube8.com','www.tube8.com', 'pornhub.com', 'www.pornhub.com', 'youjizz.com', 'www.youjizz.com',  'jizzhut.com', 'www.jizzhut.com','youporn.com','www.youporn.com','jizzonline.com', 'www.jizzonline.com','www.moviesguy.com', 'moviesguy.com', 'www.jizzbo.com', 'jizzbo.com', 'onlyjizz.com','www.onlyjizz.com','hothousefun.com','www.hothousefun.com','tnaflix.com', 'www.tnaflix.com', 'empflix.com', 'www.empflix.com', 'spankwire.com', 'www.spankwire.com','keezmovies.com', 'www.keezmovies.com', 'www.xtube.com', 'xtube.com', 'drtuber.com', 'www.drtuber.com']
		end

		def thumbnail_domains
			@thumbnail_domains ||= ['xvideos.com','www.xvideos.com','video.xnxx.com','www.xnxx.com', 'xnxx.com','redtube.com','www.redtube.com', 'xhamster.com', 'www.xhamster.com','slutload.com','www.slutload.com','tube8.com','www.tube8.com', 'pornhub.com', 'www.pornhub.com', 'youjizz.com', 'www.youjizz.com',  'jizzhut.com', 'www.jizzhut.com', 'youporn.com','www.youporn.com','jizzonline.com', 'www.jizzonline.com','www.moviesguy.com', 'moviesguy.com', 'www.jizzbo.com', 'jizzbo.com', 'onlyjizz.com','www.onlyjizz.com','hothousefun.com','www.hothousefun.com','tnaflix.com', 'www.tnaflix.com','empflix.com', 'www.empflix.com', 'spankwire.com', 'www.spankwire.com', 'drtuber.com', 'www.drtuber.com']
		end

		def set_embed
			parts = URI.split(self.url)
			# embedFinal = ""
			if (embed_domains.include? parts[2])
				case parts[2]
				when 'www.xvideos.com', 'xvideos.com'
					embed="<iframe src=\"http://flashservice.xvideos.com/embedframe/REPLACEME\"frameborder=0 width=510 height=400 scrolling=no></iframe>"
					self.embed = embed.sub(/REPLACEME/, parts[5].match(/[0-9]+/).to_s).html_safe
				when 'www.xnxx.com', 'xnxx.com', 'video.xnxx.com'
					embed="<iframe src=\"http://flashservice.xvideos.com/embedframe/REPLACEME\"frameborder=0 width=510 height=400 scrolling=no></iframe>"
					self.embed = embed.sub(/REPLACEME/, parts[5].match(/[0-9]+/).to_s).html_safe	
				when 'www.redtube.com', 'redtube.com'
					embed="<object height=\"344\" width=\"434\"><param name=\"allowfullscreen\" value=\"true\"><param name=\"movie\" value=\"http://embed.redtube.com/player/\"><param name=\"FlashVars\" value=\"id=REPLACEME&style=redtube&autostart=false\"><embed src=\"http://embed.redtube.com/player/?id=REPLACEME&style=redtube\" allowfullscreen=\"true\" AllowScriptAccess=\"always\" flashvars=\"autostart=false\" pluginspage=\"http://www.adobe.com/shockwave/download/download.cgi?P1_Prod_Version=ShockwaveFlash\" type=\"application/x-shockwave-flash\" height=\"344\" width=\"434\" /></object>"
					self.embed = embed.gsub(/REPLACEME/, parts[5].match(/[0-9]+/).to_s).html_safe
				when 'www.xhamster.com', 'xhamster.com'
					embed="<iframe width=\"510\" height=\"400\" src=\"http://xhamster.com/xembed.php?video=REPLACEME\" frameborder=\"0\" scrolling=\"no\"></iframe>"
					self.embed = embed.sub(/REPLACEME/, parts[5].match(/[0-9]+/).to_s).html_safe
				when 'slutload.com', 'www.slutload.com'
					embed= "<div style=\"margin:auto\" align=\"center\"><object type=\"application/x-shockwave-flash\" data=\"http://emb.slutload.com/REPLACEME\" width=\"450\" height=\"253\"><param name=\"AllowScriptAccess\" value=\"always\"><param name=\"movie\" value=\"http://emb.slutload.com/REPLACEME\"></param><param name=\"allowfullscreen\" value=\"true\"></param><embed src=\"http://emb.slutload.com/REPLACEME\" AllowScriptAccess=\"always\" allowfullscreen=\"true\" width=\"450\" height=\"253\"></embed></object><br /><a href=\"http://www.slutload.com/\" target=\"_blank\">Porno</a></div>"
					self.embed = embed.gsub(/REPLACEME/, parts[5].match(/watch\/(.+)\//)[1].to_s).html_safe
				when 'tube8.com','www.tube8.com'
					embed= "<iframe src=\"http://www.tube8.com/embedREPLACEME\" frameborder=0 height=481 width=608 scrolling=no name=\"t8_embed_video\"></iframe>"
					self.embed = embed.sub(/REPLACEME/, parts[5].match(/\/.+\/[0-9]+\//).to_s).html_safe
				when 'pornhub.com','www.pornhub.com'
					embed= "<iframe src=\"http://www.pornhub.com/embed/REPLACEME\" frameborder=\"0\" width=\"608\" height=\"481\" scrolling=\"no\"></iframe>"
					self.embed = embed.sub(/REPLACEME/, parts[7].match(/viewkey=([0-9]+)/)[1]).html_safe
				when 'youjizz.com', 'www.youjizz.com'
					embed="<iframe src=\'http://www.youjizz.com/videos/embed/REPLACEME\' frameborder=\'0\' width=\'704\' height=\'550\' scrolling=\'no\' allowtransparency=\'true\'></iframe>"
					self.embed = embed.sub(/REPLACEME/, parts[5].match(/-([0-9]+).html/)[1]).html_safe
				when 'jizzhut.com', 'www.jizzhut.com'
					embed="<iframe src=\'http://www.jizzhut.com/videos/embed/REPLACEME\' frameborder=\'0\' width=\'704\' height=\'550\' scrolling=\'no\' allowtransparency=\'true\'></iframe>"
					self.embed = embed.sub(/REPLACEME/, parts[5].match(/-([0-9]+).html/)[1]).html_safe
				when 'jizzonline.com', 'www.jizzonline.com'
					embed="<iframe src=\'http://www.jizzonline.com/videos/embed/REPLACEME\' frameborder=\'0\' width=\'704\' height=\'550\' scrolling=\'no\' allowtransparency=\'true\'></iframe>"
					self.embed = embed.sub(/REPLACEME/, parts[5].match(/-([0-9]+).html/)[1]).html_safe
				when 'www.jizzbo.com', 'jizzbo.com'
					embed="<iframe src=\'http://www.jizzbo.com/videos/embed/REPLACEME\' frameborder=\'0\' width=\'704\' height=\'550\' scrolling=\'no\' allowtransparency=\'true\'></iframe>"
					self.embed = embed.sub(/REPLACEME/, parts[5].match(/-([0-9]+).html/)[1]).html_safe
				when 'www.moviesguy.com', 'moviesguy.com'
					embed="<iframe src=\'http://www.moviesguy.com/videos/embed/REPLACEME\' frameborder=\'0\' width=\'704\' height=\'550\' scrolling=\'no\' allowtransparency=\'true\'></iframe>"
					self.embed = embed.sub(/REPLACEME/, parts[5].match(/-([0-9]+).html/)[1]).html_safe
				when 'onlyjizz.com','www.onlyjizz.com'
					embed="<iframe src=\'http://www.onlyjizz.com/videos/embed/REPLACEME\' frameborder=\'0\' width=\'704\' height=\'550\' scrolling=\'no\' allowtransparency=\'true\'></iframe>"
					self.embed = embed.sub(/REPLACEME/, parts[5].match(/-([0-9]+).html/)[1]).html_safe
				when 'hothousefun.com','www.hothousefun.com'
					embed="<iframe src=\'http://www.hothousefun.com/videos/embed/REPLACEME\' frameborder=\'0\' width=\'704\' height=\'550\' scrolling=\'no\' allowtransparency=\'true\'></iframe>"
					self.embed = embed.sub(/REPLACEME/, parts[5].match(/-([0-9]+).html/)[1]).html_safe
				when 'youporn.com','www.youporn.com'
					embed = "<iframe src=\'http://www.youporn.com/embedREPLACEME\' frameborder=0 height=481 width=608 scrolling=no name=\'yp_embed_video\'></iframe>"
					self.embed = embed.sub(/REPLACEME/, parts[5].match(/watch(\/.+?\/.+?\/)/)[1]).html_safe
				when 'tnaflix.com', 'www.tnaflix.com'
					embed = "<iframe src=\"http://player.tnaflix.com/video/REPLACEME\" width=\"650\" height=\"515\" frameborder=\"0\"></iframe>"
					self.embed = embed.sub(/REPLACEME/, parts[5].match(/video([0-9]+)/)[1]).html_safe
				when 'empflix.com', 'www.empflix.com'
					embed = "<iframe src=\"http://player.empflix.com/video/REPLACEME\" width=\"650\" height=\"515\" frameborder=\"0\"></iframe>"
					self.embed = embed.sub(/REPLACEME/, parts[5].match(/([0-9]+).html/)[1]).html_safe
				when 'spankwire.com', 'www.spankwire.com'
					embed="<iframe src=\"http://www.spankwire.com/EmbedPlayer.aspx?ArticleId=REPLACEME\" frameborder=\"0\" height=\"481\" width=\"608\" scrolling=\"no\" name=\"spankwire_embed_video\"></iframe>"
					self.embed = embed.sub(/REPLACEME/, parts[5].match(/video([0-9]+)/)[1]).html_safe
				when 'keezmovies.com', 'www.keezmovies.com'
					embed="<iframe src=\"http://www.keezmovies.com/embed/REPLACEME\" frameborder=\"0\" height=\"490\" width=\"608\" scrolling=\"no\" name=\"keezmovies_embed_video\"></iframe>"
					self.embed = embed.sub(/REPLACEME/, parts[5].match(/video\/(.+)/)[1]).html_safe
				when 'drtuber.com', 'www.drtuber.com'
					embed="<iframe src=\"http://www.drtuber.com/embed/REPLACEME\" width=\"608\" height=\"478\" frameborder=\"0\" scrolling=\"no\"></iframe>"
					self.embed = embed.sub(/REPLACEME/, parts[5].match(/video\/(.+)/)[1]).html_safe
				end
			end
			# return embedFinal
		end

		def set_thumbnails
			parts = URI.split(self.url)
			if (thumbnail_domains.include? parts[2])
				self.thumbnail_urls = {};
				case parts[2]
				when 'www.xvideos.com', 'xvideos.com'
					page = Nokogiri::HTML(open(url))
					thumbnail_url = page.css('embed#flash-player-embed')[0]['flashvars'].match(/url_bigthumb=(.*?.jpg)/)[1]
					self.thumbnail_urls['thumbindex'] = thumbnail_url.match(/.*\.(.+)\.jpg/)[1].to_i
					self.thumbnail_urls['thumbindexstart'] = thumbnail_url.match(/.*\.(.+)\.jpg/)[1].to_i
					self.thumbnail_urls['numthumbs']=30
					(1..30).each do |i|
						self.thumbnail_urls['thumb'+i.to_s] = thumbnail_url.sub(/\.[0-9]+\.jpg/, '.'+ i.to_s+'.jpg')
					end
				when 'www.xnxx.com', 'xnxx.com', 'video.xnxx.com'
					xvideosUrl = url.sub(/video.xnxx/,'www.xvideos')
					page = Nokogiri::HTML(open(xvideosUrl))
					thumbnail_url = page.css('embed#flash-player-embed')[0]['flashvars'].match(/url_bigthumb=(.*?.jpg)/)[1]
					self.thumbnail_urls['thumbindex'] = thumbnail_url.match(/.*\.(.+)\.jpg/)[1].to_i
					self.thumbnail_urls['thumbindexstart'] = thumbnail_url.match(/.*\.(.+)\.jpg/)[1].to_i
					self.thumbnail_urls['numthumbs']=30
					(1..30).each do |i|
						self.thumbnail_urls['thumb'+i.to_s] = thumbnail_url.sub(/\.[0-9]+\.jpg/, '.'+ i.to_s+'.jpg');
					end
				when 'www.redtube.com', 'redtube.com'
					id = Integer(parts[5][/[0-9]+/])
					id_str= '0'*(7-(id.to_s).length)+(id.to_s)
					thumbnail_url = 'http://img01.redtubefiles.com/_thumbs/0000'+id_str[1..3]+'/'+id_str+'/'+id_str+'_008m.jpg'
					self.thumbnail_urls['thumbindex'] = thumbnail_url.match(/(...).\.jpg/)[1].to_i
					self.thumbnail_urls['thumbindexstart'] = thumbnail_url.match(/(...).\.jpg/)[1].to_i
					self.thumbnail_urls['numthumbs']=16;
					(1..16).each do |i|
						self.thumbnail_urls['thumb'+i.to_s] = thumbnail_url.sub(/....\.jpg/, '0'*(3-(i.to_s).length)+(i.to_s)+'m.jpg');
					end
				when 'xhamster.com', 'www.xhamster.com'
					id_str = parts[5][/[0-9]+/]
					self.thumbnail_urls['thumbindex'] = 3
					self.thumbnail_urls['thumbindexstart'] = 3
					self.thumbnail_urls['numthumbs']=10;
					(1..10).each do |i|
						self.thumbnail_urls['thumb'+i.to_s] = 'http://ut'+id_str[-1]+'.xhamster.com/t/'+id_str[-3..-1]+'/'+i.to_s+'_b_'+id_str+'.jpg'
					end
				when 'slutload.com', 'www.slutload.com'
					id_str = parts[5].match(/watch\/(.+)\//)[1].to_s
					self.thumbnail_urls['thumbindex'] = 10
					self.thumbnail_urls['thumbindexstart'] = 10
					self.thumbnail_urls['numthumbs']=20;
					(1..20).each do |i|
						self.thumbnail_urls['thumb'+i.to_s] = "http://i4-sec.slutload-media.com/"+id_str[0]+"/"+id_str[1]+"/"+id_str[2]+"/"+id_str[3]+"/"+id_str+".240x180."+("%02d" % i)+".jpg"
					end
				# when 'beeg.com','www.beeg.com'
				# 	id_str = parts[5][/[0-9]+/]s
				# 	self.thumbnail_urls['thumbindex'] = 1
				# 	self.thumbnail_urls['thumbindexstart'] = 1
				# 	self.thumbnail_urls['thumb1'] = "http://cdn.anythumb.com/320x240/"+id_str+".jpg"
				# 	self.thumbnail_urls['numthumbs']=1
				when 'tube8.com', 'www.tube8.com'
					page = Nokogiri::HTML(open(url))
					thumbnail_url = URI.unescape(page.css('#flvplayer script')[0].text.match(/image_url\":\"(.+?\.jpg)/)[1]).gsub(/\\/,'')
					self.thumbnail_urls['thumbindex'] = thumbnail_url.match(/.*\/(.+)\.jpg/)[1].to_i
					self.thumbnail_urls['thumbindexstart'] = thumbnail_url.match(/.*\/(.+)\.jpg/)[1].to_i
					self.thumbnail_urls['numthumbs']=16;
					(1..16).each do |i|
						self.thumbnail_urls['thumb'+i.to_s] = thumbnail_url.sub(/\/[0-9]+\.jpg/, '/'+ i.to_s+'.jpg');
					end
				when 'pornhub.com', 'www.pornhub.com'
					page = Nokogiri::HTML(open(url))
 					thumbnail_url = URI.unescape(page.css('.video-wrapper script')[0].text.match(/image_url\":\"(.+?\.jpg)/)[1])
					self.thumbnail_urls['thumbindex'] = thumbnail_url.match(/.*\/(.+)\.jpg/)[1].to_i
					self.thumbnail_urls['thumbindexstart'] = thumbnail_url.match(/.*\/(.+)\.jpg/)[1].to_i
					self.thumbnail_urls['numthumbs']=16;
					(1..16).each do |i|
						self.thumbnail_urls['thumb'+i.to_s] = thumbnail_url.sub(/\/[0-9]+\.jpg/, '/'+ i.to_s+'.jpg');
					end
				when 'youjizz.com', 'www.youjizz.com'
					mobiURL = url.sub(/\/\/.*youjizz/,'//m.youjizz')
					page = Nokogiri::HTML(open(mobiURL))
 					thumbnail_url = URI.unescape(page.css('.preview_thumb img')[0]['src'])
					self.thumbnail_urls['thumbindex'] = 1
					self.thumbnail_urls['thumbindexstart'] = 1
					self.thumbnail_urls['numthumbs']= 8
					(1..8).each do |i|
						self.thumbnail_urls['thumb'+i.to_s] = thumbnail_url.sub(/[0-9]\.jpg/, i.to_s+'.jpg');
					end
				when 'jizzhut.com', 'www.jizzhut.com'
					mobiURL = url.sub(/\/\/.*jizzhut/,'//m.youjizz')
					page = Nokogiri::HTML(open(mobiURL))
 					thumbnail_url = URI.unescape(page.css('.preview_thumb img')[0]['src'])
					self.thumbnail_urls['thumbindex'] = 1
					self.thumbnail_urls['thumbindexstart'] = 1
					self.thumbnail_urls['numthumbs']= 8
					(1..8).each do |i|
						self.thumbnail_urls['thumb'+i.to_s] = thumbnail_url.sub(/[0-9]\.jpg/, i.to_s+'.jpg');
					end
				when 'jizzonline.com', 'www.jizzonline.com'
					mobiURL = url.sub(/\/\/.*jizzonline/,'//m.youjizz')
					page = Nokogiri::HTML(open(mobiURL))
 					thumbnail_url = URI.unescape(page.css('.preview_thumb img')[0]['src'])
					self.thumbnail_urls['thumbindex'] = 1
					self.thumbnail_urls['thumbindexstart'] = 1
					self.thumbnail_urls['numthumbs']= 8
					(1..8).each do |i|
						self.thumbnail_urls['thumb'+i.to_s] = thumbnail_url.sub(/[0-9]\.jpg/, i.to_s+'.jpg');
					end
				when 'www.moviesguy.com', 'moviesguy.com'
					mobiURL = url.sub(/\/\/.*moviesguy/,'//m.youjizz')
					page = Nokogiri::HTML(open(mobiURL))
 					thumbnail_url = URI.unescape(page.css('.preview_thumb img')[0]['src'])
					self.thumbnail_urls['thumbindex'] = 1
					self.thumbnail_urls['thumbindexstart'] = 1
					self.thumbnail_urls['numthumbs']= 8
					(1..8).each do |i|
						self.thumbnail_urls['thumb'+i.to_s] = thumbnail_url.sub(/[0-9]\.jpg/, i.to_s+'.jpg');
					end
				when 'www.jizzbo.com', 'jizzbo.com'
					mobiURL = url.sub(/\/\/.*jizzbo/,'//m.youjizz')
					page = Nokogiri::HTML(open(mobiURL))
 					thumbnail_url = URI.unescape(page.css('.preview_thumb img')[0]['src'])
					self.thumbnail_urls['thumbindex'] = 1
					self.thumbnail_urls['thumbindexstart'] = 1
					self.thumbnail_urls['numthumbs']= 8
					(1..8).each do |i|
						self.thumbnail_urls['thumb'+i.to_s] = thumbnail_url.sub(/[0-9]\.jpg/, i.to_s+'.jpg');
					end
				when 'onlyjizz.com','www.onlyjizz.com'
					mobiURL = url.sub(/\/\/.*onlyjizz/,'//m.youjizz')
					page = Nokogiri::HTML(open(mobiURL))
 					thumbnail_url = URI.unescape(page.css('.preview_thumb img')[0]['src'])
					self.thumbnail_urls['thumbindex'] = 1
					self.thumbnail_urls['thumbindexstart'] = 1
					self.thumbnail_urls['numthumbs']= 8
					(1..8).each do |i|
						self.thumbnail_urls['thumb'+i.to_s] = thumbnail_url.sub(/[0-9]\.jpg/, i.to_s+'.jpg');
					end
				when 'hothousefun.com','www.hothousefun.com'
					mobiURL = url.sub(/\/\/.*hothousefun/,'//m.youjizz')
					page = Nokogiri::HTML(open(mobiURL))
 					thumbnail_url = URI.unescape(page.css('.preview_thumb img')[0]['src'])
					self.thumbnail_urls['thumbindex'] = 1
					self.thumbnail_urls['thumbindexstart'] = 1
					self.thumbnail_urls['numthumbs']= 8
					(1..8).each do |i|
						self.thumbnail_urls['thumb'+i.to_s] = thumbnail_url.sub(/[0-9]\.jpg/, i.to_s+'.jpg');
					end
				when 'youporn.com', 'www.youporn.com'
					page = Nokogiri::HTML(open(url))
 					thumbnail_url = URI.unescape(page.css('#galleria img')[0]['src'])
					self.thumbnail_urls['thumbindex'] = 1
					self.thumbnail_urls['thumbindexstart'] = 1
					self.thumbnail_urls['numthumbs']= 16
					(1..16).each do |i|
						self.thumbnail_urls['thumb'+i.to_s] = thumbnail_url.sub(/[0-9]+\.jpg/, i.to_s+'.jpg');
					end
				when 'tnaflix.com', 'www.tnaflix.com'
					page = Nokogiri::HTML(open(url))
 					thumbnail_url = URI.unescape(page.css('meta[property="og:image"]')[0]['content'])
					self.thumbnail_urls['thumbindex'] = thumbnail_url.match(/([0-9]+)_[0-9]+\.jpg/)[1].to_i
					self.thumbnail_urls['thumbindexstart'] = thumbnail_url.match(/([0-9]+)_[0-9]+\.jpg/)[1].to_i
					self.thumbnail_urls['numthumbs']= 30
					(1..30).each do |i|
						self.thumbnail_urls['thumb'+i.to_s] = thumbnail_url.sub(/[0-9]+(_[0-9]+\.jpg)/,i.to_s+'\1');
					end
				when 'empflix.com', 'www.empflix.com'
					page = Nokogiri::HTML(open(url))
 					thumbnail_url = URI.unescape(page.css('form#vid_info #config')[0]['value'])
					prefix = URI.split(thumbnail_url)[5].match(/\/.+\/(..)/)[1]
					self.thumbnail_urls['thumbindex'] = URI.split(thumbnail_url)[7].match(/startThumb=([0-9]+)&/)[1]
					self.thumbnail_urls['thumbindexstart'] = URI.split(thumbnail_url)[7].match(/startThumb=([0-9]+)&/)[1]
					self.thumbnail_urls['numthumbs']= 30
					(1..30).each do |i|
						self.thumbnail_urls['thumb'+i.to_s] = "http://s1.static.empflix.com/thumbs/"+prefix+"/"+url.match(/([0-9]+)\.html/)[1]+"-"+i.to_s+".jpg"
					end
				when 'spankwire.com', 'www.spankwire.com'
					page = Nokogiri::HTML(open(url))
					thumbnail_url = URI.unescape(page.css('#flashcontent')[0].text.match(/flashvars\.image_url\s=\s\"(http.+?\.jpg)/)[1])
					self.thumbnail_urls['thumbindex'] = thumbnail_url.match(/([0-9]+).jpg/)[1]
					self.thumbnail_urls['thumbindexstart'] = thumbnail_url.match(/([0-9]+).jpg/)[1]
					self.thumbnail_urls['numthumbs']= 10
					(1..10).each do |i|
						self.thumbnail_urls['thumb'+i.to_s] = thumbnail_url.sub(/320X240\/[0-9]+/,"177X129/"+i.to_s)
					end
				when 'drtuber.com', 'www.drtuber.com'
					thumbnail_url = "http://pics.drtuber.com/media/videos/tmb/"
					self.thumbnail_urls['thumbindex'] = 1
					self.thumbnail_urls['thumbindexstart'] = 1
					self.thumbnail_urls['numthumbs']= 20
					(1..20).each do |i|
						self.thumbnail_urls['thumb'+i.to_s] = thumbnail_url+parts[5].match(/video\/([0-9]+)/)[1] +'/240_180/'+i.to_s+'.jpg'
					end
				end
			end
		end

		def check_thumbnails_and_embed
			if self.embed.nil?
				self.set_embed
			end
			if self.thumbnail_urls.nil?
				self.set_thumbnails
			end
		end

end