extends Node
## ============================================================
## 銆婁竴鏈熶竴浼?路 浜洪棿鍓у満銆婣I 璋冪敤灞?## ============================================================
## 璁捐鍘熷垯锛?##   1) 娌℃湁妯″瀷涔熻鑳界帺  鈥斺€?鏈湴璇箟灞傚缁堝厹搴曪紝AI 鍙仛澧炲己
##   2) 涓嶆妸 Key 鍐欒繘浠撳簱 鈥斺€?浠庡伐绋嬪唴鏈湴閰嶇疆 / 鐢ㄦ埛鐩綍閰嶇疆 / 鐜鍙橀噺璇诲彇
##   3) 鎱€佹柇銆佽秴鏃堕兘涓嶈鍗′綇鐜╁ 鈥斺€?姣忔璋冪敤閮芥湁鏃堕棿棰勭畻锛岃秴棰勭畻鐩存帴鐢ㄦ湰鍦扮粨鏋?##   4) 鍚屼竴涓姹傚彧浠樹竴娆￠挶 鈥斺€?鍛戒腑缂撳瓨鐨勮姹備笉鍐嶈蛋缃戠粶
##
## 鎸傝浇鐐癸紙main.gd锛夛細
##   enrich_regret()   鈥斺€?搴忕珷锛氭妸鐜╁鍐欎笅鐨勯仐鎲捐鎴愮粨鏋勫寲鍐呮牳
##   director_line()   鈥斺€?涓夊箷姣忎竴鎷嶏細鐜╁杩欏彞璇濆湪鍦烘櫙閲屾縺璧风殑鍥炲０
##   release_letter()  鈥斺€?缁堢珷锛氶噴鎬€鍗′笂鐨勯偅娈佃瘽
##
## 浠讳綍涓€姝ュけ璐ラ兘闈欓粯闄嶇骇鍒版湰鍦板眰锛岀帺瀹朵笉浼氱湅鍒版姤閿欙紝涔熶笉浼氬崱浣忋€?
signal status_changed(text: String)

const CONFIG_LOCAL := "res://ai_config.local.json"
const CONFIG_USER := "user://ai_config.json"
const CACHE_DIR := "user://ai_cache"
const POOL_SIZE := 3

const ENV_BASE_URL := "YIQIYIHUI_AI_BASE_URL"
const ENV_MODEL := "YIQIYIHUI_AI_MODEL"
const ENV_KEY := "YIQIYIHUI_AI_KEY"

const THEMES: Array[String] = ["閿欒繃", "閫夐敊", "澶卞幓", "鍛婂埆"]

const STYLE_RULES := """鏂囬閾佸緥锛堝繀椤婚伒瀹堬級锛?1. 鐭彞锛岀暀鐧斤紝鍏嬪埗銆傛瘡鍙ヤ笉瓒呰繃 20 涓瓧銆?2. 涓嶈В閲娿€佷笉璇存暀銆佷笉鎬荤粨鍓ф儏銆佷笉鍫嗛噾鍙ャ€?3. 绂佹鍗栬悓锛岀姝㈢亴楦℃堡锛岀姝㈠姖瀵煎紡鐨勯紦鍔便€?4. 涓嶇敤鎰熷徆鍙凤紝涓嶇敤 emoji銆?5. 璇濆埌鍢磋竟鐣欎笁鍒嗐€傚畞鍙皯璇达紝涓嶈澶氳銆?""

var enabled := false
var base_url := ""
var model := ""
var api_key := ""
var timeout_sec := 9.0
var max_retries := 1
var temperature := 0.85
var max_tokens := 420

var last_error := ""
var remote_calls := 0
var cache_hits := 0
var last_source := "local"

var _pool: Array = []
var _busy: Array = []
var _slot_done: Array = []
var _slot_text: Array = []
var _slot_code: Array = []


func _ready() -> void:
	_load_config()
	_ensure_cache_dir()
	for i in POOL_SIZE:
		var h := HTTPRequest.new()
		h.timeout = timeout_sec
		h.accept_gzip = true
		h.request_completed.connect(_on_http_done.bind(i))
		add_child(h)
		_pool.append(h)
		_busy.append(false)
		_slot_done.append(false)
		_slot_text.append("")
		_slot_code.append(0)
	if enabled:
		_emit_status("AI 宸查厤缃細" + model)
	else:
		_emit_status("AI 鏈厤缃紝浣跨敤鏈湴璇箟灞?)


func has_remote() -> bool:
	return enabled and base_url != "" and model != "" and api_key != ""


func status_line() -> String:
	var mode := "鏈湴"
	if has_remote():
		mode = "鍦ㄧ嚎(" + model + ")"
	return "AI=" + mode + " 缃戠粶璋冪敤=" + str(remote_calls) + " 缂撳瓨鍛戒腑=" + str(cache_hits) + " 鏉ユ簮=" + last_source


# ============================================================
# 閰嶇疆
# ============================================================

func _load_config() -> void:
	var cfg := {}
	for p in [CONFIG_LOCAL, CONFIG_USER]:
		var d := _read_json(p)
		if not d.is_empty():
			for k in d.keys():
				cfg[k] = d[k]

	var key_env := String(cfg.get("api_key_env", ""))
	var v_url := OS.get_environment(ENV_BASE_URL)
	var v_model := OS.get_environment(ENV_MODEL)
	var v_key := OS.get_environment(ENV_KEY)
	if key_env != "":
		var v_alt := OS.get_environment(key_env)
		if v_alt != "":
			v_key = v_alt
	if v_url != "":
		cfg["base_url"] = v_url
	if v_model != "":
		cfg["model"] = v_model
	if v_key != "":
		cfg["api_key"] = v_key

	base_url = String(cfg.get("base_url", "")).strip_edges()
	model = String(cfg.get("model", "")).strip_edges()
	api_key = String(cfg.get("api_key", "")).strip_edges()
	timeout_sec = clampf(float(cfg.get("timeout_sec", 9.0)), 2.0, 60.0)
	max_retries = int(clampf(float(cfg.get("max_retries", 1)), 0.0, 3.0))
	temperature = clampf(float(cfg.get("temperature", 0.85)), 0.0, 1.5)
	max_tokens = int(clampf(float(cfg.get("max_tokens", 420)), 64.0, 2048.0))
	enabled = bool(cfg.get("enabled", true))
	if base_url == "" or model == "" or api_key == "":
		enabled = false


func _read_json(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		return {}
	var f := FileAccess.open(path, FileAccess.READ)
	if f == null:
		return {}
	var txt := f.get_as_text()
	f.close()
	var d = JSON.parse_string(txt)
	if typeof(d) == TYPE_DICTIONARY:
		return d
	last_error = "閰嶇疆涓嶆槸鍚堟硶 JSON锛? + path
	return {}


func _ensure_cache_dir() -> void:
	var base := DirAccess.open("user://")
	if base == null:
		return
	if not base.dir_exists("ai_cache"):
		base.make_dir("ai_cache")


func _endpoint() -> String:
	var u := base_url
	if u.ends_with("/"):
		u = u.substr(0, u.length() - 1)
	if u.ends_with("/chat/completions"):
		return u
	if u.ends_with("/v1"):
		return u + "/chat/completions"
	return u + "/v1/chat/completions"


func _emit_status(t: String) -> void:
	status_changed.emit(t)


# ============================================================
# 缃戠粶锛氳繛鎺ユ睜 + 瓒呮椂 + 閲嶈瘯 + 缂撳瓨
# ============================================================

func _on_http_done(result: int, code: int, headers: PackedStringArray, body: PackedByteArray, i: int) -> void:
	_busy[i] = false
	_slot_code[i] = code
	var text := ""
	if result == HTTPRequest.RESULT_SUCCESS and code >= 200 and code < 300:
		var parsed = JSON.parse_string(body.get_string_from_utf8())
		if typeof(parsed) == TYPE_DICTIONARY:
			text = _extract_content(parsed)
			if text == "":
				last_error = "鍝嶅簲閲屾病鏈夋鏂?
		else:
			last_error = "鍝嶅簲涓嶆槸 JSON"
	else:
		last_error = "HTTP " + str(code) + " / result " + str(result)
	if text != "":
		remote_calls += 1
	_slot_text[i] = text
	_slot_done[i] = true


## 鍏煎 OpenAI 椋庢牸鐨?chat/completions锛屼篃鍏煎甯歌鐨勫嚑绉嶇畝鍖栬繑鍥炪€?func _extract_content(d: Dictionary) -> String:
	var choices = d.get("choices", [])
	if choices is Array and choices.size() > 0:
		var c0 = choices[0]
		if c0 is Dictionary:
			var msg = c0.get("message", {})
			if msg is Dictionary:
				var ct = msg.get("content", "")
				if ct is String and String(ct).strip_edges() != "":
					return String(ct)
				if ct is Array:
					var buf := ""
					for part in ct:
						if part is Dictionary and String(part.get("text", "")) != "":
							buf += String(part["text"])
					if buf.strip_edges() != "":
						return buf
			var tx = c0.get("text", "")
			if tx is String and String(tx).strip_edges() != "":
				return String(tx)
	for k in ["output_text", "content", "text", "answer", "result"]:
		var v = d.get(k, "")
		if v is String and String(v).strip_edges() != "":
			return String(v)
	return ""


func _acquire() -> int:
	for i in _pool.size():
		if not bool(_busy[i]):
			return i
	return -1


## 涓€娆￠棶绛旓細杩斿洖姝ｆ枃锛涘け璐ヨ繑鍥炵┖瀛楃涓层€俠udget_sec 鏄帺瀹舵渶澶氭効鎰忕瓑澶氫箙銆?func _ask(system_prompt: String, user_prompt: String, cache_key: String, budget_sec: float) -> String:
	if not has_remote():
		last_source = "local"
		return ""
	var cached := _cache_read(cache_key)
	if cached != "":
		cache_hits += 1
		last_source = "cache"
		return cached
	var slot := _acquire()
	if slot < 0:
		last_source = "local"
		last_error = "杩炴帴姹犲繖"
		return ""
	var payload := {
		"model": model,
		"messages": [
			{"role": "system", "content": system_prompt},
			{"role": "user", "content": user_prompt},
		],
		"temperature": temperature,
		"max_tokens": max_tokens,
		"stream": false,
	}
	var body := JSON.stringify(payload)
	var headers := PackedStringArray([
		"Content-Type: application/json",
		"Authorization: Bearer " + api_key,
	])
	var budget := clampf(budget_sec, 1.0, 60.0)
	var t_start := Time.get_ticks_msec()
	var attempt := 0
	while attempt <= max_retries:
		var remain := budget - float(Time.get_ticks_msec() - t_start) / 1000.0
		if remain <= 0.8:
			break
		_slot_done[slot] = false
		_slot_text[slot] = ""
		_busy[slot] = true
		_pool[slot].timeout = minf(timeout_sec, remain)
		var err: int = _pool[slot].request(_endpoint(), headers, HTTPClient.METHOD_POST, body)
		if err != OK:
			_busy[slot] = false
			last_error = "璇锋眰鏈兘鍙戝嚭锛? + str(err)
			attempt += 1
			continue
		var ok = await _wait_slot(slot, remain)
		if not ok:
			# 鏃堕棿鍒颁簡灏卞埆绛変簡锛屾妸杩炴帴璁╃粰涓嬩竴娆★紝鐜╁涓嶈琚竴娆″崱浣忕殑璇锋眰鎷栦綇銆?			_pool[slot].cancel_request()
			_slot_done[slot] = true
		var text := String(_slot_text[slot])
		_busy[slot] = false
		if text != "":
			_cache_write(cache_key, text)
			last_source = "remote"
			return text
		attempt += 1
	last_source = "local"
	return ""


func _wait_slot(slot: int, budget: float) -> bool:
	var t0 := Time.get_ticks_msec()
	while not bool(_slot_done[slot]):
		if float(Time.get_ticks_msec() - t0) / 1000.0 > budget:
			return false
		await get_tree().create_timer(0.05).timeout
	return true


## 绋冲畾 ID锛氫笉鐢?hash()锛屼繚璇佽法杩涚▼銆佽法鏈哄櫒涓€鑷淬€?func _stable_id(t: String) -> String:
	var h1 := 7
	var h2 := 13
	for i in t.length():
		var c := t.unicode_at(i)
		h1 = (h1 * 131 + c) % 2147483647
		h2 = (h2 * 137 + c + i) % 2147483647
	return str(h1) + "_" + str(h2) + "_" + str(t.length())


func _cache_path(key: String) -> String:
	return CACHE_DIR + "/" + _stable_id(key) + ".json"


func _cache_read(key: String) -> String:
	var d := _read_json(_cache_path(key))
	if d.is_empty():
		return ""
	if String(d.get("key", "")) != key:
		return ""
	return String(d.get("text", ""))


func _cache_write(key: String, text: String) -> void:
	if text.strip_edges() == "":
		return
	var f := FileAccess.open(_cache_path(key), FileAccess.WRITE)
	if f == null:
		return
	f.store_string(JSON.stringify({"key": key, "text": text}))
	f.close()


# ============================================================
# 瀵瑰鎺ュ彛涓€锛氬簭绔狅紝鎶婇仐鎲捐鎴愮粨鏋勫寲鍐呮牳
# 杩斿洖缁撴瀯涓?GameState.regret_core 瀹屽叏鍚屾瀯锛孉I 涓嶅彲鐢ㄦ椂鍘熸牱杩斿洖鏈湴缁撴灉銆?# ============================================================

func enrich_regret(text: String, local_core: Dictionary, budget_sec: float = 2.6) -> Dictionary:
	var t := text.strip_edges()
	if t == "" or not has_remote():
		last_source = "local"
		return local_core
	var sys := STYLE_RULES + "\n浣犳槸銆婁竴鏈熶竴浼氥€嬬殑鍙欎簨鍒嗘瀽鍣ㄣ€傚彧杈撳嚭涓€涓?JSON 瀵硅薄锛屼笉瑕佽В閲婏紝涓嶈浠ｇ爜鍧椼€?
	var usr := "鐜╁甯︾潃涓€浠堕仐鎲捐蛋杩涘墽鍦猴紝浠栧啓涓嬬殑鏄細\n銆? + t + "銆峔n\n" \
		+ "璇锋妸瀹冭鎴愪竴涓粨鏋勫寲鍐呮牳锛屽彧杈撳嚭 JSON锛歕n" \
		+ "{\"theme\":\"鍥涢€変竴锛氶敊杩?閫夐敊/澶卞幓/鍛婂埆\",\"target\":\"浠栨斁涓嶄笅鐨勪汉锛屾病鏈夊氨绌哄瓧绗︿覆\",\"image\":\"杩欐璁板繂閲屾渶鍏蜂綋鐨勪竴涓剰璞★紝涓ゅ埌鍥涗釜瀛楋紝娌℃湁灏辩┖瀛楃涓瞈",\"emotion\":\"涓や釜瀛楃殑鎯呯华璇峔",\"action\":\"浠栨病鑳藉仛鍒扮殑閭ｄ釜鍔ㄤ綔锛屽洓鍒板叚涓瓧锛屾病鏈夊氨绌哄瓧绗︿覆\",\"keywords\":[\"鏈€澶氫簲涓叧閿瘝\"]}\n" \
		+ "娉ㄦ剰锛歵heme 鍙兘鏄偅鍥涗釜璇嶄箣涓€銆備笉瑕佸杩扮帺瀹跺師璇濄€備笉瑕佽瘎浠蜂粬銆?
	var raw = await _ask(sys, usr, "enrich|" + t, budget_sec)
	if raw.strip_edges() == "":
		return local_core
	var d := _parse_json_loose(raw)
	if d.is_empty():
		last_error = "enrich 杩斿洖鐨勪笉鏄?JSON"
		return local_core
	var out := local_core.duplicate(true)
	var th := String(d.get("theme", "")).strip_edges()
	if THEMES.has(th):
		out["theme"] = th
	for k in ["target", "image", "emotion", "action"]:
		var v := String(d.get(k, "")).strip_edges()
		if v != "" and v.length() <= 8:
			out[k] = v
	var kws: Array[String] = []
	for k in out.get("keywords", []):
		var s := String(k).strip_edges()
		if s != "" and not kws.has(s):
			kws.append(s)
	var ai_kws = d.get("keywords", [])
	if ai_kws is Array:
		for k in ai_kws:
			var s2 := String(k).strip_edges()
			if s2 != "" and s2.length() <= 6 and not kws.has(s2):
				kws.append(s2)
	if kws.size() > 6:
		kws = kws.slice(0, 6)
	out["keywords"] = kws
	out["source"] = t
	last_source = "remote"
	return out


# ============================================================
# 瀵瑰鎺ュ彛浜岋細涓夊箷姣忎竴鎷嶏紝鐜╁杩欏彞璇濇縺璧风殑鍥炲０
# 杩斿洖鏀瑰啓鍚庣殑鍙拌瘝锛涘け璐ユ椂鍘熸牱杩斿洖 local_line銆?# ============================================================

const DIRECTOR_TAG_HINT := "鍙€夋皵璐細鍘熻皡銆侀亾姝夈€佹劅璋€佺埍鎰忋€佸憡鍒€佺害瀹氥€佹病璇村嚭鍙ｃ€佽矗鎬€佸钩甯搞€傚彴璇嶈璐翠綇鍏朵腑涓€绉嶃€?

func director_line(chapter: int, beat: int, player_text: String, local_line: String, budget_sec: float = 2.4) -> String:
	var t := player_text.strip_edges()
	if t == "" or not has_remote():
		last_source = "local"
		return local_line
	var theme := "閿欒繃"
	if chapter == 2:
		theme = "閫夐敊"
	elif chapter == 3:
		theme = "澶卞幓"
	var sys := STYLE_RULES + "\n浣犳槸銆婁竴鏈熶竴浼氥€嬬殑鍙欎簨瀵兼紨銆傚彧鍐欏彴璇嶆湰韬細涓嶈寮曞彿锛屼笉瑕佽В閲婏紝涓嶈鏃佺櫧鏍囪锛屼笉瓒呰繃涓よ銆?
	var usr := "绗? + str(chapter) + "骞曪紝涓婚锛? + theme + "銆傜幇鍦ㄦ槸杩欎竴骞曠殑绗? + str(beat + 1) + "鎷嶏紙鍏卞洓鎷嶏級銆俓n" \
		+ "鐜╁鍒氳锛氥€? + t + "銆峔n" \
		+ "杩欎竴鎷嶅師鏈殑钀界偣鏄細\n" + local_line + "\n\n" \
		+ "璇烽噸鍐欒繖涓€鎷嶏紝璁╁畠鐪熺殑鍦ㄥ洖搴旂帺瀹惰繖鍙ヨ瘽銆? + DIRECTOR_TAG_HINT + "\n" \
		+ "瑕佹眰锛氫笉瑕佸杩扮帺瀹跺師璇濓紝涓嶈鎻愬埌鐜╁锛屼笉瑕佹彁鍒板墽鍦恒€傜涓€琛屽啓鐪煎墠鐨勬櫙锛岀浜岃鍐欒惤鍦ㄤ粬韬笂鐨勯偅涓€鍙ャ€?
	var raw = await _ask(sys, usr, "director|" + str(chapter) + "|" + str(beat) + "|" + t, budget_sec)
	var clean := _clean_reply(raw, 2, 22)
	if clean == "":
		return local_line
	last_source = "remote"
	return clean


# ============================================================
# 瀵瑰鎺ュ彛涓夛細缁堢珷閲婃€€淇?# 杩斿洖鏀瑰啓鍚庣殑淇★紱澶辫触鏃跺師鏍疯繑鍥?local_text銆?# ============================================================

func release_letter(context: Dictionary, local_text: String, budget_sec: float = 6.0) -> String:
	if not has_remote():
		last_source = "local"
		return local_text
	var src := String(context.get("source", "")).strip_edges()
	var who := String(context.get("target", "")).strip_edges()
	var img := String(context.get("image", "")).strip_edges()
	var th := String(context.get("theme", "")).strip_edges()
	var said := ""
	var n := 0
	var lines = context.get("lines", [])
	if lines is Array:
		for l in lines:
			if n >= 5:
				break
			var s := String(l).strip_edges()
			if s != "":
				said += "銆? + s.substr(0, 24) + "銆峔n"
				n += 1
	var sys := STYLE_RULES + "\n浣犲湪鍐欎竴寮犵粰鐜╁鐨勩€婇噴鎬€淇°€嬶紝缃插悕鏄汉闂村墽鍦虹殑寮曡矾浜恒€傚彧鍐欐鏂囷紝涓嶈绉板懠锛屼笉瑕佽惤娆撅紝涓嶈瑙ｉ噴銆?
	var usr := "鐜╁甯︾潃杩欎欢閬楁喚璧拌繘鏉ワ細銆? + src + "銆峔n" \
		+ "鎻愮偧鍑虹殑鍐呮牳锛氫富棰?" + th + "锛屾斁涓嶄笅鐨勪汉=" + who + "锛屾剰璞?" + img + "\n" \
		+ "浠栧湪涓夊箷閲岃杩囪繖浜涜瘽锛歕n" + said + "\n" \
		+ "璇峰啓涓€娈典笉瓒呰繃 90 涓瓧鐨勮瘽锛屼氦鍥炵粰浠栥€備笁鍒板洓涓煭鍙ャ€俓n" \
		+ "瑕佺偣锛氫粬闄笁涓檶鐢熶汉璧板畬浜嗗悇鑷殑灏藉ご锛涚粨灞€娌℃湁鍙橈紱浣嗕粬鍛婂埆鐨勬柟寮忓彉浜嗭紱杩欎簺鍚屾牱绠楁暟銆俓n" \
		+ "涓嶈榧撳姳浠栵紝涓嶈缁欎粬寤鸿锛屼笉瑕佺敤銆岄噴鎬€銆嶈繖涓や釜瀛椼€?
	var raw = await _ask(sys, usr, "letter|" + src + "|" + str(said.length()), budget_sec)
	var clean := _clean_reply(raw, 6, 30)
	if clean == "":
		return local_text
	last_source = "remote"
	return clean


# ============================================================
# 鏂囨湰娓呮礂
# ============================================================

func _parse_json_loose(raw: String) -> Dictionary:
	var t := raw.strip_edges()
	var a := t.find("{")
	var b := t.rfind("}")
	if a >= 0 and b > a:
		t = t.substr(a, b - a + 1)
	var d = JSON.parse_string(t)
	if typeof(d) == TYPE_DICTIONARY:
		return d
	return {}


func _clean_reply(raw: String, max_lines: int, max_line_len: int) -> String:
	var t := raw.strip_edges()
	if t == "":
		return ""
	var fence := String.chr(96) + String.chr(96) + String.chr(96)
	if t.begins_with(fence):
		var nl := t.find("\n")
		if nl >= 0:
			t = t.substr(nl + 1)
		var e := t.rfind(fence)
		if e >= 0:
			t = t.substr(0, e)
		t = t.strip_edges()
	var out := PackedStringArray()
	for line in t.split("\n"):
		var s := _strip_wrap(String(line).strip_edges())
		if s == "":
			continue
		if s.length() > max_line_len:
			s = s.substr(0, max_line_len)
		out.append(s)
		if out.size() >= max_lines:
			break
	return "\n".join(out)


func _strip_wrap(s: String) -> String:
	var t := s
	var guard := 0
	while guard < 4:
		guard += 1
		if t.length() < 2:
			break
		var a := t.substr(0, 1)
		var b := t.substr(t.length() - 1, 1)
		var paired := (a == "\"" and b == "\"") \
			or (a == "鈥? and b == "鈥?) \
			or (a == "銆? and b == "銆?) \
			or (a == "銆? and b == "銆?) \
			or (a == "'" and b == "'")
		if paired:
			t = t.substr(1, t.length() - 2).strip_edges()
			continue
		break
	return t

