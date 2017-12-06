package app;

import android.util.Log;

import com.tencent.android.tpush.XGIOperateCallback;
import com.tencent.android.tpush.XGPushManager;

import org.cocos2dx.lib.Cocos2dxLuaJavaBridge;
import org.cocos2dx.lua.AppActivity;
import org.json.JSONException;
import org.json.JSONObject;

import app.QiYuSDK;

/**
 * Created by queyou on 2017/6/27.
 */
public class XingePush
{

    private static XingePush instance;

    private static int XingePushCallback = 0;


    public static synchronized XingePush getInstance() {
        if (instance == null) {
            instance = new XingePush();
        }
        return instance;
    }

    public static void registerXPush(final String json,final int callback)
    {
        ((AppActivity) AppActivity.getContext()).runOnUiThread(new Runnable() {
            @Override
            public void run() {

                JSONObject objInfo;
                try {
                    objInfo = new JSONObject(json);
                } catch (JSONException e) {
                    e.printStackTrace();
                    return;
                }

                final String account =  objInfo.optString("account");

                Log.e("registerXPush", account);

                XGPushManager.registerPush((AppActivity) AppActivity.getContext(), account, new XGIOperateCallback() {
                    @Override
                    public void onSuccess(Object data, int flag) {
                        Log.d("TPush", "注册成功，设备token为：" + data + "accout = " + account);

                        QiYuSDK qiyuSdk = QiYuSDK.getInstance();

                        Log.e("tagname = ", qiyuSdk.staffName());

                        XGPushManager.setTag((AppActivity) AppActivity.getContext(), qiyuSdk.staffName());
                    }
                    @Override
                    public void onFail(Object data, int errCode, String msg) {
                        Log.d("TPush", "注册失败，错误码：" + errCode + ",错误信息：" + msg);
                    }
                });




                ((AppActivity) AppActivity.getContext()).runOnGLThread(new Runnable() {
                    @Override
                    public void run() {

                        JSONObject obj = new JSONObject();
                        try {
                            obj.put("result", 1);

                        } catch (JSONException e) {
                            e.printStackTrace();
                            return;
                        }

                        String param = obj.toString();
                        Cocos2dxLuaJavaBridge.callLuaFunctionWithString(callback, param);
                        Cocos2dxLuaJavaBridge.releaseLuaFunction(callback);
                    }
                });
            }
        });
    }


}
