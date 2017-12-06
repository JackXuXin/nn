package app;

import android.os.Bundle;
import android.util.Log;

import com.tencent.connect.share.QQShare;
import com.tencent.tauth.IUiListener;
import com.tencent.tauth.Tencent;
import com.tencent.tauth.UiError;

import org.cocos2dx.lib.Cocos2dxLuaJavaBridge;
import org.cocos2dx.lua.AppActivity;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * Created by hantaosun on 5/2/16.
 */
public class QQSDK implements IUiListener {
    public static String appId = "1105299795";

    private static QQSDK instance;
    private int loginCallback = 0;
    public Tencent tencent;

    public static synchronized QQSDK getInstance() {
        if (instance == null) {
            instance = new QQSDK();
        }
        return instance;
    }

    public static void login(final int callback) {
        ((AppActivity) AppActivity.getContext()).runOnGLThread(new Runnable() {
            @Override
            public void run() {
                QQSDK sdk = QQSDK.getInstance();
                sdk.loginCallback = callback;
                if (!sdk.tencent.isSessionValid()) {
                    Log.e("QQ login", "success");
                    sdk.tencent.login((AppActivity) AppActivity.getContext(), "get_simple_userinfo", sdk);
                } else {
                    Log.e("QQ login", "false");
                }
            }
        });
    }

    public static void share(final boolean screenshot, final boolean qzone) {
        ((AppActivity) AppActivity.getContext()).runOnUiThread(new Runnable() {
            @Override
            public void run() {
                QQSDK sdk = QQSDK.getInstance();
                final Bundle bundle = new Bundle();
                bundle.putInt(QQShare.SHARE_TO_QQ_KEY_TYPE, QQShare.SHARE_TO_QQ_TYPE_DEFAULT);
                bundle.putString(QQShare.SHARE_TO_QQ_TITLE, AppActivity.MySharedTitle);
                bundle.putString(QQShare.SHARE_TO_QQ_SUMMARY,  AppActivity.MySharedDescription);
                bundle.putString(QQShare.SHARE_TO_QQ_TARGET_URL, AppActivity.MySharedUrl);
                bundle.putString(QQShare.SHARE_TO_QQ_APP_NAME, AppActivity.MySharedTitle);
                bundle.putInt(QQShare.SHARE_TO_QQ_EXT_INT, qzone ? QQShare.SHARE_TO_QQ_FLAG_QZONE_AUTO_OPEN
                        : QQShare.SHARE_TO_QQ_FLAG_QZONE_ITEM_HIDE);

                String path = Util.getScreenShotPath(screenshot);

                bundle.putString(QQShare.SHARE_TO_QQ_IMAGE_URL, path);

                sdk.tencent.shareToQQ((AppActivity) AppActivity.getContext(), bundle, null);
            }
        });
    }

    public static void didLogin(final JSONObject ret) {
        final QQSDK sdk = QQSDK.getInstance();
        if (sdk.loginCallback == 0) {
            return;
        }
        final int callback = sdk.loginCallback;
        sdk.loginCallback = 0;

        ((AppActivity) AppActivity.getContext()).runOnGLThread(new Runnable() {
            @Override
            public void run() {
                JSONObject obj = new JSONObject();
                try {
                    obj.put("result", ret.optInt("ret", 0));
                    obj.put("id", ret.optString("openid", ""));
                    obj.put("token", ret.optString("access_token", ""));
                    obj.put("time", ret.optInt("expires_in", 0) + System.currentTimeMillis() / 1000);
                } catch (JSONException e) {
                    sdk.loginCallback = 0;
                    e.printStackTrace();
                    return;
                }

                String param = obj.toString();
                Cocos2dxLuaJavaBridge.callLuaFunctionWithString(callback, param);
                Cocos2dxLuaJavaBridge.releaseLuaFunction(callback);
            }
        });
    }

    @Override
    public void onComplete(Object o) {
        JSONObject ret = (JSONObject) o;
        Log.e("QQ Login onComplete", ret.toString());

        QQSDK.didLogin(ret);
    }

    @Override
    public void onError(UiError uiError) {
        Log.e("onError:", "code:" + uiError.errorCode + ", msg:"
                + uiError.errorMessage + ", detail:" + uiError.errorDetail);
    }

    @Override
    public void onCancel() {
        Log.e("onCancel:", "onCancel");
    }
}
