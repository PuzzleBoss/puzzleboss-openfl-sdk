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
import flash.filters.GlowFilter;
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
	private static var CACHE:Map<String, BitmapData> = null;
	private static var fontname:String = null;
	public var text:String;
	public var textfield:TextField;

	public function centerVertically(parentheight:Float):Void
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
		refreshText(ptext, psize, center, ptype, color, forcewidth, pmultiline);
	}

	public static function TextField(ptext:String = "", psize:Int=20, center:Bool=false,
						ptype:String=null, color:Int = -1,
						forcewidth:Int = 1, pmultiline:Bool = false):TextField
	{
		var lb = new Label();
		return lb.createTextField(ptext, psize, center, "none", ptype, color, forcewidth, pmultiline, false);
	}

	public function refreshText(ptext:String = "", psize:Int=20, center:Bool=false,
								ptype:String=null, color:Int = -1,
								forcewidth:Int = 1, pmultiline:Bool = false, attachbitmap:Bool = true):Void
	{
		if(CACHE == null)
		{
			CACHE = new Map<String, BitmapData>();
		}

		text = StringTools.trim(ptext);

		if(numChildren > 0)
		{
			while(numChildren > 0)
			{
				removeChildAt(0);
			}
		}

		#if html5
		var bmp = Fonts.render(text, psize, color);
		addChild(bmp);
		return;
		#else

		#if flash
		psize -= 2;
		#elseif android
		if(Images.WIDTH >= 1280)
		{
			psize = Std.int(psize * 1.7);
		}
		else
		{
			psize = Std.int(psize * 1.4);
		}
		#end

		if(fontname == null)
		{
			#if flash
			fontname = "Droid Sans Bold";
			#else
			fontname = Assets.getFont("fonts/DroidSansBold.ttf").fontName;
			#end
		}

		var pautosize:String = "left";

		if(forcewidth > 1)
		{
			pautosize = "none";//TextFieldAutoSize.NONE;
			width = forcewidth;
		}

		if(ptype == null)
		{
			ptype = "dynamic";//TextFieldType.DYNAMIC;
		}

		if(color == -1)
		{
			color = 0xFFFFFF;
		}

		var key = text + psize + fontname + pautosize + width + ptype + color;


		attachbitmap = false;

		/*if(attachbitmap)
		{
			var tb:BitmapData;

			if(CACHE[key] == null)
			{
				var tl = createTextField(ptext, psize, center, pautosize, ptype, color, forcewidth, pmultiline);
				tb = draw(tl);

				if(color > 0x000000)
				{
					tb.applyFilter(tb, tb.rect, new Point(), new GlowFilter(0x000000, 0.5, 8, 8, 12));
				}

				CACHE[key] = tb;
			}

			tb = CACHE[key];

			var bitmap = new Bitmap(tb);
			bitmap.scaleX = 0.25;
			bitmap.scaleY = 0.25;
			addChild(bitmap);

			tw = tb.width * 0.25;
			th = tb.height * 0.25;
		}
		else
		{*/
			textfield = createTextField(text, psize, center, pautosize, ptype, color, forcewidth, pmultiline);
			addChild(textfield);
			//tw = textfield.textWidth;
			//th = textfield.textHeight;
	//	}
		#end
	}

	private function createTextField(ptext:String = "", psize:Int=20, center:Bool=false,
								pautosize:String=null, ptype:String=null, color:Int = -1,
								forcewidth:Int = 1, pmultiline:Bool = false, attachbitmap:Bool = true):TextField
	{
		var tf = new TextFormat(fontname);
		tf.color = color;
		tf.align = center ? TextFormatAlign.CENTER : TextFormatAlign.LEFT;
		tf.size = psize;

		var tl = new TextField();
		tl.multiline = pmultiline || forcewidth > 1;
		tl.setTextFormat(tf);

		switch(pautosize)
		{
			case "left":
			tl.autoSize = TextFieldAutoSize.LEFT;
			case "right":
			tl.autoSize = TextFieldAutoSize.RIGHT;
			case "center":
			tl.autoSize = TextFieldAutoSize.CENTER;
			case "none":
			tl.autoSize = TextFieldAutoSize.NONE;
		}

		switch(ptype)
		{
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
