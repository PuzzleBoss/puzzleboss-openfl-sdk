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
import flash.geom.Rectangle;
import flash.net.URLRequest;
import sys.io.File;
import sys.io.FileOutput;
import sys.FileSystem;
import haxe.ds.ArraySort;
import haxe.Json;

class CrossPromotion {

	private static inline var ONE_DAY:Int = 86400;
	private static inline var CACHE_FILE:String = "/promotions.json";
	public static var ready:Bool = false;
	private static var _games:Array<CrossPromotion> = null;

	public var imageurl:String;
	public var url:String;
	public var urlRect:Rectangle;
	public var amazonRect:Rectangle;
	public var amazonPackage:String;
	public var googleRect:Rectangle;
	public var googlePackage:String;
	public var nookRect:Rectangle;
	public var nookEAN:String;
	public var itunesRect:Rectangle;
	public var itunesURL:String;

	public function new() {}

	public static function initialize(preserve:Bool = false) {
		if (!preserve) {
			_games = [];
		}

		// load promotion _games
		var path = Path.path();
		var cachefile = path + CACHE_FILE;

		#if !flash
		if (FileSystem.exists(cachefile)) {
			var cached = File.getContent(cachefile);
			var json = Json.parse(cached);
			var cdate:Int = Std.parseInt(json.cached);
			var cnow:Int = _timestamp();

			// cache for 3 days
			var diff = cnow - cdate;

			if (diff < ONE_DAY) {
				_processData(json.data);
				return;
			}
			else {
				FileSystem.deleteFile(cachefile);
			}
		}
		#end

		try {
			var url = "http://files2.puzzleboss.com/publishernetwork.json?" + Math.random();
			var loader = new URLLoader(_dataLoaded);
			loader.load(new URLRequest(url));
		}
		catch(s:String) {
		}
	}

	private static function _dataLoaded(loader:URLLoader) {
		_processData(Json.parse(loader.data));

		var fout = File.write(Path.path() + CACHE_FILE, true);
		fout.writeString(" { \"cached\": " + _timestamp() + ", \"data\": " + loader.data + " } ");
		fout.close();
	}

	private static function _timestamp():Int {
		return Std.int(Date.now().getTime() / 1000);
	}

	private static function _processData(json:Dynamic) {

		var games:Array<Dynamic> = Reflect.getProperty(json, Settings.APP_STORE);

		for (gdata in games) {

			// note:  at puzzleboss we patch together our promotions with various
			// overlays and dynamically generated logos and stuff, this ensures
			// the test json (ours) will still be okay
			if (!Reflect.hasField(gdata, "imageurl") || !Reflect.hasField(gdata, "hitareas")) {
				continue;
			}

			var cp = new CrossPromotion();
			cp.imageurl = Reflect.hasField(gdata, "imageurl") ? Reflect.getProperty(gdata, "imageurl") : null;

			if (gdata.hitareas.amazon != null) {
				cp.amazonRect = _makeRectangle(gdata.hitareas.amazon.rect);
				cp.amazonPackage = gdata.hitareas.amazon.pkg;
			}

			if (gdata.hitareas.google != null) {
				cp.googleRect = _makeRectangle(gdata.hitareas.google.rect);
				cp.googlePackage = gdata.hitareas.google.pkg;
			}

			if (gdata.hitareas.nook != null) {
				cp.nookRect = _makeRectangle(gdata.hitareas.nook.rect);
				cp.nookEAN = gdata.hitareas.nook.ean;
			}

			if (gdata.hitareas.itunes != null) {
				cp.itunesRect = _makeRectangle(gdata.hitareas.itunes.rect);
				cp.itunesURL = gdata.hitareas.itunes.url;
			}

			if (gdata.hitareas.url != null) {
				cp.url = gdata.hitareas.url.url;
				cp.urlRect = _makeRectangle(gdata.hitareas.url.rect);
			}

			_games.push(cp);
		}

		ready = true;
	}

	private static function _makeRectangle(str:String):Rectangle {
		var sp = str.split(",");
		var rect = new Rectangle();
		rect.x = sp.length > 0 ? Std.parseFloat(sp[0]) * Images.scaleX : 0;
		rect.y = sp.length > 1 ? Std.parseFloat(sp[1]) * Images.scaleY : 0;
		rect.width = sp.length > 2 ? Std.parseFloat(sp[2]) * Images.scaleX : 0;
		rect.height = sp.length > 3 ? Std.parseFloat(sp[3]) * Images.scaleY : 0;
		return rect;
	}

	public static function getGames(num:Int):Array<CrossPromotion> {
		if (_games == null || _games.length == 0) {
			return null;
		}

		var results:Array<CrossPromotion> = [];

		ArraySort.sort(_games, function(a:CrossPromotion, b:CrossPromotion):Int {
			return Math.random() < 0.5 ? -1 : 1;
		});

		for(game in _games) {
			results.push(game);

			if (results.length == num) {
				return results;
			}
		}

		return results;
	}
}
