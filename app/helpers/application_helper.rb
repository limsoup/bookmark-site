require 'open-uri'
require 'uri'

module ApplicationHelper
	def embedVideo(url)
		parts = URI.split(url)
		if parts[0] and parts[2] and parts[5]
			case parts[2]
			when 'www.xvideos.com', 'xvideos.com'
				embed="<iframe src=\"http://flashservice.xvideos.com/embedframe/REPLACEME\"frameborder=0 width=510 height=400 scrolling=no></iframe>"
				return embed.sub(/REPLACEME/, parts[5].match(/[0-9]+/).to_s).html_safe
			when 'www.redtube.com', 'redtube.com'
				embed="<object height=\"344\" width=\"434\"><param name=\"allowfullscreen\" value=\"true\"><param name=\"movie\" value=\"http://embed.redtube.com/player/\"><param name=\"FlashVars\" value=\"id=REPLACEME&style=redtube&autostart=false\"><embed src=\"http://embed.redtube.com/player/?id=REPLACEME&style=redtube\" allowfullscreen=\"true\" AllowScriptAccess=\"always\" flashvars=\"autostart=false\" pluginspage=\"http://www.adobe.com/shockwave/download/download.cgi?P1_Prod_Version=ShockwaveFlash\" type=\"application/x-shockwave-flash\" height=\"344\" width=\"434\" /></object>"
				return embed.gsub(/REPLACEME/, parts[5].match(/[0-9]+/).to_s).html_safe
			when 'www.xhamster.com', 'xhamster.com'
				embed="<iframe width=\"510\" height=\"400\" src=\"http://xhamster.com/xembed.php?video=REPLACEME\" frameborder=\"0\" scrolling=\"no\"></iframe>"
				return embed.sub(/REPLACEME/, parts[5].match(/[0-9]+/).to_s).html_safe
			end
		end
		return nil
	end
end
#<param name=\"AllowScriptAccess\" value=\"always\">