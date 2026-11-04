package com.sarahocam.app

import android.content.res.AssetManager
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.Search
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import org.json.JSONArray
import org.json.JSONObject

private data class VocabularyEntry(
    val id: String,
    val turkish: String,
    val arabic: String,
    val pronunciation: String,
    val level: String,
    val lessonTitle: String
)

private fun firstText(json: JSONObject, vararg keys: String): String {
    for (key in keys) {
        val value = json.optString(key).trim()
        if (value.isNotEmpty() && value != "null") return value
    }
    return ""
}

private fun readVocabulary(assets: AssetManager): List<VocabularyEntry> {
    val catalog = JSONObject(assets.open("catalog.json").bufferedReader().use { it.readText() })
    val units = catalog.optJSONArray("units") ?: JSONArray()
    val result = mutableListOf<VocabularyEntry>()

    for (unitIndex in 0 until units.length()) {
        val unit = units.optJSONObject(unitIndex) ?: continue
        val level = unit.optString("level")
        val unitId = unit.optString("id")
        val lessons = unit.optJSONArray("lessons") ?: JSONArray()

        for (lessonIndex in 0 until lessons.length()) {
            val lessonMeta = lessons.optJSONObject(lessonIndex) ?: continue
            val lessonId = lessonMeta.optString("id")
            if (lessonId.isBlank()) continue

            try {
                val path = "lessons/$level/$unitId/$lessonId.json"
                val lesson = JSONObject(assets.open(path).bufferedReader().use { it.readText() })
                val titleRoot = lesson.optJSONObject("title") ?: JSONObject()
                val titleAr = titleRoot.optJSONObject("ar")?.optString("titleAr")
                    ?.takeIf { it.isNotBlank() } ?: lessonMeta.optString("titleAr", "الدرس")
                val words = lesson.optJSONArray("vocabulary") ?: JSONArray()

                for (wordIndex in 0 until words.length()) {
                    val word = words.optJSONObject(wordIndex) ?: continue
                    val turkish = firstText(word, "tr", "word", "term", "turkish")
                    val arabic = firstText(word, "ar", "meaning", "translation", "arabic")
                    if (turkish.isBlank() && arabic.isBlank()) continue
                    result += VocabularyEntry(
                        id = "$lessonId-$wordIndex",
                        turkish = turkish,
                        arabic = arabic,
                        pronunciation = firstText(word, "pronunciation", "reading"),
                        level = level,
                        lessonTitle = titleAr
                    )
                }
            } catch (_: Exception) {
                // One malformed or absent lesson must not prevent the remaining dictionary from loading.
            }
        }
    }
    return result.sortedWith(compareBy<VocabularyEntry> { it.level }.thenBy { it.turkish.lowercase() })
}

@Composable
fun VocabularyPage(assets: AssetManager, onBack: () -> Unit) {
    var entries by remember { mutableStateOf<List<VocabularyEntry>>(emptyList()) }
    var loading by remember { mutableStateOf(true) }
    var query by remember { mutableStateOf("") }
    var level by remember { mutableStateOf("الكل") }
    var error by remember { mutableStateOf<String?>(null) }

    LaunchedEffect(assets) {
        try {
            entries = withContext(Dispatchers.IO) { readVocabulary(assets) }
        } catch (e: Exception) {
            error = "تعذّر تحميل المفردات: ${e.localizedMessage}"
        } finally {
            loading = false
        }
    }

    val levels = listOf("الكل", "A1", "A2", "B1", "B2", "C1", "C2")
    val filtered = entries.filter { entry ->
        (level == "الكل" || entry.level == level) &&
            (query.isBlank() || entry.turkish.contains(query, true) ||
                entry.arabic.contains(query, true) || entry.lessonTitle.contains(query, true))
    }

    Column(Modifier.fillMaxSize().background(Color(0xFFFFFAF3))) {
        Row(
            Modifier.fillMaxWidth().padding(horizontal = 12.dp, vertical = 10.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            IconButton(onClick = onBack) {
                Icon(Icons.AutoMirrored.Filled.ArrowBack, contentDescription = "رجوع", tint = Color(0xFF164E63))
            }
            Column(Modifier.weight(1f)) {
                Text("قاموس المفردات", color = Color(0xFF164E63), fontSize = 19.sp, fontWeight = FontWeight.Black)
                Text("كلمات الدروس مرتبة حسب المستوى", color = Color(0xFF71858A), fontSize = 11.sp)
            }
            Text(entries.size.toString(), color = Color(0xFF0F9D9A), fontWeight = FontWeight.Bold)
        }

        OutlinedTextField(
            value = query,
            onValueChange = { query = it },
            modifier = Modifier.fillMaxWidth().padding(horizontal = 16.dp),
            singleLine = true,
            shape = RoundedCornerShape(16.dp),
            placeholder = { Text("ابحث بالتركية أو العربية") },
            leadingIcon = { Icon(Icons.Default.Search, contentDescription = null) }
        )

        Row(
            Modifier.fillMaxWidth().padding(horizontal = 12.dp, vertical = 10.dp),
            horizontalArrangement = Arrangement.spacedBy(5.dp)
        ) {
            levels.forEach { item ->
                FilterChip(
                    selected = level == item,
                    onClick = { level = item },
                    label = { Text(item, fontSize = 11.sp) }
                )
            }
        }

        when {
            loading -> Box(Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                CircularProgressIndicator(color = Color(0xFF0F9D9A))
            }
            error != null -> Text(error!!, color = Color(0xFFB4534B), modifier = Modifier.padding(18.dp))
            entries.isEmpty() -> Box(Modifier.fillMaxSize().padding(24.dp), contentAlignment = Alignment.Center) {
                Text(
                    "لا توجد مفردات مدخلة في ملفات الدروس حتى الآن. ستظهر الكلمات هنا تلقائياً عند إضافتها إلى JSON.",
                    color = Color(0xFF71858A),
                    lineHeight = 24.sp
                )
            }
            filtered.isEmpty() -> Box(Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                Text("لا توجد نتائج مطابقة للبحث.", color = Color(0xFF71858A))
            }
            else -> LazyColumn(
                contentPadding = PaddingValues(start = 16.dp, end = 16.dp, top = 4.dp, bottom = 24.dp),
                verticalArrangement = Arrangement.spacedBy(9.dp)
            ) {
                item {
                    Text("${filtered.size} مفردة", color = Color(0xFF71858A), fontSize = 12.sp)
                }
                items(filtered, key = { it.id }) { entry ->
                    Surface(
                        color = Color.White,
                        shape = RoundedCornerShape(16.dp),
                        shadowElevation = 1.dp,
                        modifier = Modifier.fillMaxWidth()
                    ) {
                        Column(Modifier.padding(14.dp)) {
                            Row(verticalAlignment = Alignment.CenterVertically) {
                                Text(entry.turkish.ifBlank { "—" }, color = Color(0xFF164E63),
                                    fontWeight = FontWeight.Bold, fontSize = 17.sp,
                                    modifier = Modifier.weight(1f))
                                Surface(color = Color(0xFFE2F5F2), shape = RoundedCornerShape(20.dp)) {
                                    Text(entry.level, color = Color(0xFF0F7775),
                                        modifier = Modifier.padding(horizontal = 9.dp, vertical = 5.dp),
                                        fontSize = 10.sp, fontWeight = FontWeight.Bold)
                                }
                            }
                            if (entry.pronunciation.isNotBlank()) {
                                Text(entry.pronunciation, color = Color(0xFF71858A), fontSize = 11.sp)
                            }
                            Text(entry.arabic.ifBlank { "لم تضاف الترجمة بعد" },
                                color = Color(0xFF18343B), fontSize = 14.sp)
                            Spacer(Modifier.height(5.dp))
                            Text(entry.lessonTitle, color = Color(0xFF71858A), fontSize = 10.sp)
                        }
                    }
                }
            }
        }
    }
}
