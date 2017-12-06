/****************************************************************************
Copyright (c) 2008-2010 Ricardo Quesada
Copyright (c) 2010-2012 cocos2d-x.org
Copyright (c) 2011      Zynga Inc.
Copyright (c) 2013-2014 Chukong Technologies Inc.
 
http://www.cocos2d-x.org

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
****************************************************************************/
package org.cocos2dx.lua;

import org.cocos2dx.lib.Cocos2dxActivity;
import org.cocos2dx.lib.Cocos2dxLuaJavaBridge;
import org.json.JSONException;
import org.json.JSONObject;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

import com.android.volley.RequestQueue;
import com.android.volley.toolbox.Volley;
import com.nostra13.universalimageloader.core.ImageLoaderConfiguration;
import com.qiyukf.unicorn.api.Unicorn;
import com.tencent.connect.common.Constants;
import com.tencent.mm.sdk.openapi.WXAPIFactory;
import com.tencent.tauth.Tencent;

import android.support.v4.app.ActivityCompat;
import android.support.v4.app.FragmentTransaction;
import android.support.v4.content.ContextCompat;
import android.Manifest;
import android.app.AlertDialog;
import android.content.pm.PackageManager;
import android.content.DialogInterface;
import android.support.annotation.NonNull;
import android.net.Uri;

import android.content.BroadcastReceiver;
import android.content.IntentFilter;
import android.content.Intent;

import java.io.File;
import java.util.TimerTask;
import java.util.Timer;

import app.AliSDK;
import app.QQSDK;
import app.Util;
import app.WeixinSDK;
import app.QiYuSDK;
import app.UILImageLoader;
import app.PermissionsChecker;
import app.PermissionsActivity;

import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;


//import com.tencent.android.tpush.XGPushManager;
//import com.tencent.android.tpush.XGIOperateCallback;



public class AppActivity extends Cocos2dxActivity implements ActivityCompat.OnRequestPermissionsResultCallback{

    static{

        System.loadLibrary("YvImSdk");
    }

    //add by whb 0915
    private static final int REQUEST_CODE = 0; // 请求码

    // 所需的全部权限
    static final String[] PERMISSIONS = new String[]{
            Manifest.permission.RECORD_AUDIO,
            Manifest.permission.WRITE_EXTERNAL_STORAGE,
//            Manifest.permission.READ_PHONE_STATE,
//            Manifest.permission.ACCESS_FINE_LOCATION,
//            Manifest.permission.ACCESS_COARSE_LOCATION,
    };


    private PermissionsChecker mPermissionsChecker; // 权限检测器
    // add end 0915


    private boolean granted;
    public static String MySharedTitle = "江南茶苑";
    public static String MySharedDescription = "江南茶苑［手机版］隆重上线！有港五、上虞麻将，简单又刺激...";
    public static String MySharedUrl = "http://www.jiangnangame.com";
    //public static String MySharedUrl = "myjncy://domain/path?gameID=1&roomID=0";

    public RequestQueue queue;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

        //initPermission();
        mPermissionsChecker = new PermissionsChecker(this);

        com.yunva.im.sdk.lib.YvLoginInit.initApplicationOnCreate(this.getApplication(), "1001201");

        queue = Volley.newRequestQueue(this);
////        QQSDK qqsdk = QQSDK.getInstance();
////        qqsdk.tencent = Tencent.createInstance(QQSDK.appId, getApplicationContext());
////
        WeixinSDK weixinSDK = WeixinSDK.getInstance();

        AliSDK.getInstance();

        Log.w("demoINit", "－－－－init!");
        //add by whb 161010
        QiYuSDK qiyuSdk = QiYuSDK.getInstance();
        if (!Unicorn.init(this, qiyuSdk.getYsfAppKey(), qiyuSdk.ysfOptions(), new UILImageLoader())) {
            Log.w("demo", "init qiyu sdk error!");
        }

        if (qiyuSdk.inMainProcess(this)) {
           // DemoCache.context = getApplicationContext();
            com.nostra13.universalimageloader.core.ImageLoader.getInstance().init(ImageLoaderConfiguration.createDefault(this));
        }
//        //add end
//
        String filesPath = AppActivity.getContext().getApplicationContext().getFilesDir().getAbsolutePath();
        Log.e("filesPath", filesPath);

        final String path = filesPath + "/FaceConfig.xml";

        File file = new File(path);
        if (!file.exists()) {
            Util.copyAssetsFile("FaceConfig.xml", path);
        }

        Intent i_getvalue = getIntent();
        String action = i_getvalue.getAction();

        if(Intent.ACTION_VIEW.equals(action)){
            Uri uri = i_getvalue.getData();
            if(uri != null){
                final String gameid1 = uri.getQueryParameter("gameID");
                final String roomid1= uri.getQueryParameter("roomID");

                Log.e("gameID:", gameid1);
                Log.e("roomID:", roomid1);
                final String uid = uri.getQueryParameter("uid");
                final String session = uri.getQueryParameter("session");
                final String tableid = uri.getQueryParameter("tableid");
                final String seatid = uri.getQueryParameter("seatid");
                final String password = uri.getQueryParameter("password");

                ((AppActivity) AppActivity.getContext()).runOnGLThread(new Runnable() {
                    @Override
                    public void run() {

                        JSONObject objJson = new JSONObject();
                        try {

                            objJson.put("gameid", gameid1);
                            objJson.put("roomid", roomid1);
                            objJson.put("uid", uid);
                            objJson.put("session", session);
                            objJson.put("tableid", tableid);
                            objJson.put("seatid", seatid);
                            objJson.put("password", password);
                            objJson.put("path", path);

                        } catch (JSONException e) {
                            e.printStackTrace();
                            return;
                        }

                        Log.e("roomID111:", "111");

                        WeixinSDK weixinSDK = WeixinSDK.getInstance();
                        weixinSDK.param = objJson.toString();
                        Log.e("roomID22:",  weixinSDK.param);

                    }
                });
            }
        }

	}

    private void initPermission() {
        int permission = ContextCompat.checkSelfPermission(this, Manifest.permission.RECORD_AUDIO);
        int permission2 = ContextCompat.checkSelfPermission(this, Manifest.permission.WRITE_EXTERNAL_STORAGE);

        if (permission != PackageManager.PERMISSION_GRANTED) {
            //需不需要解释的dialog
            if (shouldRequest(1) == false)
            {
                //请求权限
                ActivityCompat.requestPermissions(this, new String[]{Manifest.permission.RECORD_AUDIO}, 1);
            }

        }
        if(permission2 != PackageManager.PERMISSION_GRANTED)
        {
            //需不需要解释的dialog
            if (shouldRequest(2) == false)
            {
                //请求权限
                ActivityCompat.requestPermissions(this, new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE}, 2);
            }

        }

    }

    private boolean shouldRequest(int code) {

        if(code == 1)
        {
            if (ActivityCompat.shouldShowRequestPermissionRationale(this, Manifest.permission.RECORD_AUDIO)) {
                //显示一个对话框，给用户解释
                explainDialog(1);
                return true;
            }
        }
        else if(code == 2)
        {
            if (ActivityCompat.shouldShowRequestPermissionRationale(this, Manifest.permission.WRITE_EXTERNAL_STORAGE)) {
                //显示一个对话框，给用户解释
                explainDialog(2);
                return true;
            }
        }


        return false;
    }

    private void explainDialog(int code) {

        String str = "";

        if(code == 1)
        {
            str = "应用需要获取您的录音权限,是否授权？";
        }
        else if(code == 2)
        {
            str = "应用需要获取您的写入权限,是否授权？";
        }

        AlertDialog.Builder builder = new AlertDialog.Builder(this);
        builder.setMessage(str)
                .setPositiveButton("确定", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        //请求权限
                        ActivityCompat.requestPermissions((AppActivity)AppActivity.getContext(), new String[]{Manifest.permission.RECORD_AUDIO}, 1);
                    }
                }).setNegativeButton("取消", null)
                .create().show();
    }

    /**
     * 请求权限的回调
     *
     * 参数1：requestCode-->是requestPermissions()方法传递过来的请求码。
     * 参数2：permissions-->是requestPermissions()方法传递过来的需要申请权限
     * 参数3：grantResults-->是申请权限后，系统返回的结果，PackageManager.PERMISSION_GRANTED表示授权成功，PackageManager.PERMISSION_DENIED表示授权失败。
     * grantResults和permissions是一一对应的
     */
    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode == 1 && grantResults.length > 0)
        {
            granted = grantResults[0] == PackageManager.PERMISSION_GRANTED;//是否授权，可以根据permission作为标记

            Log.w("Permissio", "－－－－auto is ok!");
        }
        else if(requestCode == 2 && grantResults.length > 0)
        {
            Log.w("Permissio", "－－－－WRITE is ok!");
        }

    }

    // TODO GAME 游戏需要集成此方法并调用YSDKApi.onRestart()
    @Override
    protected void onRestart() {
        super.onRestart();
        Log.w("demoINit", "－－－－onRestart!");

    }

    // TODO GAME 游戏需要集成此方法并调用YSDKApi.onResume()
    @Override
    protected void onResume() {
        super.onResume();
        Log.w("demoINit", "－－－－onResume!");
        // 缺少权限时, 进入权限配置页面
        if (mPermissionsChecker.lacksPermissions(PERMISSIONS)) {

            Log.w("lacksPermissions-----", "0");
            startPermissionsActivity();
        }
    }

    private void startPermissionsActivity() {
        PermissionsActivity.startActivityForResult(this, REQUEST_CODE, PERMISSIONS);
    }

    // TODO GAME 游戏需要集成此方法并调用YSDKApi.onPause()
    @Override
    protected void onPause() {
        super.onPause();
        Log.w("demoINit", "－－－－onPause!");

    }

    // TODO GAME 游戏需要集成此方法并调用YSDKApi.onStop()
    @Override
    protected void onStop() {
        Log.w("demoINit", "－－－－onStop!");
       // unregisterReceiver(myReceiver);
        super.onStop();
    }

    // TODO GAME 游戏需要集成此方法并调用YSDKApi.onDestory()
    @Override
    protected void onDestroy() {
        Log.w("demo", "－－－－onDestroy!");
        super.onDestroy();

        com.yunva.im.sdk.lib.YvLoginInit.release();
    }

    @Override
    public void finish() {

        Log.d("demo", "－－－－finish!");
        super.finish();
    }

    // TODO GAME 在onNewIntent中需要调用handleCallback将平台带来的数据交给YSDK处理
    @Override
    protected void onNewIntent(Intent intent) {
        Log.e("onNewIntent", "AppActivity");
        super.onNewIntent(intent);

        Intent i_getvalue = intent;
        String action = i_getvalue.getAction();

        if(Intent.ACTION_VIEW.equals(action)){
            Uri uri = i_getvalue.getData();
            if(uri != null){
                final String gameid1 = uri.getQueryParameter("gameID");
                final String roomid1= uri.getQueryParameter("roomID");

                Log.e("gameID:", gameid1);
                Log.e("roomID:", roomid1);
                final String uid = uri.getQueryParameter("uid");
                final String session = uri.getQueryParameter("session");
                final String tableid = uri.getQueryParameter("tableid");
                final String seatid = uri.getQueryParameter("seatid");
                final String password = uri.getQueryParameter("password");

                 ((AppActivity) AppActivity.getContext()).runOnGLThread(new Runnable() {
                   @Override
                   public void run() {

                JSONObject objJson = new JSONObject();
                try {

                    objJson.put("gameid", gameid1);
                    objJson.put("roomid", roomid1);
                    objJson.put("uid", uid);
                    objJson.put("session", session);
                    objJson.put("tableid", tableid);
                    objJson.put("seatid", seatid);
                    objJson.put("password", password);

                } catch (JSONException e) {
                    e.printStackTrace();
                    return;
                }

                Log.e("roomID111:rtt", "111");

                String param = objJson.toString();

                Log.e("roomID22:", param);

                Cocos2dxLuaJavaBridge.callLuaGlobalFunctionWithString("G_RequestFromWChat",param);


            }
             });
             }
        }
    }

    // TODO GAME 在onActivityResult中需要调用YSDKApi.onActivityResult
    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if(requestCode == Constants.REQUEST_LOGIN) {
            Tencent.onActivityResultData(requestCode, resultCode, data, QQSDK.getInstance());
        }

        // 拒绝时, 关闭页面, 缺少主要权限, 无法运行
        if (requestCode == REQUEST_CODE && resultCode == PermissionsActivity.PERMISSIONS_DENIED) {
            finish();
        }
    }
}
