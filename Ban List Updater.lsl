SendHTTP(key id)
{
	string post = "https://script.google.com/macros/s/AKfycbzUyVzx4PlIUgaGjYAHQ2pfbPAxmr7Wt5qAFXkWjXY7WI48mU7b/exec";

	list params =
		[
			HTTP_METHOD, "GET",
		HTTP_MIMETYPE, "application/x-www-form-urlencoded;charset=utf-8",
		HTTP_BODY_MAXLENGTH, 16384
			];
	string body = "";

	string url = post + "?" + body;
	llHTTPRequest(post, params, body);
}


UpdateBanList(list banlist)
{
	llSay(PUBLIC_CHANNEL, "Resetting ban list.");
	llResetLandBanList();
	integer length = llGetListLength(banlist);
	llSay(PUBLIC_CHANNEL, "Reloading ban list with " + (string)length + " bad apples.");
	integer i = 0;
	while(i < length)
	{
		key badApple = (key)llList2String(banlist, i);

		if(badApple == NULL_KEY)
			llSay(PUBLIC_CHANNEL, "Cannot get key for index #" + (string)i);
		else
			llAddToLandBanList(badApple, 0);

		i++;
	}
	llSay(PUBLIC_CHANNEL, "Update complete.");
}


default
{
	touch_start(integer num)
	{
		SendHTTP(llDetectedKey(0));
	}
	http_response( key request_id, integer status, list metadata, string body )
	{
		list banlist = llParseString2List(body, [","], []);
		UpdateBanList(banlist);
	}
}