package com.puzzleboss.core;

import android.app.Activity;
import android.content.Intent;
import org.haxe.lime.GameActivity;

public class ExitApp
{
    public static void exitApp()
    {
        Intent intent = new Intent(Intent.ACTION_MAIN);
        intent.addCategory(Intent.CATEGORY_HOME);
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        GameActivity.getInstance().startActivity(intent);
    }
}
