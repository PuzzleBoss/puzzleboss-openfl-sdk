package com.puzzleboss.core;

import org.haxe.lime.GameActivity;

public class Path
{
    /**
     * getPath will create and return a shared path for your apps to store
     * whatever information needs to be shared between them.
     *
     * @param suffix your personal extension, eg /whatever/mycompany
     */
    public static String getPath(final String suffix) {
      return GameActivity.getInstance().getExternalFilesDir(suffix).getAbsolutePath();
    }
}
