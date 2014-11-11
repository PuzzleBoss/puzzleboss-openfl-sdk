#if android

package puzzleboss;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.display.DisplayObjectContainer;
import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.filters.GlowFilter;
import flash.geom.Rectangle;
import flash.Lib;
import motion.Actuate;
import openfl.utils.JNI;

/**
* ...
* @author Ben Lowry
*/
class Support extends Sprite
{
    private var note:Label;
    private var onclose:Event->Void;

    public function new(ponclose:Event->Void) {
        super();
        onclose = ponclose;
        scrollRect = new Rectangle(0, 0, Images.WIDTH, Images.HEIGHT);
        addEventListener(Event.ADDED_TO_STAGE, init);
        addEventListener(Event.REMOVED_FROM_STAGE, dispose);
    }

    private function init(e:Event):Void {
        removeEventListener(Event.ADDED_TO_STAGE, init);

        var container = new Sprite();
        addChild(container);

        var label = new Label("PuzzleBoss support: support@puzzleboss.com", 20);
        label.x = 10;
        label.y = 10;
        container.addChild(label);

        var label2 = new Label("If you email from your computer please include this information, it will automatically\n" +
                               "be included if you press 'Send email'.  Support available in English only!\n\n" +
                               "Uninstalling the app and then downloading again often fixes problems.", 14);
        label2.x = 10;
        label2.y = label.y + label.height + 16;
        container.addChild(label2);

        var data = getJNIData();
        data.push("Screen resolution: " + Images.WIDTH + "x" + Images.HEIGHT);
        data.push("Game: " + Settings.NAME);
        data.push("Store: " + Settings.VENDOR);
        data.push("Version: " + Settings.VERSION);

        note = new Label(data.join("\n"), 14);
        note.x = label.x;
        note.y = label2.y + label2.height + 20;
        container.addChild(note);

        container.x = Math.floor((Images.WIDTH - container.width) / 2);
        container.y = Math.floor((Images.HEIGHT - container.height) / 2);

        var buttons = new Sprite();
        addChild(buttons);

        var homeButton = new TextButton("Back", close);
        buttons.addChild(homeButton);

        var emailButton = new TextButton("Send email", sendMail);
        emailButton.x = homeButton.x + homeButton.width + 20;
        buttons.addChild(emailButton);

        buttons.x = Math.floor((Images.WIDTH - buttons.width) / 2);
        buttons.y = Images.HEIGHT - buttons.height - 20;
    }

    private function sendMail(e:Event):Void {
        var send = openfl.utils.JNI.createStaticMethod("com/puzzleboss/core/Support", "sendEmail", "(Ljava/lang/String;)V");
        send(note.text);
    }

    private static function getJNIData():Array<String> {
        var data = new Array<String>();
        var jni = "com/puzzleboss/core/Support";
        var getOS = openfl.utils.JNI.createStaticMethod(jni, "getOS", "()Ljava/lang/String;");
        var getAPILevel = openfl.utils.JNI.createStaticMethod(jni, "getAPILevel", "()Ljava/lang/String;");
        var getDevice = openfl.utils.JNI.createStaticMethod(jni, "getDevice", "()Ljava/lang/String;");
        var getModel = openfl.utils.JNI.createStaticMethod(jni, "getModel", "()Ljava/lang/String;");
        var getProduct = openfl.utils.JNI.createStaticMethod(jni, "getProduct", "()Ljava/lang/String;");

        var os:String = getOS();
        if(os.indexOf("-") > -1)
        {
            os = os.substr(0, os.indexOf("-"));
        }

        data.push("OS: " + os);
        data.push("API Level: " + getAPILevel());
        data.push("Device: " + getDevice());
        //data.push("Model: " + getModel());
        //data.push("Product: " + getProduct());

        return data;
    }

    private function close(e:Event):Void {
        onclose(e);
    }

    private function dispose(e:Event):Void {
        removeEventListener(Event.ADDED_TO_STAGE, init);
        removeEventListener(Event.REMOVED_FROM_STAGE, dispose);
    }
}

#end
