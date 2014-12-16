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
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.geom.Rectangle;
import flash.geom.Matrix;
import openfl.Assets;
import flash.Lib;

class Images {
	private static var _cache:Map<String, BitmapData> = null;
	public static var width:Int;
	public static var height:Int;
	public static var scaleX:Float;
	public static var scaleY:Float;
	private static inline var TARGETWIDTH:Int = 2560;
	private static inline var TARGETHEIGHT:Int = 1600;

	public static function initialize() {

		if (_cache == null) {
			_cache = new Map<String, BitmapData>();
		}

		width = Lib.current.stage.stageWidth;
		height = Lib.current.stage.stageHeight;
		scaleX = width / TARGETWIDTH;
		scaleY = height / TARGETHEIGHT;
	}

	public static function attach(image:String, parent:DisplayObject, flipped:Bool = false) {
		var img = load(image);

		if (flipped) {
			img = _flip(img);
		}

		if (Std.is(parent, Bitmap)) {
			cast(parent, Bitmap).bitmapData = img;
		}
		else if (Std.is(parent, Sprite)) {
			cast(parent, Sprite).addChild(new Bitmap(img));
		}
	}

	public static function load(image:String):BitmapData {
		var key = "images." + image;

		if (image.indexOf(".") == -1) {
			image += ".png";
		}

		if (_cache[key] == null) {
			var bmp = Assets.getBitmapData("images/" + image, false);

			if (image != "playstore" && image != "amazonstore" && (scaleX != 1 || scaleY != 1)) {
				bmp = _resize(bmp, scaleX);
			}

			_cache[key] = bmp;
		}

		return _cache[key];
	}

	private static function _resize(pic:BitmapData, scale:Float=0, width:Int=0, height:Int=0,
	basewidth:Int=0, baseheight:Int=0):BitmapData {

		var scaled:BitmapData;

		// just cropping off the bottom or right
		if (width == pic.width || height == pic.height) {
			return pic;
		}

		if (basewidth == 0) {
			basewidth = scale > 0 ? Std.int(pic.width * scale) : pic.width;
		}

		if (baseheight == 0) {
			baseheight = scale > 0 ? Std.int(pic.height * scale) : pic.height;
		}

		// resizing
		var matrix = new Matrix();

		if (scale == 0) {
			matrix.scale(width / basewidth, height / baseheight);
		}
		else {
			matrix.scale(scale, scale);
		}

		if (basewidth == 0) {
			basewidth = width;
		}

		if (baseheight == 0) {
			baseheight = height;
		}

		var pw:Int = Std.int(Math.ceil(pic.width * matrix.a));
		var ph:Int = Std.int(Math.ceil(pic.height * matrix.d));

		if (width > 0 && width != pw) {
			pw = width;
		}

		if (height > 0 && height != ph) {
			ph = height;
		}

		matrix.identity();
		matrix.scale(pw / pic.width, ph / pic.height);

		scaled = new BitmapData(pw, ph, true, 0x00000000);
		scaled.draw(pic, matrix);

		if (width == 0 && height == 0) {
			return scaled;
		}

		// cropping
		if (width > 0 && scaled.width > width) {
			return _crop(scaled, new Rectangle(Math.ceil((scaled.width - width) / 2), 0, width, scaled.height));
		}

		if (height > 0 && scaled.height > height) {
			return _crop(scaled, new Rectangle(0, Math.ceil((scaled.height - height) / 2), scaled.width, height));
		}

		return scaled;
	}

	private static function _crop(pic:BitmapData, rect:Rectangle):BitmapData {
		var cropped = new BitmapData(Std.int(rect.width), Std.int(rect.height));
		cropped.draw(pic);
		return cropped;
	}

	private static function _flip(b:BitmapData):BitmapData {
		var m = new Matrix( -1, 0, 0, 1, b.width, 0);
		var b2 = new BitmapData(b.width, b.height, true, 0x00000000);
		b2.draw(b, m);
		return b2;
	}
}
