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
        #if (flash || html5)
        return null;
        #else

        if(_path != null) {
            return _path;
        }

        #if android
        var prefix:String = FileSystem.exists("/media/") ? "/media/" : "/sdcard/";
        #elseif ios
        var prefix = SystemPath.applicationStorageDirectory;
        #else
        var prefix = SystemPath.userDirectory;

        #if windows
        prefix += "\\";
        #else
        prefix += "/";
        #end
        #end

        if(!FileSystem.exists(prefix)) {
            FileSystem.createDirectory(prefix);
        }

        prefix += "puzzleboss";

        if(!FileSystem.exists(prefix)) {
            FileSystem.createDirectory(prefix);
        }

        #if windows
        prefix += "\\" + Settings.SHORT_NAME + "\\";
        #else
        prefix += "/" + Settings.SHORT_NAME + "/";
        #end

        if(!FileSystem.exists(prefix)) {
            FileSystem.createDirectory(prefix);
        }

        _path = prefix;
        return _path;
        #end
    }
}
