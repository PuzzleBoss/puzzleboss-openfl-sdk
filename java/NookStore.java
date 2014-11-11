package com.puzzleboss.core;

import android.content.Intent;
import android.app.Activity;
import android.util.Log;
import org.haxe.nme.GameActivity;

public class NookStore
{
    public static String openShop(final String ean)
    {
        Activity currentActivity = GameActivity.getInstance();

        Intent i = new Intent();
        i.setAction("com.bn.sdk.shop.details");
        i.putExtra("product_details_ean", ean);

        try
        {
            currentActivity.startActivity(i);
        }
        catch(Exception e)
        {
            Log.d("MainActivity", e.toString());
            GameActivity.launchBrowser("https://barnesandnoble.com");
        }

        return ean;
    }
}
