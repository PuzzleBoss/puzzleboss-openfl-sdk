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
import flash.events.Event;
import flash.net.URLRequest;
import flash.Lib;
#if nook
import openfl.utils.JNI;
#end

class AppLink {

	#if nook
	private static inline var NOOK_JNI_PATH:String = "com/puzzleboss/core/NookStore";
	private static inline var NOOK_JNI_SIGNATURE:String = "(Ljava/lang/String;)Ljava/lang/String;";
	private static inline var NOOK_JNI_METHOD:String = "openShop";
	#end

	private static inline var PLAY_STORE:String = "https://play.google.com/store/apps/details?id=";
	private static inline var AMAZON_STORE:String = "http://www.amazon.com/gp/mas/dl/android?p=";

	public static function twitter(e:Event = null) {
		Analytics.track("/AppLink/twitter/");
		Lib.getURL(new URLRequest("https://twitter.com/puzzleboss"), "_blank");
	}

	public static function website(e:Event = null) {
		Analytics.track("/AppLink/website/");
		Lib.getURL(new URLRequest("http://puzzleboss.com/"), "_blank");
	}

	public static function link(url:String) {
		Lib.getURL(new URLRequest(url), "_blank");
	}

	public static function nook(ean:String, url:String) {

		#if nook
		var nookstore = openfl.utils.JNI.createStaticMethod("com/puzzleboss/core/NookStore", "openShop", "(Ljava/lang/String;)Ljava/lang/String;");

		try {
			nookstore(ean);
		}
		catch(s:String) {
		}

		return;
		#end

		if(url != null && url != "") {
			Lib.getURL(new URLRequest(url));
		}
	}

	public static function google(pkg:String) {
		var url = "market://details?id=" + pkg;
		Lib.getURL(new URLRequest(url));
	}

	public static function amazon(pkg:String) {
		var url = "amzn://apps/android?p=" + pkg;
		Lib.getURL(new URLRequest(url));
	}

	 public static function open(pkg:String = "", ean:String = "")
	{
		if(pkg == null || pkg == "") {
			pkg = Settings.PACKAGE;
		}

		if(ean == null || ean == "") {
			ean = Settings.EAN;
		}

		switch(Settings.APP_STORE) {
			case "google":
			google(pkg);

			case "amazon":
			amazon(pkg);

			#if nook
			case "nook":
			var nookstore = openfl.utils.JNI.createStaticMethod("com/puzzleboss/core/NookStore", "openShop", "(Ljava/lang/String;)");

			try {
				nookstore(ean);
			}
			catch(s:String) {
			}

			return;
			#end
		}
	}

}
