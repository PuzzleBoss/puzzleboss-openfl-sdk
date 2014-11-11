package com.puzzleboss.core;

import android.content.Intent;
import android.app.Activity;
import android.content.pm.ResolveInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageItemInfo;
import android.content.pm.PackageInfo;
import android.net.Uri;
import android.text.TextUtils;
import java.util.ArrayList;
import java.util.List;
import java.net.URL;
import java.net.URLConnection;
import com.pinterest.pinit.PinIt;
import org.haxe.lime.GameActivity;

public class Social
{
    public static void googleShare(final String url, final String fallback) {

        Activity currentActivity = GameActivity.getInstance();

        if(appOwned(currentActivity, "com.google.android.apps.plus"))
        {
            try {
                Intent intent = new Intent(Intent.ACTION_SEND);
                intent.putExtra(Intent.EXTRA_TEXT, url);
                intent.setType("text/plain");
                intent.setPackage("com.google.android.apps.plus");
                currentActivity.startActivity(intent);
                return;
            } catch( Exception e) {
            }
        }

        Intent web = new Intent(Intent.ACTION_VIEW, Uri.parse(fallback));
        currentActivity.startActivity(web);
    }

    public static void twitterShare(final String tweet, final String fallback) {

        Activity currentActivity = GameActivity.getInstance();

        if(appOwned(currentActivity, "com.twitter.android")) {

            try {
                Intent intent = new Intent(Intent.ACTION_SEND);
                intent.putExtra(Intent.EXTRA_TEXT, tweet);
                intent.setType("application/twitter");

                PackageManager pm = currentActivity.getPackageManager();
                List<ResolveInfo> lract = pm.queryIntentActivities(intent, PackageManager.MATCH_DEFAULT_ONLY);

                boolean resolved = false;

                for(ResolveInfo ri: lract) {
                    if(ri.activityInfo.name.endsWith(".SendTweet")) {
                        intent.setClassName(ri.activityInfo.packageName, ri.activityInfo.name);
                        resolved = true;
                        break;
                    }
                }

                if(!resolved) {
                    intent.setPackage("com.twitter.android");
                }

                currentActivity.startActivity(intent);
                return;

            } catch( Exception e) {
            }
        }

        Intent web = new Intent(Intent.ACTION_VIEW, Uri.parse(fallback));
        currentActivity.startActivity(web);
    }

    public static void pinterestShare(final String url, final String imageurl, final String name, final String fallback)
    {
        Activity currentActivity = GameActivity.getInstance();

        if(appOwned(currentActivity, "com.pinterest")) {
            try {
                PinIt.setPartnerId("1437791");
                PinIt pin = new PinIt();
                pin.setImageUrl(imageurl);
                pin.setUrl(url);
                pin.setDescription(name);
                pin.doPinIt(currentActivity);
            } catch( Exception e) {
            }
        }

        Intent web = new Intent(Intent.ACTION_VIEW, Uri.parse(fallback));
        currentActivity.startActivity(web);
    }

    public static void facebookShare(final String url, final String fallback) {

        Activity currentActivity = GameActivity.getInstance();

        if(appOwned(currentActivity, "com.facebook.katana")) {
            try{
                Intent intent = new Intent(Intent.ACTION_SEND);
                intent.setType("text/plain");
                intent.putExtra(Intent.EXTRA_TEXT, url);
                intent.setPackage("com.facebook.katana");
                currentActivity.startActivity(intent);
                return;
            } catch( Exception e ){
            }
        }

        Intent web = new Intent(Intent.ACTION_VIEW, Uri.parse(fallback));
        currentActivity.startActivity(web);
    }

    public static void emailShare(final String url, final String name) {
        Intent email = new Intent(Intent.ACTION_SEND);
        email.putExtra(Intent.EXTRA_SUBJECT, name);
        email.putExtra(Intent.EXTRA_TEXT, url);
        email.setType("message/rfc822");

        Activity currentActivity = GameActivity.getInstance();
        currentActivity.startActivity(Intent.createChooser(email, "Choose an Email client:"));
    }

    private static boolean appOwned(Activity activity, String uri) {

        PackageManager pm = activity.getPackageManager();

        try {
            pm.getPackageInfo(uri, PackageManager.GET_ACTIVITIES);
            return true;
        }
        catch (PackageManager.NameNotFoundException e) {
        }

        return false;
    }
}
