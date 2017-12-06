package app;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.util.Log;

import com.tencent.mm.sdk.modelbase.BaseResp;
import com.tencent.mm.sdk.modelmsg.GetMessageFromWX;
import com.tencent.mm.sdk.modelmsg.SendAuth;
import com.tencent.mm.sdk.modelmsg.SendMessageToWX;
import com.tencent.mm.sdk.modelmsg.WXAppExtendObject;
import com.tencent.mm.sdk.modelmsg.WXImageObject;
import com.tencent.mm.sdk.modelmsg.WXMediaMessage;
import com.tencent.mm.sdk.modelmsg.WXTextObject;
import com.tencent.mm.sdk.modelmsg.WXWebpageObject;
import com.tencent.mm.sdk.modelpay.PayReq;
import com.tencent.mm.sdk.openapi.IWXAPI;
import com.tencent.mm.sdk.openapi.WXAPIFactory;

import org.cocos2dx.lib.Cocos2dxLuaJavaBridge;
import org.cocos2dx.lua.AppActivity;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.tencent.mm.sdk.modelmsg.ShowMessageFromWX;

import java.io.File;


/**
 * Created by hantaosun on 5/2/16.
 */
public class WeixinSDK {

    public static String appId = "wx3078da8981e17344";
    public static String appKey = "293513f6d6950b0ce1a737b3263d25b2";

    public static String param = "";

    private static WeixinSDK instance;
    private int loginCallback = 0;
    private int rechargeCallback = 0;
    private int shareCallback = 0;
    private int shareExCallBack = 0;
    private boolean isFriend = false;
    public IWXAPI iwxapi;

    private static final int THUMB_SIZE = 150;
    public static synchronized WeixinSDK getInstance() {
        if (instance == null) {
            instance = new WeixinSDK();

            String name = AppActivity.getContext().getPackageName();

            Log.e("PageName---", name);
            if (name.equals("com.tencent.tmgp.cixi"))
            {
                appId = "wx3078da8981e17344";
                appKey = "293513f6d6950b0ce1a737b3263d25b2";
            }
            else if(name.equals("com.tencent.tmgp.yuyao"))
            {
                appId = "wx62af3cecbb4ebe04";
                appKey = "cb29b137571802641960b617237b1850";
            }
            else if(name.equals("com.tencent.tmgp.kxmqp"))
            {
                appId = "wx142362b02f2ca2a3";
                appKey = "06d843858e45aa59274cedc71cb20e73";
            }
            else if(name.equals("com.tencent.tmgp.shaoxing"))
            {
                appId = "wx482f1a5eff7a740e";
                appKey = "1391da7a4a2490a4b7cf90461e3846b8";
            }

            instance.iwxapi = WXAPIFactory.createWXAPI((AppActivity) AppActivity.getContext(), appId);
            instance.iwxapi.registerApp(WeixinSDK.appId);
        }
        return instance;
    }

    public static void login(final int callback) {
        ((AppActivity) AppActivity.getContext()).runOnUiThread(new Runnable() {
            @Override
            public void run() {
                WeixinSDK sdk = WeixinSDK.getInstance();
                sdk.loginCallback = callback;

                Log.e("login---", "222");

                final SendAuth.Req req = new SendAuth.Req();
                req.scope = "snsapi_userinfo";
                req.state = "none";
                sdk.iwxapi.sendReq(req);
            }
        });
    }

    public static void loginReady(final int callback) {
//        ((AppActivity) AppActivity.getContext()).runOnUiThread(new Runnable() {
//            @Override
//            public void run() {


        Log.e("loginReady", "111");

        String filesPath = AppActivity.getContext().getApplicationContext().getFilesDir().getAbsolutePath();

        final String path = filesPath + "/FaceConfig.xml";

        ((AppActivity) AppActivity.getContext()).runOnGLThread(new Runnable() {
            @Override
            public void run() {
                WeixinSDK sdk = WeixinSDK.getInstance();

                String param = "0";

                JSONObject objJson = new JSONObject();
                try {

                    objJson.put("gameid", 0);
                    objJson.put("path", path);

                } catch (JSONException e) {
                    e.printStackTrace();
                    return;
                }

                if (sdk.param.length()>0)
                {
                    Log.e("loginReady:2", sdk.param);

                    String info = sdk.param;

                    param = info;

                    // Cocos2dxLuaJavaBridge.callLuaGlobalFunctionWithString("G_RequestFromWChat",info);
                }
                else
                {
                    param = objJson.toString();
                }

                Cocos2dxLuaJavaBridge.callLuaFunctionWithString(callback, param);
                Cocos2dxLuaJavaBridge.releaseLuaFunction(callback);

                sdk.param = "";


            }
        });

    }

    public static void share(final String json, final int callback) {
        // Log.e("WX share", screenshot + " " + friend);
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

                int sex = objInfo.optInt("sex");

                String bgPath = objInfo.optString("bgPath");

                WeixinSDK sdk = WeixinSDK.getInstance();
                sdk.shareCallback = callback;
                boolean friend = objInfo.optBoolean("friend");
                sdk.isFriend = friend;

                AppActivity.MySharedTitle = objInfo.optString("SharedTitle");
                AppActivity.MySharedDescription = objInfo.optString("SharedDescription");
                AppActivity.MySharedUrl = objInfo.optString("SharedUrl");

                String sharePath = objInfo.optString("sharePath");
                int sharePerson = objInfo.optInt("sharePerson");
                int shareFrined = objInfo.optInt("shareFrined");
                boolean screenshot = objInfo.optBoolean("screenshot");

                Log.e("SharedTitle", AppActivity.MySharedTitle);
                Log.e("MySharedDescription", AppActivity.MySharedDescription);
                Log.e("MySharedUrl", AppActivity.MySharedUrl);
                Log.e("sharePath", sharePath);
                Log.e("sharePerson", sharePerson+"");
                Log.e("shareFrined", shareFrined+"");

                sdk.iwxapi.registerApp(WeixinSDK.appId);


                if (friend) {

                    SendMessageToWX.Req req = new SendMessageToWX.Req();

                    if(sharePath.length()==0 || sharePath==null)
                    {
                        WXTextObject obj = new WXTextObject();
                        obj.text = AppActivity.MySharedDescription + " 下载地址：" + AppActivity.MySharedUrl;

                        WXMediaMessage msg = new WXMediaMessage();
                        msg.title = AppActivity.MySharedTitle;
                        msg.mediaObject = obj;

                        req.message = msg;
                    }
                    else
                    {
                        if(shareFrined==1)
                        {
                            WXWebpageObject webpage = new WXWebpageObject();
                            webpage.webpageUrl = AppActivity.MySharedUrl;

                            WXMediaMessage msg = new WXMediaMessage(webpage);
                            msg.title = AppActivity.MySharedTitle;
                            msg.description = AppActivity.MySharedDescription;

                            String filesPath = AppActivity.getContext().getApplicationContext().getFilesDir().getAbsolutePath();
                            Log.e("filesPath", filesPath);

                            String path = filesPath + "/ShareIcon.png";

                            File file = new File(path);
                            if (!file.exists()) {
                                Util.copyAssetsFile("ShareIcon.png", path);
                            }
                            Bitmap bitmap = BitmapFactory.decodeFile(path);


                            msg.setThumbImage(bitmap);

                            req.message = msg;
                        }
                        else if(shareFrined==2)
                        {

                            String filesPath = AppActivity.getContext().getApplicationContext().getFilesDir().getAbsolutePath();
                            Log.e("filesPath", filesPath);
                            String path = filesPath + "/new_version/"+sharePath;

                            String path2 = filesPath + "share.png";


                            if(screenshot)
                            {
                                path = Util.getScreenShotPath(screenshot);
                            }
                            else
                            {
                                File file = new File(path);
                                if (!file.exists()) {

                                    Log.e("no exists---:",path);
                                    path = path2;
                                    Util.copyAssetsFile(sharePath, path);
                                }
                            }

                            Bitmap bmp = BitmapFactory.decodeFile(path);

                            WXImageObject imgObj = new WXImageObject(bmp);

                            //imgObj.setImagePath(path);

                            WXMediaMessage msg = new WXMediaMessage();
                            msg.mediaObject = imgObj;

                            Bitmap thumbBmp = Bitmap.createScaledBitmap(bmp, THUMB_SIZE, THUMB_SIZE, true);
                            bmp.recycle();
                            msg.thumbData = Util.bmpToByteArray(thumbBmp, true);
                            req.message = msg;

//                            Bitmap bmp = BitmapFactory.decodeResource(AppActivity.getContext().getResources(), R.drawable.sha);
//                            WXImageObject imgObj = new WXImageObject(bmp);
//
//                            WXMediaMessage msg = new WXMediaMessage();
//                            msg.mediaObject = imgObj;
//
//                            Bitmap thumbBmp = Bitmap.createScaledBitmap(bmp, THUMB_SIZE, THUMB_SIZE, true);
//                            bmp.recycle();
//                            msg.thumbData = Util.bmpToByteArray(thumbBmp, true);
//                            req.message = msg;

                        }
                    }

                    req.transaction = String.valueOf(System.currentTimeMillis());
                    req.scene = SendMessageToWX.Req.WXSceneTimeline;

                    sdk.iwxapi.sendReq(req);

                    // ((AppActivity) AppActivity.getContext()).finish();


                } else {

                    SendMessageToWX.Req req = new SendMessageToWX.Req();
                    if(sharePerson==1 || (sharePath.length()==0 || sharePath==null))
                    {
                        WXWebpageObject webpage = new WXWebpageObject();
                        webpage.webpageUrl = AppActivity.MySharedUrl;

                        WXMediaMessage msg = new WXMediaMessage(webpage);
                        msg.title = AppActivity.MySharedTitle;
                        msg.description = AppActivity.MySharedDescription;

                        // String path = "assets://" + sharePath;
                        String filesPath = AppActivity.getContext().getApplicationContext().getFilesDir().getAbsolutePath();
                        Log.e("filesPath", filesPath);
                        String path = filesPath + "/ShareIcon.png";
                        File file = new File(path);
                        if (!file.exists()) {

                            Log.e("no exists---:",path);
                            Util.copyAssetsFile("ShareIcon.png", path);
                        }

                        Bitmap bitmap = BitmapFactory.decodeFile(path);

                        double scale = Math.sqrt(32000.0f / (bitmap.getWidth() * bitmap.getHeight()));
                        if (scale < 1) {
                            bitmap = Bitmap.createScaledBitmap(bitmap, (int) (bitmap.getWidth() * scale),
                                    (int) (bitmap.getHeight() * scale), true);
                        }
                        msg.setThumbImage(bitmap);

                        req.message = msg;
                    }
                    else if(sharePerson==2)
                    {
                        String filesPath = AppActivity.getContext().getApplicationContext().getFilesDir().getAbsolutePath();
                        Log.e("filesPath", filesPath);

                        String path = filesPath + "/new_version/"+sharePath;
                        String path2 = filesPath + "share.png";

                        if(screenshot)
                        {
                            path = Util.getScreenShotPath(screenshot);
                        }
                        else
                        {
                            File file = new File(path);
                            if (!file.exists()) {

                                Log.e("no exists---:",path);
                                path = path2;
                                Util.copyAssetsFile(sharePath, path);
                            }
                        }

                        Bitmap bmp = BitmapFactory.decodeFile(path);

                        WXImageObject imgObj = new WXImageObject(bmp);

                        //imgObj.setImagePath(path);

                        WXMediaMessage msg = new WXMediaMessage();
                        msg.mediaObject = imgObj;

                        Bitmap thumbBmp = Bitmap.createScaledBitmap(bmp, THUMB_SIZE, THUMB_SIZE, true);
                        bmp.recycle();
                        msg.thumbData = Util.bmpToByteArray(thumbBmp, true);
                        req.message = msg;

                    }

                    req.transaction = String.valueOf(System.currentTimeMillis());
                    req.scene = SendMessageToWX.Req.WXSceneSession;
                    sdk.iwxapi.sendReq(req);
                }
            }
        });
    }

    public static void didShare(final BaseResp ret) {
        final WeixinSDK sdk = WeixinSDK.getInstance();
        Log.e("weixin didShare", ret.errCode + " " + sdk.shareCallback);

        if (sdk.shareCallback != 0)
        {
            final int callback = sdk.shareCallback;
            sdk.shareCallback = 0;

            ((AppActivity) AppActivity.getContext()).runOnGLThread(new Runnable() {
                @Override
                public void run() {
                    JSONObject obj = new JSONObject();
                    try {
                        obj.put("result", ret.errCode);
                        obj.put("friend", sdk.isFriend);
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
        else if(sdk.shareExCallBack != 0)
        {
            final int callback = sdk.shareExCallBack;
            sdk.shareExCallBack = 0;

            ((AppActivity) AppActivity.getContext()).runOnGLThread(new Runnable() {
                @Override
                public void run() {
                    JSONObject obj = new JSONObject();
                    try {

                        obj.put("result", ret.errCode);
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


    }

    public static void didLogin(final JSONObject ret) {
        final WeixinSDK sdk = WeixinSDK.getInstance();
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
                    if (ret == null) {


                        Log.e("Weixin didLogin", "ccc");

                        obj.put("result", 1);
                    } else {
                        obj.put("result", 0);
                        obj.put("access_token", ret.optString("access_token", ""));
                        obj.put("expires_in", ret.optInt("expires_in", 0) + System.currentTimeMillis() / 1000);
                        obj.put("refresh_token", ret.optString("refresh_token", ""));
                        obj.put("openid", ret.optString("openid", ""));

                        Log.e("Weixin didLogin", "bbb");
                    }
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

    public static void recharge(final String json, final int callback) {
        ((AppActivity) AppActivity.getContext()).runOnUiThread(new Runnable() {
            @Override
            public void run() {
                JSONObject obj;
                try {
                    obj = new JSONObject(json);
                } catch (JSONException e) {
                    e.printStackTrace();
                    return;
                }

                WeixinSDK sdk = WeixinSDK.getInstance();
                sdk.rechargeCallback = callback;

                PayReq request = new PayReq();
                request.appId = WeixinSDK.appId;
                request.partnerId = obj.optString("PartnerId", "");
                request.prepayId = obj.optString("PrepayId", "");
                request.packageValue = obj.optString("Package", "");
                request.nonceStr = obj.optString("Noncestr", "");
                request.timeStamp = obj.optString("Timestamp", "");
                request.sign = obj.optString("Sign", "");

                sdk.iwxapi.sendReq(request);
            }
        });
    }

    public static void didRecharge(final BaseResp ret) {
        final WeixinSDK sdk = WeixinSDK.getInstance();
        Log.e("weixin recharge", ret.errCode + " " + sdk.rechargeCallback);
        if (sdk.rechargeCallback == 0) {
            return;
        }
        final int callback = sdk.rechargeCallback;
        sdk.rechargeCallback = 0;

        ((AppActivity) AppActivity.getContext()).runOnGLThread(new Runnable() {
            @Override
            public void run() {
                JSONObject obj = new JSONObject();
                try {
                    obj.put("result", ret.errCode);
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

    public static void shareEx(final String json, final int callback)
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

                WeixinSDK sdk = WeixinSDK.getInstance();

                sdk.shareExCallBack = callback;

                boolean isAdd = objInfo.optBoolean("isAddFriend");

                int sex = objInfo.optInt("sex");

                String requestInfo = objInfo.optString("requestInfo");
                String downUrl = objInfo.optString("SharedUrl");
                String titleInfo = objInfo.optString("titleInfo");
                String uid = objInfo.optString("uid");

                String gameid = objInfo.optString("gameid");
                String roomid = objInfo.optString("roomid");
                String session = objInfo.optString("session");
                String tableid = objInfo.optString("tableid");
                String seatid = objInfo.optString("seatid");
                String password = objInfo.optString("password");
                String nowTime = String.valueOf(System.currentTimeMillis());

                Log.e("requestInfo:", requestInfo);
                Log.e("SharedUrl:", downUrl);


                String filesPath = AppActivity.getContext().getApplicationContext().getFilesDir().getAbsolutePath();
                Log.e("filesPath", filesPath);

                String path = filesPath + "/ShareIcon.png";

                File file = new File(path);
                if (!file.exists()) {
                    Util.copyAssetsFile("ShareIcon.png", path);
                }
                Bitmap bitmap = BitmapFactory.decodeFile(path);


                WXWebpageObject webpage = new WXWebpageObject();
                webpage.webpageUrl = downUrl;

                WXMediaMessage msg = new WXMediaMessage(webpage);
                msg.title = titleInfo;
                msg.description = requestInfo;

                msg.setThumbImage(bitmap);

//                final WXAppExtendObject appdata = new WXAppExtendObject();
//                //final String path = SDCARD_ROOT + "/test.png";
//
//                JSONArray array = new JSONArray();
//
//                array.put(gameid);
//                array.put(roomid);
//                array.put(uid);
//                array.put(session);
//                array.put(tableid);
//                array.put(seatid);
//                array.put(password);
//                array.put(nowTime);
//
//                appdata.fileData = array.toString().getBytes();
//                appdata.extInfo = uid;
//                //appdata.filePath = ;
//
//                final WXMediaMessage msg = new WXMediaMessage();
//                msg.setThumbImage(bitmap);
//
//                msg.title = titleInfo;
//                msg.description = requestInfo;
//                msg.mediaObject = appdata;

                SendMessageToWX.Req req = new SendMessageToWX.Req();

                req.transaction = String.valueOf(System.currentTimeMillis());
                req.message = msg;

                req.scene = SendMessageToWX.Req.WXSceneSession;
                sdk.iwxapi.sendReq(req);

            }
        });

    }

    public static void didShareEx(ShowMessageFromWX.Req showReq) {
        final WeixinSDK sdk = WeixinSDK.getInstance();
        Log.e("weixin didShareEx:", ""+sdk.shareExCallBack);

        WXMediaMessage wxMsg = showReq.message;
        WXAppExtendObject obj = (WXAppExtendObject) wxMsg.mediaObject;

        byte[] fileData = obj.fileData;

        String sFileData = new String(fileData);

        JSONArray array;
        String gameid;
        String roomid;
        String uid;
        String session;
        String tableid;
        String seatid;
        String password;


        try {
            array = new JSONArray(sFileData);

            gameid = array.getString(0);
            roomid = array.getString(1);
            uid = array.getString(2);
            session = array.getString(3);
            tableid = array.getString(4);
            seatid = array.getString(5);
            password = array.getString(6);

            Log.e("weixin gameid:", gameid);


        } catch (JSONException e)
        {
            e.printStackTrace();
            return;
        }

        JSONObject objJson = new JSONObject();
        try {

            objJson.put("gameid", gameid);
            objJson.put("roomid", roomid);
            objJson.put("uid", uid);
            objJson.put("session", session);
            objJson.put("tableid", tableid);
            objJson.put("seatid", seatid);
            objJson.put("password", password);

        } catch (JSONException e) {
            e.printStackTrace();
            return;
        }

        String param = objJson.toString();

        Cocos2dxLuaJavaBridge.callLuaGlobalFunctionWithString("G_RequestFromWChat",param);

    }

}
