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
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFieldAutoSize;
import flash.text.TextFieldType;
import flash.text.TextFormatAlign;
import openfl.Assets;

class Label extends Sprite {
	private static var _cache:Map<String, BitmapData> = null;
	private static var _fontName:String = null;
	public var text:String;
	public var textfield:TextField;

	public function centerVertically(parentheight:Float) {
		#if html5
		y = Math.floor((parentheight - height) / 2);
		#else
		y = Math.floor((parentheight - textfield.textHeight) / 2);
		#end
	}

	public function new(ptext:String = "", psize:Int=20, center:Bool=false, ptype:String=null, color:Int = -1,
	forcewidth:Float = 1, pmultiline:Bool = false) {
		super();

		if (_cache == null) {
			_cache = new Map<String, BitmapData>();
		}

		text = StringTools.trim(ptext);

		while(numChildren > 0) {
			removeChildAt(0);
		}

		#if html5
		var bmp = Fonts.render(text, psize, color);
		addChild(bmp);
		return;
		#end

		#if flash
		psize -= 2;
		#elseif android
		psize = Images.width > 1280 ? Std.int(psize * 1.7) : Std.int(psize * 1.4);
		#end

		if (_fontName == null) {
			#if flash
			_fontName = "Droid Sans Bold";
			#else
			_fontName = Assets.getFont("fonts/DroidSansBold.ttf").fontName;
			#end
		}

		var pautosize = "left";

		if (forcewidth > 1) {
			pautosize = "none";//TextFieldAutoSize.NONE;
			width = forcewidth;
		}

		if (ptype == null) {
			ptype = "dynamic";//TextFieldType.DYNAMIC;
		}

		if (color == -1) {
			color = 0xFFFFFF;
		}

		textfield = _createTextField(text, psize, center, pautosize, ptype, color, forcewidth, pmultiline);
		addChild(textfield);
	}

	private function _createTextField(ptext:String = "", psize:Int=20, center:Bool=false,
	pautosize:String=null, ptype:String=null, color:Int = -1,
	forcewidth:Float = 1, pmultiline:Bool = false, attachbitmap:Bool = true):TextField {

		var tf = new TextFormat(_fontName);
		tf.color = color;
		tf.align = center ? TextFormatAlign.CENTER : TextFormatAlign.LEFT;
		tf.size = psize;

		var tl = new TextField();
		tl.multiline = pmultiline;
		tl.setTextFormat(tf);

		switch(pautosize) {
			case "left":
			tl.autoSize = TextFieldAutoSize.LEFT;
			case "right":
			tl.autoSize = TextFieldAutoSize.RIGHT;
			case "center":
			tl.autoSize = TextFieldAutoSize.CENTER;
			case "none":
			tl.autoSize = TextFieldAutoSize.NONE;
		}

		switch(ptype) {
			case "input":
			tf.color = 0xFFFFFF;
			tl.defaultTextFormat = tf;
			tl.type = TextFieldType.INPUT;
			tl.setTextFormat(tf);
			case "dynamic":
			tl.defaultTextFormat = tf;
			tl.type = TextFieldType.DYNAMIC;
			tl.selectable = false;
		}

		tl.text = ptext;

		if (forcewidth > 1) {
			tl.width = forcewidth;
		}

		return tl;
	}
}
