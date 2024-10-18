string appId = "";
string key = "";

string GetVersion(){
    return "1.0.0";
}

string GetTitle(){
    return "{$CP936=百度翻译$}{$CP950=百度翻译$}{$CP0=BaiDu translate$}";
}

string GetDesc(){
    return "https://github.com/Chen2226/PotPlayer_Subtitle_Translate";
}

string GetLoginTitle(){
    return "请输入配置";
}

string GetLoginDesc(){
    return "请输入AppId和密钥！";
}

string GetUserText(){
    return "App ID:";
}

string GetPasswordText(){
    return "密钥:";
}


array<string> GetSrcLangs(){
    array<string> ret = GetLangTable();
    ret.insertAt(0, "");
    return ret;
}

array<string> GetDstLangs(){
    return GetLangTable();
}

string ServerLogin(string User, string Pass){
    appId = User;
    key = Pass;
	if (appId.empty() || key.empty()) return "fail";
	return "200 ok";
}

string Translate(string text, string &in srcLang, string &in dstLang){
    string ret = "";
    if(!text.empty()){
        
        string parames = "&app_id=" + appId + "&sec_key=" + key + "&source_text="+ HostUrlEncode(text) + "&source_language=" + GetLang(srcLang) + "&target_language=" + GetLang(dstLang);
        string url = "https://server.cutil.top/translate/baidu?" + parames;

        string html = HostUrlGetString(url);

        if(!html.empty()){
            ret = JsonParse(html);
        }

        if(ret.length() > 0){
            srcLang = "UTF8";
            dstLang = "UTF8";
        }
    }
    return ret;
}

string GetLang(string &in lang){
    string l = lang;
    if(l.empty()) {
        l = 'auto';
    }else if(lang == "zh-CN"){
        l = "zh";
    } else if(lang == "zh-TW"){
        l = "cht";
    } else if(lang == "ja"){
        l = "jp";
    } else if(lang == "ko"){
        l = "kor";
    } else if(lang == "fr"){
        l = "fra";
    } else if(lang == "es"){
        l = "spa";
    } else if(lang == "vi"){
        l = "vie";
    } else if(lang == "ar"){
        l = "ara";
    }
    return l;
}

array<string>  GetLangTable(){
    array<string> langList = {
        "zh-CN",//zh
        "zh-TW",//cht
        "en",
        "ja",//jp
        "ko",//kor
        "fr",//fra
        "es",//spa
        "th",
        "vi",//vie
        "it",
        "ru",
        "pt",
        "de",
        "ar",//ara
        "nl",
        "el",
        "tr",
    };
    return langList;
}

string JsonParse(string json){
    string text = "";
    JsonReader reader;
    JsonValue res;
    if (reader.parse(json, res)){
        if(res.isObject()){
            if(res["code"].asString() != "200"){
                text = "错误信息：" + res["msg"].asString();
            } else {
                JsonValue transResult = res["data"]["text"];
                if(transResult.isArray()){
                    for(int i = 0; i < transResult.size(); i++){
                        JsonValue str = transResult[i];
                        if(i > 0){
                            text += "\n";
                        }
                        text += str.asString();
                    }
                }
            }
        }
    } 
    return text;
}
