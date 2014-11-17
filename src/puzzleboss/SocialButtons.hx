/*
PuzzleBoss APIs and SDKs are licensed under the MIT license.  Certain
portions may come from 3rd parties and carry their own licensing
terms and are referenced where applicable.

https://github.com/puzzleboss/puzzleboss-openfl-sdk

Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the "Software"),
to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
IN THE SOFTWARE.
*/

package puzzleboss;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.net.URLRequest;
import flash.Lib;
import motion.Actuate;
import openfl.utils.JNI;

class SocialButtons extends Sprite {

	private static inline var JNI_PATH:String = "com/puzzleboss/core/Social";

	public static function facebook(pkg:String = "", name:String="") {
		if (pkg == null || pkg == "") {
			pkg = Settings.PACKAGE;
		}

		var storelink = "http://puzzleboss.com/" + Settings.TYPE + "/" + pkg;
		var fallback = "http://www.facebook.com/sharer.php?u=" + StringTools.htmlEscape(storelink) + "&t=" + name;

		#if !android
		Lib.getURL(new URLRequest(fallback));
		#else
		var send = JNI.createStaticMethod(JNI_PATH, "facebookShare", "(Ljava/lang/String;Ljava/lang/String;)V");
		send(storelink, fallback);
		#end

		Analytics.track("/SocialButtons/facebook/" + pkg);
	}

	public static function email(pkg:String = "", name:String = "") {
		if (pkg == null || pkg == "") {
			pkg = Settings.PACKAGE;
		}

		var storelink = "http://puzzleboss.com/" + Settings.TYPE + "/" + pkg;

		#if !android
		Lib.getURL(new URLRequest(storelink));
		#else
		var send = JNI.createStaticMethod(JNI_PATH, "emailShare", "(Ljava/lang/String;Ljava/lang/String;)V");
		send(storelink, name);
		#end

		Analytics.track("/SocialButtons/email/" + pkg);
	}

	public static function pinterest(pkg:String = "", name:String = "") {
		if (pkg == null || pkg == "") {
			pkg = Settings.PACKAGE;
		}

		var storelink = "http://puzzleboss.com/"+  Settings.TYPE + "/" + pkg;
		var imageurl = Settings.SHARE_IMAGE;
		var fallback = "http://www.pinterest.com/pin/create/button/" +
		"?url=" + StringTools.htmlEscape(storelink) +
		"&media=" + StringTools.htmlEscape(imageurl) +
		"&description=" + StringTools.htmlEscape(name);

		#if !android
		Lib.getURL(new URLRequest(fallback));
		#else

		var send = JNI.createStaticMethod(JNI_PATH, "pinterestShare",
		"(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V");
		send(storelink, imageurl, name, fallback);
		#end

		Analytics.track("/SocialButtons/pinterest/" + pkg);
	}

	public static function googleplus(pkg:String = "") {
		if (pkg == null || pkg == "") {
			pkg = Settings.PACKAGE;
		}

		var storelink = "http://puzzleboss.com/"+  Settings.TYPE + "/" + pkg;
		var fallback = "https://plus.google.com/share?url=" + StringTools.htmlEscape(storelink);

		#if !android
		Lib.getURL(new URLRequest(fallback));
		#else
		var send = JNI.createStaticMethod(JNI_PATH, "googleShare", "(Ljava/lang/String;Ljava/lang/String;)V");
		send(storelink, fallback);
		#end

		Analytics.track("/SocialButtons/googleplus/" + pkg);
	}

	public static function twitter(pkg:String = "") {
		if (pkg == null || pkg == "") {
			pkg = Settings.PACKAGE;
		}

		var storelink = "http://puzzleboss.com/"+  Settings.TYPE + "/" + pkg;
		var fallback = "https://twitter.com/intent/tweet?original_referer=&text=&url=" + StringTools.htmlEscape(storelink);

		#if !android
		Lib.getURL(new URLRequest(fallback));
		#else

		var send = JNI.createStaticMethod(JNI_PATH, "twitterShare", "(Ljava/lang/String;Ljava/lang/String;)V");
		send(storelink, fallback);
		#end

		Analytics.track("/SocialButtons/twitter/" + pkg);
	}
}
