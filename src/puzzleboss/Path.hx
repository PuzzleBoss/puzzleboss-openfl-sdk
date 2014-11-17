package puzzleboss;

#if android
import openfl.utils.JNI;
#end

class Path {

	private static inline var JNI_PATH:String = "com/puzzleboss/core/Path";
	private static inline var JNI_SIGNATURE:String = "(Ljava/lang/String;)Ljava/lang/String;";
	private static var _path:String = null;

	public static function reset() {
		_path = null;
		path();
	}

	public static function path():String {
		if (_path != null) {
			return _path;
		}

		var getpath = JNI.createStaticMethod(JNI_PATH, "getPath", JNI_SIGNATURE);
		_path = getpath(Settings.PUBLIC_STORAGE);
		return _path;
	}
}
