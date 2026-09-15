extends Node3D
## 銆婁竴鏈熶竴浼?路 浜洪棿鍓у満銆?## 瑙嗚涓昏矾绾匡細2.5D 娣峰悎 鈥斺€?鎵嬬粯缇庢湳搴曞浘 + 瀹炴椂椋橀洩 + 鐢靛奖璋冭壊 + 鍏嬪埗鐨?UI銆?## 3D 鍏滃簳锛氬懡浠よ鍔?--3d锛屾敼鐢?Blender 瀵煎嚭鐨?GLB 鍋氬疄鏃舵覆鏌撱€?## 鎴浘锛?-capture <鐩綍>锛屼緷娆¤緭鍑?搴忕珷 / 杞︾エ / 涓夊箷鍚勫洓鎷?/ 缁堢珷 / 閲婃€€ 鍏?21 寮犲畾鏈轰綅鐢婚潰銆?
# Baked scenes: Kanshan is painted directly into each plate by the image model,
# so the runtime no longer composites a separate cutout sprite on top.
const BG_PATH := "res://assets/art/prologue_baked.webp"
const BG_CH1 := "res://assets/art/ch1_baked.webp"
const BG_CH2 := "res://assets/art/ch2_baked.webp"
const BG_CH3 := "res://assets/art/ch3_baked.webp"
const BG_FINALE := "res://assets/art/finale_baked.webp"
const GLB_PATH := "res://assets/yichihuiche_station.glb"
const FONT_DISPLAY := "res://assets/fonts/STZHONGS.TTF"
const FONT_BODY := "res://assets/fonts/NotoSansSC-VF.ttf"

# 寮曡矾浜虹珛缁橈細AI 鐢熸垚鐨?3D 鐧界嫄锛屽凡鎶犲浘鍘婚粦搴曪紙瑙?tools/_img2/cutout_kanshan3.py锛?const KANSHAN_FIG := "res://assets/art/kanshan_cutout.png"
const KANSHAN_GLOW := "res://assets/art/kanshan_glow.png"
const KANSHAN_SHADER_PATH := "res://assets/shaders/kanshan_fuse.gdshader"

# 澹伴煶锛氬師鍒涘悎鎴愶紙瑙?_audiogen.gd锛夛紝閽㈢惔 ambient + 闆鐜椋?const BGM_PATH := "res://assets/audio/bgm_piano_snow.ogg"
const AMB_PATH := "res://assets/audio/amb_snow_wind.ogg"
const BGM_DB := -12.0
const AMB_DB := -18.0

const BASE := Vector2(1600.0, 900.0)

const COL_INK := Color(0.925, 0.945, 0.972)
const COL_TITLE := Color(0.995, 0.960, 0.880)
const COL_DIM := Color(0.706, 0.772, 0.855)
const COL_WARM := Color(0.96, 0.80, 0.55)
const COL_PAPER := Color(0.905, 0.878, 0.812)
const COL_PAPER_INK := Color(0.129, 0.122, 0.114)
const COL_PAPER_DIM := Color(0.40, 0.355, 0.30)
const COL_STRIP := Color(0.62, 0.30, 0.34)

const GRAIN_SHADER := "shader_type canvas_item;\nrender_mode blend_mul;\nuniform float amount : hint_range(0.0, 0.3) = 0.055;\nuniform float t = 0.0;\nfloat hash(vec2 p){ return fract(sin(dot(p, vec2(12.9898, 78.233)) + t * 1.7) * 43758.5453); }\nvoid fragment(){\n\tfloat n = hash(floor(FRAGCOORD.xy));\n\tfloat d = abs(n - 0.5) * 2.0 * amount;\n\tCOLOR = vec4(vec3(1.0 - d), 1.0);\n}\n"

const TYPE_SPEED := 22.0

const KANSHAN_SIZE := Vector2(352.0, 497.0)
const KANSHAN_HOME := Vector2(196.0, 344.0)

# 绔嬬粯铻嶅悎鐫€鑹插櫒锛氬簳閮ㄧ幆澧冮伄钄?+ 鍐疯皟鐜鑹?+ 鏋佽杽杞粨鍏夛紝缂撹В"璐村浘鎰?
const KANSHAN_SHADER := "shader_type canvas_item;\n\n// 绔嬬粯铻嶅悎锛氬帇鏆楁洕鍏?+ 鍐疯壊娴告煋 + 涓嬬紭鐜閬斀 + 澶栫紭鍐呮敹\n// 瀹炴祴渚濇嵁锛氱珛缁樻墍鍦ㄤ綅缃殑鑳屾櫙浜害浠?50/255锛岃€岀珛缁樺師鏈?170/255锛孿n// 蹇呴』鎶婄珛缁樺帇鍒颁笌鑳屾櫙鍚屼竴鏇濆厜鍖洪棿锛屾墠涓嶄細鍍忚创涓婂幓鐨勪寒鐗囥€俓nuniform vec4 ambient_tint : source_color = vec4(0.42, 0.53, 0.76, 1.0);\nuniform float tint_amount : hint_range(0.0, 0.9) = 0.30;\nuniform float exposure : hint_range(0.2, 1.2) = 0.62;\nuniform float ao_strength : hint_range(0.0, 1.0) = 0.42;\nuniform float ao_start : hint_range(0.0, 1.0) = 0.30;\nuniform vec4 edge_ink : source_color = vec4(0.06, 0.09, 0.16, 1.0);\nuniform float edge_darken : hint_range(0.0, 1.0) = 0.34;\n\nvoid fragment(){\n	vec4 c = texture(TEXTURE, UV);\n	if (c.a < 0.012) { discard; }\n	float lum = dot(c.rgb, vec3(0.299, 0.587, 0.114));\n\n	// 1) 鍘嬫洕鍏夛紝鍐嶅線闆鍐疯壊閲屾媺锛屾妸绾櫧姣涜壊鏀惰繘鍦烘櫙鐨勬殫璋僜n	vec3 base = c.rgb * exposure;\n	base = mix(base, ambient_tint.rgb * (0.30 + lum * 0.95), tint_amount);\n\n	// 2) 涓嬬紭鐜閬斀锛氳秺闈犺繎鑴氳秺娌夛紝鍒堕€犺惤鍦版劅\n	float t = clamp((UV.y - ao_start) / max(1.0 - ao_start, 0.001), 0.0, 1.0);\n	base *= mix(1.0, 1.0 - ao_strength, t * t);\n\n	// 3) 澶栫紭鍐呮敹锛氳疆寤撴渶澶栧湀鍘嬪悜鏆楄壊锛屾秷鎺夊彂鐧界殑纭竟\n	vec2 px = TEXTURE_PIXEL_SIZE;\n	float a_l = texture(TEXTURE, UV - vec2(px.x * 1.7, 0.0)).a;\n	float a_r = texture(TEXTURE, UV + vec2(px.x * 1.7, 0.0)).a;\n	float a_u = texture(TEXTURE, UV - vec2(0.0, px.y * 1.7)).a;\n	float a_d = texture(TEXTURE, UV + vec2(0.0, px.y * 1.7)).a;\n	float edge = 1.0 - min(min(a_l, a_r), min(a_u, a_d));\n	base = mix(base, edge_ink.rgb, clamp(edge, 0.0, 1.0) * edge_darken * c.a);\n\n	COLOR = vec4(base, c.a);\n}"

const CH1_BEATS := [
	{
		"label": "绗竴骞?路 妯辫姳涓庣數杞?,
		"line": "鏈彮杞﹁繕鏈変竷鍒嗛挓銆俓n绔欏彴鐨勭伅鎶婇洩鐓ф垚涓€灞傝杽钖勭殑榛勩€俓n浣犳潵杩欓噷锛屾槸涓轰簡绛変竴涓凡缁忎笉浼氬湪杩欎竴绔欎笅杞︾殑浜恒€?,
		"quick": ["鐪嬩竴鐪煎墠鏂圭殑閾佽建", "鎶婂洿宸炬嫝绱т竴鐐?, "鍦ㄥ績閲屾暟杩樺墿鍑犲ぉ"],
		"hint": "绔欏彴涓婄殑椋庯紝姣斾綘浠ヤ负鐨勮杞汇€?,
	},
	{
		"label": "绗竴骞?路 妯辫姳涓庣數杞?,
		"line": "浣犳兂璧峰緢澶氬勾鍓嶇殑鏄ュぉ銆俓n閭ｈ稛杞﹀紑璧扮殑鏃跺€欙紝浣犵湅瑙佺獥鐜荤拑鍚庨潰鏈変竴寮犺劯锛屾鍦ㄦ壘浣犮€俓n浣犱妇璧锋墜鈥斺€旇溅宸茬粡杩囧幓浜嗐€?,
		"quick": ["鍛婅瘔鑷繁锛氭槸鎴戝厛绉诲紑浜嗚绾?, "鍛婅瘔鑷繁锛氭槸濂规病鏈夊洖澶?, "浠€涔堜篃涓嶆兂锛屽氨绔欑潃"],
		"hint": "鏈変簺璇濓紝璇村嚭鍙ｇ殑鏃跺€欏凡缁忔櫄浜嗕竴鐐广€傞偅涔熺畻璇磋繃浜嗐€?,
	},
	{
		"label": "绗竴骞?路 妯辫姳涓庣數杞?,
		"line": "杞︽潵浜嗐€俓n闂ㄥ湪浣犻潰鍓嶆墦寮€锛屾殩鍏夎惤鍦ㄩ洩鍦颁笂锛屽儚涓€鏉″緢鐭殑璺€俓n涓婁笉涓婂幓锛岄兘鍙互銆?,
		"quick": ["璧颁笂杞︼紝鎵句釜闈犵獥鐨勪綅缃?, "鐣欏湪绔欏彴涓婏紝绛夊畠寮€璧?, "鍏堢珯鍦ㄥ師鍦帮紝涓嶅姩"],
		"hint": "鎴戜笉浼氬憡璇変綘鍝鏇村ソ銆傝繖涓€绋嬫槸浣犵殑銆?,
	},
	{
		"label": "绗竴骞?路 妯辫姳涓庣數杞?,
		"line": "浣犲缁堟病鑳借鍑洪偅鍙ヨ瘽銆俓n浣嗕綘鎶婂洿宸捐В涓嬫潵锛屾惌鍦ㄤ簡闀挎鐨勬壎鎵嬩笂鈥斺€斿儚鏄暀缁欒皝銆俓n寰堝骞翠互鍚庝綘鎵嶇煡閬擄紝閭ｅ嚑骞达紝濂逛篃鍦ㄨ繖鏉＄嚎涓婄瓑杩囦綘銆?,
		"quick": ["鎶婅瘽鐣欏湪闆噷", "鎶婅瘽鍐欏湪蹇冮噷", "鍏跺疄鎴戞棭灏辫杩囦簡"],
		"hint": "杩欎竴绋嬶紝浣犲凡缁忓敖鍔涗簡銆?,
	},
]

const CH2_BEATS := [
	{
		"label": "绗簩骞?路 娌¤蛋鐨勯偅鏉¤矾",
		"line": "寰堝骞村墠鐨勯偅涓笅鍗堬紝浣犲湪涓ゅ紶琛ㄦ牸涔嬮棿绔欎簡寰堜箙銆俓n涓€寮犻€氬線杩滄柟锛屼竴寮犻€氬線鐣欎笅銆俓n鏈€鍚庝綘绛句笅鐨勯偅涓悕瀛楋紝鏀瑰彉浜嗗緢澶氫汉鐨勪竴鐢熲€斺€斿寘鎷綘鑷繁鐨勩€?,
		"quick": ["鎯宠捣閭ｅぉ涓嬪崍鐨勫厜", "鎯宠捣绛惧瓧鏃舵墜鍦ㄦ姈", "鎯宠捣鏈変汉鍦ㄥ闈㈢瓑浣?],
		"hint": "閭ｆ椂鍊欑殑浣狅紝鍙兘鐪嬭鐪煎墠鐨勯偅鐐瑰厜銆?,
	},
	{
		"label": "绗簩骞?路 娌¤蛋鐨勯偅鏉¤矾",
		"line": "濡傛灉褰撳垵閫変簡鍙︿竴鏉♀€斺€擻n浣犱細鍦ㄥ彟涓€搴у煄甯傞啋鏉ワ紝閬囪鍙︿竴浜涗汉锛岄敊杩囧彟涓€浜涗簨銆俓n浣犱細鍦ㄦ煇涓繁澶滐紝鍚屾牱鍦版兂璧凤細濡傛灉褰撳垵鐣欎笅灏卞ソ浜嗐€?,
		"quick": ["璇曠潃鐪熺殑璧颁竴閬嶉偅鏉¤矾", "鎵胯鑷繁鏇剧粡鎯宠繃閫冭窇", "涓嶆兂浜嗭紝鐪嬬湅鐜板湪"],
		"hint": "浜虹敓娌℃湁鏃犳喚鐨勭増鏈紝鍙湁浣犵殑鐗堟湰銆?,
	},
	{
		"label": "绗簩骞?路 娌¤蛋鐨勯偅鏉¤矾",
		"line": "浣犳妸涓よ竟閮芥兂浜嗕竴閬嶃€俓n杩滄柟鏈夎繙鏂圭殑瀛ょ嫭锛岀暀涓嬫湁鐣欎笅鐨勫灞堛€俓n涓ゆ潯璺笂锛岄兘鏈変汉鍦ㄥ閲岄棶杩囪嚜宸卞悓涓€涓棶棰樸€?,
		"quick": ["瀵瑰綋骞寸殑鑷繁璇翠竴鍙ヨ瘽", "鏇垮綋骞寸殑鑷繁鏉句竴鍙ｆ皵", "浠€涔堥兘涓嶈锛岀珯涓€浼氬効"],
		"hint": "閫夐敊锛屼篃鏄竴绉嶈鐪熴€?,
	},
	{
		"label": "绗簩骞?路 娌¤蛋鐨勯偅鏉¤矾",
		"line": "浣犵粓绌舵病鑳借蛋涓婂彟涓€鏉¤矾銆俓n浣嗕綘浠婂ぉ鍥炲ご鐪嬩簡涓€鐪尖€斺€旈偅涓珯鍦ㄥ矓鍙ｇ殑骞磋交浜猴紝宸茬粡灏藉姏浜嗐€俓n浠栦笉鐭ラ亾鍚庢潵浼氭€庢牱锛岃繕鏄浜嗗瓧銆?,
		"quick": ["鍘熻皡浠?, "璋㈣阿浠?, "鍛婅瘔浠栵細娌″叧绯?],
		"hint": "浣犺蛋鐨勯偅鏉¤矾涓婏紝涔熸湁鍙睘浜庝綘鐨勯鏅€?,
	},
]

const CH3_BEATS := [
	{
		"label": "绗笁骞?路 鏉ヤ笉鍙?,
		"line": "鍘ㄦ埧鐨勭伅鎬绘槸浜殑銆俓n姘村６鍦ㄥ搷锛岀數瑙嗗紑寰楀緢灏忓０锛屾涓婇偅纰楁堡鍑変簡涓€鍗娿€俓n浣犲綋鏃朵互涓猴紝杩欐牱鐨勬櫄涓婅繕鏈夊緢澶氬緢澶氥€?,
		"quick": ["鍧愪笅鏉ワ紝鎶婇偅纰楁堡鍠濆畬", "璇翠竴鍙ワ細鎴戝洖鏉ヤ簡", "浠€涔堥兘涓嶈锛屽厛鍧愪竴浼氬効"],
		"hint": "骞冲父鐨勬棩瀛愶紝浠庝笉鍛婅瘔浣犳槸鏈€鍚庝竴娈点€?,
	},
	{
		"label": "绗笁骞?路 鏉ヤ笉鍙?,
		"line": "浣犲紑濮嬫敞鎰忓埌涓€浜涘緢灏忕殑浜嬨€俓n濂硅蛋璺參浜嗕竴鐐癸紝璇磋瘽浼氬仠涓€涓嬶紝鍥炲ご鎵句綘鐨勬鏁板彉澶氫簡銆俓n浣犳兂璇寸偣浠€涔堬紝鍙堣寰楁潵鏃ユ柟闀裤€?,
		"quick": ["鎻′綇閭ｅ彧鎵?, "鎶婃兂璇寸殑璇濆厛鍜藉洖鍘?, "澶氱暀涓€鏅?],
		"hint": "閭ｄ簺浣犱互涓虹█鏉惧钩甯哥殑鐬棿锛屾鍦ㄤ竴寮犱竴寮犲湴缈昏繃鍘汇€?,
	},
	{
		"label": "绗笁骞?路 鏉ヤ笉鍙?,
		"line": "绂诲埆濡傛湡鑰岃嚦銆俓n浣犺刀鍥炲幓鐨勬椂鍊欙紝涓€鍒囬兘宸茬粡瀹夐潤涓嬫潵浜嗐€俓n閭ｅ彞鍑嗗浜嗗緢澶氬勾鐨勮瘽锛屾渶缁堟病鑳借鍑哄彛銆?,
		"quick": ["鍦ㄥ績閲屾妸璇濊缁欏ス鍚?, "鎬嚜宸辨病鏈夋棭鐐瑰洖鏉?, "璁╁ス鐭ラ亾浣犱竴鐩撮兘鍦?],
		"hint": "鐖变粠涓嶉潬鏈€鍚庝竴鍙ヨ瘽鎵嶆垚绔嬨€?,
	},
	{
		"label": "绗笁骞?路 鏉ヤ笉鍙?,
		"line": "寰堜箙浠ュ悗浣犳墠鏄庣櫧锛歕n濂规棭灏辨妸浣犵殑蹇冩剰鏀惰繘浜嗕竴鐢熲€斺€旀敹鍦ㄦ瘡涓€娆＄暀鐏€佹瘡涓€纰楃儹姹ら噷銆俓n浣犱笉鏄病鏉ュ緱鍙娿€備綘鍙槸娌″惉瑙佸ス鏃╁氨鍥炵瓟杩囦簡銆?,
		"quick": ["缁堜簬鎶婇偅鍙ヨ瘽璇村嚭鍙?, "瀵圭潃绌哄帹鎴胯交杞昏涓€鍙?, "璁╅偅鐩忕伅缁х画浜潃"],
		"hint": "杩欎竴绋嬶紝浣犲凡缁忓敖鍔涗簡銆?,
	},
]

const PROLOGUE_QUICK := ["鍏充簬涓€涓汉", "鍏充簬涓€鏉℃病璧扮殑璺?, "鍏充簬涓€鍙ユ病璇寸殑璇?]

# ---------- 鑸炲彴 ----------
var stage_root: Control
var bg_clip: Control
var bg_rect: TextureRect
var bg_next: TextureRect
var bg_cur_path := ""
var cold_grade: ColorRect
var shadow_lift: ColorRect
var warm_glow: TextureRect
var bottom_shade: TextureRect
var vignette_rect: TextureRect
var grain_rect: ColorRect
var film_layer: CanvasLayer
var film_grain_mat: ShaderMaterial
var snow_far: GPUParticles2D
var snow_near: GPUParticles2D
var kanshan_root: Control
var kanshan_fig: TextureRect
var kanshan_halo: TextureRect
var kanshan_on := 1.0
var kanshan_target := 1.0

# ---------- HUD ----------
var hud: Control
var title_label: Label
var sub_label: Label
var chapter_label: Label
var distance_track: ColorRect
var distance_fill: ColorRect
var panel: PanelContainer
var panel_shade: TextureRect
var speaker_label: Label
var line_label: RichTextLabel
var input_edit: LineEdit
var action_btn: Button
var quick_row: HBoxContainer
var quick_caption: Label
var hint_label: Label
var ticket_layer: Control
var ticket_panel: PanelContainer
var card_layer: Control
var card_panel: PanelContainer
var card_quote: Label

# 浜洪棿闀滈壌锛堢粓绔狅級锛氭妸鐜╁鐨勯仐鎲炬帴鍒扮煡涔庝笂鐪熷疄瀛樺湪鐨勪汉闂寸粡楠屼笂
var mirror_layer: Control
var mirror_panel: PanelContainer
var mirror_title: Label
var mirror_excerpt: Label
var mirror_author: Label
var mirror_ask: Label
var mirror_source: Button
var mirror_note: Label
var mirror_data: Dictionary = {}

# ---------- 鐘舵€?----------
var state := "prologue"
var beat := 0
var distance := 0.42
var distance_target := 0.42
var typing := false
var typed_chars := 0.0
var breath := 0.0
var clock := 0.0
var panel_home := Vector2.ZERO
var ticket_home := Vector2.ZERO
var font_display: Font
var font_body: Font
var use_3d := false
var capture_dir := ""
var movie_mode := false
var quick_shot := false
# Baked plates already contain Kanshan, so the cutout overlay stays off by default.
# Use --fox on the command line to composite the standalone cutout instead.
var nofox := true
var grain_mat: ShaderMaterial
var busy := false
var _capture_done := false
var _bg_tween: Tween
var _kb_tween: Tween
var _bg_pending := ""
var _pending_readback := ""
var _pending_echo := ""
var _pending_resonance := ""
var _pending_input := ""
var capture_inputs_path := ""
var capture_inputs: PackedStringArray = PackedStringArray()
var _capture_idx := 1

# ---------- 澹伴煶 ----------
var audio_btn: Button
var _audio: Dictionary = {}
var _audio_built := false
var audio_muted := false
var audio_level := 1.0


func _ready() -> void:
	_parse_args()
	print("[AI] " + AILayer.status_line())
	_load_capture_inputs()
	font_body = _try_font(FONT_BODY)
	font_display = _try_font(FONT_DISPLAY)
	if font_display != null and font_body != null:
		# 鏍囬瀛椾綋鍙敹褰曞父鐢ㄥ瓧锛涙寕姝ｆ枃涓哄洖閫€锛岀‘淇濈帺瀹惰嚜鐢辫緭鍏ヤ笌鐭ヤ箮鏍囬涓嶇己瀛椼€?		var fb: Array[Font] = [font_body]
		font_display.fallbacks = fb
	_build_stage()
	_build_hud()
	_build_audio()
	_play_audio()
	if use_3d:
		_build_3d()
	_show_prologue()
	if capture_dir != "":
		_capture_flow()
	elif movie_mode:
		_movie_flow()


func _try_font(path: String) -> Font:
	var r = load(path)
	if r is Font:
		return r
	push_warning("[涓€鏈熶竴浼歖 瀛椾綋缂哄け锛屽洖閫€榛樿瀛椾綋: " + path)
	return null


func _parse_args() -> void:
	var args := OS.get_cmdline_user_args()
	print("[涓€鏈熶竴浼歖 鍘熷鍙傛暟 args=" + str(OS.get_cmdline_args()) + " | user_args=" + str(OS.get_cmdline_user_args()))
	if args.is_empty():
		args = OS.get_cmdline_args()
	for i in args.size():
		var a: String = args[i]
		if a == "--3d":
			use_3d = true
		elif a == "--capture" and i + 1 < args.size():
			capture_dir = args[i + 1]
		elif a == "--capture-inputs" and i + 1 < args.size():
			capture_inputs_path = args[i + 1]
		elif a == "--movie":
			movie_mode = true
		elif a == "--quick":
			quick_shot = true
		elif a == "--nofox":
			nofox = true
		elif a == "--fox":
			nofox = false


# ============================================================
# 鑸炲彴锛氬簳鍥?/ 璋冭壊 / 椋橀洩
# ============================================================
func _build_stage() -> void:
	var layer := CanvasLayer.new()
	layer.layer = 1
	add_child(layer)
	stage_root = Control.new()
	stage_root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	layer.add_child(stage_root)
	stage_root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	stage_root.clip_contents = false

	bg_clip = Control.new()
	bg_clip.clip_contents = true
	bg_clip.mouse_filter = Control.MOUSE_FILTER_IGNORE
	stage_root.add_child(bg_clip)
	bg_clip.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	bg_rect = TextureRect.new()
	var tex = load(BG_PATH)
	if tex is Texture2D:
		bg_rect.texture = tex
	else:
		push_error("[涓€鏈熶竴浼歖 缇庢湳搴曞浘缂哄け: " + BG_PATH)
	bg_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	bg_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	bg_rect.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS
	bg_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	bg_clip.add_child(bg_rect)
	bg_rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	bg_rect.resized.connect(_on_bg_resized)
	_start_kenburns.call_deferred()

	# 浜ゅ弶娣″寲灞傦細鎹㈢珷鏃舵柊鐢婚潰浠庤繖涓€灞傛贰鍏ワ紝閬垮厤"鍟?鍦版崲鍥?	bg_next = TextureRect.new()
	bg_next.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	bg_next.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	bg_next.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS
	bg_next.mouse_filter = Control.MOUSE_FILTER_IGNORE
	bg_next.modulate = Color(1, 1, 1, 0)
	bg_clip.add_child(bg_next)
	bg_next.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	bg_cur_path = BG_PATH
	_build_kanshan()

	# 鍐疯皟鍘嬫殫锛氭鐗囧彔搴曚竴灞傛贰钃濓紝闆鐨勯€氶€忔劅鏉ヨ嚜杩欓噷
	cold_grade = ColorRect.new()
	cold_grade.color = Color(0.992, 0.997, 1.0, 1.0)
	cold_grade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var mul_mat := CanvasItemMaterial.new()
	mul_mat.blend_mode = CanvasItemMaterial.BLEND_MODE_MUL
	cold_grade.material = mul_mat
	stage_root.add_child(cold_grade)
	cold_grade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	# 鏆楅儴鎻愪寒锛氬姞娉曟贩鍚堝灚涓€灞傛瀬娣＄殑鍐疯摑锛岄伩鍏嶆殫閮ㄦ榛戯紝鍋氬嚭鑳剁墖鏆楅儴鐨勯€氶€忔劅
	shadow_lift = ColorRect.new()
	shadow_lift.color = Color(0.055, 0.066, 0.086, 1.0)
	shadow_lift.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var lift_mat := CanvasItemMaterial.new()
	lift_mat.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
	shadow_lift.material = lift_mat
	stage_root.add_child(shadow_lift)
	shadow_lift.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	# 绔欏彴鐏殩鍏夋檿锛氬姞娉曟贩鍚堬紝钀藉湪鐢婚潰宸︿晶绔欏彴涓庨暱妞呬竴甯?	warm_glow = TextureRect.new()
	warm_glow.texture = _radial_tex(Color(1.0, 0.78, 0.48, 0.22), Color(1.0, 0.76, 0.44, 0.0))
	warm_glow.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var add_mat := CanvasItemMaterial.new()
	add_mat.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
	warm_glow.material = add_mat
	warm_glow.position = Vector2(210, 60)
	warm_glow.size = Vector2(760, 520)
	stage_root.add_child(warm_glow)

	# 搴曢儴鍘嬫殫锛岀粰鏂囧瓧鐣欏嚭鍙鐨勬殫搴?	bottom_shade = TextureRect.new()
	bottom_shade.texture = _shade_tex(0.34)
	bottom_shade.stretch_mode = TextureRect.STRETCH_SCALE
	bottom_shade.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	bottom_shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	stage_root.add_child(bottom_shade)
	bottom_shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	# 鑳剁墖棰楃矑
	grain_mat = ShaderMaterial.new()
	var sh := Shader.new()
	sh.code = GRAIN_SHADER
	grain_mat.shader = sh
	grain_mat.set_shader_parameter("amount", 0.030)
	grain_rect = ColorRect.new()
	grain_rect.color = Color(1, 1, 1, 1)
	grain_rect.material = grain_mat
	grain_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	stage_root.add_child(grain_rect)
	grain_rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	# 鏆楄
	vignette_rect = TextureRect.new()
	vignette_rect.texture = _vignette_tex(0.20)
	vignette_rect.stretch_mode = TextureRect.STRETCH_SCALE
	vignette_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	vignette_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	stage_root.add_child(vignette_rect)
	vignette_rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	# 涓ゅ眰椋橀洩锛氳繙灞傜粏瀵嗐€佽繎灞傚ぇ鑰岃櫄锛屽舰鎴愭櫙娣?	snow_far = _make_snow(900, Vector3(920.0, 40.0, 0.0), 24.0, 0.55, 0.48)
	snow_far.position = Vector2(BASE.x * 0.5, -80.0)
	stage_root.add_child(snow_far)
	snow_near = _make_snow(240, Vector3(900.0, 30.0, 0.0), 44.0, 1.30, 0.80)
	snow_near.position = Vector2(BASE.x * 0.5, -110.0)
	stage_root.add_child(snow_near)


# 寮曡矾浜猴細绔欏湪绔欏彴宸︿晶鐨勫紩搴у憳銆傚簳灞傛槸鍔犳€ф煍鍏夛紝涓眰鏄惤鍦版姇褰憋紝涓婂眰鏄珛缁樸€?func _build_kanshan() -> void:
	kanshan_root = Control.new()
	kanshan_root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	kanshan_root.position = KANSHAN_HOME
	kanshan_root.size = KANSHAN_SIZE
	if not nofox:
		stage_root.add_child(kanshan_root)

	kanshan_halo = TextureRect.new()
	kanshan_halo.texture = _radial_tex(Color(0.72, 0.80, 0.98, 0.11), Color(0.72, 0.80, 0.98, 0.0))
	kanshan_halo.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var halo_mat := CanvasItemMaterial.new()
	halo_mat.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
	kanshan_halo.material = halo_mat
	kanshan_halo.position = Vector2(-KANSHAN_SIZE.x * 0.30, -KANSHAN_SIZE.y * 0.10)
	kanshan_halo.size = KANSHAN_SIZE * 1.60
	kanshan_root.add_child(kanshan_halo)

	var foot := TextureRect.new()
	foot.texture = _radial_tex(Color(0.0, 0.004, 0.016, 0.82), Color(0.0, 0.004, 0.016, 0.0))
	foot.mouse_filter = Control.MOUSE_FILTER_IGNORE
	foot.position = Vector2(KANSHAN_SIZE.x * -0.06, KANSHAN_SIZE.y - 46.0)
	foot.size = Vector2(KANSHAN_SIZE.x * 1.12, 74.0)
	kanshan_root.add_child(foot)

	kanshan_fig = TextureRect.new()
	var tex = load(KANSHAN_FIG)
	if tex is Texture2D:
		kanshan_fig.texture = tex
	else:
		push_warning("[涓€鏈熶竴浼歖 寮曡矾浜虹珛缁樼己澶? " + KANSHAN_FIG)
	kanshan_fig.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	kanshan_fig.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	kanshan_fig.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS
	kanshan_fig.mouse_filter = Control.MOUSE_FILTER_IGNORE
	# 绔嬬粯铻嶅悎锛氬喎鏆栫幆澧冭壊娴告煋 + 涓嬬紭鑷槾褰?+ 杈圭紭鍏夛紝缂撹В璐村浘鎰熶笌婕傛诞鎰熴€?	var fig_mat := ShaderMaterial.new()
	var fig_sh: Shader = load(KANSHAN_SHADER_PATH)
	if fig_sh == null:
		fig_sh = Shader.new()
		fig_sh.code = KANSHAN_SHADER
	fig_mat.shader = fig_sh
	kanshan_fig.material = fig_mat
	kanshan_fig.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	kanshan_root.add_child(kanshan_fig)


# 绔嬬粯鐨勬樉闅愶細0 = 瀹屽叏閫€鍦猴紝1 = 鍦ㄥ満銆傛贰鍏ユ贰鍑虹敱 _process 閫愬抚鎻掑€硷紝閬垮厤琛ラ棿鎵撴灦銆?func _kanshan_show(v: float) -> void:
	kanshan_target = clampf(v, 0.0, 1.0)


func _swap_bg(path: String, dur := 1.6) -> void:
	if bg_next == null or path == "":
		return
	if path == _bg_pending:
		return
	if path == bg_cur_path and bg_next.modulate.a <= 0.001:
		return
	var tex = load(path)
	if not (tex is Texture2D):
		push_warning("[涓€鏈熶竴浼歖 绔犺妭搴曞浘缂哄け锛屼繚鎸佸綋鍓嶇敾闈? " + path)
		return
	_bg_pending = path
	# 鍏堟妸"姝ｅ湪鏄剧ず鐨勫浘"鍥哄寲涓轰富灞傦紝鍐嶈澶囩敤灞傛贰鍏ユ柊鍥俱€?	# 涓诲眰鍚屾鎹㈠浘銆佷笉鐣欑瓑寰呯獥鍙ｏ紝閬垮厤杩炵画璋冪敤鏃朵袱涓ˉ闂翠簰鐩歌俯鍒般€?	if bg_rect.texture != null:
		bg_rect.texture = bg_rect.texture
	bg_next.texture = tex
	bg_next.modulate = Color(1, 1, 1, 0)
	bg_next.pivot_offset = bg_next.size * 0.5
	bg_next.scale = Vector2(1.035, 1.035)
	if _bg_tween != null and _bg_tween.is_valid():
		_bg_tween.kill()
		# 涓婁竴娆℃贰鍖栧彲鑳借鎵撴柇锛氭妸瀹冨凡缁忔贰鍒扮殑绋嬪害鍥哄寲鍒颁富灞傦紝闃茶烦鍙?		_freeze_bg()
	_bg_tween = create_tween()
	_bg_tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	_bg_tween.tween_property(bg_next, "modulate", Color(1, 1, 1, 1), dur)
	_bg_tween.tween_callback(func():
		bg_rect.texture = tex
		bg_rect.pivot_offset = bg_rect.size * 0.5
		bg_rect.scale = Vector2(1.035, 1.035)
		bg_next.modulate = Color(1, 1, 1, 0)
		bg_cur_path = path
		_bg_pending = ""
		_start_kenburns()
	)


# 鎶婂鐢ㄥ眰褰撳墠娣″埌鐨勭▼搴?鍥哄寲"鍒颁富灞傦紝浠呯敤浜庢墦鏂棫娣″寲鏃堕槻璺冲彉
func _freeze_bg() -> void:
	if bg_next == null or bg_next.texture == null:
		return
	var a: float = bg_next.modulate.a
	if a <= 0.02:
		return
	bg_rect.texture = bg_next.texture
	bg_next.modulate = Color(1, 1, 1, 0)


# 缂撴參鎺ㄩ暅锛氳闈欐搴曞浘鏈夊懠鍚告劅
func _start_kenburns() -> void:
	if _kb_tween != null and _kb_tween.is_valid():
		_kb_tween.kill()
	for r in [bg_rect, bg_next]:
		if r == null:
			continue
		r.pivot_offset = r.size * 0.5
		r.scale = Vector2(1.020, 1.020)
	_kb_tween = create_tween()
	_kb_tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	_kb_tween.set_loops()
	for r in [bg_rect, bg_next]:
		if r != null:
			_kb_tween.parallel().tween_property(r, "scale", Vector2(1.072, 1.072), 48.0)
	for r in [bg_rect, bg_next]:
		if r != null:
			_kb_tween.parallel().tween_property(r, "scale", Vector2(1.020, 1.020), 48.0)


func _on_bg_resized() -> void:
	bg_rect.pivot_offset = bg_rect.size * 0.5


func _radial_tex(center: Color, edge: Color) -> GradientTexture2D:
	var g := Gradient.new()
	# 澶氭琛板噺锛氬崟娈电嚎鎬ф笎鍙樹細鍦ㄨ竟缂樺垏鍑轰竴鏉＄‖杈癸紝杩欓噷鎸?1 / 0.45 / 0.14 / 0 鏀舵暃
	g.offsets = PackedFloat32Array([0.0, 0.32, 0.62, 1.0])
	g.colors = PackedColorArray([
		center,
		Color(center.r, center.g, center.b, center.a * 0.46),
		Color(center.r, center.g, center.b, center.a * 0.15),
		edge,
	])
	var t := GradientTexture2D.new()
	t.gradient = g
	t.width = 512
	t.height = 512
	t.fill = GradientTexture2D.FILL_RADIAL
	t.fill_from = Vector2(0.5, 0.5)
	t.fill_to = Vector2(0.5, 0.0)
	return t


# 鏆楄锛氫腑蹇冪暀鐧斤紝鍙湪澶栧湀娴呮祬鍘嬩竴灞傦紝閬垮厤鎶婄敾闈㈡暣浣撳帇姝?func _vignette_tex(max_alpha: float) -> GradientTexture2D:
	var g := Gradient.new()
	g.offsets = PackedFloat32Array([0.0, 0.50, 0.76, 1.0])
	g.colors = PackedColorArray([
		Color(0.006, 0.012, 0.024, 0.0),
		Color(0.006, 0.012, 0.024, 0.0),
		Color(0.006, 0.012, 0.024, max_alpha * 0.40),
		Color(0.006, 0.012, 0.024, max_alpha),
	])
	var t := GradientTexture2D.new()
	t.gradient = g
	t.width = 512
	t.height = 512
	t.fill = GradientTexture2D.FILL_RADIAL
	t.fill_from = Vector2(0.5, 0.5)
	t.fill_to = Vector2(0.5, 0.0)
	return t


# 搴曢儴鍘嬫殫锛氫笂鍥涙垚瀹屽叏閫氶€忥紝鍙湪鏈€涓嬫柟缁欐枃瀛楀灚涓€灞?func _shade_tex(bottom_alpha: float) -> GradientTexture2D:
	var g := Gradient.new()
	g.offsets = PackedFloat32Array([0.0, 0.44, 0.74, 1.0])
	g.colors = PackedColorArray([
		Color(0.010, 0.016, 0.030, 0.0),
		Color(0.010, 0.016, 0.030, 0.0),
		Color(0.008, 0.012, 0.024, bottom_alpha * 0.52),
		Color(0.008, 0.012, 0.024, bottom_alpha),
	])
	var t := GradientTexture2D.new()
	t.gradient = g
	t.width = 8
	t.height = 512
	t.fill = GradientTexture2D.FILL_LINEAR
	t.fill_from = Vector2(0.5, 0.0)
	t.fill_to = Vector2(0.5, 1.0)
	return t


# 瀵硅瘽妗嗚儗琛細椤堕儴娓愰殣銆佷笅鏂硅浆瀹烇紝閬垮厤鏂囧瓧鍙戣櫄鍙堜笉鍒囧嚭涓€鏉＄‖杈?func _panel_shade_tex() -> GradientTexture2D:
	var g := Gradient.new()
	g.offsets = PackedFloat32Array([0.0, 0.12, 0.42, 1.0])
	g.colors = PackedColorArray([
		Color(0.005, 0.009, 0.020, 0.22),
		Color(0.005, 0.009, 0.020, 0.42),
		Color(0.004, 0.007, 0.017, 0.52),
		Color(0.003, 0.006, 0.014, 0.62),
	])
	var t := GradientTexture2D.new()
	t.gradient = g
	t.width = 64
	t.height = 512
	t.fill = GradientTexture2D.FILL_LINEAR
	t.fill_from = Vector2(0.5, 0.0)
	t.fill_to = Vector2(0.5, 1.0)
	return t


func _flake_tex() -> GradientTexture2D:
	var g := Gradient.new()
	g.set_color(0, Color(1.0, 0.99, 0.96, 0.95))
	g.set_color(1, Color(1.0, 0.99, 0.96, 0.0))
	var t := GradientTexture2D.new()
	t.gradient = g
	t.width = 32
	t.height = 32
	t.fill = GradientTexture2D.FILL_RADIAL
	t.fill_from = Vector2(0.5, 0.5)
	t.fill_to = Vector2(0.5, 0.0)
	return t


func _make_snow(amount: int, box: Vector3, speed: float, scale_sz: float, alpha: float) -> GPUParticles2D:
	var p := GPUParticles2D.new()
	p.amount = amount
	p.lifetime = 16.0
	p.preprocess = 14.0
	p.fixed_fps = 30
	p.texture = _flake_tex()
	p.local_coords = false
	var m := ParticleProcessMaterial.new()
	m.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_BOX
	m.emission_box_extents = box
	m.direction = Vector3(0.18, -1.0, 0.0)
	m.spread = 14.0
	m.initial_velocity_min = speed * 0.55
	m.initial_velocity_max = speed * 1.15
	m.gravity = Vector3(5.5, -11.0, 0.0)
	m.scale_min = scale_sz * 0.55
	m.scale_max = scale_sz * 1.35
	m.color = Color(1.0, 1.0, 1.0, alpha)
	m.damping_min = 2.0
	m.damping_max = 6.0
	p.process_material = m
	return p

# ============================================================
# HUD
# ============================================================
func _build_hud() -> void:
	var layer := CanvasLayer.new()
	layer.layer = 2
	add_child(layer)
	hud = Control.new()
	hud.mouse_filter = Control.MOUSE_FILTER_PASS
	layer.add_child(hud)
	hud.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)


	# 鏍囬搴曡‖锛氶伩鍏嶅崐閫忔枃瀛楀帇鍦ㄨ繙鏅笂浜х敓"婕傛诞绌挎ā"瑙傛劅
	var title_back := ColorRect.new()
	title_back.color = Color(0.008, 0.018, 0.038, 0.50)
	title_back.position = Vector2(30, 24)
	title_back.size = Vector2(190, 76)
	title_back.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hud.add_child(title_back)

	# 鏍囬
	title_label = _mk_label("涓€鏈熶竴浼?, 34, COL_TITLE)
	title_label.add_theme_color_override("font_shadow_color", Color(0.0, 0.01, 0.04, 0.95))
	title_label.add_theme_constant_override("shadow_outline_size", 4)
	title_label.add_theme_constant_override("shadow_offset_y", 2)
	title_label.position = Vector2(46, 34)
	_fontify(title_label, font_display)
	hud.add_child(title_label)
	sub_label = _mk_label("浜洪棿鍓у満", 17, Color(0.74, 0.79, 0.88, 0.80))
	sub_label.position = Vector2(51, 80)
	_fontify(sub_label, font_display)
	sub_label.add_theme_constant_override("outline_size", 0)
	sub_label.add_theme_constant_override("shadow_outline_size", 2)
	sub_label.add_theme_color_override("font_shadow_color", Color(0.0, 0.01, 0.04, 0.70))
	sub_label.add_theme_constant_override("shadow_offset_y", 1)
	hud.add_child(sub_label)

	# 鍙充笂瑙掔珷鑺傜墝
	chapter_label = _mk_label("搴?路 鏈彮绔欏彴", 15, Color(0.82, 0.87, 0.95))
	chapter_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	chapter_label.position = Vector2(BASE.x - 400.0, 40.0)
	chapter_label.size = Vector2(354, 24)
	hud.add_child(chapter_label)

# 璺濈绾匡細涓嶅啓鏁板瓧锛屽彧鐢ㄤ竴鏉′細鍛煎惛鐨勭粏绾?	var dist_wrap := Control.new()
	dist_wrap.mouse_filter = Control.MOUSE_FILTER_IGNORE
	dist_wrap.position = Vector2(BASE.x - 400.0, 74.0)
	dist_wrap.size = Vector2(354, 6)
	hud.add_child(dist_wrap)
	distance_track = ColorRect.new()
	distance_track.color = Color(0.62, 0.72, 0.86, 0.22)
	distance_track.mouse_filter = Control.MOUSE_FILTER_IGNORE
	distance_track.position = Vector2(0, 0)
	distance_track.size = Vector2(354, 2)
	dist_wrap.add_child(distance_track)
	distance_fill = ColorRect.new()
	distance_fill.color = Color(0.98, 0.80, 0.50, 0.88)
	distance_fill.mouse_filter = Control.MOUSE_FILTER_IGNORE
	distance_fill.position = Vector2(0, 0)
	distance_fill.size = Vector2(140, 3)
	dist_wrap.add_child(distance_fill)

	# 澹伴煶寮€鍏筹細鏋佸皬銆佹瀬娣★紝涓嶆墦鎵扮敾闈紝浣嗛殢鏃跺彲鐢?	audio_btn = Button.new()
	audio_btn.text = "澹伴煶 寮€"
	audio_btn.focus_mode = Control.FOCUS_NONE
	audio_btn.mouse_filter = Control.MOUSE_FILTER_STOP
	audio_btn.position = Vector2(BASE.x - 400.0, 96.0)
	audio_btn.size = Vector2(88, 26)
	audio_btn.add_theme_font_size_override("font_size", 13)
	audio_btn.add_theme_color_override("font_color", Color(0.72, 0.79, 0.89, 0.72))
	audio_btn.add_theme_color_override("font_hover_color", Color(0.99, 0.87, 0.63, 0.98))
	audio_btn.add_theme_color_override("font_pressed_color", Color(0.99, 0.87, 0.63, 1.0))
	var sb_audio := StyleBoxFlat.new()
	sb_audio.bg_color = Color(0.02, 0.03, 0.06, 0.22)
	sb_audio.border_color = Color(0.74, 0.81, 0.92, 0.16)
	sb_audio.set_border_width_all(1)
	sb_audio.set_corner_radius_all(2)
	sb_audio.content_margin_left = 8.0
	sb_audio.content_margin_right = 8.0
	audio_btn.add_theme_stylebox_override("normal", sb_audio)
	var absh := sb_audio.duplicate()
	absh.bg_color = Color(0.06, 0.07, 0.11, 0.42)
	absh.border_color = Color(0.99, 0.87, 0.63, 0.42)
	audio_btn.add_theme_stylebox_override("hover", absh)
	audio_btn.add_theme_stylebox_override("pressed", absh)
	audio_btn.add_theme_stylebox_override("focus", sb_audio)
	_fontify(audio_btn, font_body)
	audio_btn.pressed.connect(_toggle_audio)
	hud.add_child(audio_btn)

	_build_panel()
	_build_ticket()
	_build_card()
	_build_mirror()
	_apply_layout()
	get_viewport().size_changed.connect(_apply_layout)


func _mk_label(txt: String, sz: int, col: Color) -> Label:
	var l := Label.new()
	l.text = txt
	l.add_theme_font_size_override("font_size", sz)
	l.add_theme_color_override("font_color", col)
	l.add_theme_color_override("font_shadow_color", Color(0.0, 0.01, 0.03, 0.85))
	l.add_theme_constant_override("shadow_offset_x", 0)
	l.add_theme_constant_override("shadow_offset_y", 1)
	l.add_theme_constant_override("shadow_outline_size", 1)
	l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_fontify(l, font_body)
	return l


func _fontify(n: Control, f: Font) -> void:
	if f != null:
		n.add_theme_font_override("font", f)


func _build_panel() -> void:
	panel = PanelContainer.new()
	panel.mouse_filter = Control.MOUSE_FILTER_STOP
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.012, 0.020, 0.040, 0.0)
	sb.border_color = Color(0.74, 0.81, 0.92, 0.0)
	sb.set_border_width_all(0)
	sb.set_corner_radius_all(0)
	sb.shadow_color = Color(0.0, 0.0, 0.0, 0.0)
	sb.shadow_size = 0
	sb.shadow_offset = Vector2(0, 0)
	sb.content_margin_left = 30.0
	sb.content_margin_right = 30.0
	sb.content_margin_top = 16.0
	sb.content_margin_bottom = 16.0
	panel.add_theme_stylebox_override("panel", sb)
	panel.clip_contents = false
	hud.add_child(panel)
	panel.size = Vector2(620, 186)
	panel.custom_minimum_size = Vector2(620, 0)

	# 娓愬彉鑳岃‖锛氶《铏氬簳瀹烇紝璁╂鏂囩ǔ瀹氬彲璇伙紝鍚屾椂涓嶄笌鑳屾櫙鍒囧嚭纭竟
	panel_shade = TextureRect.new()
	panel_shade.texture = _panel_shade_tex()
	panel_shade.stretch_mode = TextureRect.STRETCH_SCALE
	panel_shade.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	panel_shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel_shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	panel.add_child(panel_shade)
	panel.move_child(panel_shade, 0)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 6)
	box.mouse_filter = Control.MOUSE_FILTER_PASS
	panel.add_child(box)

	var speaker_row := HBoxContainer.new()
	speaker_row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	speaker_row.add_theme_constant_override("separation", 0)
	box.add_child(speaker_row)

	var speaker_chip := PanelContainer.new()
	speaker_chip.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var chip_sb := StyleBoxFlat.new()
	chip_sb.bg_color = Color(0.0, 0.0, 0.0, 0.0)
	chip_sb.border_color = Color(0.0, 0.0, 0.0, 0.0)
	chip_sb.set_border_width_all(0)
	chip_sb.border_width_left = 2
	chip_sb.border_color = Color(0.96, 0.78, 0.47, 0.78)
	chip_sb.set_corner_radius_all(0)
	chip_sb.content_margin_left = 12.0
	chip_sb.content_margin_right = 12.0
	chip_sb.content_margin_top = 2.0
	chip_sb.content_margin_bottom = 2.0
	chip_sb.shadow_color = Color(0.0, 0.0, 0.0, 0.0)
	chip_sb.shadow_size = 0
	speaker_chip.add_theme_stylebox_override("panel", chip_sb)
	speaker_row.add_child(speaker_chip)

	speaker_label = _mk_label("寮曡矾浜?, 15, Color(0.94, 0.79, 0.52))
	speaker_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	speaker_chip.add_child(speaker_label)

	var speaker_spacer := Control.new()
	speaker_spacer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	speaker_spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	speaker_row.add_child(speaker_spacer)

	line_label = RichTextLabel.new()
	line_label.bbcode_enabled = false
	line_label.fit_content = true
	line_label.scroll_active = false
	line_label.custom_minimum_size = Vector2(0, 48)
	line_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	line_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	line_label.add_theme_font_size_override("normal_font_size", 20)
	line_label.add_theme_color_override("default_color", Color(0.945, 0.960, 0.978))
	line_label.add_theme_constant_override("line_separation", 13)
	line_label.add_theme_constant_override("shadow_offset_x", 0)
	line_label.add_theme_constant_override("shadow_offset_y", 1)
	line_label.add_theme_constant_override("shadow_outline_size", 2)
	line_label.add_theme_color_override("font_shadow_color", Color(0.0, 0.008, 0.020, 0.80))
	_fontify(line_label, font_body)
	box.add_child(line_label)

	var input_row := HBoxContainer.new()
	input_row.add_theme_constant_override("separation", 14)
	input_row.mouse_filter = Control.MOUSE_FILTER_PASS
	box.add_child(input_row)

	input_edit = LineEdit.new()
	input_edit.placeholder_text = "鍐欎笅閭ｄ欢浣犺繕娌℃斁涓嬬殑浜嬧€︹€?
	input_edit.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	input_edit.custom_minimum_size = Vector2(0, 40)
	input_edit.add_theme_font_size_override("font_size", 17)
	input_edit.add_theme_color_override("font_color", COL_INK)
	input_edit.add_theme_color_override("font_placeholder_color", Color(0.70, 0.78, 0.88, 0.82))
	input_edit.add_theme_color_override("caret_color", COL_WARM)
	var le_sb := StyleBoxFlat.new()
	le_sb.bg_color = Color(0.022, 0.036, 0.062, 0.72)
	le_sb.border_color = Color(0.70, 0.79, 0.92, 0.26)
	le_sb.set_border_width_all(0)
	le_sb.border_width_bottom = 1
	le_sb.set_corner_radius_all(0)
	le_sb.content_margin_left = 6.0
	le_sb.content_margin_right = 6.0
	input_edit.add_theme_stylebox_override("normal", le_sb)
	var le_focus := le_sb.duplicate()
	le_focus.border_color = Color(0.96, 0.78, 0.47, 0.80)
	le_focus.border_width_bottom = 2
	input_edit.add_theme_stylebox_override("focus", le_focus)
	_fontify(input_edit, font_body)
	input_row.add_child(input_edit)

	action_btn = Button.new()
	action_btn.text = "鎶婅繖寮犵エ鐣欎笅"
	action_btn.custom_minimum_size = Vector2(168, 42)
	action_btn.add_theme_font_size_override("font_size", 17)
	var bs := StyleBoxFlat.new()
	bs.bg_color = Color(0.212, 0.232, 0.278, 0.90)
	bs.border_color = Color(0.96, 0.78, 0.47, 0.72)
	bs.set_border_width_all(0)
	bs.border_width_left = 2
	bs.border_width_bottom = 1
	bs.set_corner_radius_all(0)
	bs.content_margin_left = 26.0
	bs.content_margin_right = 26.0
	bs.shadow_color = Color(0.0, 0.0, 0.0, 0.30)
	bs.shadow_size = 6
	bs.shadow_offset = Vector2(0, 2)
	var bs_h := bs.duplicate()
	bs_h.bg_color = Color(0.300, 0.322, 0.372, 0.96)
	bs_h.border_color = Color(1.0, 0.86, 0.58, 0.92)
	var bs_p := bs.duplicate()
	bs_p.bg_color = Color(0.150, 0.166, 0.204, 0.96)
	action_btn.add_theme_stylebox_override("normal", bs)
	action_btn.add_theme_stylebox_override("hover", bs_h)
	action_btn.add_theme_stylebox_override("pressed", bs_p)
	action_btn.add_theme_stylebox_override("focus", bs_h)
	action_btn.add_theme_color_override("font_color", Color(0.975, 0.905, 0.760))
	action_btn.add_theme_color_override("font_hover_color", Color(1.0, 0.965, 0.880))
	action_btn.add_theme_color_override("font_pressed_color", Color(0.88, 0.84, 0.76))
	_fontify(action_btn, font_body)
	action_btn.pressed.connect(_on_action);
	input_row.add_child(action_btn)

	quick_row = HBoxContainer.new()
	quick_row.add_theme_constant_override("separation", 14)
	quick_row.mouse_filter = Control.MOUSE_FILTER_PASS
	box.add_child(quick_row)

	# 搴曢儴涓€琛岋細宸﹁竟鏄揩鎹烽€夐」鐨勫紩瀛愶紝鍙宠竟鏄繖涓€鎷嶇殑鐣欑櫧鎻愮ず銆備袱琛屽苟浣滀竴琛岋紝
	# 缁欑敾闈笅鏂圭殑绔欏彴涓庨暱妞呰鍑洪珮搴︺€?	var foot_row := HBoxContainer.new()
	foot_row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	foot_row.add_theme_constant_override("separation", 10)
	box.add_child(foot_row)

	quick_caption = _mk_label("鎴栬€咃紝浠庝笅闈㈡寫涓€鍙?鈥斺€?, 16, Color(0.86, 0.90, 0.96, 0.86))
	quick_caption.mouse_filter = Control.MOUSE_FILTER_IGNORE
	quick_caption.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	foot_row.add_child(quick_caption)

	var foot_spacer := Control.new()
	foot_spacer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	foot_spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	foot_row.add_child(foot_spacer)

	hint_label = _mk_label("闆仠涔嬪墠锛屾湯鐝溅浼氭潵銆?, 16, Color(0.94, 0.965, 0.995, 1.0))
	hint_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hint_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	hint_label.size_flags_horizontal = Control.SIZE_SHRINK_END
	foot_row.add_child(hint_label)


# 蹇嵎閫夐」锛氬悓涓€濂楀舰鍒讹紝闈犲乏渚т竴閬撴瀬缁嗙殑鎯呯华鑹叉潯鍋氬尯鍒嗭紝鑰屼笉鏄潬鑺卞摠鐨勬牱寮忋€?func _mk_quick(txt: String) -> Button:
	var b := Button.new()
	b.text = txt
	b.add_theme_font_size_override("font_size", 16)
	b.custom_minimum_size = Vector2(0, 40)
	b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var accent := _accent_for(txt)
	var s := StyleBoxFlat.new()
	s.bg_color = Color(0.026, 0.042, 0.074, 0.58)
	s.border_color = Color(accent.r, accent.g, accent.b, 0.34)
	s.set_border_width_all(0)
	s.border_width_left = 3
	s.set_corner_radius_all(0)
	s.content_margin_left = 20.0
	s.content_margin_right = 18.0
	s.content_margin_top = 12.0
	s.content_margin_bottom = 12.0
	s.shadow_color = Color(0.0, 0.0, 0.0, 0.0)
	s.shadow_size = 0
	s.shadow_offset = Vector2(0, 0)
	var sh := s.duplicate()
	sh.bg_color = Color(0.088, 0.120, 0.180, 0.78)
	sh.border_color = Color(accent.r, accent.g, accent.b, 0.95)
	sh.border_width_left = 4
	b.add_theme_stylebox_override("normal", s)
	b.add_theme_stylebox_override("hover", sh)
	b.add_theme_stylebox_override("pressed", sh)
	b.add_theme_stylebox_override("focus", sh)
	b.add_theme_color_override("font_color", Color(0.940, 0.960, 0.990))
	b.add_theme_color_override("font_hover_color", Color(1.0, 0.96, 0.84))
	b.add_theme_color_override("font_pressed_color", Color(1.0, 0.96, 0.84))
	b.add_theme_color_override("font_focus_color", Color(1.0, 0.96, 0.84))
	_fontify(b, font_body)
	return b


# 鎯呯华鑹诧細涓夋鍚勬湁涓€涓富鑹诧紝钀藉埌姣忎釜閫夐」涓婃椂鎸夎涔夊氨杩戝彇鑹层€?func _accent_for(txt: String) -> Color:
	var pink := Color(0.94, 0.66, 0.72)   # 妯辩矇鐏?路 閿欒繃
	var dusk := Color(0.62, 0.76, 0.96)   # 榛勬槒钃?路 宀旇矾
	var amber := Color(0.96, 0.78, 0.47)  # 鏆栫惀鐝€ 路 鏉ヤ笉鍙?	var quiet := Color(0.62, 0.88, 0.86)  # 闈欒哀闈?路 鐙
	for k in ["浜?, "璋?, "鍚嶅瓧", "鐩€?, "鍥炲ご"]:
		if txt.find(String(k)) >= 0:
			return pink
	for k in ["璺?, "璧?, "閫?, "鐣?, "杩?, "鍙︿竴"]:
		if txt.find(String(k)) >= 0:
			return dusk
	for k in ["璇?, "璇?, "鍑哄彛", "淇?, "闂?, "鍛婅瘔"]:
		if txt.find(String(k)) >= 0:
			return amber
	var palette := [pink, dusk, amber, quiet]
	var h := 0
	for i in txt.length():
		h = (h * 31 + txt.unicode_at(i)) % 100000
	return palette[h % palette.size()]
func _build_ticket() -> void:
	var layer := CanvasLayer.new()
	layer.layer = 3
	add_child(layer)
	ticket_layer = Control.new()
	ticket_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ticket_layer.modulate = Color(1, 1, 1, 0);
	layer.add_child(ticket_layer)
	ticket_layer.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	ticket_panel = PanelContainer.new()
	ticket_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var sb := StyleBoxFlat.new()
	sb.bg_color = COL_PAPER
	sb.set_corner_radius_all(1)
	sb.content_margin_right = 24.0
	sb.shadow_color = Color(0.0, 0.0, 0.0, 0.55)
	sb.shadow_size = 22
	sb.shadow_offset = Vector2(0, 10)
	ticket_panel.add_theme_stylebox_override("panel", sb)
	ticket_layer.add_child(ticket_panel)
	ticket_panel.size = Vector2(430, 216)

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 0)
	ticket_panel.add_child(row)

	var strip := ColorRect.new()
	strip.color = COL_STRIP
	strip.custom_minimum_size = Vector2(7, 0)
	strip.size_flags_vertical = Control.SIZE_EXPAND_FILL
	strip.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.add_child(strip)

	var body := MarginContainer.new()
	body.add_theme_constant_override("margin_left", 28)
	body.add_theme_constant_override("margin_right", 28)
	body.add_theme_constant_override("margin_top", 22)
	body.add_theme_constant_override("margin_bottom", 22)
	body.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(body)

	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 6)
	body.add_child(col)

	var t1 := _mk_label("浜?闂?鍓?鍦?, 13, COL_PAPER_DIM)
	t1.mouse_filter = Control.MOUSE_FILTER_IGNORE
	col.add_child(t1)
	var sp1 := Control.new(); sp1.custom_minimum_size = Vector2(0, 6); col.add_child(sp1)
	var t2 := _mk_label("妯?鑺?涓?鐢?杞?, 24, COL_PAPER_INK)
	t2.mouse_filter = Control.MOUSE_FILTER_IGNORE
	col.add_child(t2)
	var t3 := _mk_label("绗竴骞?路 鏈彮绔欏彴", 14, COL_PAPER_DIM)
	t3.mouse_filter = Control.MOUSE_FILTER_IGNORE
	col.add_child(t3)
	var sp2 := Control.new(); sp2.custom_minimum_size = Vector2(0, 10); col.add_child(sp2)
	var t4 := _mk_label("鍏ュ満鍒?/ 鍗曠▼", 13, COL_PAPER_DIM)
	t4.mouse_filter = Control.MOUSE_FILTER_IGNORE
	col.add_child(t4)

	var num := _mk_label("绗琝n涓€\n寮?, 19, Color(0.62, 0.30, 0.34))
	num.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	num.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	num.size_flags_vertical = Control.SIZE_EXPAND_FILL
	num.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.add_child(num)


func _build_card() -> void:
	var layer := CanvasLayer.new()
	layer.layer = 4
	add_child(layer)
	card_layer = Control.new()
	card_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	card_layer.modulate = Color(1, 1, 1, 0);
	layer.add_child(card_layer)
	card_layer.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	card_panel = PanelContainer.new()
	card_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.930, 0.912, 0.876, 0.86)
	sb.set_corner_radius_all(3)
	sb.border_width_left = 1
	sb.border_width_right = 1
	sb.border_width_top = 1
	sb.border_width_bottom = 1
	sb.border_color = Color(0.62, 0.55, 0.44, 0.34)
	sb.shadow_color = Color(0.0, 0.0, 0.0, 0.42)
	sb.shadow_size = 22
	sb.shadow_offset = Vector2(0, 8)
	card_panel.add_theme_stylebox_override("panel", sb)
	card_layer.add_child(card_panel)
	card_panel.size = Vector2(900, 232)

	var m := MarginContainer.new()
	m.add_theme_constant_override("margin_left", 56)
	m.add_theme_constant_override("margin_right", 56)
	m.add_theme_constant_override("margin_top", 20)
	m.add_theme_constant_override("margin_bottom", 20)
	card_panel.add_child(m)
	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 8)
	m.add_child(col)

	var k := _mk_label("閲?鎬€ 鍗?, 13, Color(0.52, 0.46, 0.38))
	k.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	k.mouse_filter = Control.MOUSE_FILTER_IGNORE
	col.add_child(k)

	card_quote = _mk_label("", 15, Color(0.16, 0.15, 0.14))
	card_quote.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	card_quote.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	card_quote.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	card_quote.add_theme_constant_override("line_spacing", 2)
	card_quote.size_flags_vertical = Control.SIZE_EXPAND_FILL
	card_quote.custom_minimum_size = Vector2(0, 0)
	card_quote.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_fontify(card_quote, font_display)
	col.add_child(card_quote)

	var f := _mk_label("鈥斺€?浜洪棿鍓у満", 13, Color(0.52, 0.46, 0.38))
	f.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	f.mouse_filter = Control.MOUSE_FILTER_IGNORE
	col.add_child(f)


# 浜洪棿闀滈壌锛氱粓绔犳妸鐜╁鐨勯仐鎲炬帴鍒扮煡涔庝笂鐪熷疄瀛樺湪鐨勪汉闂寸粡楠屼笂銆?# 鍙睍绀虹湡瀹炰綔鍝侊紝濡傚疄淇濈暀浣滆€呬笌鏉ユ簮锛岀帺瀹跺彲鐐硅繘鐭ヤ箮锛涗笉鍋氫换浣曟敼鍐欍€?func _build_mirror() -> void:
	var layer := CanvasLayer.new()
	layer.layer = 5
	add_child(layer)
	mirror_layer = Control.new()
	mirror_layer.mouse_filter = Control.MOUSE_FILTER_PASS
	mirror_layer.modulate = Color(1, 1, 1, 0)
	mirror_layer.visible = false
	layer.add_child(mirror_layer)
	mirror_layer.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	mirror_panel = PanelContainer.new()
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.020, 0.032, 0.056, 0.82)
	sb.set_corner_radius_all(0)
	sb.border_width_left = 3
	sb.border_color = Color(0.62, 0.76, 0.96, 0.55)
	sb.content_margin_left = 30.0
	sb.content_margin_right = 30.0
	sb.content_margin_top = 14.0
	sb.content_margin_bottom = 14.0
	sb.shadow_color = Color(0.0, 0.0, 0.0, 0.42)
	sb.shadow_size = 14
	sb.shadow_offset = Vector2(0, 5)
	mirror_panel.add_theme_stylebox_override("panel", sb)
	mirror_layer.add_child(mirror_panel)
	mirror_panel.size = Vector2(900, 168)

	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 6)
	col.mouse_filter = Control.MOUSE_FILTER_PASS
	mirror_panel.add_child(col)

	mirror_note = _mk_label("", 11, Color(0.88, 0.79, 0.62, 0.92))
	mirror_note.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_fontify(mirror_note, font_body)
	col.add_child(mirror_note)

	var head := HBoxContainer.new()
	head.add_theme_constant_override("separation", 8)
	head.mouse_filter = Control.MOUSE_FILTER_IGNORE
	col.add_child(head)
	var h := _mk_label("浜?闂?闀?閴?, 12, Color(0.72, 0.80, 0.92))
	h.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	head.add_child(h)
	mirror_source = Button.new()
	mirror_source.text = "鍦ㄧ煡涔庢墦寮€ 鈫?
	mirror_source.add_theme_font_size_override("font_size", 12)
	mirror_source.flat = true
	mirror_source.add_theme_color_override("font_color", Color(0.80, 0.86, 0.96))
	mirror_source.add_theme_color_override("font_hover_color", Color(1.0, 0.96, 0.84))
	mirror_source.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	_fontify(mirror_source, font_body)
	mirror_source.pressed.connect(_open_mirror_link)
	head.add_child(mirror_source)

	mirror_title = _mk_label("", 16, Color(0.96, 0.94, 0.88))
	_fontify(mirror_title, font_display)
	col.add_child(mirror_title)

	mirror_excerpt = _mk_label("", 13, Color(0.82, 0.86, 0.92))
	mirror_excerpt.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	mirror_excerpt.add_theme_constant_override("line_spacing", 2)
	col.add_child(mirror_excerpt)

	mirror_author = _mk_label("", 12, Color(0.62, 0.70, 0.82))
	col.add_child(mirror_author)

	mirror_ask = _mk_label("", 12, Color(0.62, 0.70, 0.82))
	mirror_ask.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	col.add_child(mirror_ask)


## 鍙睍绀虹湡瀹炴潯鐩紝瀛楁缂哄け灏卞瀹炵暀绌猴紝缁濅笉琛ラ€犱綔鑰呮垨姝ｆ枃銆?func _fill_mirror(d: Dictionary) -> void:
	if d.is_empty():
		return
	mirror_title.text = String(d.get("title", ""))
	var ex := String(d.get("excerpt", "")).strip_edges()
	if ex.length() > 88:
		ex = ex.substr(0, 88) + "鈥︹€?
	mirror_excerpt.text = ex
	var au := String(d.get("author", "")).strip_edges()
	var kind := "鐭ヤ箮鏁呬簨" if String(d.get("kind", "story")) == "story" else "鐭ヤ箮闂瓟"
	mirror_author.text = "鈥斺€?" + (au if au != "" else "浣滆€呬俊鎭互鐭ヤ箮椤甸潰涓哄噯") + " 路 " + kind
	var ask = d.get("ask", {})
	if ask is Dictionary and not (ask as Dictionary).is_empty():
		mirror_ask.text = "鍚岃矾浜轰篃鍦ㄩ棶锛? + String((ask as Dictionary).get("title", ""))
	else:
		mirror_ask.text = ""


func _open_mirror_link() -> void:
	var u := String(mirror_data.get("url", ""))
	# 鍙厑璁歌烦鍥炵煡涔庣珯鍐咃紝閬垮厤浠讳綍鏉ヨ矾涓嶆槑鐨勫湴鍧€銆?	if not u.begins_with("https://www.zhihu.com/"):
		return
	OS.shell_open(u)


## 缁堢珷锛氬厛浜嚭鍐呯疆鐨勭湡瀹炴潯鐩紝鍐嶅湪鍚庡彴椤烘墜鍒锋柊涓€娆℃鏂囧紑澶淬€?## 鏃犺鑱旂綉鎴愬姛涓庡惁锛岀帺瀹堕兘鐪嬪緱鍒颁笢瑗匡紱鑱旂綉澶辫触涓嶉噸璇曘€佷笉鎹㈠煙鍚嶃€?func _open_mirror() -> void:
	if mirror_layer == null:
		return
	var theme := String(GameState.regret_core.get("theme", ""))
	var kws = GameState.regret_core.get("keywords", [])
	if not (kws is Array):
		kws = []
	mirror_data = ZhihuMirror.story_for(theme)
	mirror_data["ask"] = ZhihuMirror.knowledge_for(theme, kws)
	if mirror_note != null:
		mirror_note.text = ""
	_fill_mirror(mirror_data)
	mirror_layer.visible = true
	mirror_layer.modulate = Color(1, 1, 1, 0)
	var tw := create_tween()
	tw.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tw.tween_property(mirror_layer, "modulate", Color(1, 1, 1, 1), 1.2)
	await get_tree().create_timer(1.2).timeout
	var live = await ZhihuMirror.fetch_story(theme)
	if mirror_layer == null or not mirror_layer.visible:
		return
	if live is Dictionary and not (live as Dictionary).is_empty():
		live["ask"] = mirror_data.get("ask", {})
		mirror_data = live
		_fill_mirror(mirror_data)
	_refresh_mirror_note()
	print("[浜洪棿闀滈壌] " + ZhihuMirror.status_line() + " 浣滃搧=" + String(mirror_data.get("title", "")))
	await get_tree().create_timer(1.8).timeout
	if mirror_layer == null or not mirror_layer.visible:
		return
	var tw2 := create_tween()
	tw2.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tw2.tween_property(mirror_layer, "modulate", Color(1, 1, 1, 0), 1.0)
	await get_tree().create_timer(1.0).timeout
	mirror_layer.visible = false


## 瀹樻柟妫€鏌ョ 6 鏉★細鎺ュ彛澶辫触 / 棰濆害鑰楀敖 / 绌烘暟鎹兘蹇呴』鏈変竴鍙ョ帺瀹剁湅寰楄鐨勪汉璇濄€?## 鍙檲杩颁簨瀹烇紝涓嶈В閲婃妧鏈紝涓嶆墦鏂儏缁€?func _refresh_mirror_note() -> void:
	if mirror_note == null:
		return
	if String(mirror_title.text).strip_edges() == "":
		mirror_note.text = "杩欐鍐呭鏆傛椂娌¤兘鍙栧埌锛屽厛璺宠繃涔熶笉褰卞搷鍚庨潰銆?
		return
	if ZhihuMirror.live_ok:
		mirror_note.text = ""
		return
	var err := String(ZhihuMirror.last_error).strip_edges()
	if err == "":
		mirror_note.text = "濡傚疄鍛堢幇 路 浠ヤ笂涓哄凡鏀跺綍鐨勭湡瀹炵煡涔庢潯鐩?
	elif err.begins_with("HTTP 429") or err.find("棰濆害") >= 0 or err.find("闄愭祦") >= 0:
		mirror_note.text = "浠婂ぉ鐨勮仈缃戦搴︾敤瀹屼簡 路 浠ヤ笂涓哄凡鏀跺綍鐨勭湡瀹炵煡涔庢潯鐩?
	elif err == "瓒呮椂":
		mirror_note.text = "缃戠粶鏈夌偣鎱?路 鍏堢湅宸叉敹褰曠殑鐪熷疄鐭ヤ箮鏉＄洰"
	else:
		mirror_note.text = "姝ゅ埢杩炰笉涓婄煡涔?路 鍏堢湅宸叉敹褰曠殑鐪熷疄鐭ヤ箮鏉＄洰"


func _apply_layout() -> void:
	var vs := get_viewport().get_visible_rect().size
	var sc: float = minf(vs.x / BASE.x, vs.y / BASE.y)
	if hud != null:
		hud.scale = Vector2(sc, sc)
		hud.position = Vector2((vs.x - BASE.x * sc) * 0.5, (vs.y - BASE.y * sc) * 0.5)
		hud.pivot_offset = Vector2.ZERO
	if stage_root != null:
		stage_root.scale = Vector2(sc, sc)
		stage_root.position = Vector2((vs.x - BASE.x * sc) * 0.5, (vs.y - BASE.y * sc) * 0.5)
	for l in [ticket_layer, card_layer, mirror_layer]:
		if l != null:
			l.scale = Vector2(sc, sc)
			l.position = Vector2((vs.x - BASE.x * sc) * 0.5, (vs.y - BASE.y * sc) * 0.5)
	if panel != null:
		panel_home = Vector2(880, 624)
		panel.position = panel_home
	if ticket_panel != null:
		ticket_home = Vector2(760, 330)
		ticket_panel.position = ticket_home
	if card_panel != null:
		card_panel.position = Vector2((BASE.x - 900.0) * 0.5, 48.0)
	if mirror_panel != null:
		mirror_panel.position = Vector2((BASE.x - 900.0) * 0.5, 284.0)
	if snow_far != null:
		snow_far.position = Vector2(BASE.x * 0.5, -80.0)
	if snow_near != null:
		snow_near.position = Vector2(BASE.x * 0.5, -110.0)
	if kanshan_root != null:
		kanshan_root.position = KANSHAN_HOME
		kanshan_root.size = KANSHAN_SIZE

# ============================================================
# 娴佺▼
# ============================================================
func _show_prologue() -> void:
	state = "prologue"
	chapter_label.text = "搴?路 鏈彮绔欏彴"
	speaker_label.text = "寮曡矾浜?
	_clear_quick()
	for q in PROLOGUE_QUICK:
		var b := _mk_quick(q)
		b.pressed.connect(_on_quick.bind(q))
		quick_row.add_child(b)
	input_edit.visible = true
	action_btn.visible = true
	action_btn.text = "鎶婅繖寮犵エ鐣欎笅"
	input_edit.placeholder_text = "鍐欎笅閭ｄ欢浣犺繕娌℃斁涓嬬殑浜嬧€︹€?
	if quick_caption != null:
		quick_caption.visible = true
	panel.visible = true
	# 浠庣粓绔犻噸鐜╂椂锛屾妸閲婃€€鍗℃暣灞傛敹骞插噣锛屽埆璁╁畠鍘嬪湪搴忕珷涓?	if card_layer != null:
		card_layer.modulate = Color(1, 1, 1, 0)
		card_layer.visible = false
	if mirror_layer != null:
		mirror_layer.modulate = Color(1, 1, 1, 0)
		mirror_layer.visible = false
	_say("鈥︹€︿綘鏉ヤ簡銆俓n鎴戞槸杩欏骇浜洪棿鍓у満鐨勫紩搴у憳銆俓n杩涘墽鍦哄墠锛屽厛鎶婁竴浠朵笢瑗垮瘎瀛樺湪鎴戣繖閲屸€斺€斾綘甯︾潃浠€涔堟潵锛?)
	_set_hint("闆仠涔嬪墠锛屾湯鐝溅浼氭潵銆?)
	_distance_to(0.42)
	# 搴忕珷浠庨粦鏆楅噷浜捣鏉ワ細鏁村潡鑸炲彴鍏堥殣鍒?0锛屽啀缂撶紦娴嚭
	stage_root.modulate = Color(1, 1, 1, 0)
	var vw := create_tween()
	vw.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	vw.tween_property(stage_root, "modulate", Color(1, 1, 1, 1), 3.0)
	# 浠庣粓绔犲洖鍒板簭绔犳椂锛屽簳鍥句篃瑕佺湡鐨勪氦鍙夋贰鍖栦竴娆?	bg_cur_path = ""
	_swap_bg(BG_PATH, 2.6)


func _on_quick(txt: String) -> void:
	if busy:
		print("[娴佺▼] 蹇欑涓拷鐣ヤ簡蹇嵎杈撳叆锛歴tate=" + state + " beat=" + str(beat))
		return
	if state == "prologue":
		input_edit.text = txt
		input_edit.grab_focus()
		input_edit.caret_column = input_edit.text.length()
		_set_hint("鈥︹€﹀氨浠庤繖閲屽紑濮嬨€傚墿涓嬬殑瀛楋紝浣犺嚜宸卞啓銆?)
		_distance_to(0.50)
		return
	if state == "chapter1" or state == "chapter2" or state == "chapter3":
		busy = true
		_pending_echo = GameState.echo_for(txt)
		beat += 1
		if beat >= _beats().size():
			_closing_beat()
			return
		_render_beat()


func _on_action() -> void:
	if busy:
		print("[娴佺▼] 蹇欑涓拷鐣ヤ簡纭杈撳叆锛歴tate=" + state + " beat=" + str(beat))
		return
	if state == "prologue":
		var t := input_edit.text.strip_edges()
		if t.length() < 2:
			_set_hint("鈥︹€︿笉鐢ㄦ€ャ€傛兂濂戒簡锛屽啀鍐欎笅绗竴涓瓧銆?)
			_shake(panel)
			return
		busy = true
		_set_hint("鈥︹€?)
		GameState.set_regret(t)
		_pending_readback = GameState.prologue_readback()
		# AI 鍙仛澧炲己锛氳寰楁洿缁嗕竴鐐广€傚け璐ャ€佽秴鏃躲€佹病閰?Key 閮借蛋鏈湴缁撴灉銆?		var core_local = GameState.regret_core
		var core_ai = await AILayer.enrich_regret(t, core_local)
		if typeof(core_ai) == TYPE_DICTIONARY and not core_ai.is_empty() and _core_differs(core_local, core_ai):
			GameState.regret_core = core_ai
			var back := GameState.prologue_readback()
			if back != "":
				_pending_readback = back
			print("[AI] 搴忕珷鍐呮牳宸插寮猴細" + str(core_ai.get("theme", "")) + " / " + str(core_ai.get("image", "")))
		else:
			print("[AI] 搴忕珷鍐呮牳浣跨敤鏈湴缁撴灉锛? + AILayer.last_source + "锛?)
		busy = false
		_accept_ticket()
		return
	if state == "chapter1" or state == "chapter2" or state == "chapter3":
		var t := input_edit.text.strip_edges()
		if t.length() < 2:
			_set_hint("鈥︹€︿笉鐢ㄦ€ャ€傛兂濂戒簡锛屽啀鍐欍€傛垨鑰咃紝浠庝笅闈㈡寫涓€鍙ャ€?)
			_shake(panel)
			return
		busy = true
		_pending_input = t
		_pending_echo = GameState.echo_for(t)
		beat += 1
		if beat >= _beats().size():
			_closing_beat()
			return
		_render_beat()
		return
	if state == "card":
		_show_prologue()


## AI 鏀规病鏀瑰唴鏍革細鍙瘮鍑犱釜鍏抽敭瀛楁锛岄伩鍏?Dictionary 姣旇緝鐨勪笉纭畾琛屼负銆?func _core_differs(a: Dictionary, b: Dictionary) -> bool:
	for k in ["theme", "target", "image", "emotion", "action"]:
		if String(a.get(k, "")) != String(b.get(k, "")):
			return true
	return false


func _accept_ticket() -> void:
	busy = true
	state = "ticket"
	_set_hint("鏈彮杞︼紝蹇埌浜嗐€?)
	input_edit.visible = false
	action_btn.visible = false
	if quick_caption != null:
		quick_caption.visible = false
	_clear_quick()
	_distance_to(0.58)
	var readback := _pending_readback
	_pending_readback = ""
	if readback != "":
		_say(readback)
		await get_tree().create_timer(2.4).timeout
	_say("鈥︹€︽敹涓嬩簡銆俓n鎴戜細鏇夸綘淇濈鐫€銆俓n绛変綘鐪嬪畬涓夊満鎴忥紝鍐嶆潵鍙栥€?)
	await get_tree().create_timer(1.1).timeout
	_show_ticket()
	await get_tree().create_timer(2.6).timeout
	_hide_ticket()
	await get_tree().create_timer(0.7).timeout
	_enter_chapter1()
	busy = false


func _show_ticket() -> void:
	ticket_layer.modulate = Color(1, 1, 1, 0)
	var tw := create_tween()
	tw.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tw.tween_property(ticket_layer, "modulate", Color(1, 1, 1, 1), 0.9)
	var from := ticket_home + Vector2(0, 26)
	ticket_panel.position = from
	tw.parallel().tween_property(ticket_panel, "position", ticket_home, 0.9)
	_rise_swell()


func _hide_ticket() -> void:
	var tw := create_tween()
	tw.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tw.tween_property(ticket_layer, "modulate", Color(1, 1, 1, 0), 0.8)


func _enter_chapter1() -> void:
	state = "chapter1"
	beat = 0
	chapter_label.text = "绗竴骞?路 妯辫姳涓庣數杞?
	speaker_label.text = "寮曡矾浜?
	panel.visible = true
	input_edit.visible = true
	action_btn.visible = true
	input_edit.text = ""
	input_edit.placeholder_text = "鎯宠浠€涔堬紝灏卞啓涓嬫潵鈥︹€?
	if quick_caption != null:
		quick_caption.visible = true
	_swap_bg(BG_CH1, 2.4)
	_hush_audio(2.6, 1.2)
	_render_beat()


func _beats() -> Array:
	if state == "chapter2":
		return CH2_BEATS
	if state == "chapter3":
		return CH3_BEATS
	return CH1_BEATS


func _chapter_index() -> int:
	if state == "chapter2":
		return 2
	if state == "chapter3":
		return 3
	return 1


## 姣忎竴骞曠殑鏈€鍚庝竴鎷嶏細鐜╁鍒氬啓涓嬬殑閭ｅ彞璇濓紝涔熻琚帴浣忎竴娆★紝鍐嶈繘涓嬩竴骞曘€?## 浠ュ墠杩欓噷鐩存帴鎹㈠箷锛屾渶鍚庝竴鍙ヨ瘽鏃㈡病鏈夊洖搴旓紝涔熸病鏈夎鐢婚潰鎺ヤ綇銆?func _closing_beat() -> void:
	busy = true
	var pre := ""
	if _pending_echo != "":
		pre = _pending_echo
		_pending_echo = ""
	_pending_resonance = ""
	var inner := ""
	if _pending_input != "":
		var last_beat := _beats().size() - 1
		inner = GameState.director_line(_chapter_index(), last_beat, _pending_input)
		print("[瀵兼紨] 骞?" + str(_chapter_index()) + " 鎷?" + str(last_beat) + " 鏍囩=" + GameState.last_director_tag + " 杈撳叆=" + _pending_input.substr(0, 20))
		_pending_input = ""
	var line := inner
	if pre != "":
		line = pre + "\n\n" + line
	if line.strip_edges() == "":
		_advance_chapter()
		return
	_say(line)
	_set_hint("鈥︹€﹁繖涓€绋嬶紝浣犲凡缁忓敖鍔涗簡銆?)
	_hush_audio(2.2, 1.4)
	_distance_to(0.86)
	# 璁╃帺瀹剁湅娓呰繖鍙ヨ瘽鍐嶆崲骞曘€備互鍓嶅浐瀹?3.6 绉掞紝鏀舵潫鍙拌瘝涓€闀垮氨浼氳鎵撴柇銆佺敋鑷虫暣鍙ヨ璺虫帀锛?	# 鐜板湪鍏堢瓑鎵撳瓧鏈虹湡鐨勬墦瀹岋紝鍐嶅鐣?2.6 绉掞紝鍐嶆崲骞曘€傝皟鐢ㄧ偣浠嶇劧鏄悓姝ョ殑銆?	_hold_then_advance()


## 鏀舵潫鎷嶄笓鐢細绛夎繖鍙ヨ瘽琚畬鏁村康瀹岋紝鐣欎竴鐐逛綑鍛筹紝鍐嶈繘鍏ヤ笅涓€骞曘€?func _hold_then_advance() -> void:
	var waited := 0.0
	while typing and waited < 15.0:
		await get_tree().process_frame
		waited += get_process_delta_time()
	await get_tree().create_timer(2.6).timeout
	_advance_chapter()


func _advance_chapter() -> void:
	# 涓婁竴骞曟渶鍚庝竴鍙ュ凡缁忓啓杩?player_lines锛堜細鍑虹幇鍦ㄩ噴鎬€淇￠噷锛夛紝
	# 浣嗕笉鑳戒綔涓?鍥炲０"娓楀埌涓嬩竴骞曠殑绗竴鎷嶅幓锛岃繖閲屾樉寮忔竻绌恒€?	_pending_input = ""
	_pending_echo = ""
	_pending_resonance = ""
	if state == "chapter1":
		_enter_chapter2()
		return
	if state == "chapter2":
		_enter_chapter3()
		return
	_enter_card()


func _enter_chapter2() -> void:
	state = "chapter2"
	beat = 0
	chapter_label.text = "绗簩骞?路 娌¤蛋鐨勯偅鏉¤矾"
	speaker_label.text = "寮曡矾浜?
	panel.visible = true
	input_edit.visible = true
	action_btn.visible = true
	input_edit.text = ""
	input_edit.placeholder_text = "鎯宠浠€涔堬紝灏卞啓涓嬫潵鈥︹€?
	if quick_caption != null:
		quick_caption.visible = true
	_swap_bg(BG_CH2, 2.4)
	_hush_audio(2.6, 1.2)
	_render_beat()


func _enter_chapter3() -> void:
	state = "chapter3"
	beat = 0
	chapter_label.text = "绗笁骞?路 鏉ヤ笉鍙?
	speaker_label.text = "寮曡矾浜?
	panel.visible = true
	input_edit.visible = true
	action_btn.visible = true
	input_edit.text = ""
	input_edit.placeholder_text = "鎯宠浠€涔堬紝灏卞啓涓嬫潵鈥︹€?
	if quick_caption != null:
		quick_caption.visible = true
	_swap_bg(BG_CH3, 2.4)
	_hush_audio(2.6, 1.2)
	_render_beat()


func _render_beat() -> void:
	var beats := _beats()
	if beat < 0 or beat >= beats.size():
		_advance_chapter()
		return
	var b: Dictionary = beats[beat]
	chapter_label.text = String(b.get("label", ""))
	_clear_quick()
	for q in b.get("quick", []):
		var btn := _mk_quick(String(q))
		btn.pressed.connect(_on_quick.bind(String(q)))
		quick_row.add_child(btn)
	input_edit.visible = true
	action_btn.visible = true
	action_btn.text = "鎶婅繖鍙ヨ瘽璇村嚭鏉?
	input_edit.placeholder_text = "鎶婃病鑳借鍑哄彛鐨勯偅鍙ヨ瘽锛屽啓鍦ㄨ繖閲屸€︹€?
	if quick_caption != null:
		quick_caption.visible = true
	var pre := ""
	if _pending_echo != "":
		pre = _pending_echo
		_pending_echo = ""
	if _pending_resonance != "" and pre == "":
		pre = _pending_resonance
		_pending_resonance = ""
	if beat == 0:
		var res := GameState.resonance(_chapter_index())
		if res != "":
			if pre == "":
				pre = res
			else:
				_pending_resonance = res
	var line := String(b.get("line", ""))
	if _pending_input != "":
		var director := GameState.director_line(_chapter_index(), beat, _pending_input)
		if director != "":
			line = director + "\n\n" + line
			print("[瀵兼紨] 骞?" + str(_chapter_index()) + " 鎷?" + str(beat) + " 鏍囩=" + GameState.last_director_tag + " 鍥炲０=" + GameState.last_director_echo.substr(0, 24) + " 杈撳叆=" + _pending_input.substr(0, 20))
		# AI 鍙噸鍐?杩欎竴鎷嶈惤鍦ㄥ摢閲?锛屾墜宸ユ儏缁鏋跺拰缁撳眬涓嶅姩銆?		if AILayer.has_remote():
			_set_hint("鈥︹€?)
			var ai_director = await AILayer.director_line(_chapter_index(), beat, _pending_input, director)
			if typeof(ai_director) == TYPE_STRING and String(ai_director).strip_edges() != "" and String(ai_director) != director:
				line = String(ai_director) + "\n\n" + String(b.get("line", ""))
				print("[瀵兼紨-AI] 骞?" + str(_chapter_index()) + " 鎷?" + str(beat) + " 鏉ユ簮=" + AILayer.last_source)
		_pending_input = ""
	if pre != "":
		line = pre + "\n\n" + line
	_say(line)
	_set_hint(String(b.get("hint", "")))
	var base := 0.50
	if state == "chapter2":
		base = 0.56
	elif state == "chapter3":
		base = 0.62
	match beat:
		0: _distance_to(base)
		1: _distance_to(base - 0.06)
		2: _distance_to(base + 0.10)
		_: _distance_to(base + 0.22)
	busy = false


func _enter_card() -> void:
	state = "card"
	busy = true
	chapter_label.text = "缁?路 閲婃€€"
	panel.visible = false
	_swap_bg(BG_FINALE, 2.8)
	_hush_audio(3.2, 2.4)
	_clear_quick()
	if quick_caption != null:
		quick_caption.visible = false
	card_quote.text = _compose_card_text()
	_enhance_card_letter()
	print("[閲婃€€鍗 " + card_quote.text.replace("\n", " / "))
	_distance_to(0.86)
	card_layer.visible = true
	card_layer.modulate = Color(1, 1, 1, 0)
	var tw := create_tween()
	tw.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tw.tween_property(card_layer, "modulate", Color(1, 1, 1, 1), 1.4)
	await get_tree().create_timer(2.0).timeout
	await _open_mirror()
	_show_epilogue_panel()
	busy = false


func _show_epilogue_panel() -> void:
	panel.visible = true
	speaker_label.text = "寮曡矾浜?
	var last := ""
	if GameState.player_lines.size() > 0:
		last = GameState.player_lines[GameState.player_lines.size() - 1]
		if last.length() > 18:
			last = last.substr(0, 18) + "鈥︹€?
	var closing := "涓夊紶绁紝鎴戦兘鏀跺洖鏉ヤ簡銆俓n鍒拌繖閲岋紝鍓у満灏辫鍏抽棬浜嗐€?
	if last != "":
		closing += "\n浣犺鐨勯偅鍙ャ€? + last + "銆嶏紝鎴戜篃鏀朵笅浜嗐€?
	closing += "\n鎯冲啀璧颁竴閬嶇殑璇濓紝鐐逛笅闈㈢殑鎸夐挳銆?
	_say(closing)
	_clear_quick()
	var b := _mk_quick("鍐嶇湅涓€娆″簭绔?)
	b.pressed.connect(_show_prologue)
	quick_row.add_child(b)
	input_edit.visible = false
	action_btn.visible = false
	if quick_caption != null:
		quick_caption.visible = false
	_set_hint("鈥斺€?杩欎竴绋嬶紝浣犲凡缁忓敖鍔涗簡銆?)


func _compose_card_text() -> String:
	return GameState.release_letter()


## 閲婃€€淇″厛鍦ㄦ湰鍦版垚绋垮苟鏄剧ず锛涘鏋滈厤浜嗘ā鍨嬶紝绛夊畠鍐欏ソ鍐嶈交杞绘崲涓婂幓銆?## 鐜╁涓嶄細鐪嬪埌绌虹櫧绛夊緟锛屼篃涓嶄細鍥犱负缃戠粶闂鎷夸笉鍒颁俊銆?func _enhance_card_letter() -> void:
	if not AILayer.has_remote():
		print("[AI] 閲婃€€淇′娇鐢ㄦ湰鍦版枃鏈?)
		return
	var local := card_quote.text
	var ctx: Dictionary = GameState.regret_core.duplicate(true)
	ctx["lines"] = GameState.player_lines
	var ai_letter = await AILayer.release_letter(ctx, local, 4.0)
	if state != "card":
		return
	if typeof(ai_letter) != TYPE_STRING or String(ai_letter).strip_edges() == "":
		print("[AI] 閲婃€€淇″洖閫€鏈湴鏂囨湰")
		return
	card_quote.text = String(ai_letter)
	print("[AI] 閲婃€€淇＄敱鍦ㄧ嚎妯″瀷鐢熸垚")
	var tw := create_tween()
	tw.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tw.tween_property(card_quote, "modulate", Color(1, 1, 1, 1), 0.6)


# ============================================================
# 鍙拌瘝 / 璺濈 / 鎻愮ず
# ============================================================
func _say(txt: String) -> void:
	line_label.text = ""
	typed_chars = 0.0
	_typed = txt
	typing = true


var _typed: String = ""


func _set_hint(txt: String) -> void:
	hint_label.text = txt


func _clear_quick() -> void:
	for c in quick_row.get_children():
		c.queue_free()


func _distance_to(v: float) -> void:
	distance_target = clampf(v, 0.0, 1.0)


func _shake(n: Control) -> void:
	var home := n.position
	var tw := create_tween()
	tw.set_trans(Tween.TRANS_SINE)
	for i in 5:
		var dx := 7.0 if i % 2 == 0 else -7.0
		tw.tween_property(n, "position", home + Vector2(dx, 0), 0.045)
	tw.tween_property(n, "position", home, 0.06)


func _rise_swell() -> void:
	var tw := create_tween()
	tw.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tw.tween_property(warm_glow, "modulate", Color(1.16, 1.12, 1.06, 1.0), 1.8)
	tw.tween_property(warm_glow, "modulate", Color(1.0, 1.0, 1.0, 1.0), 2.4)


# ============================================================
# 澹伴煶灞傦細閽㈢惔 ambient + 闆鐜椋?+ 鍏抽敭澶勯潤榛?# 璁捐鍘熷垯锛氬０闊虫案杩滃湪鑳屾櫙锛屼笉鎶㈠彴璇嶏紱姣忔鎹㈠箷鍋氫竴娆°€屽懠鍚稿紡銆?# 鐨勬贰鍖栵紝璁╃帺瀹跺湪鎯呯华杞姌澶勬劅鍒颁笘鐣屽畨闈欎簡涓€绉掋€?# ============================================================
func _build_audio() -> void:
	if _audio_built:
		return
	var master := AudioServer.get_bus_index("Master")
	for spec in [["Music", BGM_DB], ["Ambience", AMB_DB]]:
		var idx := AudioServer.get_bus_index(spec[0])
		if idx < 0:
			AudioServer.add_bus()
			idx = AudioServer.bus_count - 1
			AudioServer.set_bus_name(idx, spec[0])
			AudioServer.set_bus_send(idx, "Master")
		AudioServer.set_bus_volume_db(idx, spec[1])
		AudioServer.set_bus_mute(idx, false)
	var bgm := AudioStreamPlayer.new()
	bgm.name = "BGM"
	bgm.bus = "Music"
	var st := load(BGM_PATH)
	if st is AudioStream:
		if st is AudioStreamWAV:
			st.loop_mode = AudioStreamWAV.LOOP_FORWARD
			st.loop_begin = 0
			st.loop_end = int(round(st.get_length() * float(st.mix_rate)))
		bgm.stream = st
		add_child(bgm)
		_audio["bgm"] = bgm
	else:
		push_warning("[涓€鏈熶竴浼歖 鑳屾櫙闊充箰缂哄け: " + BGM_PATH)
	var amb := AudioStreamPlayer.new()
	amb.name = "AMB"
	amb.bus = "Ambience"
	var sa := load(AMB_PATH)
	if sa is AudioStream:
		if sa is AudioStreamWAV:
			sa.loop_mode = AudioStreamWAV.LOOP_FORWARD
			sa.loop_begin = 0
			sa.loop_end = int(round(sa.get_length() * float(sa.mix_rate)))
		amb.stream = sa
		add_child(amb)
		_audio["amb"] = amb
	else:
		push_warning("[涓€鏈熶竴浼歖 鐜闊崇己澶? " + AMB_PATH)
	_audio_built = true


func _play_audio() -> void:
	if not _audio_built:
		return
	for k in ["bgm", "amb"]:
		var pl: AudioStreamPlayer = _audio.get(k)
		if pl != null and not pl.playing:
			pl.play()
	_fade_audio(0.0, 1.0, 3.2)


## 鎶婃暣鏉″０杞ㄦ姮鍒?/ 钀藉埌鐩爣闊抽噺锛涙崲骞曟椂鐢ㄤ竴娆℃瀬缂撶殑鍛煎惛銆?func _fade_audio(from: float, to: float, dur: float) -> void:
	if not _audio_built:
		return
	var bus := AudioServer.get_bus_index("Music")
	if bus < 0:
		return
	var tw := create_tween()
	tw.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tw.tween_method(_set_audio_gain, from, to, dur)


func _set_audio_gain(v: float) -> void:
	audio_level = clampf(v, 0.0, 1.0)
	for spec in [["Music", BGM_DB], ["Ambience", AMB_DB]]:
		var idx := AudioServer.get_bus_index(spec[0])
		if idx < 0:
			continue
		var db: float = spec[1] + linear_to_db(maxf(audio_level, 0.0008))
		AudioServer.set_bus_volume_db(idx, db)
		AudioServer.set_bus_mute(idx, audio_muted or audio_level <= 0.001)


## 鍏抽敭鎯呯华鑺傜偣锛氬０闊宠交杞婚€€鍒板嚑涔庡惉涓嶈锛屽啀鎱㈡參鍥炴潵銆?## 鐢ㄥ湪涓夊箷鏀舵潫涓庣粓绔犲紑鍦衡€斺€斻€屼笘鐣屽畨闈欎簡涓€绉掋€嶃€?func _hush_audio(dur := 2.4, hold := 1.6) -> void:
	if not _audio_built:
		return
	var tw := create_tween()
	tw.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tw.tween_method(_set_audio_gain, audio_level, 0.16, dur)
	tw.tween_interval(hold)
	tw.tween_method(_set_audio_gain, 0.16, 1.0, dur * 1.4)


func _toggle_audio() -> void:
	audio_muted = not audio_muted
	if audio_btn != null:
		audio_btn.text = "澹伴煶 鍏? if audio_muted else "澹伴煶 寮€"
	_set_audio_gain(1.0)


# ============================================================
# 姣忓抚
# ============================================================
func _process(delta: float) -> void:
	clock += delta
	grain_mat.set_shader_parameter("t", clock)
	if film_grain_mat != null:
		film_grain_mat.set_shader_parameter("t", clock)

	# 搴曞浘鏋佺紦鎺ㄨ繎 + 鍛煎惛锛屽儚闀滃ご鍦ㄩ洩閲岃交杞诲懠姘?	breath += delta
	if bg_rect != null and bg_rect.texture != null:
		var k := 1.035 + sin(breath * 0.16) * 0.006
		bg_rect.pivot_offset = bg_rect.size * 0.5
		bg_rect.scale = Vector2(k, k)
		var drift := Vector2(sin(breath * 0.10) * 7.0, cos(breath * 0.07) * 4.0)
		bg_rect.position = (bg_rect.size * (1.0 - k) * 0.5) + drift

	if bg_next != null and bg_next.texture != null and bg_next.modulate.a > 0.001:
		var nk := 1.035 + sin(breath * 0.16) * 0.006
		bg_next.pivot_offset = bg_next.size * 0.5
		bg_next.scale = Vector2(nk, nk)
		bg_next.position = (bg_next.size * (1.0 - nk) * 0.5) + Vector2(sin(breath * 0.10) * 7.0, cos(breath * 0.07) * 4.0)

	if warm_glow != null:
		warm_glow.position = Vector2(120, 30) + Vector2(sin(breath * 0.22) * 12.0, cos(breath * 0.18) * 7.0)

	# 寮曡矾浜猴細鏋佺紦鐨勫懠鍚告诞鍔?+ 杞诲井杩庡厜锛屽儚绔欏湪闆噷闈欓潤绛変綘鍐欏畬
	if kanshan_root != null:
		kanshan_on = lerpf(kanshan_on, kanshan_target, clampf(delta * 1.1, 0.0, 1.0))
		var kb := sin(breath * 0.42) * 3.4
		var kx := sin(breath * 0.29) * 1.8
		kanshan_root.position = KANSHAN_HOME + Vector2(kx, kb)
		kanshan_root.modulate = Color(1.0, 1.0, 1.0, kanshan_on)
	if kanshan_halo != null:
		kanshan_halo.modulate = Color(1.0, 1.0, 1.0, 0.58 + sin(breath * 0.5) * 0.14)

	if typing and line_label != null:
		typed_chars += delta * TYPE_SPEED
		var n := int(typed_chars)
		if n >= _typed.length():
			line_label.text = _typed
			typing = false
		else:
			line_label.text = _typed.substr(0, n)

	distance = lerpf(distance, distance_target, clampf(delta * 1.6, 0.0, 1.0))
	var track_w := 354.0
	distance_fill.size.x = lerpf(26.0, track_w, distance)
	var pulse := 0.72 + sin(clock * 1.15) * 0.12
	distance_fill.color = Color(0.98, 0.80, 0.50, pulse)

# ============================================================
# 3D 鍏滃簳锛?-3d锛夛細鍔犺浇 Blender 瀵煎嚭鐨勬寮忚溅绔欒祫浜?# ============================================================
const CAM_HERO_POS := Vector3(0.50, 3.62, -24.00)
const CAM_HERO_LOOK := Vector3(0.50, 1.20, 8.00)
const LAMP_XS := [-5.60, -3.95, -2.30]
const LAMP_ZS := [-1.10, 3.95, 9.00, 14.05]

func _build_3d() -> void:
	if stage_root != null:
		stage_root.visible = false
		print("[涓€鏈熶竴浼歖 2D 鑸炲彴搴曞浘宸查殣钘?)

	var world := get_node_or_null("WorldEnvironment")
	if world is WorldEnvironment:
		world.environment = _make_env()

	var glb = load(GLB_PATH)
	var node: Node3D = null
	if glb is PackedScene:
		node = (glb as PackedScene).instantiate() as Node3D
	if node == null:
		push_error("[涓€鏈熶竴浼歖 3D 璧勪骇鍔犺浇澶辫触: " + GLB_PATH)
		print("[涓€鏈熶竴浼歖 3D 璧勪骇鍔犺浇澶辫触")
		_show_load_error()
		return
	add_child(node)
	_tame_glb_materials(node)
	_strip_placeholders(node)
	_dress_station_sign()

	var cam := get_node_or_null("Camera3D") as Camera3D
	if cam != null:
		cam.current = true
		cam.fov = 38.0
		cam.position = CAM_HERO_POS
		cam.look_at(CAM_HERO_LOOK, Vector3.UP)

	var moon := get_node_or_null("MoonLight") as DirectionalLight3D
	if moon != null:
		moon.light_color = Color(0.52, 0.66, 0.98)
		moon.light_energy = 1.25
		moon.shadow_enabled = true
		moon.rotation_degrees = Vector3(-32, 128, 0)

	# 绔欏彴鏆栫伅姹狅細鑰佸紡鍚婄伅 + 鐢电紗
	for z in LAMP_ZS:
		for x in LAMP_XS:
			var l := SpotLight3D.new()
			l.position = Vector3(x, 3.28, z)
			l.rotation_degrees = Vector3(-90.0, 0.0, 0.0)
			l.light_color = Color(1.0, 0.70, 0.36)
			l.light_energy = 5.40
			l.spot_range = 7.0
			l.spot_angle = 72.0
			l.spot_angle_attenuation = 1.10
			l.spot_attenuation = 1.35
			l.shadow_enabled = true
			l.shadow_bias = 0.035
			add_child(l)
	# 涓ょ洀涓荤伅甯﹂槾褰憋紝缁欓暱妞呬笌绔嬫煴钀藉奖
	for z in [-1.10, 9.00]:
		var kl := OmniLight3D.new()
		kl.position = Vector3(-3.95, 3.30, z)
		kl.light_color = Color(1.0, 0.72, 0.38)
		kl.light_energy = 3.00
		kl.omni_range = 6.5
		kl.omni_attenuation = 1.70
		kl.shadow_enabled = true
		add_child(kl)
	# 杩滃鐢佃溅鏆栧厜
	var tl := OmniLight3D.new()
	tl.position = Vector3(5.6, 2.4, 1.5)
	tl.light_color = Color(1.0, 0.74, 0.44)
	tl.light_energy = 1.90
	tl.omni_range = 8.0
	tl.omni_attenuation = 1.60
	add_child(tl)

	# 澶ц寖鍥存煍鍜岃ˉ鍏夛細鎶婇洦妫氫笅涓庤溅鍘晶闈㈢殑姝婚粦鎶埌鍙灞傛
	var key_fill := OmniLight3D.new()
	key_fill.position = Vector3(-4.2, 4.6, 1.0)
	key_fill.light_color = Color(0.72, 0.82, 1.0)
	key_fill.light_energy = 0.62
	key_fill.omni_range = 30.0
	key_fill.omni_attenuation = 0.55
	add_child(key_fill)

	# 浣庤搴﹀喎鑹插弽寮瑰厜锛氫笓闂ㄦ姮椤舵搴曢潰銆佺珛鏌卞唴渚т笌杞﹀帰渚ч潰鐨勬榛戯紝妯℃嫙闆湴鍙嶅皠
	var bounce := OmniLight3D.new()
	bounce.position = Vector3(-3.6, 0.55, -2.0)
	bounce.light_color = Color(0.66, 0.78, 1.00)
	bounce.light_energy = 0.40
	bounce.omni_range = 20.0
	bounce.omni_attenuation = 1.10
	add_child(bounce)

	# 绗簩鐩忎綆浣嶅弽寮癸紝鐓ч【杩滃绔欏彴涓庨《妫氬悗娈?	var bounce2 := OmniLight3D.new()
	bounce2.position = Vector3(-4.6, 0.55, 10.5)
	bounce2.light_color = Color(0.70, 0.80, 1.00)
	bounce2.light_energy = 0.34
	bounce2.omni_range = 16.0
	bounce2.omni_attenuation = 1.10
	add_child(bounce2)

	_build_train_undercarriage()
	_build_lamp_shades()
	_settle_backdrop(node)
	_build_3d_snow()
	_build_3d_film()


# 鏀跺彛 GLB 鑷彂鍏夛細Blender 瀵煎嚭鎶?emissiveStrength 鎷夊埌 7.5~20锛岀洿鎺ョ儳绌?ACES 鐧界偣銆?# 杩欓噷缁熶竴鍘嬪埌鍙帶鍖洪棿锛屽苟鎶婅繃鏇濈殑鐏僵/鏈堜寒鏀逛负鏌斿拰鑷彂鍏夛紝淇濅綇 albedo 涓?PBR 涓嶈瑕嗙洊銆?func _tame_glb_materials(root: Node) -> void:
	for m in _all_meshes(root):
		var mesh := m as MeshInstance3D
		if mesh == null or mesh.mesh == null:
			continue
		for si in mesh.mesh.get_surface_count():
			var base := mesh.mesh.surface_get_material(si)
			if base is StandardMaterial3D:
				var mat := (base as StandardMaterial3D).duplicate() as StandardMaterial3D
				var nm := String(mat.resource_name)
				var e := mat.emission_energy_multiplier
				if e > 0.0:
					mat.emission_enabled = true
					mat.emission_energy_multiplier = clampf(e * 0.18, 0.35, 3.0)
				_restore_baked_albedo(mat, nm)
				_tune_emissive(mat, nm)
				_tame_snow_albedo(mat, nm)
				if (nm.contains("Glass") or nm.contains("Window")) and not nm.contains("WindowLit"):
					# 鍗婇€忔槑鐜荤拑鏄?绯婄櫧"涓诲洜锛氬帇浣庝笉閫忔槑搴﹀苟鍘绘帀闀滈潰鍙嶅樊
					mat.albedo_color.a = minf(mat.albedo_color.a, 0.10)
					mat.metallic = 0.0
					mat.metallic_specular = 0.18
					mat.roughness = maxf(mat.roughness, 0.42)
				elif mat.metallic > 0.7:
					# 鍏滃簳锛氫粛鏈夐珮閲戝睘搴﹁〃闈竴寰嬮檷涓嬫潵锛岄伩鍏嶅急鍏変笅姝婚粦
					mat.metallic = 0.30
					mat.metallic_specular = 0.26
					mat.roughness = maxf(mat.roughness, 0.62)
				mesh.set_surface_override_material(si, mat)


# Blender 鐑樼剻鑴氭湰瀵归噾灞炶〃闈㈠仛 DIFFUSE bake锛屽鑷磋创鍥炬暣寮犲叏榛戯紙瀹炴祴 meanL 0~15/255锛夈€?# 杩欓噷鎸夋潗璐ㄥ悕鎶婅鐑ら粦鐨勮〃闈㈣繕鍘熶负姝ｇ‘鍩鸿壊涓?PBR锛屽苟涓㈠純榛戣创鍥撅紱鏈垪鍑虹殑鏉愯川淇濇寔鍘熸牱銆?# 2026-09-13锛欱lender 绔凡鏀圭敤 EMIT 閫氶亾閲嶇儤锛岄噾灞炲熀鑹蹭笉鍐嶆槸鍏ㄩ粦锛堝疄娴?Rails 0鈫?74銆?# LampShades 0鈫?33銆丆olumns 10鈫?3锛夛紝鍥犳涓嬮潰杩欏紶"鍒涘彲璐?鑹茶〃鏁翠綋浣滃簾銆?# 淇濈暀绌鸿〃涓庡嚱鏁颁綋锛屾槸涓轰簡鍚庣画鑻ュ彂鐜颁釜鍒潗璐ㄤ粛鍋忚壊鏃讹紝鍙互鎸夋潗璐ㄥ悕鍗曠偣瑕嗙洊銆?const BAKED_ALBEDO_FIX := {
}


func _restore_baked_albedo(mat: StandardMaterial3D, nm: String) -> void:
	if not BAKED_ALBEDO_FIX.has(nm):
		return
	var v: Array = BAKED_ALBEDO_FIX[nm]
	mat.albedo_texture = null
	mat.albedo_color = v[0] as Color
	mat.metallic = v[1] as float
	mat.metallic_specular = 0.36
	mat.roughness = v[2] as float
	mat.disable_receive_shadows = false


# 鑷彂鍏夐€愪釜鏍″噯锛氳溅绐椼€佺伅缃┿€佹湀浜粰瓒充寒搴︼紝杩滄櫙鐏覆鍘嬪埌鍑犱箮涓嶅彲瑙併€?const EMISSIVE_TUNE := {
	"TrainWindowLit": [2.60, Color(1.00, 0.62, 0.28)],
	"LampGlow": [2.20, Color(1.00, 0.72, 0.40)],
	"HeadlightGlow": [3.00, Color(1.00, 0.95, 0.86)],
	"MoonGlow": [1.30, Color(0.86, 0.90, 1.00)],
	"TownLights": [0.22, Color(1.00, 0.64, 0.30)],
	"SnowLit": [0.12, Color(0.58, 0.70, 0.98)],
}


# 闆湴璐村浘鏈韩鎺ヨ繎绾櫧锛屽湪 ACES 涓嬩細鎶婁笅鍗婂睆鐑ф垚鐧芥樇銆傝繖閲屾寜鏉愯川鍚嶅帇鍙嶇収鐜囥€?const SNOW_ALBEDO_TUNE := {
	"SnowGround": Color(0.34, 0.40, 0.55),
	"SnowHard": Color(0.38, 0.44, 0.58),
	"SnowSoft": Color(0.40, 0.46, 0.60),
	"SnowLit": Color(0.30, 0.36, 0.52),
	"Ballast": Color(0.52, 0.54, 0.58),
	# 瀹夊叏绾垮師鑹叉槸绾粍锛屽湪鏂版満浣嶄笅浼氭姠璧拌绾夸腑蹇冿紝鍘嬫垚鏃ф紗鐨勭伆榛勩€?	"PaintYellow": Color(0.60, 0.55, 0.40),
	# 杩滄櫙锛氭爲绾垮帇鎴愬壀褰憋紝闆北鍘绘帀"浜摑鍦嗛敟"鐨勫鏂欐劅銆?	"Conifer": Color(0.30, 0.34, 0.40),
	"Mountain": Color(0.20, 0.24, 0.36),
	"MountainSnow": Color(0.22, 0.27, 0.40),
	"TowerRoof": Color(0.52, 0.56, 0.64),
	"TownLights": Color(0.05, 0.05, 0.05),
}


# 闆潰璐ㄦ劅锛氱函骞?albedo 鍦?ACES 涓嬩細鍍忛摵浜嗕竴寮犳甯冦€傝繖閲岀粰鎵€鏈夐洩/閬撶牊琛ㄩ潰
# 绋嬪簭鐢熸垚涓€灞傜粏瀵嗗櫔澹版硶绾?+ 绮楃硻搴︽壈鍔紝璁╂帬灏勭殑绔欏彴鐏笌鏈堝厜鑳藉湪闆潰鎷夊嚭棰楃矑涓庤捣浼忋€?const SNOW_BUMP_TUNE := {
	"SnowGround": [2.4, 0.62, 1.30],
	"SnowHard": [2.0, 0.55, 1.15],
	"SnowSoft": [1.8, 0.50, 1.05],
	"SnowLit": [1.4, 0.44, 0.90],
	"Ballast": [3.2, 0.72, 2.60],
}


func _snow_noise_tex(freq: float, seed_val: int, bump: float, as_normal: bool) -> NoiseTexture2D:
	var n := FastNoiseLite.new()
	n.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	n.seed = seed_val
	n.frequency = freq
	n.fractal_type = FastNoiseLite.FRACTAL_FBM
	n.fractal_octaves = 5
	n.fractal_lacunarity = 2.1
	n.fractal_gain = 0.48
	var nt := NoiseTexture2D.new()
	nt.noise = n
	nt.width = 512
	nt.height = 512
	nt.seamless = true
	nt.normalize = true
	nt.as_normal_map = as_normal
	nt.bump_strength = bump
	return nt


func _tame_snow_albedo(mat: StandardMaterial3D, nm: String) -> void:
	if not SNOW_ALBEDO_TUNE.has(nm):
		return
	var t := SNOW_ALBEDO_TUNE[nm] as Color
	mat.albedo_color = Color(
		mat.albedo_color.r * t.r, mat.albedo_color.g * t.g,
		mat.albedo_color.b * t.b, mat.albedo_color.a)
	mat.roughness = maxf(mat.roughness, 0.72)
	if SNOW_BUMP_TUNE.has(nm):
		var b: Array = SNOW_BUMP_TUNE[nm]
		mat.normal_enabled = true
		mat.normal_scale = b[1] as float
		mat.normal_texture = _snow_noise_tex(0.011, 7717, b[0] as float, true)
		mat.roughness_texture = _snow_noise_tex(0.030, 3319, 0.6, false)
		mat.roughness_texture_channel = BaseMaterial3D.TEXTURE_CHANNEL_RED
		mat.uv1_scale = Vector3(b[2] as float, b[2] as float, 1.0)


func _tune_emissive(mat: StandardMaterial3D, nm: String) -> void:
	if not EMISSIVE_TUNE.has(nm):
		return
	var v: Array = EMISSIVE_TUNE[nm]
	mat.emission_enabled = true
	mat.emission = v[1] as Color
	mat.emission_energy_multiplier = v[0] as float

# 绔欑墝鍐呭锛欸LB 閲岀殑 SignFace 鏄竴鍧楃函鐧芥澘锛岃瘎瀹¤浣?鏈畬鎴?銆?# 杩欓噷鍦ㄧ墝闈㈡鍓嶆柟璐翠竴鍧?Label3D锛屽唴瀹逛负绔欏悕涓庢湯鐝彁绀恒€?func _dress_station_sign() -> void:
	var lab := Label3D.new()
	lab.name = "SignText"
	lab.text = "涓€鏈熶竴浼歕n缁? 鐢?
	lab.font = font_body
	lab.font_size = 100
	lab.pixel_size = 0.0026
	lab.modulate = Color(0.16, 0.15, 0.16, 1.0)
	lab.outline_size = 0
	lab.outline_modulate = Color(0.94, 0.94, 0.96, 0.0)
	lab.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lab.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	lab.alpha_cut = Label3D.ALPHA_CUT_OPAQUE_PREPASS
	lab.no_depth_test = false
	lab.render_priority = 1
	# 鐗岄潰鏈濆悜 -Z锛堢浉鏈轰晶锛夛紝鏁呯粫 Y 杞磋浆 180 搴?	lab.rotation_degrees = Vector3(0.0, 180.0, 0.0)
	lab.position = Vector3(-6.55, 2.22, 2.828)
	add_child(lab)
	print("[涓€鏈熶竴浼歖 绔欑墝鏂囧瓧宸茶创鍏?)


# 鍗犱綅璧勪骇娓呯悊锛氳瘎瀹″弽澶嶇偣鍚?榛戣壊灏栨潌涓?鏉嗛《鍙犵悆"涓烘湭瀹屾垚鍝佺‖閿欒
const PLACEHOLDER_NODES := ["BareBranches", "BushSnow", "Icicles", "FallingSnow", "TramSnowMist", "LampGlassShells", "TownLights"]


func _strip_placeholders(root: Node) -> void:
	for n in root.get_children():
		if String(n.name) in PLACEHOLDER_NODES:
			n.visible = false
			print("[涓€鏈熶竴浼歖 宸查殣钘忓崰浣嶈祫浜? " + String(n.name))
		_strip_placeholders(n)


func _all_meshes(root: Node) -> Array:
	var acc: Array = []
	for c in root.get_children():
		if c is MeshInstance3D:
			acc.append(c)
		acc.append_array(_all_meshes(c))
	return acc


func _make_env() -> Environment:
	var e := Environment.new()
	e.background_mode = Environment.BG_COLOR
	e.background_color = Color(0.028, 0.042, 0.075)
	e.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	e.ambient_light_color = Color(0.24, 0.31, 0.46)
	e.ambient_light_energy = 0.40
	e.tonemap_mode = Environment.TONE_MAPPER_ACES
	e.tonemap_white = 2.4
	e.glow_enabled = true
	e.glow_intensity = 0.52
	e.glow_bloom = 0.22
	e.glow_strength = 1.05
	e.glow_hdr_threshold = 0.92
	e.glow_blend_mode = Environment.GLOW_BLEND_MODE_SCREEN
	e.fog_enabled = true
	e.fog_light_color = Color(0.20, 0.28, 0.42)
	e.fog_light_energy = 0.38
# 楂樺害闆惧繀椤绘樉寮忔寚瀹?depth 妯″紡鎵嶄細鐢熸晥锛堟湰鏋勫缓鏃?EXPONENTIAL_SQUARED锛?	e.fog_mode = Environment.FOG_MODE_DEPTH
	e.fog_density = 0.020
	e.fog_depth_begin = 12.0
	e.fog_depth_end = 190.0
	e.fog_depth_curve = 1.15
	e.fog_height = 6.5
	e.fog_height_density = 0.055
	e.fog_aerial_perspective = 0.35
	e.fog_sky_affect = 0.35
	e.ssao_enabled = true
	e.ssao_radius = 1.6
	e.ssao_intensity = 0.95
	e.ssil_enabled = true
	e.adjustment_enabled = true
	e.adjustment_contrast = 1.02
	e.adjustment_saturation = 1.06
	e.adjustment_brightness = 1.00
	return e


# 3D 璺緞涓撶敤鐢靛奖鎰熷彔灞傦細stage_root 鍦?3D 妯″紡涓嬫暣浣撻殣钘忥紝2D 閭ｅ鏆楄/鏆栧厜/棰楃矑
# 浼氫竴璧峰け鏁堬紝瀵艰嚧 3D 鐢婚潰娌℃湁鏅繁鏀跺彛銆傝繖閲屽崟鐙寕涓€灞?CanvasLayer锛堝眰鍙蜂綆浜?HUD锛夛紝
# 鍙綔鐢ㄤ簬 3D 鐢婚潰锛岃鏆楄銆佸簳閮ㄥ帇鏆椼€佹殩鍏夋檿涓庤兌鐗囬绮掗噸鏂板洖鍒扮敾闈笂銆?func _build_3d_film() -> void:
	film_layer = CanvasLayer.new()
	film_layer.name = "FilmLayer"
	film_layer.layer = 1
	add_child(film_layer)
	var film := Control.new()
	film.mouse_filter = Control.MOUSE_FILTER_IGNORE
	film_layer.add_child(film)
	film.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	# 搴曢儴鍘嬫殫锛氱粰搴忕珷瀵硅瘽妗嗕笌绁ㄦ牴鍨嚭鍙鐨勬殫搴?	var shade := TextureRect.new()
	shade.texture = _shade_tex(0.42)
	shade.stretch_mode = TextureRect.STRETCH_SCALE
	shade.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	film.add_child(shade)
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	# 绔欏彴鏆栧厜鏅曪細鍔犳硶娣峰悎锛岃惤鍦ㄧ敾闈㈠彸渚х珯鍙颁笌鍊欒溅浜竴甯?	var glow := TextureRect.new()
	glow.texture = _radial_tex(Color(1.0, 0.74, 0.42, 0.34), Color(1.0, 0.72, 0.38, 0.0))
	glow.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var add_mat := CanvasItemMaterial.new()
	add_mat.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
	glow.material = add_mat
	glow.position = Vector2(560.0, 60.0)
	glow.size = Vector2(1080.0, 760.0)
	film.add_child(glow)

	# 鏆楄锛氭妸瑙嗙嚎鏀惰繘鐢婚潰涓績锛屽帇鎺夊洓瑙?	var vig := TextureRect.new()
	vig.texture = _vignette_tex(0.40)
	vig.stretch_mode = TextureRect.STRETCH_SCALE
	vig.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	vig.mouse_filter = Control.MOUSE_FILTER_IGNORE
	film.add_child(vig)
	vig.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	# 鑳剁墖棰楃矑锛氬拰 2D 鍚屼竴濂楃潃鑹插櫒锛屽箙搴︾暐闄嶏紝閬垮厤鍦ㄦ殫鍦洪噷鍣偣杩囬噸
	film_grain_mat = ShaderMaterial.new()
	var sh := Shader.new()
	sh.code = GRAIN_SHADER
	film_grain_mat.shader = sh
	film_grain_mat.set_shader_parameter("amount", 0.022)
	var gr := ColorRect.new()
	gr.color = Color(1, 1, 1, 1)
	gr.material = film_grain_mat
	gr.mouse_filter = Control.MOUSE_FILTER_IGNORE
	film.add_child(gr)
	gr.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	print("[涓€鏈熶竴浼歖 3D 鐢靛奖鎰熷彔灞傚凡鎸傝浇")


func _find_glb_node(root: Node, nm: String) -> Node3D:
	for c in root.get_children():
		if String(c.name) == nm:
			return c as Node3D
		var r := _find_glb_node(c, nm)
		if r != null:
			return r
	return null


# 鍒楄溅钀藉湴锛欸LB 閲岃溅浣撶杞ㄩ潰 0.5m 涓旀病鏈夎浆鍚戞灦涓庤溅杞紝璇勫鍒ゅ畾"鎮┖"銆?# 杩欓噷琛ヤ袱鍓殫鑹茶浆鍚戞灦 + 鍏釜璐磋建杞﹁疆锛岃杞︿綋涓庨挗杞ㄧ湡姝ｆ帴涓娿€?func _build_train_undercarriage() -> void:
	var frame_mat := StandardMaterial3D.new()
	frame_mat.albedo_color = Color(0.055, 0.060, 0.075)
	frame_mat.metallic = 0.45
	frame_mat.roughness = 0.68
	var wheel_mat := StandardMaterial3D.new()
	wheel_mat.albedo_color = Color(0.085, 0.090, 0.105)
	wheel_mat.metallic = 0.62
	wheel_mat.roughness = 0.48
	var axle_mat := StandardMaterial3D.new()
	axle_mat.albedo_color = Color(0.13, 0.14, 0.16)
	axle_mat.metallic = 0.70
	axle_mat.roughness = 0.40

	var under := Node3D.new()
	under.name = "TrainUndercarriage"
	add_child(under)

	for bz in [-8.80, 4.30]:
		var frame := MeshInstance3D.new()
		var bm := BoxMesh.new()
		bm.size = Vector3(1.34, 0.40, 2.40)
		frame.mesh = bm
		frame.position = Vector3(5.60, 0.80, bz)
		frame.set_surface_override_material(0, frame_mat)
		under.add_child(frame)

		for wz in [bz - 0.82, bz + 0.82]:
			var wheel := MeshInstance3D.new()
			var cm := CylinderMesh.new()
			cm.top_radius = 0.37
			cm.bottom_radius = 0.37
			cm.height = 1.10
			cm.radial_segments = 20
			wheel.mesh = cm
			wheel.rotation_degrees = Vector3(0.0, 0.0, 90.0)
			wheel.position = Vector3(5.60, 0.512, wz)
			wheel.set_surface_override_material(0, wheel_mat)
			under.add_child(wheel)

			var rim := MeshInstance3D.new()
			var rm := TorusMesh.new()
			rm.inner_radius = 0.30
			rm.outer_radius = 0.375
			rm.rings = 12
			rm.ring_segments = 18
			rim.mesh = rm
			rim.rotation_degrees = Vector3(0.0, 0.0, 90.0)
			rim.position = Vector3(5.60, 0.512, wz)
			rim.set_surface_override_material(0, axle_mat)
			under.add_child(rim)

	# 杞﹀簳闃村奖鏉匡細缁欓洩鍦板帇鍑轰竴閬撴帴瑙︽殫閮紝娑堥櫎"鏁村垪杞﹂鍦ㄧ┖涓?
	var occl := MeshInstance3D.new()
	var om := BoxMesh.new()
	om.size = Vector3(2.60, 0.02, 16.60)
	occl.mesh = om
	occl.position = Vector3(5.60, 0.335, -2.14)
	var omat := StandardMaterial3D.new()
	omat.albedo_color = Color(0.02, 0.025, 0.035)
	omat.roughness = 1.0
	omat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	omat.albedo_color.a = 0.72
	occl.set_surface_override_material(0, omat)
	under.add_child(occl)

	print("[涓€鏈熶竴浼歖 鍒楄溅杞悜鏋朵笌杞﹁疆宸茶ˉ榻?)


# 鍚婄伅鐏僵锛欸LB 鐨?LampShades 鍚?525 涓€€鍖栭《鐐瑰爢鍦ㄥ師鐐癸紝浼氬湪鐢婚潰涓ぎ鐣欎笅纰庡睉銆?# 闅愯棌鍘熺綉鏍硷紝鎸?12 涓伅浣嶉噸寤哄共鍑€鐨勯敟褰㈢伅缃?+ 鏆栬壊鐏姱銆?func _build_lamp_shades() -> void:
	var old := _find_glb_node(self, "LampShades")
	if old != null:
		old.visible = false
		print("[涓€鏈熶竴浼歖 宸查殣钘忛€€鍖栫伅缃╃綉鏍?)

	var shade_mat := StandardMaterial3D.new()
	shade_mat.albedo_color = Color(0.075, 0.085, 0.080)
	shade_mat.metallic = 0.55
	shade_mat.roughness = 0.55
	var bulb_mat := StandardMaterial3D.new()
	bulb_mat.albedo_color = Color(1.0, 0.80, 0.50)
	bulb_mat.emission_enabled = true
	bulb_mat.emission = Color(1.0, 0.72, 0.40)
	bulb_mat.emission_energy_multiplier = 2.40

	var rig := Node3D.new()
	rig.name = "LampRig"
	add_child(rig)

	for z in LAMP_ZS:
		for x in LAMP_XS:
			var shade := MeshInstance3D.new()
			var cm := CylinderMesh.new()
			cm.top_radius = 0.055
			cm.bottom_radius = 0.30
			cm.height = 0.26
			cm.radial_segments = 18
			shade.mesh = cm
			shade.position = Vector3(x, 3.56, z)
			shade.set_surface_override_material(0, shade_mat)
			rig.add_child(shade)

			var bulb := MeshInstance3D.new()
			var sm := SphereMesh.new()
			sm.radius = 0.085
			sm.height = 0.17
			sm.radial_segments = 14
			sm.rings = 7
			bulb.mesh = sm
			bulb.position = Vector3(x, 3.38, z)
			bulb.set_surface_override_material(0, bulb_mat)
			rig.add_child(bulb)


# 杩滄櫙鏀跺彛锛氭爲绾挎帹杩滃帇鐭€侀洩宄伴敟浣撶Щ闄ゃ€侀挗杞ㄥ悜鐢诲寤堕暱锛岃В鍐宠瘎瀹＄偣鍚嶇殑
# "妫氶《闀挎爲 / 浜摑鍦嗛敟 / 閾佽建鏂ご" 涓変釜纭敊璇€?func _settle_backdrop(root: Node) -> void:
	var caps := _find_glb_node(root, "MountainSnowcaps")
	if caps != null:
		caps.visible = false
		print("[涓€鏈熶竴浼歖 宸茬Щ闄ょ┛鍑洪《妫氱殑闆嘲閿ヤ綋")

	var conifer := _find_glb_node(root, "ConiferBelt")
	if conifer != null:
		conifer.scale = Vector3(0.94, 0.62, 0.94)
		conifer.position = Vector3(0.0, 0.0, 26.0)
		print("[涓€鏈熶竴浼歖 杩滄櫙鏉炬灄宸叉帹杩滃帇鐭?)

	for nm in ["Rails", "RailFasteners", "Sleepers", "BallastBed", "SnowBetweenRails"]:
		var nd := _find_glb_node(root, nm)
		if nd != null:
			nd.scale = Vector3(1.0, 1.0, 1.62)
	print("[涓€鏈熶竴浼歖 閽㈣建涓庨亾搴婂凡鍚戠敾澶栧欢闀?)


func _build_3d_snow() -> void:
	var far := _make_snow3d(1500, Vector3(26.0, 16.0, 34.0), 0.105)
	far.name = "Snowfall"
	far.position = Vector3(-3.0, 7.5, 2.0)
	add_child(far)
	var near := _make_snow3d(520, Vector3(14.0, 6.0, 16.0), 0.05)
	near.name = "SnowNear"
	near.position = Vector3(-3.0, 3.2, 2.0)
	add_child(near)


# 鍦嗗舰杞竟闆姳 sprite锛氭秷闄よ瘎瀹″弽澶嶇偣鍚嶇殑"纭竟鏂瑰舰鐧界墖"
func _snow_flake_tex() -> GradientTexture2D:
	var g := Gradient.new()
	g.set_color(0, Color(1, 1, 1, 1.0))
	g.set_color(1, Color(1, 1, 1, 0.0))
	g.add_point(0.42, Color(1, 1, 1, 0.92))
	g.add_point(0.70, Color(1, 1, 1, 0.30))
	var t := GradientTexture2D.new()
	t.gradient = g
	t.width = 64
	t.height = 64
	t.fill = GradientTexture2D.FILL_RADIAL
	t.fill_from = Vector2(0.5, 0.5)
	t.fill_to = Vector2(0.5, 0.02)
	return t


func _make_snow3d(amount: int, ext: Vector3, flake: float) -> GPUParticles3D:
	var p := GPUParticles3D.new()
	p.amount = amount
	p.lifetime = 14.0
	p.preprocess = 12.0
	p.fixed_fps = 30
	p.visibility_aabb = AABB(Vector3(-ext.x, -ext.y, -ext.z), ext * 2.0)
	var draw := QuadMesh.new()
	draw.size = Vector2(flake * 2.0, flake * 2.0)
	var dm := StandardMaterial3D.new()
	dm.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	dm.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	dm.billboard_mode = BaseMaterial3D.BILLBOARD_ENABLED
	dm.albedo_color = Color(1, 1, 1, 1.0)
	dm.albedo_texture = _snow_flake_tex()
	dm.disable_receive_shadows = true
	dm.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA_DEPTH_PRE_PASS
	draw.material = dm
	p.draw_pass_1 = draw
	var m := ParticleProcessMaterial.new()
	m.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_BOX
	m.emission_box_extents = ext
	m.direction = Vector3(0.16, -1.0, 0.05)
	m.spread = 12.0
	m.initial_velocity_min = 0.5
	m.initial_velocity_max = 1.3
	m.gravity = Vector3(0.9, -1.1, 0.0)
	m.damping_min = 0.15
	m.damping_max = 0.5
	p.process_material = m
	return p


func _show_load_error() -> void:
	var layer := CanvasLayer.new()
	layer.layer = 9
	add_child(layer)
	var cl := ColorRect.new()
	cl.color = Color(0.02, 0.03, 0.05, 1.0)
	layer.add_child(cl)
	cl.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var l := _mk_label("3D 璧勪骇鏈兘鍔犺浇銆傝鍘绘帀 --3d 鍙傛暟锛屼娇鐢ㄧ編鏈簳鍥捐矾绾裤€?, 20, Color(0.95, 0.7, 0.6))
	l.position = Vector2(80, 80)
	layer.add_child(l)

# ============================================================
# 鑷姩鏀炬槧锛?-movie锛夛細閰嶅悎 Godot 鐨?--write-movie 杈撳嚭鍙挱鏀捐棰?# ============================================================
func _movie_flow() -> void:
	var fade := ColorRect.new()
	fade.color = Color(0.008, 0.012, 0.022, 1.0)
	fade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var fl := CanvasLayer.new()
	fl.layer = 20
	add_child(fl)
	fl.add_child(fade)
	fade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var tw := create_tween()
	tw.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tw.tween_property(fade, "color", Color(0.008, 0.012, 0.022, 0.0), 1.6)
	await get_tree().create_timer(3.6).timeout

	# 鐜╁鍦ㄨ緭鍏ユ閲屽啓涓嬭嚜宸辩殑閬楁喚
	var txt := "娌¤兘璇村嚭鍙ｇ殑閭ｅ彞璇?
	input_edit.grab_focus()
	for i in txt.length():
		input_edit.text = txt.substr(0, i + 1)
		input_edit.caret_column = input_edit.text.length()
		_set_hint("鈥︹€﹀氨浠庤繖閲屽紑濮嬨€傚墿涓嬬殑瀛楋紝浣犺嚜宸卞啓銆?)
		_distance_to(0.50)
		await get_tree().create_timer(0.075).timeout
	await get_tree().create_timer(1.4).timeout
	_on_action()
	await get_tree().create_timer(8.0).timeout

	# 涓夋寮忥細鍥涙媿锛屾瘡鎷嶇敤涓€娆″惈钃勭殑蹇嵎閫夋嫨鎺ㄨ繘
	for k in CH1_BEATS.size():
		await get_tree().create_timer(5.2).timeout
		if k == 0:
			_on_quick("鐪嬩竴鐪煎墠鏂圭殑閾佽建")
		elif k == 1:
			_on_quick("鍛婅瘔鑷繁锛氭槸鎴戝厛绉诲紑浜嗚绾?)
		elif k == 2:
			_on_quick("璧颁笂杞︼紝鎵句釜闈犵獥鐨勪綅缃?)
		else:
			_on_quick("鎶婅瘽鐣欏湪闆噷")
	await get_tree().create_timer(9.0).timeout

	var tw2 := create_tween()
	tw2.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tw2.tween_property(fade, "color", Color(0.008, 0.012, 0.022, 1.0), 3.0)
	await get_tree().create_timer(3.4).timeout
	print("[涓€鏈熶竴浼歖 鑷姩鏀炬槧缁撴潫")
	get_tree().quit()

# ============================================================
# 瀹氭満浣嶆埅鍥撅紙--capture <鐩綍>锛?# ============================================================
func _load_capture_inputs() -> void:
	capture_inputs.clear()
	_capture_idx = 1
	if capture_inputs_path == "":
		return
	if not FileAccess.file_exists(capture_inputs_path):
		push_warning("[涓€鏈熶竴浼歖 杈撳叆鑴氭湰涓嶅瓨鍦? " + capture_inputs_path)
		return
	var f := FileAccess.open(capture_inputs_path, FileAccess.READ)
	if f == null:
		push_warning("[涓€鏈熶竴浼歖 杈撳叆鑴氭湰鎵撲笉寮€: " + capture_inputs_path)
		return
	while not f.eof_reached():
		var l := f.get_line().strip_edges()
		if l != "":
			capture_inputs.append(l)
	f.close()
	print("[涓€鏈熶竴浼歖 宸茶浇鍏ヨ緭鍏ヨ剼鏈?" + str(capture_inputs.size()) + " 琛?)


func _capture_advance() -> void:
	if capture_inputs.size() > _capture_idx:
		input_edit.text = capture_inputs[_capture_idx]
		_capture_idx += 1
		_on_action()
	else:
		_on_quick("")


## 鏀舵潫鎷嶏細蹇呴』鐪熺殑閫掍竴鍙ヨ瘽杩涘幓銆?## 鍚﹀垯 _closing_beat() 浼氬洜涓虹┖杈撳叆鐩存帴鎹㈠箷锛屾姄鍒扮殑"鏀舵潫甯?鍏跺疄鏄笅涓€骞曠殑棣栧抚銆?func _capture_closing() -> void:
	var line := ""
	if state == "chapter1":
		line = "鎴戝叾瀹炴棭灏辨兂鎶婇偅鍙ヨ瘽璇村嚭鏉?
	elif state == "chapter2":
		line = "鎴戜笉鍚庢倲鎴戦€夌殑閭ｆ潯璺?
	elif state == "chapter3":
		line = "鎴戜竴鐩撮兘璁板緱濂?
	if line == "":
		_capture_advance()
		return
	input_edit.text = line
	_on_action()


## 绛夋墦瀛楁満鎶婂綋鍓嶈繖涓€鎷嶇湡姝ｆ墦瀹岋紙_say 缃?true锛宊process 鎵撳畬缃?false锛夈€?func _wait_typing_done(max_sec: float) -> bool:
	var waited := 0.0
	while typing and waited < max_sec:
		await get_tree().process_frame
		waited += get_process_delta_time()
	if typing:
		print("[鎴浘] 瓒呮椂绛夊緟鎵撳瓧瀹屾垚 waited=" + str(waited))
		return false
	return true


func _capture_flow() -> void:
	if not DirAccess.dir_exists_absolute(capture_dir):
		DirAccess.make_dir_recursive_absolute(capture_dir)
	# 鐪嬮棬鐙楋細浠讳綍涓€姝ュ崱浣忛兘瑕佺暀涓嬭瘉鎹苟閫€鍑猴紝缁濅笉鏃犲０鎸傛銆?	_watchdog(300.0)
	await _wait_frames(50)
	await _wait_until_idle(6.0, "prologue")
	await _wait_sec(3.4)
	print("[甯冨眬] panel pos=" + str(panel.position) + " size=" + str(panel.size) + " min=" + str(panel.get_combined_minimum_size()))
	await _grab(capture_dir.path_join("01_prologue.png"))
	if quick_shot:
		print("[涓€鏈熶竴浼歖 蹇€熷崟甯у畬鎴?-> " + capture_dir)
		_capture_done = true
		get_tree().quit()
		return

	# ---- 搴忕珷锛氬啓涓嬮仐鎲?----
	input_edit.text = "娌¤兘璇村嚭鍙ｇ殑閭ｅ彞璇?
	if capture_inputs.size() > 0:
		input_edit.text = capture_inputs[0]
	_on_action()
	# 绛夎溅绁ㄩ樁娈电湡鐨勫紑濮嬶紙AI 澧炲己鍙兘鍏堣姳鎺変竴鐐规椂闂达級锛屽啀鎸夐樁娈靛唴閮ㄨ妭濂忓彇甯с€?	await _wait_for_state("ticket", 25.0)
	await _wait_sec(1.5)
	await _grab(capture_dir.path_join("01b_readback.png"))
	await _wait_sec(2.7)
	await _grab(capture_dir.path_join("02_ticket.png"))

	# ---- 绗竴骞?----
	await _wait_until_idle(30.0, "ch1_beat1")
	await _wait_sec(2.6)  # 绛夊簳鍥句氦鍙夋贰鍖栬蛋瀹?	await _grab(capture_dir.path_join("03_ch1_beat1.png"))
	for i in 3:
		_capture_advance()
		await _wait_until_idle(30.0, "ch1_beat%d" % (i + 2))
		await _grab(capture_dir.path_join("03_ch1_beat%d.png" % (i + 2)))
	_capture_closing()
	await _wait_typing_done(12.0)
	await _wait_sec(0.5)
	await _grab(capture_dir.path_join("03_ch1_closing.png"))
	# 鎹㈠箷鐢?3.6 绉掑畾鏃跺櫒瑙﹀彂锛涜繖閲屼笉鍐嶇寽绉掓暟锛岀瓑涓嬩竴骞曠涓€鎷嶇湡姝ｆ覆鏌撳畬鎴愩€?	await _wait_until_idle(30.0, "ch2_beat1")
	await _wait_sec(2.6)
	await _grab(capture_dir.path_join("04_ch2_beat1.png"))

	# ---- 绗簩骞?----
	for i in 3:
		_capture_advance()
		await _wait_until_idle(30.0, "ch2_beat%d" % (i + 2))
		await _grab(capture_dir.path_join("04_ch2_beat%d.png" % (i + 2)))
	_capture_closing()
	await _wait_typing_done(12.0)
	await _wait_sec(0.5)
	await _grab(capture_dir.path_join("04_ch2_closing.png"))
	await _wait_until_idle(30.0, "ch3_beat1")
	await _wait_sec(2.6)
	await _grab(capture_dir.path_join("05_ch3_beat1.png"))

	# ---- 绗笁骞?----
	for i in 3:
		_capture_advance()
		await _wait_until_idle(30.0, "ch3_beat%d" % (i + 2))
		await _grab(capture_dir.path_join("05_ch3_beat%d.png" % (i + 2)))
	_capture_closing()
	await _wait_typing_done(12.0)
	await _wait_sec(0.5)
	await _grab(capture_dir.path_join("05_ch3_closing.png"))

	# ---- 缁堢珷锛氶噴鎬€鍗?-> 浜洪棿闀滈壌 -> 灏剧珷 ----
	await _wait_for_state("card", 25.0)
	await _wait_sec(1.6)
	await _grab(capture_dir.path_join("06_finale.png"))
	await _wait_for_mirror(20.0)
	await _wait_sec(0.6)
	await _grab(capture_dir.path_join("06b_mirror.png"))
	await _wait_until_idle(30.0, "epilogue")
	await _wait_sec(0.4)
	await _grab(capture_dir.path_join("07_epilogue.png"))

	print("[涓€鏈熶竴浼歖 鎴浘瀹屾垚 -> " + capture_dir)
	_capture_done = true
	await _wait_frames(3)
	get_tree().quit()


# ---- 鎴浘鍥炲綊涓撶敤绛夊緟鍘熻锛氫竴寰嬪甫瓒呮椂锛屽崱浣忓繀椤荤暀涓嬭瘉鎹?----
func _wait_sec(sec: float) -> void:
	await get_tree().create_timer(sec).timeout


func _wait_until_idle(max_sec: float, tag: String) -> bool:
	var waited := 0.0
	while busy and waited < max_sec:
		await get_tree().process_frame
		waited += get_process_delta_time()
	if busy:
		print("[鎴浘] 瓒呮椂绛夊緟绌洪棽 tag=" + tag + " state=" + state + " beat=" + str(beat) + " waited=" + str(waited))
		return false
	return true


func _wait_for_state(want: String, max_sec: float) -> bool:
	var waited := 0.0
	while state != want and waited < max_sec:
		await get_tree().process_frame
		waited += get_process_delta_time()
	if state != want:
		print("[鎴浘] 瓒呮椂绛夊緟鐘舵€?want=" + want + " 瀹為檯=" + state + " busy=" + str(busy))
		return false
	return true


func _wait_for_mirror(max_sec: float) -> bool:
	var waited := 0.0
	while waited < max_sec:
		if mirror_layer != null and mirror_layer.visible and mirror_layer.modulate.a > 0.85:
			return true
		await get_tree().process_frame
		waited += get_process_delta_time()
	print("[鎴浘] 瓒呮椂绛夊緟闀滈壌闈㈡澘 鍙=" + str(mirror_layer != null and mirror_layer.visible))
	return false


func _watchdog(max_sec: float) -> void:
	await get_tree().create_timer(max_sec).timeout
	if _capture_done:
		return
	print("[鎴浘] 鐪嬮棬鐙楄Е鍙戯細state=" + state + " beat=" + str(beat) + " busy=" + str(busy) + " dir=" + capture_dir)
	push_error("[鎴浘] 娴佺▼瓒呮椂鏈畬鎴?)
	get_tree().quit(1)


func _race_frame_post_draw(max_sec: float) -> bool:
	# 涓庤秴鏃惰禌璺戯細璋佸厛鍒板氨鐢ㄨ皝锛涜秴鏃跺垯璺宠繃鏈抚浣嗕笉闃绘柇娴佺▼锛岄伩鍏嶆暣鏉″崗绋嬫案涔呮寕姝汇€?	var done := [false]
	_frame_post_draw_probe(done)
	var waited := 0.0
	while not done[0] and waited < max_sec:
		await get_tree().process_frame
		waited += get_process_delta_time()
	if not done[0]:
		print("[鎴浘] 娓叉煋甯х瓑寰呰秴鏃讹紙绐楀彛鍙兘琚伄鎸℃垨澶辩劍锛夛紝璺宠繃鏈抚 waited=" + str(waited))
		return false
	return true


func _frame_post_draw_probe(done: Array) -> void:
	await RenderingServer.frame_post_draw
	done[0] = true


func _wait_frames(n: int) -> void:
	for i in n:
		await get_tree().process_frame


func _grab(path: String) -> void:
	var cam := get_node_or_null("Camera3D") as Camera3D
	if typing:
		line_label.text = _typed
		typing = false
	# frame_post_draw 鍦ㄧ獥鍙ｈ閬尅/鏈€灏忓寲鏃朵笉浼氬彂灏勶紝蹇呴』涓庤秴鏃剁珵閫燂紝鍚﹀垯鏁存潯鍗忕▼姘镐箙鎸傛銆?	await _race_frame_post_draw(3.0)
	var img := get_viewport().get_texture().get_image()
	var err := img.save_png(path)
	if err != OK:
		push_error("[涓€鏈熶竴浼歖 鎴浘澶辫触: " + path + " err=" + str(err))
	else:
		print("[涓€鏈熶竴浼歖 宸蹭繚瀛?" + path)
		if panel != null and panel.visible:
			print("[甯冨眬] panel=" + str(panel.size) + " line=" + str(line_label.size) + " 鍐呭楂?" + str(line_label.get_content_height()) + " 鏂囧瓧=" + line_label.text.replace("\n", " / ").substr(0, 150))

