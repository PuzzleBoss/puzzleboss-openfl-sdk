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
import openfl.utils.JNI;
import sys.FileSystem;

class Path {
	private static inline var JNI_PATH:String = "com/puzzleboss/core/Path";
	private static inline var JNI_SIGNATURE:String = "(Ljava/lang/String;)Ljava/lang/String;";
	private static inline var JNI_SUPPORT:String = "com/puzzleboss/core/Support";
	private static var _path:String = null;

	public static function reset() {
		_path = null;
		path();
	}

	public static function path():String {
		if (_path != null) {
			return _path;
		}

		#if android
		var getAPILevel = JNI.createStaticMethod(JNI_SUPPORT, "getAPILevel", "()Ljava/lang/String;");
		var apilevel = Std.parseInt(getAPILevel());

		if (apilevel < 19) {
			return _legacy();
		}

		var getpath = JNI.createStaticMethod(JNI_PATH, "getPath", JNI_SIGNATURE);
		_path = getpath(Settings.PUBLIC_STORAGE);
		#elseif windows
		_path = "\\" + Settings.PUBLIC_STORAGE;
		if (!FileSystem.exists(_path)) {
			FileSystem.createDirectory(_path);
		}
		#elseif mac
		_path = "~/" + Settings.PUBLIC_STORAGE;
		if (!FileSystem.exists(_path)) {
			FileSystem.createDirectory(_path);
		}
		#end

		return _path;
	}

	/*
	* legacy returns a path generated for pre-kitkat devices, kitkat introduced
	* new rules for writing on the sdcard which prevents this from working
	*/
	private static function _legacy():String {
		#if windows
		var divider = "\\";
		#else
		var divider = "/";
		#end

		#if android
		var path = FileSystem.exists("/media/") ? "/media/" : "/sdcard/";
		#elseif ios
		var path = SystemPath.applicationStorageDirectory;
		#else
		var path = SystemPath.userDirectory;
		#end

		if (!FileSystem.exists(path)) {
			FileSystem.createDirectory(path);
		}

		path += Settings.PUBLIC_STORAGE + divider;

		if (!FileSystem.exists(path)) {
			FileSystem.createDirectory(path);
		}

		_path = path;
		return path;
	}
}