package app;

import android.content.ClipData;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.text.ClipboardManager;
import android.content.Context;
import android.util.Log;

import com.rawstone.wangwang.R;

import org.cocos2dx.lua.AppActivity;

/**
 * Created by hantaosun on 3/26/16.
 */
public class LuaOcUtil {
    public static void copyToClipBoard(final String str) {
        ClipboardManager manager = ((ClipboardManager) AppActivity.getContext()
                .getSystemService(Context.CLIPBOARD_SERVICE));
        manager.setText(str);
    }
    public static int getBundleVersion() {
        int ret = 0;
        PackageManager manager = AppActivity.getContext().getPackageManager();
        PackageInfo info = null;
        try {
            info = manager.getPackageInfo(AppActivity.getContext().getPackageName(), 0);
            ret = info.versionCode;
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }
        return ret;
    }
}
