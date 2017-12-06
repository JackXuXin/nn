package com.tencent.tmgp.shaoxing.wxapi;


import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.StringRequest;
import com.tencent.mm.sdk.constants.ConstantsAPI;
import com.tencent.mm.sdk.modelbase.BaseReq;
import com.tencent.mm.sdk.modelbase.BaseResp;
import com.tencent.mm.sdk.modelmsg.SendAuth;
import com.tencent.mm.sdk.modelmsg.ShowMessageFromWX;
import com.tencent.mm.sdk.openapi.IWXAPIEventHandler;

import org.cocos2dx.lua.AppActivity;
import org.json.JSONException;
import org.json.JSONObject;

import app.HttpsTrustManager;
import app.WeixinSDK;

/**
 * !!此文件的代码逻辑部分使用者不要修改
 */
public class WXEntryActivity extends Activity implements IWXAPIEventHandler {

    private StringRequest request;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        Log.e("onCreate", "WXEntryActivity");
        super.onCreate(savedInstanceState);

        WeixinSDK.getInstance().iwxapi.handleIntent(getIntent(), this);
    }

    @Override
     protected void onNewIntent(Intent intent) {
        Log.e("onNewIntent", "WXEntryActivity");
        // TODO Auto-generated method stub
        super.onNewIntent(intent);
       // setIntent(intent);
        WeixinSDK.getInstance().iwxapi.handleIntent(intent, this);
    }

    @Override
//    public void onReq(BaseReq req) {
//        Log.e("Weixin onReq", req.getType() + "");
//    }

    public void onReq(BaseReq req) {

        Log.e("Weixin onReq", req.getType() + "");

        if(req.getType() == ConstantsAPI.COMMAND_SHOWMESSAGE_FROM_WX)
        {
            WeixinSDK.didShareEx((ShowMessageFromWX.Req) req);

           // Intent intent = new Intent(this, ShowFromWXActivity.class);

           // startActivity(intent);
            finish();
        }
    }

    @Override
    public void onResp(BaseResp resp) {
        Log.e("Weixin onResp", resp.getType() + "");

        if (resp.getType() == ConstantsAPI.COMMAND_SENDAUTH ) {
            SendAuth.Resp ret = (SendAuth.Resp)resp;

            Log.e("Weixin onResp222", ret.errCode+"");

            if (ret.errCode != BaseResp.ErrCode.ERR_OK) {

                Log.e("Weixin onResp444", ret.errCode+"");
                WeixinSDK.didLogin(null);
            } else {

                Log.e("Weixin onResp333", ret.code+"");
                GetToken(ret.code);
                return;
            }
        }
        else if (resp.getType() == ConstantsAPI.COMMAND_SENDMESSAGE_TO_WX )
        {
            Log.e("Weixin COMMAND-resp", resp.getType() + "");
            WeixinSDK.didShare(resp);

        }

        finish();
        Log.e("Weixin finish", resp.getType() + "");
    }

    private void GetToken(String code) {
        String url = "https://api.weixin.qq.com/sns/oauth2/access_token?"
                + "appid="+WeixinSDK.appId + "&secret=" + WeixinSDK.appKey
                + "&code=" + code + "&grant_type=authorization_code";

        HttpsTrustManager.allowAllSSL();
        request = new StringRequest(url, new Response.Listener<String>() {
            @Override
            public void onResponse(String response) {
                Log.e("GetToken", response);

                try {
                    JSONObject ret = new JSONObject(response);
                    WeixinSDK.didLogin(ret);
                } catch (JSONException e) {
                    e.printStackTrace();
                }
                finish();
            }
        }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                finish();
            }
        });

        ((AppActivity) AppActivity.getContext()).queue.add(request);
    }


}
