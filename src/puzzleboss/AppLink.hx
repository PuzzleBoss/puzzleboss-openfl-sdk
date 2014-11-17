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

	public static function open(pkg:String = "", ean:String = "", store:String = "") {
		if (pkg == null || pkg == "") {
			pkg = Settings.PACKAGE;
		}

		if (ean == null || ean == "") {
			ean = Settings.EAN;
		}

		if (pkg.indexOf(".") == -1) {
			pkg = "com.puzzleboss.jigsaw." + pkg;

			#if (flash || html5)
			pkg += "." + store;
			#elseif amazon
			pkg += ".amazon";
			#elseif samsung
			pkg += ".samsung";
			#else
			pkg += ".google";
			#end
		}

		#if nook
		var nookstore = JNI.createStaticMethod(NOOK_JNI_PATH, NOOK_JNI_METHOD, NOOK_JNI_SIGNATURE);

		try {
			nookstore(ean);
		}
		catch(s:String) {
		}

		return;
		#end

		var purl:String = null;

		#if !android
		purl = (store == "google" ? PLAY_STORE : AMAZON_STORE) + pkg;
		#elseif amazon
		purl = "amzn://apps/android?p=" + pkg;
		#elseif google
		purl = "market://details?id=" + pkg;
		#elseif samsung
		purl = "samsungapps://ProductDetail/" + pkg;
		#end

		if (purl != null) {
			Lib.getURL(new URLRequest(purl));
		}
	}
}
