require 'open-uri'
require 'uri'
require 'nokogiri'

module ApplicationHelper


	def getEmbed(url)
		parts = URI.split(url)
		# if parts[0] and parts[2] and parts[5]
		case parts[2]
		when 'www.xvideos.com', 'xvideos.com'
			embed="<iframe src=\"http://flashservice.xvideos.com/embedframe/REPLACEME\"frameborder=0 width=510 height=400 scrolling=no></iframe>"
			return embed.sub(/REPLACEME/, parts[5].match(/[0-9]+/).to_s).html_safe
		when 'www.redtube.com', 'redtube.com'
			embed="<iframe><object height=\"344\" width=\"434\"><param name=\"allowfullscreen\" value=\"true\"><param name=\"movie\" value=\"http://embed.redtube.com/player/\"><param name=\"FlashVars\" value=\"id=REPLACEME&style=redtube&autostart=false\"><embed src=\"http://embed.redtube.com/player/?id=REPLACEME&style=redtube\" allowfullscreen=\"true\" AllowScriptAccess=\"always\" flashvars=\"autostart=false\" pluginspage=\"http://www.adobe.com/shockwave/download/download.cgi?P1_Prod_Version=ShockwaveFlash\" type=\"application/x-shockwave-flash\" height=\"344\" width=\"434\" /></object></iframe>"
			return embed.gsub(/REPLACEME/, parts[5].match(/[0-9]+/).to_s).html_safe
		when 'www.xhamster.com', 'xhamster.com'
			embed="<iframe width=\"510\" height=\"400\" src=\"http://xhamster.com/xembed.php?video=REPLACEME\" frameborder=\"0\" scrolling=\"no\"></iframe>"
			return embed.sub(/REPLACEME/, parts[5].match(/[0-9]+/).to_s).html_safe
		end
		# return nil
	end

	def getThumbnailUrls(url)
		parts = URI.split(url)
		thumbHash = {}
		case parts[2]
		when 'www.xvideos.com', 'xvideos.com'
			page = Nokogiri::HTML(open(url))
			thumbnail_url = page.css('embed#flash-player-embed')[0]['flashvars'].match(/url_bigthumb=(.*?.jpg)/)[1]
			thumbHash['thumbindex'] = thumbHash['thumbindexstart'] = thumbnail_url.match(/.*\.(.+)\.jpg/)[1].to_i
			thumbHash['numthumbs']=30;
			(1..30).each do |i|
				thumbHash['thumb'+i.to_s] = thumbnail_url.sub(/\.[0-9]+\.jpg/, '.'+ i.to_s+'.jpg');
			end
		when 'www.redtube.com', 'redtube.com'
			id = Integer(parts[5][/[0-9]+/])
			id_str= '0'*(7-(id.to_s).length)+(id.to_s)
			thumbnail_url = 'http://img01.redtubefiles.com/_thumbs/0000'+id_str[1..3]+'/'+id_str+'/'+id_str+'_008m.jpg'
			thumbHash['thumbindex'] = thumbHash['thumbindexstart'] = thumbnail_url.match(/(...).\.jpg/)[1].to_i
			thumbHash['numthumbs']=16;
			(1..16).each do |i|
				thumbHash['thumb'+i.to_s] = thumbnail_url.sub(/....\.jpg/, '0'*(3-(i.to_s).length)+(i.to_s)+'m.jpg');
			end
		end
		return thumbHash
	end


	def thumbnail_image_tag(bookmark_url, size = nil)
		# if(bookmark_url.thumbnail_urls['sprite'])
		# 	image_tag('1px.png', :size => size,  :class => 'cycle', :data => bookmark_url.thumbnail_urls, :style => "background-size: 135px 240px; background-image:url(\""+bookmark_url.thumbnail_urls['thumb']+"\"); background-position: 0px -"+bookmark_url.thumbnail_urls['spriteSize'].to_s+"px;").html_safe
		# else
			image_tag(bookmark_url.thumbnail_urls['thumb'+bookmark_url.thumbnail_urls['thumbindexstart'].to_s], :size => size,  :class => 'cycle', :data => bookmark_url.thumbnail_urls).html_safe
		# end
	end

end
