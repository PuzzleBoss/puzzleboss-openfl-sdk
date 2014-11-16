package com.puzzleboss.core;

import java.io.File;
import android.util.Log;
import java.lang.System;

public class Path
{
    /**
     * getPath will return the publicly accessible path for Android,
     * either the secondary storage, the misleadingly named 'external'
     * storage, or falling back to /sdcard/ for older androids
     *
     * @param suffix your personal extension, eg /whatever/mycompany
     */
    public static String getPath(final String suffix) {

      Log.i("getPath", suffix);

      try {
        String secStore = System.getenv("SECONDARY_STORAGE");

        if(secStore != null) {
          Log.i("using secStore", secStore);
          return createPath(secStore, suffix);
        }
      }
      catch(Exception e) {

      }

      try {
        String extStore = System.getenv("EXTERNAL_STORAGE");

        if(extStore != null) {
          Log.i("using extStore", extStore);
          return createPath(extStore, suffix);
        }
      }
      catch(Exception e) {

      }

      Log.i("fallback", "sdcard");

      return createPath("/sdcard", suffix);
    }

    private static String createPath(final String prefix, final String suffix) {

      File f = new File(prefix + "/" + suffix + "/");

      Log.i("creating path", f.getPath());
      f.mkdirs();

      return f.getPath();
    }
}
