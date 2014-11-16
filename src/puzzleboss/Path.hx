package puzzleboss;

#if (!html5 && !flash)
import sys.io.File;
import sys.io.FileOutput;
import sys.io.FileInput;
import sys.FileSystem;
#end

class Path
{
    private static var _path:String = null;

    public static function reset():Void {
        _path = null;
        path();
    }

    public static function path():String {
      if(_path != null) {
        return _path;
      }

      var getpath = openfl.utils.JNI.createStaticMethod("com/puzzleboss/core/Path", "getPath", "(Ljava/lang/String;)Ljava/lang/String;");
      _path = getpath(Settings.PUBLIC_STORAGE);
      return _path;
    }
}
