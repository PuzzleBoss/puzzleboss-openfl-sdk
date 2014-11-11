package puzzleboss;

class Settings
{
    private function new() { }

    // used in social media sharing
    public static inline var NAME:String = "Amazing Jigsaw Puzzles";

    // this will be your folder on the website, eg puzzleboss.com/TYPE/SHORTNAME
    public static inline var SHORT_NAME:String = "amazing";

    // your game genre
    public static inline var TYPE:String = "jigsaw";

    // the marketplace the game's compiled for
    public static inline var VENDOR:String = "amazon";

    // your package name for the game
    public static inline var PACKAGE:String = "com.puzzleboss.jigsaw.Amazing.amazon";

    // game version
    public static inline var VERSION:String = "1.7.0";

    // for the NOOK appstore only
    public static inline var EAN:String = "";

    // for social media sharing (we can host this)
    public static inline var SHARE_IMAGE:String = "http://files.puzzleboss.com/yourgame/pic.jpg";
}
