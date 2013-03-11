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
			@embed_domains ||= ['xvideos.com','www.xvideos.com','redtube.com','www.redtube.com','xhamster.com','www.xhamster.com','tube8.com','www.tube8.com', 'pornhub.com', 'www.pornhub.com']
		end

		def thumbnail_domains
			@thumbnail_domains ||= ['xvideos.com','www.xvideos.com','redtube.com','www.redtube.com', 'xhamster.com', 'www.xhamster.com','slutload.com','www.slutload.com','tube8.com','www.tube8.com', 'pornhub.com', 'www.pornhub.com']
		end

		def set_embed
			parts = URI.split(self.url)
			# embedFinal = ""
			if (embed_domains.include? parts[2])
				case parts[2]
				when 'www.xvideos.com', 'xvideos.com'
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
					self.embed = embed.sub(/REPLACEME/, parts[5].match(/\/.+\/[0-9]+\//).to_s)
				when 'pornhub.com','www.pornhub.com'
					embed= "<iframe src=\"http://www.pornhub.com/embed/REPLACEME\" frameborder=\"0\" width=\"608\" height=\"481\" scrolling=\"no\"></iframe>"
					self.embed = embed.sub(/REPLACEME/, parts[7].match(/viewkey=([0-9]+)/)[1])
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
					self.thumbnail_urls['numthumbs']=30;
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
					"http://i4-sec.slutload-media.com/U/w/v/B/UwvBjPPQoW8.240x180.10.jpg"
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