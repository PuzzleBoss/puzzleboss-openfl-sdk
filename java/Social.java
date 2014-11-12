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
    /**
     * googleShare will try and use the Google+ app to share your url and
     * if it is not installed / detected it will fallback to using the
     * browser to share your alternate url.
     *
     * @param url the url you want to share through the app
     * @param fallback the alternate url to share through the website
     */
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

    /**
     * twitterShare will try and use the Twitter app to share your url and
     * if it is not installed / detected it will fallback to using the
     * browser to share your alternate url.
     *
     * @param url the url you want to share through the app
     * @param fallback the alternate url to share through the website
     */
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

    /**
     * pinterestShare will try and use the Pinterest app to share your url and
     * if it is not installed / detected it will fallback to using the
     * browser to share your alternate url.
     *
     * @param url the url you want to share through the app
     * @param imageurl the photo to accompany the post
     * @param description the text to accompany the post
     * @param fallback the alternate url to share through the website
     */
    public static void pinterestShare(final String url, final String imageurl, final String description, final String fallback)
    {
        Activity currentActivity = GameActivity.getInstance();

        if(appOwned(currentActivity, "com.pinterest")) {
            try {
                PinIt.setPartnerId("1437791");
                PinIt pin = new PinIt();
                pin.setImageUrl(imageurl);
                pin.setUrl(url);
                pin.setDescription(description);
                pin.doPinIt(currentActivity);
                return;
            } catch( Exception e) {
            }
        }

        Intent web = new Intent(Intent.ACTION_VIEW, Uri.parse(fallback));
        currentActivity.startActivity(web);
    }

    /**
     * facebookShare will try and use the Facebook app to share your url and
     * if it is not installed / detected it will fallback to using the
     * browser to share your alternate url.
     *
     * @param url the url you want to share through the app
     * @param fallback the alternate url to share through the website
     */
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

    /**
     * emailShare will send an email on the user's behalf.
     *
     * @param url the url you want to share through the app
     * @param name the subject of the email
     */
    public static void emailShare(final String url, final String subject) {
        Intent email = new Intent(Intent.ACTION_SEND);
        email.putExtra(Intent.EXTRA_SUBJECT, subject);
        email.putExtra(Intent.EXTRA_TEXT, url);
        email.setType("message/rfc822");

        Activity currentActivity = GameActivity.getInstance();
        currentActivity.startActivity(Intent.createChooser(email, "Choose an Email client:"));
    }

    /**
     * appOwned scans the users apps to see if the nominated app
     * package name is installed.
     *
     * @param activity the current acitivity
     * @param pkg the package name
     */
    private static boolean appOwned(Activity activity, String pkg) {
        
        try {
            PackageManager pm = activity.getPackageManager();
            pm.getPackageInfo(pkg, PackageManager.GET_ACTIVITIES);
            return true;
        }
        catch (PackageManager.NameNotFoundException e) {
        }

        return false;
    }
}
