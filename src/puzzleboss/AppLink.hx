package puzzleboss;

import flash.events.Event;
import flash.net.URLRequest;
import flash.Lib;

#if android
import openfl.utils.JNI;
#end

/**
* ...
* @author Ben Lowry
*/
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

		var nookstore = JNI.createStaticMethod(nookJNIPath, NOOK_JNI_METHOD, nookJNISignature);

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
