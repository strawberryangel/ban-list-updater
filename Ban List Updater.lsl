#include "ban-updater/ban.h"
#include "ban-updater/whitelist.lsl" 
#include "lib/avatar.lsl"

		string VERSION = "1.3.0";

say(string message)
{
	llInstantMessage(WL_Sophie, message);
}

AddTempBan(key agent)
{
	say("Temporarily banning " + format_name(agent) + " for " + (string)DEAULT_BAN_TIME + " hourse.");
	llAddToLandBanList(agent, DEAULT_BAN_TIME);
}

SendHTTP()
{
	string post = "https://script.google.com/macros/s/AKfycbzUyVzx4PlIUgaGjYAHQ2pfbPAxmr7Wt5qAFXkWjXY7WI48mU7b/exec";

	list params = [
		HTTP_METHOD, "GET",
		HTTP_MIMETYPE, "application/x-www-form-urlencoded;charset=utf-8",
		HTTP_BODY_MAXLENGTH, 16384];
	string body = "";

	string url = post + "?" + body;
	llHTTPRequest(post, params, body);
}


UpdateBanList(list banlist)
{
	say("Resetting ban list.");
	llResetLandBanList();
	integer length = llGetListLength(banlist);
	say("Reloading ban list with " + (string)length + " bad apples.");
	integer i = 0;
	while(i < length)
	{
		key badApple = (key)llList2String(banlist, i);

		if(badApple == NULL_KEY)
			say("Cannot get key for index #" + (string)i);
		else
			llAddToLandBanList(badApple, 0);

		i++;
	}
	say("Update complete.");
}


default
{
	http_response( key request_id, integer status, list metadata, string body )
	{
		if(status == 200) {
			list banlist = llParseString2List(body, [","], []);
			if(llGetListLength(banlist) > 0)
				UpdateBanList(banlist);
		}
	}
	listen(integer channel, string name, key id, string message)
	{
		if(channel == REGION_CHANNEL && message == "update") SendHTTP();
		if(channel == REGION_TEMP_BAN_CHANNEL) AddTempBan((key)message);
	}
	state_entry()
	{
		llListen(REGION_CHANNEL, "", NULL_KEY, "");
		llListen(REGION_TEMP_BAN_CHANNEL, "", NULL_KEY, "");
	}
	touch_end(integer total_number)
	{
		SendHTTP();
	}
}

