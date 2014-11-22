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
import flash.display.BitmapData;
import flash.events.Event;
import flash.geom.Rectangle;
import flash.net.URLRequest;
import haxe.Timer;
import sys.io.File;
import sys.io.FileOutput;
import sys.io.FileInput;
import sys.FileSystem;
import haxe.ds.ArraySort;
import haxe.Json;

class CrossPromotion {

	private static inline var THREE_DAYS:Int = 259200;
	public static var ready:Bool = false;
	private static var _games:Array<CrossPromotion> = null;

	public var ean:String;
	public var pkg:String;
	public var imageurl:String;

	public function new() {
	}

	public static function initialize(preserve:Bool = false) {
		if (!preserve) {
			_games = [];
		}

		// load promotion _games
		var path = Path.path();
		var cachefile = path + "promotions.json";
		var url = "http://files2.puzzleboss.com/publishernetwork.json?" + Math.random();
		var loader = new URLLoader(_processData);
		var path = Path.path();

		#if !flash
		if (FileSystem.exists(cachefile)) {
			var cached = File.getContent(cachefile);
			var json = haxe.Json.parse(cached);
			var cdate = json.cached;
			var cnow = Timer.stamp();

			// cache for 3 days
			var diff = cnow - cdate;

			if (diff < THREE_DAYS) {
				loader.data = cached;
				_processData(loader);
				return;
			}
			else {
				FileSystem.deleteFile(cachefile);
			}
		}
		#end

		try {
			loader.load(new URLRequest(url));
		}
		catch(s:String)
		{
		}
	}

	private static function _processData(loader:URLLoader) {
		var json:Dynamic = null;

		try {
			json = Json.parse(loader.data);
		}
		catch(s:String) {
			return;
		}

		if (json == null) {
			return;
		}

		var games:Array<Dynamic> = Reflect.getProperty(json, Settings.VENDOR);

		for (gdata in games) {

			// note:  at puzzleboss we patch together our promotions with various
			// overlays and dynamically generated logos and stuff, this ensures
			// the test json (ours) will still be okay
			if (!Reflect.hasField(gdata, "imageurl")) {
				continue;
			}

			var cp = new CrossPromotion();
			cp.pkg = Reflect.getProperty(gdata, "package");

			if(cp.pkg == Settings.PACKAGE) {
				continue;
			}

			cp.imageurl = Reflect.hasField(gdata, "imageurl") ? Reflect.getProperty(gdata, "imageurl") : null;
			cp.ean = Reflect.hasField(gdata, "ean") ? Reflect.getProperty(gdata, "ean") : null;
			_games.push(cp);
		}

		ready = true;
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
