package com.puzzleboss.core;

import android.content.Intent;
import android.app.Activity;
import org.haxe.lime.GameActivity;

public class Support {

    /**
     * getOS returns the operating system version
     */
    public static String getOS() {
        return System.getProperty("os.version");
    }

    /**
     * getAPILevel returns the SDK version of the device
     */
    public static String getAPILevel() {
        return android.os.Build.VERSION.SDK;
    }

    /**
     * getDevice returns the device name, this usually
     * is a code name
     */
    public static String getDevice() {
        return android.os.Build.DEVICE;
    }

    /**
     * getModel returns the model of the device
     */
    public static String getModel() {
        return android.os.Build.MODEL;
    }

    /**
     * getProduct returns the product
     */
    public static String getProduct() {
        return android.os.Build.PRODUCT;
    }

    /**
     * sendEmail will send an email to the support address
     * (default = support@puzzleboss.com) with the device information
     * in the payload.
     *
     * @param payload the device information, collected in haxe
     */
    public static void sendEmail(String payload) {
        Intent email = new Intent(Intent.ACTION_SEND);
        email.putExtra(Intent.EXTRA_EMAIL, new String[]{ "support@puzzleboss.com" });
        email.putExtra(Intent.EXTRA_SUBJECT, "Support issue");
        email.putExtra(Intent.EXTRA_TEXT, payload + "\r\n------ Please write below this ------\r\n");
        email.setType("message/rfc822");

        Activity currentActivity = GameActivity.getInstance();
        currentActivity.startActivity(Intent.createChooser(email, "Choose an Email client:"));
    }
}
