package app;

import android.app.ActivityManager;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;

import org.cocos2dx.lua.AppActivity;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Timer;
import java.util.TimerTask;

public class Util {

    private static Util instance;

    public static boolean logger=true;

    public static synchronized Util getInstance() {
        if (instance == null) {
            instance = new Util();
        }
        return instance;
    }

    /**
     * 获取当前系统SDK版本号
     */
    public static int getSystemVersion(){
		/*获取当前系统的android版本号*/
        int version= android.os.Build.VERSION.SDK_INT;
        return version;
    }


    private Bitmap compressImage(Bitmap image) {

        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        image.compress(Bitmap.CompressFormat.JPEG, 100, baos);//质量压缩方法，这里100表示不压缩，把压缩后的数据存放到baos中
        int options = 100;
        while ( baos.toByteArray().length / 1024>32) {  //循环判断如果压缩后图片是否大于32kb,大于继续压缩
            baos.reset();//重置baos即清空baos
            image.compress(Bitmap.CompressFormat.JPEG, options, baos);//这里压缩options%，把压缩后的数据存放到baos中
            options -= 1;//每次都减少1
        }
        ByteArrayInputStream isBm = new ByteArrayInputStream(baos.toByteArray());//把压缩后的数据baos存放到ByteArrayInputStream中
        Bitmap bitmap = BitmapFactory.decodeStream(isBm, null, null);//把ByteArrayInputStream数据生成图片
        return bitmap;
    }
//
//    public static byte[] bmpToByteArray(final Bitmap bmp, final boolean needRecycle) {
//        ByteArrayOutputStream output = new ByteArrayOutputStream();
//
//        final Util util = Util.getInstance();
//     //   Bitmap compressBit = util.compressImage(bmp);
//        bmp.compress(Bitmap.CompressFormat.JPEG, 100, output);
//        if (needRecycle) {
//            bmp.recycle();
//        }
//
//        byte[] result = output.toByteArray();
//        try {
//            output.close();
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//
//        return result;
//    }



    public static byte[] bmpToByteArray(final Bitmap bmp,
                                        final boolean needRecycle) {
        ByteArrayOutputStream output = new ByteArrayOutputStream();
        bmp.compress(Bitmap.CompressFormat.JPEG, 100, output);
        int i = 3276800 / output.toByteArray().length;
        if (i < 100) {
            output.reset();// 重置baos即清空baos
            bmp.compress(Bitmap.CompressFormat.JPEG, i, output);// 这里压缩options%，把压缩后的数据存放到baos中
        }
        if (needRecycle) {
            bmp.recycle();
        }
        byte[] result = output.toByteArray();
        try {
            output.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return result;
    }


    public static String getScreenShotPath(boolean screenshot) {
        String path = "";
        String filesPath = AppActivity.getContext().getApplicationContext().getFilesDir().getAbsolutePath();
        if (screenshot) {
            path = filesPath + "/ScreenShot.png";
        } else {
            path = filesPath + "/ShareIcon.png";

            try {
                File file = new File(path);
                if (!file.exists()) {
                    Util.copyAssetsFile("ShareIcon.png", path);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return path;
    }

    public static boolean copyAssetsFile(String srcPath, String dstPath) {
        boolean ret = false;

        try {


            InputStream in = AppActivity.getContext().getResources().getAssets()
                    .open(srcPath);

            //InputStream in =  new FileInputStream(srcPath);
            OutputStream out = new FileOutputStream(dstPath);

            byte[] buffer = new byte[1024];
            int length = in.read(buffer);
            while(length > 0)
            {
                out.write(buffer, 0, length);
                length = in.read(buffer);
            }
            out.flush();
            in.close();
            out.close();

            ret = true;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return ret;
    }



    public static int getDayOfWeek(){
        int weekday=0;
        Calendar c = Calendar.getInstance();
        c.setTime(new Date(System.currentTimeMillis()));
        int dayOfWeek = c.get(Calendar.DAY_OF_WEEK);
        switch (dayOfWeek) {
            case 1:
                weekday=dayOfWeek;
                System.out.println("星期日");
                break;
            case 2:
                weekday=dayOfWeek;
                //System.out.println("星期一");
                break;
            case 3:
                weekday=dayOfWeek;
                System.out.println("星期二");
                break;
            case 4:
                weekday=dayOfWeek;
                System.out.println("星期三");
                break;
            case 5:
                weekday=dayOfWeek;
                System.out.println("星期四");
                break;
            case 6:
                weekday=dayOfWeek;
                System.out.println("星期五");
                break;
            case 7:
                weekday=dayOfWeek;
                System.out.println("星期六");
                break;
        }
        return weekday;
    }

    public static void getDaytime(){
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd ");
        Date date = new Date();
        //定义开始时间字符串
        String timeStr = "20:13:00";
        timeStr =sdf.format(date)+timeStr;
        //获得当天的指定时间的date对象
        sdf = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
        //System.out.println("设定时间为： "+timeStr);
        try {
            date = sdf.parse(timeStr);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        //判断今天的执行时间是否已经过去，如果过去则改为明天
        if(date.getTime()<System.currentTimeMillis()){
            date = new Date(date.getTime()+24*60*60*1000);
        }

//        TimerTask task = new TimerTask(){
//            @Override
//            public void run() {
//                //your task
//                System.out.println("task 来了 ");
//            }
//        };
//        Timer timer = new Timer();
//        timer.schedule(task, date, 24*60*60*1000);
    }

    public static Date  getTaskStartTime(Context ctx){
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd ");
        Date date = new Date();
        //定义开始时间字符串
        String timeStr = "8:00:00";
        timeStr =sdf.format(date)+timeStr;
        //获得当天的指定时间的date对象
        sdf = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
        try {
            date = sdf.parse(timeStr);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        //System.out.println("startTime= "+date.getTime());
        return date;
    }

    /**
     * 获取当前时间 yyyy-MM-dd HH:mm:ss
     */
    public static Long getCurrentTime(){
        try{
            Date date=new Date();
            SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            //System.out.println("current time---"+df.format(date));
            return df.parse(df.format(date)).getTime();
        }catch(Exception e){
        }
        return null;
    }

    public static String getLongTimeToDateTime(Long l){
        Date date=new Date(l);
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String t=df.format(date);
        System.out.println("现在的时间是:"+t);
        return t;
    }

    public static boolean isServiceRunning(Context ctx,String filePath) {
        ActivityManager manager = (ActivityManager) ctx.getSystemService(ctx.ACTIVITY_SERVICE);
        for (ActivityManager.RunningServiceInfo service : manager.getRunningServices(Integer.MAX_VALUE)) {
            if (filePath.equalsIgnoreCase(service.service.getClassName())) {
                return true;
            }
        }
        return false;
    }

}