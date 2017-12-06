<?php

	echo "接收到{$argc}个参数\n";
	#print_r($argv);

    $app_name = $argv[1];
    $app_root = $argv[2];

    echo "app_name:$app_name\n";

	//读取XML并解析
	$string_doc = new DOMDocument();
	$string_doc->load($temp_prj_dir . "$app_root/res/values/strings.xml");
	$stringList = $string_doc->getElementsByTagName("string");

	$len = $stringList->length;
	for($i=0;$i<$len;$i++) {
	    $item  = $stringList->item($i);//获取列表中单条记录
	    if($item->getAttribute('name') == "app_name") {
	        $item->nodeValue = $app_name;
	        break;
	    }
	}
	$string_doc->save($temp_prj_dir . "$app_root/res/values/strings.xml");
	echo "修改app_name success\n";
?>