package app;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Color;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.text.TextUtils;

import com.qiyukf.unicorn.api.ConsultSource;
import com.qiyukf.unicorn.api.ProductDetail;
import com.qiyukf.unicorn.api.SavePowerConfig;
import com.qiyukf.unicorn.api.StatusBarNotificationConfig;
import com.qiyukf.unicorn.api.Unicorn;
import com.qiyukf.unicorn.api.UnreadCountChangeListener;
import com.qiyukf.unicorn.api.YSFOptions;
import com.qiyukf.unicorn.api.YSFUserInfo;
import com.qiyukf.unicorn.api.UICustomization;
import com.rawstone.wangwang.R;

import android.app.ActivityManager;
import android.util.Log;

import org.cocos2dx.lib.Cocos2dxLuaJavaBridge;
import org.cocos2dx.lua.AppActivity;
import org.json.JSONException;
import org.json.JSONObject;
import org.json.JSONArray;



/**
 * Created by queyou on 16/10/10.
 */
public class QiYuSDK {

    private static QiYuSDK instance;

    private static int qiyuCallback = 0;

    public static YSFOptions ysfOptions;

    public static String appName = "旺旺慈溪游戏";

    public static synchronized QiYuSDK getInstance() {
        if (instance == null) {
            instance = new QiYuSDK();

            String name = AppActivity.getContext().getPackageName();

            Log.e("PageName---", name);
            if (name.equals("com.tencent.tmgp.cixi"))
            {
                appName = "旺旺慈溪游戏";;
            }
            else if(name.equals("com.tencent.tmgp.yuyao"))
            {
                appName = "旺旺余姚游戏";
            }
            else if(name.equals("com.tencent.tmgp.kxmqp"))
            {
                appName = "凯旋门棋牌";
            }
            else if(name.equals("com.tencent.tmgp.shaoxing"))
            {
                appName = "旺旺绍兴游戏";
            }

        }
        return instance;
    }

    public static String getYsfAppKey()
    {
        String appKey = "7fbdf2b64bf1f6e9b82d6e244ddddcfe";
        return appKey;
    }

    public static UnreadCountChangeListener mUnreadCountListener = new UnreadCountChangeListener() {
        @Override
        public void onUnreadCountChange(int count) {
            updateUnreadCount(count);
        }
    };

    public static void SetUnreadListener(final boolean isOpen, final int callback) {

        ((AppActivity) AppActivity.getContext()).runOnUiThread(new Runnable() {
            @Override
            public void run() {

                Unicorn.addUnreadCountChangeListener(mUnreadCountListener, isOpen);
                if(isOpen)
                {
                    updateUnreadCount(Unicorn.getUnreadCount());
                }

                ((AppActivity) AppActivity.getContext()).runOnGLThread(new Runnable() {
                    @Override
                    public void run() {

                        JSONObject obj = new JSONObject();
                        try {
                            if(isOpen)
                            {
                                obj.put("result", 10);
                            }
                            else
                            {
                                obj.put("result", 11);
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
        });
    }



    private static  void updateUnreadCount(final int count) {

        ((AppActivity) AppActivity.getContext()).runOnGLThread(new Runnable() {
            @Override
            public void run() {

                JSONObject obj = new JSONObject();
                try {

                    final int num = count;
                    obj.put("result", num);


                } catch (JSONException e) {
                    e.printStackTrace();
                    return;
                }

                Log.e("updateUnreadCount", count+"");

                String chatNum = obj.toString();
                Cocos2dxLuaJavaBridge.callLuaGlobalFunctionWithString("G_SetChatNum",chatNum);

            }
        });

    }

    private static JSONObject userInfoDataItem(String key, Object value, boolean hidden, int index, String label, String href) {
        JSONObject item = new JSONObject();
        try {

            item.put("key", key);
            item.put("value", value);
            if (hidden) {
                item.put("hidden", true);
            }
            if (index >= 0) {
                item.put("index", index);
            }
            if (!TextUtils.isEmpty(label)) {
                item.put("label", label);
            }
            if (!TextUtils.isEmpty(href)) {
                item.put("href", href);
            }

        } catch (JSONException e) {
            e.printStackTrace();
            return null;
        }

        return item;
    }

    private static JSONArray userInfoData(String name, String sex, String time, String uID) {
        JSONArray array = new JSONArray();

        array.put(userInfoDataItem("real_name", name, false, -1, null, null));
        array.put(userInfoDataItem("uid", uID, false, 0, "用户ID", null));
        array.put(userInfoDataItem("sex", sex, false, 1, "性别", null));
        array.put(userInfoDataItem("session_date", time, false, 2, "会话日期", null));

        return array;
    }

   // final int uid, final String nick, final int sex, final String time,
    public static void UpdateUserInfo(final String json,final int callback)
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
                int sex = objInfo.optInt("sex", 0);
                String sexStr;
                if(sex==1)
                {
                    sexStr = "小姐";
                }
                else
                {
                    sexStr = "先生";
                }

                YSFUserInfo userInfo = new YSFUserInfo();
                userInfo.userId =  objInfo.optString("uid");
                Log.e("SetUserInfo",userInfo.userId);
                userInfo.data = userInfoData(objInfo.optString("nickname"), sexStr, objInfo.optString("time"),userInfo.userId).toString();
                Unicorn.setUserInfo(userInfo);

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

    public static void LogOutChat(final int callback) {

        ((AppActivity) AppActivity.getContext()).runOnUiThread(new Runnable() {
            @Override
            public void run() {

                Log.e("LogOutChat","user:null");
                Unicorn.setUserInfo(null);

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

    public static void SetUIChat(final String json, final int callback) {

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

              //  params.bgPath = "res/Image/Common/Avatar/session_bg.png"
               // params.customerPath = image
               // params.serverPath = "res/Image/Common/Avatar/serviceIcon.png"

                String bgPath = objInfo.optString("bgPath");
                String customerPath = objInfo.optString("customerPath");
                String serverPath = objInfo.optString("serverPath");

                Log.e("SetUIChat-bgPath",bgPath);
                UICustomization customization = new UICustomization();
                customization.titleBarStyle = 0;
                customization.screenOrientation = 1;
//                customization.titleBackgroundResId = R.drawable.my_ysf_title_bar_bg;
//
//                customization.topTipBarBackgroundColor = 0xFFDCF2F5;
//                customization.topTipBarTextColor = 0xFF4E97D9;
                customization.msgBackgroundUri = "assets://" + bgPath;
                customization.leftAvatar = "assets://" + serverPath;
                customization.rightAvatar = "assets://" + "res/" +customerPath;
                Log.e("SetUIChat-customerPath",customerPath);
                customization.hideKeyboardOnEnterConsult = true;
                customization.titleBackgroundResId = R.drawable.image_bar;

//                customization.msgItemBackgroundLeft = R.drawable.my_message_item_left_selector;
//                customization.msgItemBackgroundRight = R.drawable.my_message_item_right_selector;
//
//                customization.textMsgColorLeft = Color.BLACK;
//                customization.textMsgColorRight = Color.WHITE;

//                customization.audioMsgAnimationLeft = R.drawable.my_audio_animation_list_left;
//                customization.audioMsgAnimationRight = R.drawable.my_audio_animation_list_right;

             //   customization.tipsTextColor = 0xFF76838F;

             //   customization.buttonBackgroundColorList = R.color.my_button_color_state_list;
                if(ysfOptions.uiCustomization!=null)
                {
                    ysfOptions.uiCustomization = null;
                }
                ysfOptions.uiCustomization = customization;

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

    public static void OpenChatMenu(final int callback) {
        //Log.e("QIYU OpenChatMenu", json);

        final QiYuSDK sdk = QiYuSDK.getInstance();
        qiyuCallback = callback;

        ((AppActivity) AppActivity.getContext()).runOnUiThread(new Runnable() {
            @Override
            public void run() {

                sdk.consultService((AppActivity) AppActivity.getContext(), "https://8.163.com/", appName ,null);

                ((AppActivity) AppActivity.getContext()).runOnGLThread(new Runnable() {
                    @Override
                    public void run() {

                        if (sdk.qiyuCallback == 0) {
                            return;
                        }

                        final int callback = sdk.qiyuCallback;
                        sdk.qiyuCallback = 0;

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

    public YSFOptions ysfOptions()
    {
        YSFOptions options = new YSFOptions();
        options.statusBarNotificationConfig = new StatusBarNotificationConfig();
        //options.statusBarNotificationConfig.notificationSmallIconId = R.drawable.ic_status_bar_notifier;
        options.savePowerConfig = new SavePowerConfig();
        ysfOptions = options;
        return options;
    }

    public static void consultService(final Context context, String uri, String title, ProductDetail productDetail) {
        if (!Unicorn.isServiceAvailable()) {
            // 当前客服服务不可用
            AlertDialog.Builder dialog = new AlertDialog.Builder(context);
            if (!isNetworkAvailable(context)) {
                // 当前无网络
                dialog.setMessage("网络状况不佳，请重试。");
                dialog.setPositiveButton("确定", null);
            }

            dialog.show();
            return;
        }

        // 启动聊天界面
        ConsultSource source = new ConsultSource(uri, title, null);
        source.productDetail = productDetail;
        Unicorn.openServiceActivity(context, staffName(), source);
    }

    public static String staffName() {
        return appName;
    }

    public static boolean isNetworkAvailable(Context context) {
        ConnectivityManager connectivityManager = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
        if (connectivityManager != null) {
            NetworkInfo[] allNetworkInfo = connectivityManager.getAllNetworkInfo();
            if (allNetworkInfo != null) {
                for (NetworkInfo networkInfo : allNetworkInfo) {
                    if (networkInfo.getState() == NetworkInfo.State.CONNECTED) {
                        return true;
                    }
                }
            }
        }
        return false;
    }

    public static boolean inMainProcess(Context context) {
        String packageName = context.getPackageName();
        String processName = getProcessName(context);
        return packageName.equals(processName);
    }

    /**
     * 获取当前进程名
     * @param context
     * @return 进程名
     */
    public static final String getProcessName(Context context) {
        String processName = null;

        // ActivityManager
        ActivityManager am = ((ActivityManager) context.getSystemService(Context.ACTIVITY_SERVICE));

        while (true) {
            for (ActivityManager.RunningAppProcessInfo info : am.getRunningAppProcesses()) {
                if (info.pid == android.os.Process.myPid()) {
                    processName = info.processName;
                    break;
                }
            }

            // go home
            if (!TextUtils.isEmpty(processName)) {
                return processName;
            }

            // take a rest and again
            try {
                Thread.sleep(100L);
            } catch (InterruptedException ex) {
                ex.printStackTrace();
            }
        }
    }

}
