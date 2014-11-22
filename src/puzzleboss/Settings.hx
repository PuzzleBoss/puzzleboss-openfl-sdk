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

class Settings {
	// used in social media sharing
	public static inline var NAME:String = "Amazing Jigsaw Puzzles";

	// this will be your folder on the website, eg puzzleboss.com/TYPE/SHORTNAME
	public static inline var SHORT_NAME:String = "amazing";

	// your game genre
	public static inline var TYPE:String = "jigsaw";

	// the marketplace the game's compiled for
	public static inline var APP_STORE:String = "amazon";

	// your package name for the game
	public static inline var PACKAGE:String = "com.puzzleboss.jigsaw.Amazing.amazon";

	// game version
	public static inline var VERSION:String = "1.7.0";

	// for the NOOK appstore only
	public static inline var EAN:String = "";

	// for social media sharing (we can host this)
	public static inline var SHARE_IMAGE:String = "http://files.puzzleboss.com/yourgame/pic.jpg";

	// for your path on the device storage
	public static inline var PUBLIC_STORAGE:String = "my_folder4";
}
