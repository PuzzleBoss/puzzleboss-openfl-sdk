package com.puzzleboss.core;

import android.content.Intent;
import android.app.Activity;
import android.util.Log;
import org.haxe.lime.GameActivity;

public class NookStore
{
    /**
     * openShop will open the NOOK app store on their
     * tablets to the specified app.
     *
     * You can get your EAN from the NOOK dashboard.
     *
     * @param ean the app id
     */
    public static void openShop(final String ean) {
        Activity currentActivity = GameActivity.getInstance();

        Intent i = new Intent();
        i.setAction("com.bn.sdk.shop.details");
        i.putExtra("product_details_ean", ean);

        try {
            currentActivity.startActivity(i);
        }
        catch(Exception e) {
            GameActivity.launchBrowser("https://nookdeveloper.barnesandnoble.com/tools/dev/linkManager/" + ean);
        }
    }
}
