package app;

import android.os.Handler;
import android.os.Message;
import android.text.TextUtils;
import android.util.Log;
import android.widget.Toast;

import com.alipay.sdk.app.PayTask;
import com.tencent.mm.sdk.modelbase.BaseResp;

import org.cocos2dx.lib.Cocos2dxGLSurfaceView;
import org.cocos2dx.lib.Cocos2dxLuaJavaBridge;
import org.cocos2dx.lua.AppActivity;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * Created by hantaosun on 5/4/16.
 */
public class AliSDK {

//    private static final int SDK_PAY_FLAG = 1;
    private static AliSDK instance;

    private static int rechargeCallback = 0;

    public static synchronized AliSDK getInstance() {
        if (instance == null) {
            instance = new AliSDK();
        }
        return instance;
    }

    public static void recharge(final String json, final int callback) {
        Log.e("Alipay recharge", json);

        final AliSDK sdk = AliSDK.getInstance();
        rechargeCallback = callback;

        new Thread() {
            @Override
            public void run () {
                JSONObject obj;
                try {
                    obj = new JSONObject(json);
                } catch (JSONException e) {
                    e.printStackTrace();
                    return;
                }
                Log.e("AliPay", "json");
                // 构造PayTask 对象
                PayTask alipay = new PayTask((AppActivity) AppActivity.getContext());
                Log.e("AliPay", "task");
                // 调用支付接口，获取支付结果
                final String result = alipay.pay(obj.optString("OrderString", ""), false);

                // TODO 如果没有sleep,回调时不渲染有错误,原因不明!
                try {
                    Thread.sleep(1000);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                sdk.didRecharge(result);
            }
        }.start();
    }

    public void didRecharge(final String ret) {
        ((AppActivity) AppActivity.getContext()).runOnGLThread(new Runnable() {
            @Override
            public void run() {
                final AliSDK sdk = AliSDK.getInstance();
                Log.e("alipay recharge", ret + " " + getResultStatus(ret));
                if (sdk.rechargeCallback == 0) {
                    return;
                }
                final int callback = sdk.rechargeCallback;
                sdk.rechargeCallback = 0;

                JSONObject obj = new JSONObject();
                try {
                    if (TextUtils.equals(getResultStatus(ret), "9000")) {
                        obj.put("result", 0);
                    } else {
                        obj.put("result", 1);
                    }
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

    private String getResultStatus(String rawResult) {
        if (TextUtils.isEmpty(rawResult))
            return "";

        String[] resultParams = rawResult.split(";");
        for (String resultParam : resultParams) {
            if (resultParam.startsWith("resultStatus")) {
                return getValue(resultParam, "resultStatus");
            }
        }

        return "";
    }

    private String getValue(String content, String key) {
        String prefix = key + "={";
        return content.substring(content.indexOf(prefix) + prefix.length(),
                content.lastIndexOf("}"));
    }
}
