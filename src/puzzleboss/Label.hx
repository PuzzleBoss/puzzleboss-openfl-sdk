package puzzleboss;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFieldAutoSize;
import flash.text.TextFieldType;
import flash.text.TextFormatAlign;
import flash.text.Font;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.utils.ByteArray;
import openfl.Assets;

/**
* ...
* @author Ben Lowry
*/


class Label extends Sprite
{
	private static var _cache:Map<String, BitmapData> = null;
	private static var _fontName:String = null;
	public var text:String;
	public var textfield:TextField;

	public function centerVertically(parentheight:Float)
	{
		#if html5
		y = Math.floor((parentheight - height) / 2);
		#else
		y = Math.floor((parentheight - textfield.textHeight) / 2);
		#end
	}

	public function new(ptext:String = "", psize:Int=20, center:Bool=false, ptype:String=null, color:Int = -1,
	forcewidth:Int = 1, pmultiline:Bool = false)
	{
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
			_fontName = Assets.getFont("fonts/DroidSansBold.ttf")._fontName;
			#end
		}

		var pautosize:String = "left";

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

		var key = text + psize + _fontName + pautosize + width + ptype + color;
		attachbitmap = false;

		textfield = _createTextField(text, psize, center, pautosize, ptype, color, forcewidth, pmultiline);
		addChild(textfield);
	}

	private function _createTextField(ptext:String = "", psize:Int=20, center:Bool=false,
	pautosize:String=null, ptype:String=null, color:Int = -1,
	forcewidth:Int = 1, pmultiline:Bool = false, attachbitmap:Bool = true):TextField
	{
		var tf = new TextFormat(_fontName);
		tf.color = color;
		tf.align = center ? TextFormatAlign.CENTER : TextFormatAlign.LEFT;
		tf.size = psize;

		var tl = new TextField();
		tl.multiline = pmultiline || forcewidth > 1;
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

		return tl;
	}
}
