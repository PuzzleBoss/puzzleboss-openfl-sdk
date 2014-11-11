package com.puzzleboss.core;

import android.content.Intent;
import android.app.Activity;
import org.haxe.lime.GameActivity;

public class Support {

    public static String getOS() {
        return System.getProperty("os.version");
    }

    public static String getAPILevel() {
        return android.os.Build.VERSION.SDK;
    }

    public static String getDevice() {
        return android.os.Build.DEVICE;
    }

    public static String getModel() {
        return android.os.Build.MODEL;
    }

    public static String getProduct() {
        return android.os.Build.PRODUCT;
    }


    public static void sendEmail(String message) {
        Intent email = new Intent(Intent.ACTION_SEND);
        email.putExtra(Intent.EXTRA_EMAIL, new String[]{ "support@puzzleboss.com" });
        email.putExtra(Intent.EXTRA_SUBJECT, "Support issue");
        email.putExtra(Intent.EXTRA_TEXT, message + "\r\n------ Please write below this ------\r\n");
        email.setType("message/rfc822");

        Activity currentActivity = GameActivity.getInstance();
        currentActivity.startActivity(Intent.createChooser(email, "Choose an Email client:"));
    }
}
