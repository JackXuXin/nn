package com.tencent.tmgp.shaoxing.wxapi;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

import com.tencent.mm.sdk.constants.ConstantsAPI;
import com.tencent.mm.sdk.modelbase.BaseReq;
import com.tencent.mm.sdk.modelbase.BaseResp;
import com.tencent.mm.sdk.openapi.IWXAPIEventHandler;

import app.WeixinSDK;

/**
 * Created by hantaosun on 5/4/16.
 */
public class WXPayEntryActivity extends Activity implements IWXAPIEventHandler {

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
        WeixinSDK.getInstance().iwxapi.handleIntent(intent, this);
    }

    @Override
    public void onReq(BaseReq req) {

    }

    @Override
    public void onResp(BaseResp resp) {
        Log.e("Weixin onResp", resp.getType() + "");
        if (resp.getType() == ConstantsAPI.COMMAND_PAY_BY_WX ) {
            WeixinSDK.didRecharge(resp);
        }

        finish();
    }
}
