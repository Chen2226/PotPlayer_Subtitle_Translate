string SecretId = "";
string SecretKey = "";

string GetVersion(){
    return "1.0.0";
}

string GetTitle(){
    return "{$CP936=腾讯翻译$}{$CP950=腾讯翻译$}{$CP0=Tencent translate$}";
}

string GetDesc(){
    return "https://github.com/Chen2226/PotPlayer_Subtitle_Translate";
}

string GetLoginTitle(){
    return "请输入配置";
}

string GetLoginDesc(){
    return "请输入SecretId和SecretKey！";
}

string GetUserText(){
    return "SecretId:";
}

string GetPasswordText(){
    return "SecretKey:";
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
    SecretId = User;
    SecretKey = Pass;
	if (SecretId.empty() || SecretKey.empty()) return "fail";
	return "200 ok";
}

string Translate(string text, string &in srcLang, string &in dstLang){
    string ret = "";
    if(!text.empty()){
        
        string parames = "&secret_id=" + SecretId + "&secret_key=" + SecretKey + "&source_text="+ HostUrlEncode(text) + "&source_language=" + GetLang(srcLang) + "&target_language=" + GetLang(dstLang);
        string url = "https://server.cutil.top/translate/tencent?" + parames;

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
    } else {
        l = 'auto';
    }
    return l;
}

array<string>  GetLangTable(){
    array<string> langList = {
        "zh-CN",//zh
        "zh-TW",
        "en",
        "ja",
        "ko",
        "fr",
        "es",
        "th",
        "vi",
        "it",
        "ru",
        "pt",
        "de",
        "ar",
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
                text = res["data"]["text"].asString();
            }
        }
    } 
    return text;
}
