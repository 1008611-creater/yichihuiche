extends Node
## ============================================================
## 浜洪棿闀滈壌 路 鐭ヤ箮鍐呭鎺ュ叆灞?## ============================================================
## 浣滅敤锛氱粓绔犮€婇噴鎬€淇°€嬩箣鍚庯紝鎶婄帺瀹剁殑閬楁喚涓婚鎺ュ埌鐭ヤ箮涓婄湡瀹炲瓨鍦ㄧ殑
##       鏁呬簨涓庨棶绛斾笂锛岃铏氭瀯鐨勪笁娈典汉鐢熻惤鍦ㄧ湡瀹炰汉闂寸粡楠屼笂銆?##
## 浣跨敤杈圭晫锛堜弗鏍奸伒瀹堥粦瀹㈡澗鍐呭鎺ュ彛璇存槑锛夛細
##   1) 鍙睍绀虹湡瀹炲瓨鍦ㄧ殑鐭ヤ箮浣滃搧锛屽瀹炰繚鐣欎綔鑰呫€佹爣棰樹笌鏉ユ簮閾炬帴锛?##   2) 涓嶆敼鍐欐鏂囥€佷笉鎶婂師鏂囪鎴愭槸鏈簲鐢ㄦ垨鐜╁鍒涗綔锛?##   3) 鍗曟鍙彇涓€灏忔锛屾帶鍒堕暱搴︼紱
##   4) 瀛楁缂哄け灏卞瀹炵暀绌猴紝涓嶈ˉ閫狅紱
##   5) 鍙闂?api.zhihu.com锛屽け璐ヤ笉閲嶈瘯銆佷笉鎹㈠煙鍚嶏紱
##   6) 鑱旂綉澶辫触鏃剁敤鍐呯疆鐨勭湡瀹炴潯鐩厹搴曪紝鐜╁姘歌繙鐪嬪緱鍒颁笢瑗裤€?##
## 鍐呯疆鏉＄洰鍏ㄩ儴鏉ヨ嚜鏈榛戝鏉惧畼鏂瑰唴瀹规帴鍙ｇ殑鐪熷疄杩斿洖锛?026-09-12 瀹炴祴锛夛紝
## 涓嶆槸缂栭€犵殑绀轰緥鏁版嵁銆?
signal refreshed()

const API_HOST := "https://api.zhihu.com"
const PATH_STORY := "/km-indep-home/hackathon/v2/story/"
const PATH_KNOWLEDGE := "/km-indep-home/hackathon/v2/knowledge/"
const CACHE_DIR := "user://zhihu_cache"

## 鑱旂綉鍒锋柊鍙粰杩欎箞闀挎椂闂达紝瓒呬簡灏辩敤鍐呯疆鏉＄洰锛岀粷涓嶈鐜╁绛夈€?const FETCH_BUDGET := 2.5
## 姝ｆ枃鍙彇寮€澶磋繖鍑犺锛屾帶鍒跺崟娆¤緭鍑洪暱搴︺€?const EXCERPT_LINES := 3
const EXCERPT_MAX := 88

const STORY_URL := "https://www.zhihu.com/story/"
const KNOWLEDGE_URL := "https://www.zhihu.com/search?type=content&q="

# ------------------------------------------------------------
# 鍐呯疆鏁呬簨鏉＄洰锛氫笁娈?BE 鍚勮嚜瀵瑰簲涓€绡囩湡瀹炵殑鐭ヤ箮鏁呬簨
# ------------------------------------------------------------
const STORIES := {
	"閿欒繃": {
		"work_id": "1985108790006277782",
		"title": "绔榛戝張澹?,
		"author": "閲嶅崄鍏?,
		"avatar": "https://picx.zhimg.com/v2-a476c33321632d876b715ee383b4e7e0.jpg?source=33ed3ac9",
		"labels": ["瑷€鎯?, "澶уコ涓?, "BE", "铏愭亱", "鏆楁亱", "澶氳瑙掑弽杞?, "娌绘剤", "鍙や唬"],
		"intro": "榛戝張澹叆瀹悗锛岀殗甯濇嬁鎴戝綋鍏勫紵锛屽皢鍐涜鎴戝儚鏄熸槦銆?,
		"excerpt": "閫夌閭ｅぉ锛屾垜鎵撲簡涓柗鍤忥紝闇囧緱澶ф鐡︾墖涔遍ⅳ銆俓n钀у鐪嬫垜鐨勭溂绁炲儚鍦ㄧ湅涓€澶磋鍏ラ工缇ょ殑妫曠唺锛屾渶鍚庡嵈澶ф墜涓€鎸ャ€俓n銆岀暀锛屾濂界粰鏈曠殑鍚庡杈熼偑銆傘€?,
	},
	"閫夐敊": {
		"work_id": "2025954672918163637",
		"title": "鍚冧汉蹇冪殑灏忓鎬?,
		"author": "濂冲帆",
		"avatar": "https://pica.zhimg.com/v2-c1300d3129e2aa7819333599aa8abd12.jpg?source=33ed3ac9",
		"labels": ["鐜勫够濂囧够", "鑴戞礊", "鐜勫", "娌绘剤", "浠欎緺", "HE", "鍙や唬"],
		"intro": "鍚冧汉蹇冪殑灏忓鎬渶鍚庢垚浠欎簡",
		"excerpt": "鎴戞槸涓€涓悆浜哄績鐨勫皬濡栨€€俓n濞樿鍚冨涓€涓囬浜哄績灏辫兘鎴愪粰銆俓n鍙ス杩樻病鍛婅瘔鎴戣繖浜哄績鎬庝箞鍚冿紝灏辨浜嗐€?,
	},
	"澶卞幓": {
		"work_id": "1930445234262750503",
		"title": "淇哄鍜屽ス鐨勪抚灏搁椇濂?,
		"author": "褰掑儚",
		"avatar": "https://pic1.zhimg.com/v2-5814dc275ef7c07553949e79a46f198e.jpg?source=33ed3ac9",
		"labels": ["鐜板疄鎯呮劅", "鑽夋牴", "瀹跺涵", "涓у案", "姹傜敓", "娌绘剤", "鍔卞織", "鏈棩"],
		"intro": "淇哄鍜屽ス鐨勪抚灏搁椇濂?,
		"excerpt": "淇哄鏄釜鍐滄潙浜恒€俓n濂规晳涓嬫垜鐨勬椂鍊欙紝鎴戝凡缁忓彉鎴愪抚灏镐簡銆俓n淇哄涓嶆噦銆?,
	},
}

# ------------------------------------------------------------
# 鍐呯疆闂瓟鏉＄洰锛氱湡瀹炵殑鐭ヤ箮楂樿禐鍥炵瓟锛屾寜涓婚涓庡叧閿瘝灏辫繎鍙栦竴鏉?# ------------------------------------------------------------
const KNOWLEDGE := [
	{
		"work_id": "1547987528036315136",
		"title": "濡備綍浠庡績鐞嗚鍔ㄧ殑浜烘參鎱㈠彉涓轰富鍔ㄧ殑浜猴紵",
		"author": "鏇炬椈Zeng Min",
		"avatar": "",
		"labels": [],
		"intro": "缁濆ぇ閮ㄥ垎鐨勯€€缂┿€佽鍔ㄨ涓洪兘鍜岃嚜鎴戞蹇垫湁鍏炽€?,
		"themes": ["閿欒繃", "澶卞幓"],
	},
	{
		"work_id": "1528398892400353280",
		"title": "銆屼笉鎳傛嫆缁濓紝浜嬩簨鎿嶅績銆嶏細濡備綍璁╄嚜宸卞湪浜洪檯鍏崇郴涓悎缇ゅ張鐙珛锛?,
		"author": "鑳℃厧涔嬪績鐞?,
		"avatar": "",
		"labels": [],
		"intro": "銆屾嫆缁濆埆浜烘槸浜虹敓涓伃閬囩殑涓€浠跺緢闅剧殑浜嬫儏锛屼絾鏄笉鎳傛嫆缁濆氨浼氭妸鑷繁鐨勪汉鐢熸暣寰楁湁澶氱疮灏辨湁澶氱疮銆傘€?,
		"themes": ["閫夐敊"],
	},
	{
		"work_id": "1523701957479239680",
		"title": "瀹炵幇澶х洰鏍囷細渚濋潬銆屽皬鑳溿€?鍜屻€岄棴鍚堜换鍔″洖璺€?,
		"author": "鍒€鐔婅璇?,
		"avatar": "",
		"labels": [],
		"intro": "褰撲汉鐘舵€佷笉濂界殑鏃跺€欙紝浜虹殑鑳介噺鎰熼€氶亾闈炲父鑴嗗急锛岃繖涓椂鍊欏鏋滀綘浣跨敤鎰忓織鍔涙潵涓嶆柇鍦拌姹傝嚜宸便€佷笉鏂壒璇勮嚜宸扁€︹€?,
		"themes": ["閫夐敊"],
	},
	{
		"work_id": "1697254818945699840",
		"title": "濡備綍璧板嚭鑱屼笟鍊︽€狅紵",
		"author": "鑽夎娊鍚汸sy",
		"avatar": "",
		"labels": [],
		"intro": "浣犲湪宸ヤ綔涓槸鍚︽湁杩囨垨鑰呮鍦ㄧ粡鍘嗙潃杩欐牱涓€浜涗綋楠岋細鎰熻蹇冪疮銆佺柌鎯€佹姉鎷掑伐浣溿€佸伐浣滃姩鍔涗抚澶扁€︹€?,
		"themes": ["澶卞幓"],
	},
]

var last_error := ""
var last_source := "鍐呯疆"
var live_ok := false

var _http: HTTPRequest
var _pending_theme := ""
var _slot_done := false
var _slot_body := ""
var _slot_code := 0


func _ready() -> void:
	_http = HTTPRequest.new()
	_http.timeout = FETCH_BUDGET + 1.0
	_http.accept_gzip = true
	_http.request_completed.connect(_on_http_done)
	add_child(_http)
	var base := DirAccess.open("user://")
	if base != null and not base.dir_exists("zhihu_cache"):
		base.make_dir("zhihu_cache")


# ============================================================
# 瀵瑰鎺ュ彛
# ============================================================

## 涓婚 -> 涓€绡囩湡瀹炴晠浜嬨€備富棰樹笉璁よ瘑鏃剁粰"閿欒繃"閭ｄ竴绡囥€?func story_for(theme: String) -> Dictionary:
	var e = STORIES.get(theme, STORIES["閿欒繃"])
	var out: Dictionary = (e as Dictionary).duplicate(true)
	out["kind"] = "story"
	out["url"] = STORY_URL + String(out.get("work_id", ""))
	return out


## 涓婚 + 鐜╁鍏抽敭璇?-> 涓€鏉＄湡瀹為棶绛斻€傛案杩滅粰寰楀嚭锛屽洜涓哄€欓€夐兘鏄湡鏉＄洰銆?func knowledge_for(theme: String, keywords: Array) -> Dictionary:
	var best: Dictionary = {}
	var best_score := -1
	for raw in KNOWLEDGE:
		var e: Dictionary = (raw as Dictionary).duplicate(true)
		var score := 0
		var ths = e.get("themes", [])
		if ths is Array and ths.has(theme):
			score += 4
		var hay := String(e.get("title", "")) + String(e.get("intro", ""))
		for k in keywords:
			var kw := String(k).strip_edges()
			if kw.length() >= 2 and hay.find(kw) >= 0:
				score += 2
		if score > best_score:
			best_score = score
			best = e
	if best.is_empty():
		return {}
	best["kind"] = "knowledge"
	best["url"] = KNOWLEDGE_URL + String(best.get("work_id", ""))
	return best


## 鍙繚鐣欏紑澶村嚑琛屻€侀檺闀匡紝閬垮厤鎶婃暣绡囨鏂囨惉杩涙父鎴忋€?func short_excerpt(raw: String) -> String:
	var t := raw.strip_edges()
	if t == "":
		return ""
	var kept := PackedStringArray()
	var n := 0
	for line in t.split("\n"):
		var s := String(line).strip_edges()
		if s == "":
			continue
		kept.append(s)
		n += 1
		if n >= EXCERPT_LINES:
			break
	var out := "\n".join(kept)
	if out.length() > EXCERPT_MAX:
		out = out.substr(0, EXCERPT_MAX) + "鈥︹€?
	return out


func status_line() -> String:
	return "浜洪棿闀滈壌=" + last_source + " 鑱旂綉=" + ("閫? if live_ok else "鏈€?) + " 閿欒=" + last_error


## 鍦ㄧ粓绔犻噷鐢細鍏堢粰鍐呯疆鐪熸潯鐩紝鑳借仈缃戝氨椤烘墜鍒锋柊涓€涓嬫鏂囧紑澶淬€?## 鏃犺鎴愬姛涓庡惁閮借繑鍥炲彲鐢ㄥ唴瀹癸紝缁濅笉杩斿洖绌恒€?func fetch_story(theme: String) -> Dictionary:
	var entry := story_for(theme)
	live_ok = false
	last_error = ""
	var wid := String(entry.get("work_id", ""))
	if not _valid_work_id(wid):
		last_error = "work_id 涓嶅悎娉?
		last_source = "鍐呯疆"
		return entry
	var cached := _cache_read("story_" + wid)
	if cached != "":
		entry["excerpt"] = cached
		last_source = "鍐呯疆+缂撳瓨"
		return entry
	if not await _fetch(PATH_STORY + wid):
		last_source = "鍐呯疆"
		return entry
	var d := _parse(_slot_body)
	var c := String(d.get("content", "")).strip_edges()
	if c == "":
		last_error = "璇︽儏缂?content 瀛楁"
		last_source = "鍐呯疆"
		return entry
	var ex := short_excerpt(c)
	if ex == "":
		last_source = "鍐呯疆"
		return entry
	entry["excerpt"] = ex
	if String(d.get("author_name", "")).strip_edges() != "":
		entry["author"] = String(d.get("author_name", "")).strip_edges()
	if String(d.get("chapter_name", "")).strip_edges() != "":
		entry["title"] = String(d.get("chapter_name", "")).strip_edges()
	if String(d.get("author_avatar", "")).strip_edges() != "":
		entry["avatar"] = String(d.get("author_avatar", "")).strip_edges()
	_cache_write("story_" + wid, ex)
	last_source = "鍦ㄧ嚎"
	live_ok = true
	return entry


# ============================================================
# 鑱旂綉
# ============================================================

func _valid_work_id(wid: String) -> bool:
	if wid.length() < 6 or wid.length() > 24:
		return false
	for bad in ["/", "?", "#", "\n", "\r", " "]:
		if wid.find(bad) >= 0:
			return false
	return true


func _fetch(path: String) -> bool:
	if _http == null:
		return false
	var url := API_HOST + path
	var headers := PackedStringArray(["Accept: application/json"])
	var err := _http.request(url, headers, HTTPClient.METHOD_GET)
	if err != OK:
		last_error = "璇锋眰鏈彂鍑?err=" + str(err)
		return false
	_slot_done = false
	_slot_body = ""
	_slot_code = 0
	var t0 := Time.get_ticks_msec()
	while not _slot_done:
		if float(Time.get_ticks_msec() - t0) / 1000.0 > FETCH_BUDGET:
			last_error = "瓒呮椂"
			_http.cancel_request()
			return false
		await get_tree().create_timer(0.05).timeout
	if _slot_code != 200:
		last_error = "HTTP " + str(_slot_code)
		return false
	if _slot_body.strip_edges() == "":
		last_error = "绌哄搷搴?
		return false
	return true


func _on_http_done(_result: int, code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	_slot_code = code
	_slot_body = body.get_string_from_utf8()
	_slot_done = true


func _parse(raw: String) -> Dictionary:
	var d = JSON.parse_string(raw)
	if typeof(d) == TYPE_DICTIONARY:
		return d
	last_error = "杩斿洖涓嶆槸 JSON"
	return {}


func _cache_path(key: String) -> String:
	var h := 17
	for i in key.length():
		h = (h * 131 + key.unicode_at(i)) % 2147483647
	return CACHE_DIR + "/" + str(h) + ".json"


func _cache_read(key: String) -> String:
	var p := _cache_path(key)
	if not FileAccess.file_exists(p):
		return ""
	var f := FileAccess.open(p, FileAccess.READ)
	if f == null:
		return ""
	var txt := f.get_as_text()
	f.close()
	var d = JSON.parse_string(txt)
	if typeof(d) == TYPE_DICTIONARY and String(d.get("key", "")) == key:
		return String(d.get("text", ""))
	return ""


func _cache_write(key: String, text: String) -> void:
	if text.strip_edges() == "":
		return
	var f := FileAccess.open(_cache_path(key), FileAccess.WRITE)
	if f == null:
		return
	f.store_string(JSON.stringify({"key": key, "text": text}))
	f.close()

