# معيار كتابة أوصاف صور المفردات

## القاعدة
اكتب وصفاً مستقلاً لكل معنى. احتفظ بالكلمة التركية ومعناها في بيانات المهمة فقط؛ لا تطبع أي كلمة على الصورة.

## قالب الوصف
Photorealistic educational vocabulary photo of [precise subject and sense], [simple scene/background], centered clear composition, natural soft lighting, realistic colors and details, square image, no text, no letters, no numbers, no captions, no labels, no logo, no watermark.

## أمثلة
| Turkish | المعنى | وصف مختصر |
|---|---|---|
| elma | تفاحة | تفاحة حمراء واحدة، خلفية محايدة |
| muz | موز | موزة صفراء واحدة |
| kitap | كتاب | كتاب مغلق واحد دون كتابة مقروءة على الغلاف |
| araba | سيارة | سيارة واحدة كاملة في مشهد واضح |
| kedi | قطة | قطة واحدة بوضع طبيعي |

## الكلمات متعددة المعاني
لا تولّد الصورة من الكلمة وحدها. حدد senseId أو شرح المعنى أولاً:
- yüz: وجه / مئة / أسبح
- gül: وردة / اضحك
- yaz: الصيف / اكتب

إذا لم يكن المعنى محدداً، أوقف المهمة بحالة needs-sense-review بدلاً من تخمين صورة قد تعلّم معنى خاطئاً.

## منع التكرار
احسب مفتاح المهمة من vocabularyId + senseId + promptVersion + modelId. لا تنشئ صورة جديدة تلقائياً إذا كان هناك أصل معتمد للمفتاح نفسه.
