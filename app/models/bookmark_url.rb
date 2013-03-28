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
			@embed_domains ||= ['xvideos.com','www.xvideos.com','video.xnxx.com','wwww.xnxx.com', 'xnxx.com', 'redtube.com','www.redtube.com','xhamster.com','www.xhamster.com','slutload.com','www.slutload.com','tube8.com','www.tube8.com', 'pornhub.com', 'www.pornhub.com', 'youjizz.com', 'www.youjizz.com',  'jizzhut.com', 'www.jizzhut.com','youporn.com','www.youporn.com','jizzonline.com', 'www.jizzonline.com','www.moviesguy.com', 'moviesguy.com', 'www.jizzbo.com', 'jizzbo.com', 'onlyjizz.com','www.onlyjizz.com','hothousefun.com','www.hothousefun.com','tnaflix.com', 'www.tnaflix.com', 'empflix.com', 'www.empflix.com', 'spankwire.com', 'www.spankwire.com','keezmovies.com', 'www.keezmovies.com', 'www.xtube.com', 'xtube.com', 'drtuber.com', 'www.drtuber.com','madthumbs.com', 'www.madthumbs.com', 'flingtube.com', 'www.flingtube.com', 'sublimedirectory.com','www.sublimedirectory.com', 'fastjizz.com', 'www.fastjizz.com', 'yobt.com','www.yobt.com', 'userporn.com', 'www.userporn.com', 'xfapzap.com','www.xfapzap.com','xxxbunker.com','www.xxxbunker.com', 'youtube.com','www.youtube.com','vimeo.com','www.vimeo.com','hardsextube.com', 'www.hardsextube.com']
		end

		def thumbnail_domains
			@thumbnail_domains ||= ['xvideos.com','www.xvideos.com','video.xnxx.com','www.xnxx.com', 'xnxx.com','redtube.com','www.redtube.com', 'xhamster.com', 'www.xhamster.com','slutload.com','www.slutload.com','tube8.com','www.tube8.com', 'pornhub.com', 'www.pornhub.com', 'youjizz.com', 'www.youjizz.com',  'jizzhut.com', 'www.jizzhut.com', 'youporn.com','www.youporn.com','jizzonline.com', 'www.jizzonline.com','www.moviesguy.com', 'moviesguy.com', 'www.jizzbo.com', 'jizzbo.com', 'onlyjizz.com','www.onlyjizz.com','hothousefun.com','www.hothousefun.com','tnaflix.com', 'www.tnaflix.com','empflix.com', 'www.empflix.com', 'spankwire.com', 'www.spankwire.com', 'drtuber.com', 'www.drtuber.com','madthumbs.com', 'www.madthumbs.com', 'flingtube.com', 'www.flingtube.com', 'sublimedirectory.com','www.sublimedirectory.com','fastjizz.com', 'www.fastjizz.com','yobt.com','www.yobt.com', 'xfapzap.com','www.xfapzap.com','xxxbunker.com','www.xxxbunker.com','youtube.com','www.youtube.com','vimeo.com','www.vimeo.com','hardsextube.com', 'www.hardsextube.com']
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
				when 'madthumbs.com', 'www.madthumbs.com', 'sublimedirectory.com','www.sublimedirectory.com'
					embed="<object id=\"MadThumbs_Player_REPLACEME\" type=\"application/x-shockwave-flash\" data=\"http://cache.tgpsitecentral.com/madthumbs/js/flowplayer/flowplayer.embed-3.2.6-dev.swf\" width=\"320\" height=\"264\"><param name=\"movie\" value=\"http://cache.tgpsitecentral.com/madthumbs/js/flowplayer/flowplayer.embed-3.2.6-dev.swf\" /><param value=\"true\" name=\"allowfullscreen\"/><param value=\"always\" name=\"allowscriptaccess\"/><param value=\"high\" name=\"quality\"/><param value=\"#000000\" name=\"bgcolor\"/><param value=\"config=http%3A%2F%2Fwww.madthumbs.com%2Fvideos%2Fembed_config%3Fid%3DREPLACEME\" name=\"flashvars\"/></object>"
					self.embed = embed.gsub(/REPLACEME/, parts[5].match(/videos\/.+?\/.+?\/([0-9]+)/)[1]).html_safe
				when 'flingtube.com', 'www.flingtube.com'
					embed="<iframe src=\'http://www.flingtube.com/videos/video_embed/?id=REPLACEME\' width=\'650\' height=\'480\' scrolling=\'no\' frameborder=\'0\'></iframe>"
					self.embed = embed.sub(/REPLACEME/, parts[5].match(/videos\/.+?\/([0-9]+)/)[1]).html_safe
				when 'fastjizz.com','www.fastjizz.com'
					embed="<iframe width=\"750\" height=\"550\" src=\"http://www.fastjizz.com/embed.php?id=REPLACEME\"></iframe>"
					self.embed = embed.sub(/REPLACEME/, parts[5].match(/video\/([0-9]+)/)[1]).html_safe
				when 'yobt.com','www.yobt.com'
					embed="<iframe src=\"http://www.yobt.com/embed/REPLACEME.html\" width=\"640\" height=\"510\" scrolling=\"no\" frameborder=\"0\" allowtransparency=\"true\" marginheight=\"0\" marginwidth=\"0\"></iframe>"
					self.embed = embed.sub(/REPLACEME/, parts[5].match(/.+?\/([0-9]+)\/?/)[1]).html_safe
				when 'userporn.com', 'www.userporn.com'
					embed="<object id=\"player\" width=\"425\" height=\"344\" classid=\"clsid:d27cdb6e-ae6d-11cf-96b8-444553540000\" ><param name=\"movie\" value=\"http://www.userporn.com/e/REPLACEME\" ></param><param name=\"allowFullScreen\" value=\"true\" ></param><param name=\"allowscriptaccess\" value=\"always\"></param><embed src=\"http://www.userporn.com/e/GKVw8rKmV3NC\" type=\"application/x-shockwave-flash\" allowscriptaccess=\"always\" allowfullscreen=\"true\" width=\"425\" height=\"344\"></embed></object>"
					self.embed = embed.sub(/REPLACEME/, URI.decode_www_form(URI.split(url)[7])[0][1]).html_safe
				when  'xfapzap.com','www.xfapzap.com'
					embed = "<iframe width=\"650\" height=\"490\" src=\"http://xfapzap.com/embed.php?id=REPLACEME\" frameborder=\"0\" scrolling=\"no\"></iframe>"
					self.embed = embed.sub(/REPLACEME/, parts[5].match(/([0-9]+)\/?/)[1]).html_safe
				when 'xxxbunker.com','www.xxxbunker.com'
					embed = "<div style=\"text-align:center\"><object width=\"550\" height=\"400\"><param name=\"movie\" value=\"http://xxxbunker.com/flash/player.swf\"></param><param name=\"wmode\" value=\"transparent\"></param><param name=\"allowfullscreen\" value=\"true\"></param><param name=\"allowscriptaccess\" value=\"always\"></param><param name=\"flashvars\" value=\"config=http%3A%2F%2Fxxxbunker.com%2FplayerConfig.php%3Fvideoid%3DREPLACEME%26autoplay%3Dfalse\"></param><embed src=\"http://xxxbunker.com/flash/player.swf\" type=\"application/x-shockwave-flash\" allowscriptaccess=\"always\" allowfullscreen=\"true\" wmode=\"transparent\" width=\"550\" height=\"400\" flashvars=\"config=http%3A%2F%2Fxxxbunker.com%2FplayerConfig.php%3Fvideoid%3DREPLACEME%26autoplay%3Dfalse\"></embed></object></div>"
					if parts[8] and parts[8].include?('!')
						self.url = 'http://www.xxxbunker.com/'+parts[8].match(/V([0-9]+)/)[1]
						self.embed = embed.gsub(/REPLACEME/, parts[8].match(/V([0-9]+)/)[1]).html_safe
					elsif parts[5] and parts[5].include?('_')
						page = Nokogiri::HTML(open(url))
						self.embed = embed.gsub(/REPLACEME/,URI.split(page.css('link[rel=image_src]')[0].attr('href'))[5][/[0-9]+/]).html_safe
					elsif parts[5] and parts[5].match(/^\/[0-9]+$/)
						self.embed = embed.gsub(/REPLACEME/,parts[5].match(/^\/([0-9]+)$/)[1]).html_safe
					else
						self.embed = nil
					end
				when 'youtube.com','www.youtube.com'
					embed= "<iframe width=\"560\" height=\"315\" src=\"http://www.youtube.com/embed/REPLACEME\" frameborder=\"0\" allowfullscreen></iframe>"
					URI.decode_www_form(URI.split(url)[7..8].join()).each do |a|
						if a[0] == 'v'
							self.embed = embed.gsub(/REPLACEME/,a[1]).html_safe
						end
					end
				when 'vimeo.com','www.vimeo.com'
					embed = "<iframe src=\"http://player.vimeo.com/video/REPLACEME\" width=\"500\" height=\"281\" frameborder=\"0\" webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe>"
					self.embed = embed.gsub(/REPLACEME/, parts[5].match(/[0-9]+/)[0]).html_safe
				when 'worldstarhiphop.com', 'www.worldstarhiphop.com'
					page = Nokogiri::HTML(open(url))
					self.embed = page.css(".vidURLField")[1].attr('value').html_safe
				when 'hardsextube.com', 'www.hardsextube.com'
					embed = "<object width=\"510\" height=\"400\"> <param name=\"movie\" value=\"http://www.hardsextube.com/embed/REPLACEME/\"></param><param name=\"allowFullScreen\" value=\"true\"></param><param name=\"AllowScriptAccess\" value=\"always\"></param><param name=\"wmode\" value=\"transparent\"></param><embed src=\"http://www.hardsextube.com/embed/REPLACEME/\" type=\"application/x-shockwave-flash\" wmode=\"transparent\" AllowScriptAccess=\"always\" allowFullScreen=\"true\" width=\"510\" height=\"400\"></embed></object>"
					self.embed = embed.gsub(/REPLACEME/, parts[5].match(/video\/([0-9]+)/)[1]).html_safe
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
				when 'madthumbs.com', 'www.madthumbs.com'
					self.thumbnail_urls['thumbindex'] = 16
					self.thumbnail_urls['thumbindexstart'] = 15
					self.thumbnail_urls['numthumbs']= 50
					(1..50).each do |i|
						self.thumbnail_urls['thumb'+i.to_s] = "http://pics2.madthumbscdn.com/images/t/"+parts[5].match(/videos\/.+?\/.+?\/([0-9]+)/)[1][0..3] +'/'+parts[5].match(/videos\/.+?\/.+?\/([0-9]+)/)[1]+'-'+parts[5].match(/videos\/.+?\/(.+?)\/[0-9]+/)[1]+'-'+(i-1).to_s+'.jpg'
					end
				when 'sublimedirectory.com','www.sublimedirectory.com'
					self.thumbnail_urls['thumbindex'] = 16
					self.thumbnail_urls['thumbindexstart'] = 15
					self.thumbnail_urls['numthumbs']= 50
					(1..50).each do |i|
						self.thumbnail_urls['thumb'+i.to_s] = "http://pics2.madthumbscdn.com/images/t/"+parts[5].match(/videos\/.+?\/.+?\/([0-9]+)/)[1][0..4] +'/'+parts[5].match(/videos\/.+?\/.+?\/([0-9]+)/)[1]+'-'+parts[5].match(/videos\/.+?\/(.+?)\/[0-9]+/)[1]+'-'+(i-1).to_s+'.jpg'
					end
				when 'flingtube.com', 'www.flingtube.com'
					self.thumbnail_urls['thumbindex'] = 1
					self.thumbnail_urls['thumbindexstart'] = 1
					self.thumbnail_urls['numthumbs']= 10
					(1..10).each do |i|
						self.thumbnail_urls['thumb'+i.to_s] = "http://images.flingtube.com/media/thumbs/"+parts[5].match(/videos\/.+?\/([0-9]+)/)[1][0..1] +'/'+parts[5].match(/videos\/.+?\/([0-9]+)/)[1]+'_'+i.to_s+'.jpg'
					end
				when 'fastjizz.com','www.fastjizz.com'
					self.thumbnail_urls['thumbindex'] = 1
					self.thumbnail_urls['thumbindexstart'] = 8
					self.thumbnail_urls['numthumbs']= 16
					(1..16).each do |i|
						self.thumbnail_urls['thumb'+i.to_s] = "http://www.fastjizz.com/media/videos/tmb/"+ parts[5].match(/video\/([0-9]+)/)[1] +'/'+i.to_s+'.jpg'
					end
				when 'yobt.com', 'www.yobt.com'
					page = Nokogiri::HTML(open(url))
					thumbnail_url = page.css('head title')[0].next_sibling['href'].match(/(.*\/)vid_cover/)[1]
					self.thumbnail_urls['thumbindex'] = 1
					self.thumbnail_urls['thumbindexstart'] = 1
					self.thumbnail_urls['numthumbs']= 11
					(1..10).each do |i|
						self.thumbnail_urls['thumb'+i.to_s] = thumbnail_url + 'preview/'+i.to_s+'_200x150.jpg'
					end
				when  'xfapzap.com','www.xfapzap.com'
					parts[5].match(/([0-9]+)\/?/)[1]
				when 'xxxbunker.com', 'www.xxxbunker.com'
					id = nil
					if parts[8] and parts[8].include?('!')
						self.url = 'http://www.xxxbunker.com/'+parts[8].match(/V([0-9]+)/)[1]
						id = parts[8].match(/V([0-9]+)/)[1]
					elsif parts[5] and parts[5].include?('_')
						page = Nokogiri::HTML(open(url))
						id = page.css('link[rel=image_src]')[0].attr('href')[/[0-9]+/]
					elsif parts[5] and parts[5].match(/^\/[0-9]+$/)
						logger.ap parts[5]
						id = parts[5].match(/^\/([0-9]+)$/)[1]
					end
					if id
						self.thumbnail_urls['thumbindex'] = 1
						self.thumbnail_urls['thumbindexstart'] = 1
						self.thumbnail_urls['numthumbs']= 4
						(1..4).each do |i|
							self.thumbnail_urls['thumb'+i.to_s] = "http://www.xxxbunker.com/" +id.to_s+'A-'+i.to_s+'.jpg'
						end
					end
				when 'youtube.com', 'www.youtube.com'
					id = nil
					URI.decode_www_form(URI.split(url)[7..8].join()).each do |a|
						if a[0] == 'v'
							id = a[1]
						end
					end
					if id
						self.thumbnail_urls['thumbindex'] = 1
						self.thumbnail_urls['thumbindexstart'] = 1
						self.thumbnail_urls['numthumbs']= 3
						(1..3).each do |i|
							self.thumbnail_urls['thumb'+i.to_s] = "http://img.youtube.com/vi/" +id.to_s+'/'+i.to_s+'.jpg'
						end
					end
				when 'vimeo.com', 'www.vimeo.com'
					self.thumbnail_urls['thumbindex'] = 1
					self.thumbnail_urls['thumbindexstart'] = 1
					self.thumbnail_urls['numthumbs']= 1
					response = Nokogiri::XML(open("http://vimeo.com/api/v2/video/"+parts[5].match(/[0-9]+/)[0]+".xml"))
					self.thumbnail_urls['thumb1'] = response.css('thumbnail_medium').children.text
				when 'worldstarhiphop.com', 'www.worldstarhiphop.com'
					self.thumbnail_urls['thumbindex'] = 1
					self.thumbnail_urls['thumbindexstart'] = 1
					self.thumbnail_urls['numthumbs']= 4
					vars = decode_www_form(parts[7..8].join())
					vars.each do |v|
						if v[0] == 'v'
							id = v[1]
						end
					end
					if id
						(1..4).each do |i|
							self.thumbnail_urls['thumb'+i.to_s] = "http://i.ytimg.com/vi/" +id.to_s+'/'+(i-1).to_s+'.jpg'
						end
					end
				when 'hardsextube.com', 'www.hardsextube.com'
					page = Nokogiri::HTML(open(url))
					thumbnail_url = page.css('#tab_share input')[1].attr('value').match(/\[img\](.+)\[\/img\]/)[1]
					self.thumbnail_urls['thumbindex'] = 1
					self.thumbnail_urls['thumbindexstart'] = 1
					self.thumbnail_urls['numthumbs']= 16
					(1..16).each do |i|
						self.thumbnail_urls['thumb'+i.to_s] = thumbnail_url.gsub(/\.1\./,'.'+i.to_s+'.')
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