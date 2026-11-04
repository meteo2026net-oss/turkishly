package com.sarahocam.app

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.AutoAwesome
import androidx.compose.material.icons.filled.MenuBook
import androidx.compose.material.icons.filled.Search
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.LocalLayoutDirection
import androidx.compose.ui.unit.LayoutDirection
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.text.style.TextDirection
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import org.json.JSONArray
import org.json.JSONObject

private val Cream = Color(0xFFFFFAF3)
private val Teal = Color(0xFF0F9D9A)
private val Navy = Color(0xFF164E63)
private val Sky = Color(0xFF38BDF8)
private val Gold = Color(0xFFF4C66A)
private val Ink = Color(0xFF18343B)
private val Muted = Color(0xFF71858A)
private val Pale = Color(0xFFE2F5F2)

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        window.statusBarColor = android.graphics.Color.rgb(255, 250, 243)
        window.navigationBarColor = android.graphics.Color.rgb(255, 250, 243)
        window.decorView.systemUiVisibility =
            android.view.View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR or
            android.view.View.SYSTEM_UI_FLAG_LIGHT_NAVIGATION_BAR
        setContent { SaraHocamApp() }
    }
}

private data class UnitItem(
    val id: String,
    val level: String,
    val titleAr: String,
    val titleTr: String,
    val description: String,
    val lessons: List<LessonItem>
)

private data class LessonItem(
    val id: String,
    val order: Int,
    val title: String,
    val status: String
)

@Composable
private fun SaraHocamApp() {
    val context = LocalContext.current
    var units by remember { mutableStateOf<List<UnitItem>>(emptyList()) }
    var loading by remember { mutableStateOf(true) }
    var error by remember { mutableStateOf<String?>(null) }
    var selectedUnit by remember { mutableStateOf<UnitItem?>(null) }
    var selectedLesson by remember { mutableStateOf<JSONObject?>(null) }
    var showVocabulary by remember { mutableStateOf(false) }
    var search by remember { mutableStateOf("") }
    var selectedLevel by remember { mutableStateOf("الكل") }
    var completedIds by remember {
        mutableStateOf(
            context.getSharedPreferences("sara_hocam_progress", android.content.Context.MODE_PRIVATE)
                .getStringSet("completed_lessons", mutableSetOf<String>())?.toSet() ?: emptySet()
        )
    }

    LaunchedEffect(Unit) {
        try {
            units = withContext(Dispatchers.IO) { loadCatalog(context.assets) }
        } catch (e: Exception) {
            error = "تعذّر تحميل فهرس الدروس: ${e.localizedMessage}"
        } finally {
            loading = false
        }
    }

    MaterialTheme(
        colorScheme = lightColorScheme(
            primary = Teal,
            secondary = Navy,
            background = Cream,
            surface = Color.White,
            onPrimary = Color.White,
            onBackground = Ink,
            onSurface = Ink
        )
    ) {
        CompositionLocalProvider(LocalLayoutDirection provides LayoutDirection.Rtl) {
          Surface(Modifier.fillMaxSize(), color = Cream) {
            when {
                selectedLesson != null -> LessonPage(
                    lesson = selectedLesson!!,
                    onBack = { selectedLesson = null },
                    onCompleted = { lessonId ->
                        val updated = completedIds + lessonId
                        completedIds = updated
                        context.getSharedPreferences("sara_hocam_progress", android.content.Context.MODE_PRIVATE)
                            .edit().putStringSet("completed_lessons", updated.toMutableSet()).apply()
                    },
                    isCompleted = completedIds.contains(selectedLesson!!.optString("id"))
                )
                showVocabulary -> VocabularyPage(assets = context.assets, onBack = { showVocabulary = false })
                selectedUnit != null -> UnitPage(
                    unit = selectedUnit!!,
                    onBack = { selectedUnit = null },
                    onLesson = { lesson ->
                        try {
                            selectedLesson = loadLesson(context.assets, selectedUnit!!, lesson)
                        } catch (e: Exception) {
                            error = "تعذّر فتح الدرس: ${e.localizedMessage}"
                        }
                    }
                )
                else -> HomePage(
                    units = units,
                    loading = loading,
                    error = error,
                    search = search,
                    onSearch = { search = it },
                    selectedLevel = selectedLevel,
                    onLevel = { selectedLevel = it },
                    onUnit = { selectedUnit = it },
                    onVocabulary = { showVocabulary = true },
                    completedCount = completedIds.size
                )
            }
          }
        }
    }
}

private fun loadCatalog(assets: android.content.res.AssetManager): List<UnitItem> {
    val json = JSONObject(assets.open("catalog.json").bufferedReader().use { it.readText() })
    val array = json.getJSONArray("units")
    return (0 until array.length()).map { index ->
        val unit = array.getJSONObject(index)
        val title = unit.optJSONObject("title") ?: JSONObject()
        val lessonsJson = unit.optJSONArray("lessons") ?: JSONArray()
        val lessons = (0 until lessonsJson.length()).map { i ->
            val lesson = lessonsJson.getJSONObject(i)
            LessonItem(
                id = lesson.optString("id"),
                order = lesson.optInt("order", i + 1),
                title = lesson.optString("titleAr", "الدرس ${i + 1}"),
                status = lesson.optString("contentStatus", "draft")
            )
        }
        UnitItem(
            id = unit.optString("id"),
            level = unit.optString("level"),
            titleAr = title.optString("ar"),
            titleTr = title.optString("tr"),
            description = unit.optString("description"),
            lessons = lessons
        )
    }
}

private fun loadLesson(
    assets: android.content.res.AssetManager,
    unit: UnitItem,
    item: LessonItem
): JSONObject {
    val path = "lessons/${unit.level}/${unit.id}/${item.id}.json"
    return JSONObject(assets.open(path).bufferedReader().use { it.readText() })
}

@Composable
private fun HomePage(
    units: List<UnitItem>,
    loading: Boolean,
    error: String?,
    search: String,
    onSearch: (String) -> Unit,
    selectedLevel: String,
    onLevel: (String) -> Unit,
    onUnit: (UnitItem) -> Unit,
    onVocabulary: () -> Unit,
    completedCount: Int
) {
    val levels = listOf("الكل", "A1", "A2", "B1", "B2", "C1", "C2")
    val filtered = units.filter {
        (selectedLevel == "الكل" || it.level == selectedLevel) &&
            (search.isBlank() || it.titleAr.contains(search, true) ||
                it.titleTr.contains(search, true) || it.level.contains(search, true))
    }

    LazyColumn(
        modifier = Modifier.fillMaxSize(),
        contentPadding = PaddingValues(start = 18.dp, end = 18.dp, top = 18.dp, bottom = 30.dp),
        verticalArrangement = Arrangement.spacedBy(14.dp)
    ) {
        item {
            Row(verticalAlignment = Alignment.CenterVertically) {
                Box(
                    Modifier.size(48.dp).background(
                        Brush.linearGradient(listOf(Gold, Color(0xFFFFE6A8))),
                        CircleShape
                    ),
                    contentAlignment = Alignment.Center
                ) {
                    Icon(Icons.Default.AutoAwesome, contentDescription = null, tint = Navy)
                }
                Spacer(Modifier.width(12.dp))
                Column(Modifier.weight(1f)) {
                    Text("SARA HOCAM", color = Navy, fontSize = 19.sp, fontWeight = FontWeight.Black)
                    Text("تعلم مع الانسة ساره", color = Muted, fontSize = 12.sp)
                }
                Surface(color = Pale, shape = CircleShape) {
                    Text("TR", modifier = Modifier.padding(horizontal = 13.dp, vertical = 8.dp),
                        color = Navy, fontWeight = FontWeight.Bold)
                }
            }
        }
        item {
            Box(
                Modifier.fillMaxWidth().background(
                    Brush.linearGradient(listOf(Navy, Teal, Sky)),
                    RoundedCornerShape(28.dp)
                ).padding(22.dp)
            ) {
                Column {
                    Text("MERHABA  •  أهلاً بك", color = Gold, fontSize = 11.sp, fontWeight = FontWeight.Black)
                    Spacer(Modifier.height(13.dp))
                    Text(
                        "كل يوم كلمة،\nوكل درس يقربك.",
                        color = Color.White,
                        fontSize = 27.sp,
                        lineHeight = 36.sp,
                        fontWeight = FontWeight.Black,
                        textAlign = TextAlign.Start
                    )
                    Spacer(Modifier.height(8.dp))
                    Text(
                        "ابدأ رحلتك في اللغة التركية بأسلوب واضح وممتع باللغة العربية.",
                        color = Color.White.copy(alpha = .82f),
                        fontSize = 13.sp,
                        lineHeight = 22.sp
                    )
                    Spacer(Modifier.height(18.dp))
                    Row(horizontalArrangement = Arrangement.spacedBy(9.dp)) {
                        StatPill("${units.size}", "وحدة تعليمية")
                        StatPill("${units.sumOf { it.lessons.size }}", "درساً")
                    }
                }
            }
        }
        item {
            val totalLessons = units.sumOf { it.lessons.size }
            Column(Modifier.fillMaxWidth().background(Color.White, RoundedCornerShape(18.dp)).padding(15.dp)) {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Text("تقدمك في التعلم", color = Navy, fontWeight = FontWeight.Black)
                    Spacer(Modifier.weight(1f))
                    Text("$completedCount / $totalLessons", color = Teal, fontWeight = FontWeight.Bold)
                }
                Spacer(Modifier.height(10.dp))
                LinearProgressIndicator(
                    progress = { if (totalLessons == 0) 0f else completedCount.toFloat() / totalLessons },
                    modifier = Modifier.fillMaxWidth().height(8.dp),
                    color = Teal,
                    trackColor = Pale
                )
            }
        }
        item {
            OutlinedTextField(
                value = search,
                onValueChange = onSearch,
                modifier = Modifier.fillMaxWidth(),
                singleLine = true,
                shape = RoundedCornerShape(17.dp),
                placeholder = { Text("ابحث عن وحدة أو درس") },
                leadingIcon = { Icon(Icons.Default.Search, contentDescription = null) }
            )
        }
        item {
            Text("المستويات التعليمية", color = Navy, fontWeight = FontWeight.Black, fontSize = 17.sp)
            Spacer(Modifier.height(8.dp))
            Row(horizontalArrangement = Arrangement.spacedBy(7.dp)) {
                levels.forEach { level ->
                    FilterChip(
                        selected = selectedLevel == level,
                        onClick = { onLevel(level) },
                        label = { Text(level) }
                    )
                }
            }
        }
        if (loading) {
            item { Box(Modifier.fillMaxWidth().padding(35.dp), contentAlignment = Alignment.Center) {
                CircularProgressIndicator(color = Teal)
            } }
        }
        if (error != null) item {
            Text(error, color = Color(0xFFB4534B), modifier = Modifier.padding(8.dp))
        }
        item {
            OutlinedButton(onClick = onVocabulary, modifier = Modifier.fillMaxWidth(), shape = RoundedCornerShape(15.dp)) {
                Icon(Icons.Default.MenuBook, contentDescription = null)
                Spacer(Modifier.width(8.dp))
                Text("افتح قاموس المفردات")
            }
        }
        item {
            Text("استكشف المنهج", color = Navy, fontWeight = FontWeight.Black, fontSize = 19.sp)
            Text("${filtered.size} وحدة متاحة", color = Muted, fontSize = 12.sp)
        }
        items(filtered, key = { it.id }) { unit ->
            UnitCard(unit = unit, onClick = { onUnit(unit) })
        }
    }
}

@Composable
private fun StatPill(value: String, label: String) {
    Surface(color = Color.White.copy(alpha = .14f), shape = RoundedCornerShape(15.dp)) {
        Column(Modifier.padding(horizontal = 14.dp, vertical = 10.dp)) {
            Text(value, color = Color.White, fontSize = 19.sp, fontWeight = FontWeight.Black)
            Text(label, color = Color.White.copy(alpha = .8f), fontSize = 11.sp)
        }
    }
}

@Composable
private fun UnitCard(unit: UnitItem, onClick: () -> Unit) {
    Surface(
        modifier = Modifier.fillMaxWidth().clickable(onClick = onClick),
        shape = RoundedCornerShape(21.dp),
        color = Color.White,
        shadowElevation = 2.dp
    ) {
        Row(Modifier.padding(16.dp), verticalAlignment = Alignment.CenterVertically) {
            Box(
                Modifier.size(48.dp).background(Pale, RoundedCornerShape(15.dp)),
                contentAlignment = Alignment.Center
            ) {
                Icon(Icons.Default.MenuBook, contentDescription = null, tint = Teal)
            }
            Spacer(Modifier.width(13.dp))
            Column(Modifier.weight(1f)) {
                Text(unit.level, color = Teal, fontSize = 11.sp, fontWeight = FontWeight.Black)
                Text(unit.titleAr, color = Ink, fontWeight = FontWeight.Bold, fontSize = 15.sp)
                Text(unit.titleTr, color = Muted, fontSize = 11.sp)
                Spacer(Modifier.height(5.dp))
                Text("${unit.lessons.size} دروس", color = Muted, fontSize = 11.sp)
            }
            Text("‹", color = Navy, fontSize = 30.sp, fontWeight = FontWeight.Light)
        }
    }
}

@Composable
private fun UnitPage(
    unit: UnitItem,
    onBack: () -> Unit,
    onLesson: (LessonItem) -> Unit
) {
    Column(Modifier.fillMaxSize()) {
        PageHeader(title = unit.titleAr, onBack = onBack)
        LazyColumn(
            contentPadding = PaddingValues(18.dp),
            verticalArrangement = Arrangement.spacedBy(10.dp)
        ) {
            item {
                Text(unit.titleTr, color = Teal, fontWeight = FontWeight.Bold)
                Text(unit.description, color = Muted, lineHeight = 22.sp)
                Spacer(Modifier.height(8.dp))
            }
            items(unit.lessons, key = { it.id }) { lesson ->
                Surface(
                    modifier = Modifier.fillMaxWidth().clickable { onLesson(lesson) },
                    shape = RoundedCornerShape(17.dp),
                    color = Color.White
                ) {
                    Row(Modifier.padding(15.dp), verticalAlignment = Alignment.CenterVertically) {
                        Surface(color = Pale, shape = CircleShape) {
                            Text(lesson.order.toString(), modifier = Modifier.padding(11.dp),
                                color = Navy, fontWeight = FontWeight.Black)
                        }
                        Spacer(Modifier.width(12.dp))
                        Column(Modifier.weight(1f)) {
                            Text(lesson.title, color = Ink, fontWeight = FontWeight.Bold)
                            Text(lesson.status, color = Muted, fontSize = 11.sp)
                        }
                        Text("‹", color = Teal, fontSize = 25.sp)
                    }
                }
            }
        }
    }
}

@Composable
private fun LessonPage(
    lesson: JSONObject,
    onBack: () -> Unit,
    onCompleted: (String) -> Unit,
    isCompleted: Boolean
) {
    val titleObject = lesson.optJSONObject("title") ?: JSONObject()
    val arabicTitleObject = titleObject.optJSONObject("ar") ?: JSONObject()
    val titleAr = arabicTitleObject.optString("titleAr", "الدرس")
    val titleTr = titleObject.optString("tr")
    val vocabulary = lesson.optJSONArray("vocabulary") ?: JSONArray()
    val examples = lesson.optJSONArray("examples") ?: JSONArray()
    val dialogue = lesson.optJSONArray("dialogue") ?: JSONArray()
    val questions = lesson.optJSONArray("questions") ?: JSONArray()
    var answers by remember(lesson) { mutableStateOf<Map<Int, Int>>(emptyMap()) }
    var submitted by remember(lesson) { mutableStateOf(false) }

    Column(Modifier.fillMaxSize()) {
        PageHeader(title = titleAr, onBack = onBack)
        LazyColumn(
            contentPadding = PaddingValues(16.dp),
            verticalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            item {
                Column(
                    Modifier.fillMaxWidth().background(
                        Brush.linearGradient(listOf(Navy, Teal)),
                        RoundedCornerShape(22.dp)
                    ).padding(20.dp)
                ) {
                    Text("${lesson.optString("level")}  •  LESSON ${lesson.optInt("order")}",
                        color = Gold, fontWeight = FontWeight.Black, fontSize = 11.sp)
                    Spacer(Modifier.height(7.dp))
                    Text(titleAr, color = Color.White, fontWeight = FontWeight.Black, fontSize = 21.sp)
                    if (titleTr.isNotBlank()) Text(titleTr, color = Color.White.copy(alpha = .8f))
                    Spacer(Modifier.height(9.dp))
                    Text(lesson.optString("goal"), color = Color.White.copy(alpha = .9f), lineHeight = 23.sp)
                }
            }
            if (lesson.optString("rule").isNotBlank()) item {
                LessonSection("القاعدة والشرح") {
                    Text(lesson.optString("rule"), color = Ink, lineHeight = 25.sp)
                }
            }
            if (vocabulary.length() > 0) item {
                LessonSection("المفردات") {
                    Column(verticalArrangement = Arrangement.spacedBy(10.dp)) {
                        repeat(vocabulary.length()) { index ->
                            val word = vocabulary.getJSONObject(index)
                            val turkish = word.optString("tr",
                                word.optString("word", word.optString("term")))
                            val arabic = word.optString("ar",
                                word.optString("meaning", word.optString("translation")))
                            Row(
                                Modifier.fillMaxWidth().background(Pale, RoundedCornerShape(12.dp)).padding(12.dp),
                                verticalAlignment = Alignment.CenterVertically
                            ) {
                                Column(Modifier.weight(1f)) {
                                    Text(turkish, color = Navy, fontWeight = FontWeight.Bold)
                                    if (word.optString("pronunciation").isNotBlank())
                                        Text(word.optString("pronunciation"), color = Muted, fontSize = 11.sp)
                                }
                                Text(arabic, color = Ink, textAlign = TextAlign.End)
                            }
                        }
                    }
                }
            }
            if (examples.length() > 0) item {
                LessonSection("أمثلة تطبيقية") {
                    Column(verticalArrangement = Arrangement.spacedBy(12.dp)) {
                        repeat(examples.length()) { index ->
                            val example = examples.getJSONObject(index)
                            Text(example.optString("tr"), color = Navy, fontWeight = FontWeight.Bold)
                            Text(example.optString("ar"), color = Muted)
                        }
                    }
                }
            }
            if (dialogue.length() > 0) item {
                LessonSection("محادثة تطبيقية") {
                    Column(verticalArrangement = Arrangement.spacedBy(12.dp)) {
                        repeat(dialogue.length()) { index ->
                            val line = dialogue.getJSONObject(index)
                            Text("${line.optString("speaker")}: ${line.optString("tr")}",
                                color = Navy, fontWeight = FontWeight.Bold)
                            Text(line.optString("ar"), color = Muted)
                        }
                    }
                }
            }
            if (lesson.optString("speakingTask").isNotBlank()) item {
                LessonSection("مهمة التحدث") {
                    Text(lesson.optString("speakingTask"), color = Ink, lineHeight = 24.sp)
                }
            }
            if (questions.length() > 0) item {
                Text("اختبر فهمك", color = Navy, fontSize = 18.sp, fontWeight = FontWeight.Black)
            }
            items(questions.length()) { index ->
                val q = questions.getJSONObject(index)
                val options = q.optJSONArray("options") ?: JSONArray()
                LessonSection("السؤال ${index + 1}") {
                    Text(q.optString("prompt"), color = Ink, fontWeight = FontWeight.Bold)
                    Spacer(Modifier.height(8.dp))
                    repeat(options.length()) { optionIndex ->
                        val option = options.getString(optionIndex)
                        Row(
                            Modifier.fillMaxWidth().clickable(enabled = !submitted) {
                                answers = answers + (index to optionIndex)
                            }.padding(vertical = 5.dp),
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            RadioButton(
                                selected = answers[index] == optionIndex,
                                onClick = { if (!submitted) answers = answers + (index to optionIndex) },
                                enabled = !submitted
                            )
                            Text(option, color = Ink)
                        }
                    }
                    if (submitted) {
                        val correct = q.optInt("answerIndex", -1)
                        Text(
                            if (answers[index] == correct) "إجابة صحيحة ✓" else
                                "الإجابة الصحيحة: ${options.optString(correct)}",
                            color = if (answers[index] == correct) Teal else Color(0xFFB4534B),
                            fontWeight = FontWeight.Bold
                        )
                        if (q.optString("explanation").isNotBlank())
                            Text(q.optString("explanation"), color = Muted, fontSize = 12.sp)
                    }
                }
            }
            if (isCompleted) item {
                Surface(color = Pale, shape = RoundedCornerShape(14.dp)) {
                    Text("✓ هذا الدرس مكتمل ومحفوظ على هذا الجهاز", color = Navy,
                        modifier = Modifier.fillMaxWidth().padding(13.dp), fontWeight = FontWeight.Bold)
                }
            }
            if (questions.length() > 0) item {
                Button(
                    onClick = {
                        submitted = true
                        onCompleted(lesson.optString("id"))
                    },
                    enabled = !submitted && answers.size == questions.length(),
                    modifier = Modifier.fillMaxWidth(),
                    colors = ButtonDefaults.buttonColors(containerColor = Teal)
                ) { Text(if (submitted) "تم التصحيح" else "تصحيح الإجابات") }
                if (submitted) {
                    val score = (0 until questions.length()).count { i ->
                        answers[i] == questions.getJSONObject(i).optInt("answerIndex", -1)
                    }
                    Text("نتيجتك: $score من ${questions.length()}", color = Navy,
                        fontWeight = FontWeight.Black, modifier = Modifier.padding(8.dp))
                }
            }
        }
    }
}

@Composable
private fun LessonSection(title: String, content: @Composable ColumnScope.() -> Unit) {
    Surface(color = Color.White, shape = RoundedCornerShape(18.dp), shadowElevation = 1.dp) {
        Column(Modifier.fillMaxWidth().padding(16.dp)) {
            Text(title, color = Navy, fontWeight = FontWeight.Black, fontSize = 16.sp)
            Spacer(Modifier.height(10.dp))
            content()
        }
    }
}

@Composable
private fun PageHeader(title: String, onBack: () -> Unit) {
    Row(
        Modifier.fillMaxWidth().background(Cream).padding(horizontal = 12.dp, vertical = 12.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        IconButton(onClick = onBack) {
            Icon(Icons.AutoMirrored.Filled.ArrowBack, contentDescription = "رجوع", tint = Navy)
        }
        Text(title, color = Navy, fontWeight = FontWeight.Black, fontSize = 17.sp,
            modifier = Modifier.weight(1f))
    }
}
