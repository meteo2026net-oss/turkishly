import 'package:flutter/material.dart';
import '../services/learning_progress.dart';
import '../theme/app_theme.dart';

class B1Question {
  const B1Question(this.prompt, this.options, this.answer, this.explanation);
  final String prompt;
  final List<String> options;
  final int answer;
  final String explanation;
}

class B1Lesson {
  const B1Lesson({
    required this.unitId, required this.globalNumber, required this.title,
    required this.goal, required this.rule, required this.examples,
    required this.dialogue, required this.speakingTask, required this.questions,
  });
  final String unitId;
  final int globalNumber;
  final String title, goal, rule, dialogue, speakingTask;
  final List<String> examples;
  final List<B1Question> questions;
  int get lessonNumber => (globalNumber - (unitId == 'b1-u1' ? 120 : unitId == 'b1-u2' ? 130 : 140));
}

class B1CourseData {
  static B1Question _q(String p, List<String> o, String why) => B1Question(p, o, 0, why);
  static B1Lesson _lesson({
    required String unitId, required int number, required String title,
    required String goal, required String rule, required String term,
    required String meaning, required String sentence, required String translation,
    required String form, required String formMeaning, required String function,
    required List<String> wordChoices, required List<String> sentenceChoices,
    required List<String> formChoices, required List<String> functionChoices,
    required List<String> examples, required String dialogue, required String task,
  }) => B1Lesson(
    unitId: unitId, globalNumber: number, title: title, goal: goal, rule: rule,
    examples: examples, dialogue: dialogue, speakingTask: task,
    questions: [
      _q('ما معنى «$term»؟', wordChoices, '$term تعني $meaning.'),
      _q('ما ترجمة الجملة: «$sentence»؟', sentenceChoices, '$sentence تعني $translation.'),
      _q('اختر الصيغة الصحيحة المرتبطة بالقاعدة:', formChoices, '$formMeaning.'),
      _q('ما الوظيفة النحوية للتعبير «$form»؟', functionChoices, '$function'),
      _q('أكمل التركيب: $sentence', formChoices, 'الصيغة المستهدفة هي $form؛ $formMeaning.'),
    ],
  );

  static final List<B1Lesson> lessons = [
    _lesson(unitId:'b1-u1',number:121,title:'الجمل الموصولة لوصف الأشخاص والأماكن',
      goal:'ربط الاسم بجملة تصفه باستخدام تراكيب مثل çalıştığım yer وyaşadığın şehir.',
      rule:'تُستخدم صيغ الفعل المشتقة مع لاحقة الملكية لتحديد الاسم: çalıştığım yer = المكان الذي أعمل فيه، yaşadığın şehir = المدينة التي تعيش فيها. تتغير اللاحقة بحسب الشخص والانسجام الصوتي.',
      term:'çalıştığım yer',meaning:'المكان الذي أعمل فيه',sentence:'Burası çalıştığım yer.',translation:'هذا هو المكان الذي أعمل فيه.',
      form:'çalıştığım',formMeaning:'صيغة موصولة تعني «الذي أعمل فيه» مع المتكلم',
      function:'تحديد الاسم ووصفه بجملة تابعة بدلاً من جملة مستقلة.',
      wordChoices:['المكان الذي أعمل فيه','العمل الذي سأبدأه','مكان عملك','مكان العمل السابق'],
      sentenceChoices:['هذا هو المكان الذي أعمل فيه.','هذا هو المكان الذي سأزوره.','هذا المكان لا يعمل.','أنا أعمل في المنزل.'],
      formChoices:['çalıştığım','çalışacağım','çalışıyorum','çalıştım'],
      functionChoices:['وصف اسم بجملة موصولة','التعبير عن المستقبل','نفي الفعل','السؤال عن المكان'],
      examples:['Tanıdığım kişi|الشخص الذي أعرفه','Yaşadığın şehir çok güzel.|المدينة التي تعيش فيها جميلة جداً.'],
      dialogue:'A: Hangi şehirde yaşıyorsun? — في أي مدينة تعيش؟\nB: Yaşadığım şehir İzmir. — المدينة التي أعيش فيها هي إزمير.',
      task:'صف شخصاً تعرفه ومكاناً تعيش فيه مستخدماً tanıdığım وyaşadığım.'),
    _lesson(unitId:'b1-u1',number:122,title:'الجمل الاسمية التابعة باستخدام -DIK',
      goal:'التعبير عن فكرة أو معلومة بوصفها مفعولاً به مثل onun geldiğini biliyorum.',
      rule:'تُستخدم صيغة -DIK مع لاحقة الملكية، ثم حالة المفعول المحدد عند الحاجة: geldiğini = أنه جاء، bildiğimi = أنني أعرف. تتغير الحروف والحركات وفق الانسجام الصوتي وقاعدة d/t.',
      term:'onun geldiğini biliyorum',meaning:'أعرف أنه جاء',sentence:'Onun geldiğini biliyorum.',translation:'أعرف أنه جاء.',
      form:'geldiğini',formMeaning:'اسم فعل تابع بمعنى «أنه جاء» في موقع المفعول به',
      function:'تحويل حدث كامل إلى فكرة أو معلومة تقع موقع المفعول به.',
      wordChoices:['أعرف أنه جاء','أعرف أنه سيأتي','أعرف أين ذهب','أعرف أنه لا يأتي'],
      sentenceChoices:['أعرف أنه جاء.','أظن أنه سيأتي.','لا أعرفه.','أعرف المكان الذي جاء منه.'],
      formChoices:['geldiğini','geleceğini','gelmediğini','geliyor'],
      functionChoices:['جعل الحدث مفعولاً به','تكوين أمر مباشر','وصف المكان','التعبير عن المقارنة'],
      examples:['Ne istediğini anladım.|فهمت ما الذي يريده.','Sınavı kazandığını duydum.|سمعت أنه نجح في الامتحان.'],
      dialogue:'A: Toplantıya geldi mi? — هل جاء إلى الاجتماع؟\nB: Evet, geldiğini biliyorum. — نعم، أعرف أنه جاء.',
      task:'قل بالتركية: أعتقد أنه يعرف الحقيقة، وفهمت ما الذي تريده.'),
    _lesson(unitId:'b1-u1',number:123,title:'نقل الكلام بصورة غير مباشرة',
      goal:'نقل أقوال الآخرين وأسئلتهم دون اقتباسها حرفياً.',
      rule:'يُستخدم -DIK أو -AcAK مع لواحق الملكية لنقل المحتوى: geleceğini söyledi = قال إنه سيأتي، ne istediğini sordu = سأل ماذا يريد. اختر الزمن بحسب زمن الكلام الأصلي.',
      term:'geleceğini söyledi',meaning:'قال إنه سيأتي',sentence:'Yarın geleceğini söyledi.',translation:'قال إنه سيأتي غداً.',
      form:'geleceğini söyledi',formMeaning:'نقل وعد أو قول عن حدث مستقبلي',
      function:'نقل كلام شخص آخر بطريقة غير مباشرة.',
      wordChoices:['قال إنه سيأتي','قال إنه جاء','سأل متى سيأتي','قال إنه لن يأتي'],
      sentenceChoices:['قال إنه سيأتي غداً.','قال إنه جاء أمس.','سأل إن كنت سأذهب.','قال إنه لا يعرف.'],
      formChoices:['geleceğini söyledi','geldiğini söyledi','gelmeyeceğini söyledi','geliyor musun dedi'],
      functionChoices:['نقل قول الغير','إعطاء أمر','طلب الإذن','تكوين شرط افتراضي'],
      examples:['Beni arayacağını söyledi.|قال إنه سيتصل بي.','Ne zaman döneceğini sordu.|سأل متى سيعود.'],
      dialogue:'A: Müdür ne dedi? — ماذا قال المدير؟\nB: Toplantının erteleneceğini söyledi. — قال إن الاجتماع سيؤجَّل.',
      task:'انقل بصورة غير مباشرة قولاً مثل «قال صديقي إنه سيسافر».'),
    _lesson(unitId:'b1-u1',number:124,title:'التعبير عن السبب باستخدام -DIğI için',
      goal:'شرح سبب حدوث الفعل أو اتخاذ القرار باستخدام جملة تابعة.',
      rule:'نربط السبب بالنتيجة باستخدام -DIğI için: hasta olduğum için = لأنني مريض، geç kaldığı için = لأنه تأخر. تضاف لواحق الملكية إلى الصيغة المشتقة.',
      term:'hasta olduğum için',meaning:'لأنني مريض',sentence:'Hasta olduğum için evde kaldım.',translation:'بقيت في المنزل لأنني كنت مريضاً.',
      form:'olduğum için',formMeaning:'لأنني أكون/كنت، وتربط السبب بالنتيجة',
      function:'ذكر السبب باستخدام جملة تابعة.',
      wordChoices:['لأنني مريض','بعد أن مرضت','حتى أمرض','رغم أنني مريض'],
      sentenceChoices:['بقيت في المنزل لأنني كنت مريضاً.','ذهبت إلى العمل رغم المرض.','سأبقى حتى المساء.','عدت بعد انتهاء العمل.'],
      formChoices:['olduğum için','olmadan önce','olduktan sonra','olduğum halde'],
      functionChoices:['التعبير عن السبب','التعبير عن التوقيت اللاحق','التعبير عن الغاية','التعبير عن التنازل'],
      examples:['Yağmur yağdığı için dışarı çıkmadık.|لم نخرج لأن المطر هطل.','Yorgun olduğum için erken uyudum.|نمت مبكراً لأنني متعب.'],
      dialogue:'A: Neden gelmedin? — لماذا لم تأتِ؟\nB: İşim olduğu için gelemedim. — لم أستطع المجيء لأن لدي عملاً.',
      task:'اذكر سبباً لتأخرك أو غيابك مستخدماً -DIğI için.'),
    _lesson(unitId:'b1-u1',number:125,title:'التعبير عن الغرض باستخدام -mek için',
      goal:'توضيح الهدف من القيام بفعل ما.',
      rule:'يأتي المصدر -mak/-mek قبل için للتعبير عن الغاية: öğrenmek için = لكي أتعلم، dinlenmek için = لكي أرتاح. يبقى الفعل في صيغة المصدر.',
      term:'öğrenmek için',meaning:'لكي أتعلم / من أجل التعلم',sentence:'Türkçe öğrenmek için çalışıyorum.',translation:'أدرس لكي أتعلم التركية.',
      form:'öğrenmek için',formMeaning:'مصدر متبوع بـ için لبيان الغرض',
      function:'التعبير عن الهدف أو الغاية من الفعل.',
      wordChoices:['لكي أتعلم','لأنني تعلمت','بعد أن أتعلم','رغم التعلم'],
      sentenceChoices:['أدرس لكي أتعلم التركية.','أدرس لأنني تعلمت التركية.','توقفت عن تعلم التركية.','تعلمت التركية أمس.'],
      formChoices:['öğrenmek için','öğrendiğim için','öğrendikten sonra','öğrenmeden önce'],
      functionChoices:['التعبير عن الغاية','التعبير عن السبب الماضي','التعبير عن التوقيت السابق','التعبير عن التنازل'],
      examples:['Seni görmek için geldim.|أتيت لكي أراك.','Para biriktirmek için çalışıyor.|يعمل لكي يدّخر المال.'],
      dialogue:'A: Neden kursa gidiyorsun? — لماذا تذهب إلى الدورة؟\nB: Türkçe öğrenmek için. — لكي أتعلم التركية.',
      task:'اذكر هدفين من أهدافك مستخدماً -mek için.'),
    _lesson(unitId:'b1-u1',number:126,title:'التزامن باستخدام -ken',
      goal:'وصف حدث يقع أثناء حدوث حدث آخر أو أثناء حالة معينة.',
      rule:'تأتي -ken بمعنى «بينما/عندما»: çalışırken = أثناء العمل، çocukken = عندما كنت طفلاً. مع الأسماء قد تأتي بعد صيغة مختصرة، ومع الأفعال تلحق بالجذر أو الصيغة المناسبة.',
      term:'çalışırken',meaning:'أثناء العمل',sentence:'Müzik dinlerken çalışıyorum.',translation:'أعمل بينما أستمع إلى الموسيقى.',
      form:'dinlerken',formMeaning:'أثناء الاستماع، وتدل على التزامن',
      function:'ربط فعلين يحدثان في الوقت نفسه.',
      wordChoices:['أثناء العمل','بعد العمل','قبل العمل','من أجل العمل'],
      sentenceChoices:['أعمل بينما أستمع إلى الموسيقى.','أعمل بعد أن أستمع للموسيقى.','أعمل لكي أسمع الموسيقى.','لا أعمل بسبب الموسيقى.'],
      formChoices:['dinlerken','dinledikten sonra','dinlemeden önce','dinlemek için'],
      functionChoices:['التزامن بين حدثين','ترتيب حدث بعد آخر','ذكر السبب','تحديد الغاية'],
      examples:['Yemek yaparken telefon çaldı.|رن الهاتف أثناء إعداد الطعام.','Çocukken çok kitap okurdum.|كنت أقرأ كثيراً عندما كنت طفلاً.'],
      dialogue:'A: Ne yapıyordun? — ماذا كنت تفعل؟\nB: Kitap okurken kahve içiyordum. — كنت أشرب القهوة أثناء قراءة كتاب.',
      task:'صف نشاطين تقوم بهما في الوقت نفسه مستخدماً -ken.'),
    _lesson(unitId:'b1-u1',number:127,title:'التعبير عن «بعد أن» باستخدام -DIktan sonra',
      goal:'ترتيب حدثين وبيان أن أحدهما وقع بعد الآخر.',
      rule:'نضيف -DIK إلى الفعل ثم لاحقة الابتعاد -tan/-ten، وبعدها sonra: geldikten sonra = بعد أن جاء، bitirdikten sonra = بعد أن أنهى. انتبه إلى التغير الصوتي d/t.',
      term:'bitirdikten sonra',meaning:'بعد أن أنهيت',sentence:'Ödevimi bitirdikten sonra dinlendim.',translation:'استرحت بعد أن أنهيت واجبي.',
      form:'bitirdikten sonra',formMeaning:'بعد إتمام الفعل الأول يبدأ الفعل الثاني',
      function:'تحديد أن الحدث الثاني يأتي زمنياً بعد الأول.',
      wordChoices:['بعد أن أنهيت','قبل أن أنهي','لكي أنهي','لأنني أنهيت'],
      sentenceChoices:['استرحت بعد أن أنهيت واجبي.','استرحت قبل أن أبدأ واجبي.','استرحت لكي أنهي واجبي.','لم أسترح بسبب الواجب.'],
      formChoices:['bitirdikten sonra','bitirmeden önce','bitirmek için','bitirdiğim için'],
      functionChoices:['ترتيب حدث بعد حدث','ذكر سبب الحدث','ذكر غاية الفعل','التعبير عن التزامن'],
      examples:['Eve geldikten sonra yemek yedim.|أكلت بعد أن وصلت إلى المنزل.','Ders çalıştıktan sonra dışarı çıktık.|خرجنا بعد الدراسة.'],
      dialogue:'A: Ne zaman arayayım? — متى أتصل؟\nB: Toplantı bittikten sonra ara. — اتصل بعد انتهاء الاجتماع.',
      task:'رتّب ثلاث خطوات من يومك باستخدام -DIktan sonra.'),
    _lesson(unitId:'b1-u1',number:128,title:'التعبير عن «قبل أن» باستخدام -madan önce',
      goal:'ذكر الفعل الذي ينبغي أن يسبق حدثاً آخر.',
      rule:'نضيف -madan/-meden إلى الفعل ثم önce: çıkmadan önce = قبل أن أخرج، uyumadan önce = قبل أن أنام. لا نستخدم لاحقة الماضي هنا.',
      term:'uyumadan önce',meaning:'قبل أن أنام',sentence:'Yatmadan önce kitap okuyorum.',translation:'أقرأ كتاباً قبل أن أنام.',
      form:'yatmadan önce',formMeaning:'قبل حدوث الفعل المذكور',
      function:'تحديد الحدث الذي يجب أن يقع أولاً.',
      wordChoices:['قبل أن أنام','بعد أن أنام','أثناء النوم','لكي أنام'],
      sentenceChoices:['أقرأ كتاباً قبل أن أنام.','أقرأ كتاباً بعد أن أنام.','أقرأ لأنني نمت.','لا أقرأ في المساء.'],
      formChoices:['yatmadan önce','yattıktan sonra','yatarken','yatmak için'],
      functionChoices:['تحديد التوقيت السابق','تحديد التوقيت اللاحق','التزامن','الغاية'],
      examples:['Evden çıkmadan önce kapıyı kilitle.|أقفل الباب قبل الخروج.','Yemek yemeden önce ellerimi yıkarım.|أغسل يدي قبل الأكل.'],
      dialogue:'A: Ne yaparsın yatmadan önce? — ماذا تفعل قبل النوم؟\nB: Genellikle biraz okurum. — أقرأ قليلاً عادةً.',
      task:'اذكر ثلاث عادات تقوم بها قبل النوم أو قبل الخروج.'),
    _lesson(unitId:'b1-u1',number:129,title:'التعبير عن «حتى» باستخدام -ene kadar',
      goal:'تحديد نهاية زمنية أو حدّ يستمر الفعل إليه.',
      rule:'نستخدم -ene/-ana kadar بمعنى حتى: gelene kadar = حتى يأتي، bitene kadar = حتى ينتهي. تتغير الصيغة وفق انسجام الحركات.',
      term:'gelene kadar',meaning:'حتى يأتي',sentence:'Sen gelene kadar burada bekleyeceğim.',translation:'سأنتظر هنا حتى تأتي.',
      form:'gelene kadar',formMeaning:'حتى وقوع الحدث أو بلوغ الحد',
      function:'تحديد نهاية الفترة الزمنية أو الحدث.',
      wordChoices:['حتى يأتي','بعد أن يأتي','قبل أن يأتي','لأنه يأتي'],
      sentenceChoices:['سأنتظر هنا حتى تأتي.','سأنتظر بعد أن تأتي.','سأذهب قبل أن تأتي.','سأنتظر لأنك أتيت.'],
      formChoices:['gelene kadar','geldikten sonra','gelmeden önce','geldiği için'],
      functionChoices:['تحديد نهاية زمنية','تحديد بداية زمنية','ذكر السبب','ذكر الغاية'],
      examples:['Film bitene kadar kaldık.|بقينا حتى انتهى الفيلم.','Akşama kadar çalışacağım.|سأعمل حتى المساء.'],
      dialogue:'A: Ne kadar bekleyeceğiz? — كم سننتظر؟\nB: Otobüs gelene kadar. — حتى تأتي الحافلة.',
      task:'تحدث عن شيء ستفعله حتى وقت محدد مستخدماً kadar.'),
    _lesson(unitId:'b1-u1',number:130,title:'مراجعة الجمل التابعة والروابط الزمنية',
      goal:'التمييز بين السبب والغاية والتزامن والتتابع الزمني والحد الزمني.',
      rule:'قارن بين: -DIğI için للسبب، -mek için للغرض، -ken للتزامن، -DIktan sonra لما بعد الحدث، -madan önce لما قبله، و-kadar حتى حد معين.',
      term:'-DIğI için',meaning:'لأن / بسبب أن',sentence:'Yağmur yağdığı için evde kaldık.',translation:'بقينا في المنزل لأن المطر هطل.',
      form:'yağdığı için',formMeaning:'صيغة السبب وليست الغاية أو الزمن',
      function:'تمييز الرابط بحسب العلاقة المنطقية أو الزمنية بين الجمل.',
      wordChoices:['لأن / بسبب أن','لكي / من أجل','بينما','حتى'],
      sentenceChoices:['بقينا في المنزل لأن المطر هطل.','بقينا حتى توقف المطر.','خرجنا لكي نرى المطر.','خرجنا بينما كان المطر يهطل.'],
      formChoices:['yağdığı için','yağmak için','yağarken','yağana kadar'],
      functionChoices:['ذكر السبب','ذكر الهدف','وصف التزامن','تحديد الحد النهائي'],
      examples:['Ders bittikten sonra eve gittim.|ذهبت إلى المنزل بعد انتهاء الدرس.','Uyumadan önce dişlerimi fırçalarım.|أنظف أسناني قبل النوم.'],
      dialogue:'A: Neden erken çıktın? — لماذا خرجت مبكراً؟\nB: İşim bittiği için. — لأن عملي انتهى.',
      task:'اكتب فقرة قصيرة تستخدم فيها أربعة روابط مختلفة من الوحدة.'),
    _lesson(unitId:'b1-u2',number:131,title:'الاحتمال باستخدام -abilir/-ebilir وbelki',
      goal:'التعبير عن إمكانية حدوث شيء أو عدم التأكد منه.',
      rule:'تُستخدم صيغة القدرة -abilir/-ebilir للدلالة على الاحتمال بحسب السياق: gelebilir = قد يأتي/يستطيع أن يأتي. وتسبق belki الجملة بمعنى ربما.',
      term:'belki',meaning:'ربما',sentence:'Belki yarın yağmur yağabilir.',translation:'ربما تمطر غداً.',
      form:'yağabilir',formMeaning:'صيغة احتمال أو إمكانية حدوث الفعل',
      function:'التعبير عن احتمال أو إمكانية غير مؤكدة.',
      wordChoices:['ربما','بالتأكيد','مستحيل','أمس'],
      sentenceChoices:['ربما تمطر غداً.','ستمطر بالتأكيد غداً.','أمطرت أمس.','لا تمطر أبداً.'],
      formChoices:['yağabilir','yağmalı','yağdı','yağarken'],
      functionChoices:['الاحتمال والإمكانية','الوجوب','الماضي المحدد','التزامن'],
      examples:['Akşam gelebilirim.|قد أستطيع المجيء مساءً.','Belki toplantı iptal olabilir.|ربما يُلغى الاجتماع.'],
      dialogue:'A: Yarın gelir misin? — هل ستأتي غداً؟\nB: Belki, işim erken bitebilir. — ربما، قد ينتهي عملي مبكراً.',
      task:'اذكر ثلاثة احتمالات عن الغد باستخدام belki أو -abilir.'),
    _lesson(unitId:'b1-u2',number:132,title:'الاستنتاج والتخمين باستخدام -malı/-meli',
      goal:'استخدام صيغة الوجوب للتعبير عن استنتاج مرجّح من قرائن.',
      rule:'قد تدل -malı/-meli على الاستنتاج «لا بد أن»: Çok yorgun olmalı = لا بد أنه متعب جداً. يحدد السياق هل المعنى نصيحة أم استنتاج.',
      term:'olmalı',meaning:'لا بد أنه يكون / يبدو أنه',sentence:'Saat geç oldu; evde olmalı.',translation:'تأخر الوقت؛ لا بد أنه في المنزل.',
      form:'evde olmalı',formMeaning:'استنتاج مرجح عن مكان الشخص',
      function:'التعبير عن تخمين قوي مبني على قرائن.',
      wordChoices:['لا بد أنه يكون','لن يكون','كان سابقاً','ربما لن يكون'],
      sentenceChoices:['تأخر الوقت؛ لا بد أنه في المنزل.','تأخر الوقت؛ كان في المنزل أمس.','ربما لن يعود إلى المنزل.','يجب أن أذهب إلى المنزل.'],
      formChoices:['evde olmalı','evde olabilir','evdeydi','eve gitmeli'],
      functionChoices:['استنتاج قوي','احتمال ضعيف فقط','الماضي','أمر مباشر'],
      examples:['Çok sessiz; uyuyor olmalı.|إنه هادئ جداً؛ لا بد أنه نائم.','Anahtar burada; evde olmalılar.|المفتاح هنا؛ لا بد أنهم في المنزل.'],
      dialogue:'A: Ali neden cevap vermiyor? — لماذا لا يجيب علي؟\nB: Meşgul olmalı. — لا بد أنه مشغول.',
      task:'استنتج ثلاثة أمور من قرائن بسيطة مستخدماً olmalı.'),
    _lesson(unitId:'b1-u2',number:133,title:'الضرورة الماضية -malıydı/-meliydi',
      goal:'التحدث عما كان ينبغي فعله في الماضي.',
      rule:'نضيف -ydı/-ydi إلى صيغة -malı/-meli: gitmeliydim = كان ينبغي أن أذهب. وقد تعبّر عن نصيحة لم تُنفذ أو واجب في الماضي.',
      term:'gitmeliydim',meaning:'كان ينبغي أن أذهب',sentence:'Daha erken başlamalıydım.',translation:'كان ينبغي أن أبدأ أبكر.',
      form:'başlamalıydım',formMeaning:'كان ينبغي عليّ أن أبدأ',
      function:'التعبير عن واجب أو نصيحة في الماضي.',
      wordChoices:['كان ينبغي أن أذهب','يجب أن أذهب الآن','سأذهب لاحقاً','ذهبت بالفعل'],
      sentenceChoices:['كان ينبغي أن أبدأ أبكر.','يجب أن أبدأ الآن.','سأبدأ غداً.','بدأت قبل قليل.'],
      formChoices:['başlamalıydım','başlamalıyım','başlayacağım','başladım'],
      functionChoices:['ضرورة أو نصيحة ماضية','ضرورة حاضرة','مستقبل','ماضٍ محدد'],
      examples:['Daha dikkatli olmalıydın.|كان ينبغي أن تكون أكثر انتباهاً.','Bize haber vermeliydiniz.|كان ينبغي أن تخبرونا.'],
      dialogue:'A: Sınava hazır mısın? — هل أنت مستعد للامتحان؟\nB: Daha çok çalışmalıydım. — كان ينبغي أن أدرس أكثر.',
      task:'تحدث عن أمر كان ينبغي أن تفعله في الأسبوع الماضي.'),
    _lesson(unitId:'b1-u2',number:134,title:'الافتراض باستخدام diyelim ki وfarz edelim',
      goal:'طرح موقف افتراضي لتفسير احتمال أو مناقشة حل.',
      rule:'تُستخدم diyelim ki وfarz edelim ki بمعنى «لنفترض أن». يليهما وصف الحالة، ثم نناقش النتائج: Diyelim ki yarın tatil. = لنفترض أن غداً عطلة.',
      term:'diyelim ki',meaning:'لنفترض أن',sentence:'Diyelim ki yarın tatil.',translation:'لنفترض أن غداً عطلة.',
      form:'farz edelim ki',formMeaning:'تعبير افتتاحي لتقديم افتراض',
      function:'تقديم سيناريو افتراضي للنقاش.',
      wordChoices:['لنفترض أن','لأن','بعد أن','على الرغم من'],
      sentenceChoices:['لنفترض أن غداً عطلة.','لأن غداً عطلة.','بعد أن تنتهي العطلة.','رغم أن اليوم عطلة.'],
      formChoices:['farz edelim ki','çünkü','-dikten sonra','rağmen'],
      functionChoices:['تقديم افتراض','تقديم سبب','ترتيب زمني','تقديم تنازل'],
      examples:['Farz edelim ki hiç paran yok.|لنفترض أنه ليس لديك مال.','Diyelim ki tren gecikti.|لنفترض أن القطار تأخر.'],
      dialogue:'A: Diyelim ki uçuş iptal oldu. Ne yaparız? — لنفترض أن الرحلة أُلغيت، ماذا نفعل؟\nB: Başka bir uçuş ararız. — نبحث عن رحلة أخرى.',
      task:'ابتكر موقفين افتراضيين وناقش ما الذي ستفعله.'),
    _lesson(unitId:'b1-u2',number:135,title:'الشرط الافتراضي في الماضي -seydi/-saydı',
      goal:'التحدث عن نتائج متخيلة لشرط لم يتحقق في الماضي.',
      rule:'نستخدم -seydi/-saydı في جملة الشرط، وغالباً يأتي في النتيجة زمن مناسب: Param olsaydı seyahat ederdim = لو كان لدي مال لسافرت. تتغير الحركة بحسب الانسجام.',
      term:'Param olsaydı',meaning:'لو كان لدي مال',sentence:'Param olsaydı seyahat ederdim.',translation:'لو كان لدي مال لسافرت.',
      form:'olsaydı',formMeaning:'شرط افتراضي في الماضي بمعنى «لو كان»',
      function:'التعبير عن شرط غير متحقق ونتيجته المتخيلة.',
      wordChoices:['لو كان لدي مال','لدي مال الآن','سأحصل على المال','لأن لدي مالاً'],
      sentenceChoices:['لو كان لدي مال لسافرت.','سأسافر لأن لدي مالاً.','أسافر كل أسبوع.','سافرت عندما حصلت على المال.'],
      formChoices:['olsaydı','olursa','oldu','olmalı'],
      functionChoices:['شرط افتراضي ماضٍ','شرط محتمل مستقبلاً','ماضٍ محدد','ضرورة'],
      examples:['Daha erken kalksaydım otobüsü kaçırmazdım.|لو استيقظت أبكر لما فاتتني الحافلة.','Beni arasaydın sana yardım ederdim.|لو اتصلت بي لساعدتك.'],
      dialogue:'A: Neden başvurmadın? — لماذا لم تتقدم؟\nB: Zamanım olsaydı başvururdum. — لو كان لدي وقت لتقدمت.',
      task:'اكتب ثلاث جمل تبدأ بـ لو كان لدي... مستخدماً -seydi/-saydı.'),
    _lesson(unitId:'b1-u2',number:136,title:'التنازل باستخدام rağmen و-mesine rağmen',
      goal:'التعبير عن حدوث نتيجة رغم وجود عائق أو ظرف معاكس.',
      rule:'تأتي rağmen بعد الاسم في حالة الاتجاه: yağmura rağmen = رغم المطر. ومع الفعل نستخدم -mesine/-masına rağmen: hasta olmasına rağmen = رغم أنه مريض.',
      term:'yağmura rağmen',meaning:'على الرغم من المطر',sentence:'Yağmura rağmen dışarı çıktık.',translation:'خرجنا رغم المطر.',
      form:'olmasına rağmen',formMeaning:'رغم كونه / رغم حدوثه',
      function:'إظهار التناقض بين عائق والنتيجة التي حدثت.',
      wordChoices:['على الرغم من المطر','بسبب المطر','بعد المطر','قبل المطر'],
      sentenceChoices:['خرجنا رغم المطر.','بقينا في المنزل بسبب المطر.','خرجنا بعد المطر.','خرجنا لكي نرى المطر.'],
      formChoices:['olmasına rağmen','olduğu için','olmak için','olduktan sonra'],
      functionChoices:['التنازل والتعارض','السبب','الغاية','التتابع الزمني'],
      examples:['Yorgun olmasına rağmen çalıştı.|عمل رغم تعبه.','Zorluklara rağmen başardık.|نجحنا رغم الصعوبات.'],
      dialogue:'A: Çok soğuk, neden yürüyorsun? — الجو بارد جداً، لماذا تمشي؟\nB: Soğuğa rağmen yürüyüş yapıyorum. — أتمشى رغم البرد.',
      task:'صف إنجازاً حدث رغم صعوبة ما مستخدماً rağmen.'),
    _lesson(unitId:'b1-u2',number:137,title:'التشابه والمقارنة المتقدمة gibi وkadar وdaha',
      goal:'اختيار أداة التشبيه أو المساواة أو المقارنة بحسب المعنى.',
      rule:'gibi تعني مثل/كـ، kadar تعني بقدر/مثل في الدرجة، وdaha تعني أكثر للمقارنة. أمثلة: senin gibi مثلك، senin kadar سريع مثلك، senden daha hızlı أسرع منك.',
      term:'senin gibi',meaning:'مثلك / على غرارك',sentence:'O da senin gibi düşünüyor.',translation:'هو أيضاً يفكر مثلك.',
      form:'senden daha hızlı',formMeaning:'أسرع منك؛ مقارنة تفاضلية',
      function:'التمييز بين التشبيه والمساواة والمفاضلة.',
      wordChoices:['مثلك','أسرع منك','بقدر ما','بدلاً منك'],
      sentenceChoices:['هو أيضاً يفكر مثلك.','هو يفكر أسرع منك.','هو لا يفكر مثلك.','هو يفكر بسببك.'],
      formChoices:['senden daha hızlı','senin kadar hızlı','senin gibi hızlı','senden hızlılık'],
      functionChoices:['مقارنة تفاضلية','تعبير عن مساواة','تشبيه مباشر','صيغة غير صحيحة'],
      examples:['Kardeşim benim kadar uzun.|أخي بطولي.','Bu yol diğerinden daha kısa.|هذا الطريق أقصر من الآخر.'],
      dialogue:'A: Bu film kitap gibi mi? — هل هذا الفيلم مثل الكتاب؟\nB: Hayır, film kitaptan daha kısa. — لا، الفيلم أقصر من الكتاب.',
      task:'كوّن ثلاث جمل: تشبيه بـ gibi، ومساواة بـ kadar، ومقارنة بـ daha.'),
    _lesson(unitId:'b1-u2',number:138,title:'التعبير عن الدرجة والكمية',
      goal:'استخدام ظروف الدرجة لوصف مقدار الصفة أو الفعل بدقة.',
      rule:'oldukça تعني إلى حد كبير/نوعاً ما بحسب السياق، son derece تعني للغاية، yeterince تعني بما يكفي، fazla تعني أكثر من اللازم. يوضع الظرف غالباً قبل الصفة أو الفعل.',
      term:'son derece',meaning:'للغاية / بدرجة كبيرة جداً',sentence:'Bu konu son derece önemli.',translation:'هذا الموضوع مهم للغاية.',
      form:'yeterince',formMeaning:'بما يكفي أو بالقدر الكافي',
      function:'تحديد درجة الصفة أو مقدار الفعل.',
      wordChoices:['للغاية','نادراً','مبكراً','ببطء'],
      sentenceChoices:['هذا الموضوع مهم للغاية.','هذا الموضوع غير مهم.','هذا الموضوع سهل جداً.','هذا الموضوع قديم.'],
      formChoices:['yeterince','hiçbir zaman','önce','rağmen'],
      functionChoices:['تحديد الدرجة أو الكفاية','تحديد الزمن الماضي','التعبير عن السبب','التعبير عن الشرط'],
      examples:['Yeterince dinlenmedim.|لم أرتح بما يكفي.','Oldukça zor bir sınavdı.|كان امتحاناً صعباً إلى حد كبير.'],
      dialogue:'A: Hazır mısın? — هل أنت مستعد؟\nB: Yeterince hazır olduğumu düşünüyorum. — أعتقد أنني مستعد بما يكفي.',
      task:'صف ثلاثة أشياء باستخدام oldukça وson derece وyeterince.'),
    _lesson(unitId:'b1-u2',number:139,title:'روابط ترتيب الأفكار وتنظيم الكلام',
      goal:'تنظيم الحديث أو الكتابة باستخدام روابط افتتاح وتسلسل وخاتمة.',
      rule:'من الروابط: öncelikle أولاً، ayrıca بالإضافة إلى ذلك، bunun yanında إلى جانب ذلك، son olarak أخيراً. تساعد على ترتيب الحجج وجعل النص واضحاً.',
      term:'öncelikle',meaning:'أولاً / بادئ ذي بدء',sentence:'Öncelikle konuyu açıklayacağım.',translation:'سأشرح الموضوع أولاً.',
      form:'son olarak',formMeaning:'رابط لتقديم النقطة الأخيرة أو الخاتمة',
      function:'تنظيم الأفكار وتسلسلها في الكلام والكتابة.',
      wordChoices:['أولاً / بادئ ذي بدء','أخيراً','رغم ذلك','لأن'],
      sentenceChoices:['سأشرح الموضوع أولاً.','سأشرح الموضوع أخيراً.','لن أشرح الموضوع.','شرحت الموضوع أمس.'],
      formChoices:['son olarak','çünkü','rağmen','belki'],
      functionChoices:['تنظيم وتسلسل الأفكار','إظهار السبب','إظهار التنازل','إظهار الاحتمال'],
      examples:['Ayrıca iki önerim var.|بالإضافة إلى ذلك لدي اقتراحان.','Son olarak sonuçları değerlendirelim.|أخيراً دعونا نقيّم النتائج.'],
      dialogue:'A: Nasıl başlayalım? — كيف نبدأ؟\nB: Öncelikle amacı açıklayalım, ayrıca örnek verelim. — أولاً لنشرح الهدف، ثم نضيف مثالاً.',
      task:'قدّم رأياً من أربع جمل مستخدماً ثلاثة روابط تنظيمية.'),
    _lesson(unitId:'b1-u2',number:140,title:'مراجعة الاحتمال والافتراض والروابط',
      goal:'التمييز بين الاحتمال والاستنتاج والشرط الافتراضي والتنازل والمقارنة.',
      rule:'belki/-abilir للاحتمال، -malı للاستنتاج أو الوجوب حسب السياق، -seydi للشرط الافتراضي الماضي، rağmen للتنازل، وgibi/kadar/daha للمقارنة.',
      term:'olmasına rağmen',meaning:'على الرغم من كونه',sentence:'Hasta olmasına rağmen toplantıya katıldı.',translation:'شارك في الاجتماع رغم أنه مريض.',
      form:'Param olsaydı',formMeaning:'تقديم شرط افتراضي ماضٍ',
      function:'اختيار الأداة التي تعبر عن العلاقة المنطقية الصحيحة.',
      wordChoices:['على الرغم من كونه','لأنه يكون','لكي يكون','بعد أن يكون'],
      sentenceChoices:['شارك في الاجتماع رغم أنه مريض.','شارك في الاجتماع لأنه مريض.','شارك بعد أن مرض.','شارك لكي يمرض.'],
      formChoices:['Param olsaydı','Param var','Param olmalı','Param olduğu için'],
      functionChoices:['شرط افتراضي غير متحقق','ملكية حاضرة','استنتاج','سبب مباشر'],
      examples:['Belki geç kalabilir.|ربما يتأخر.','Daha dikkatli olmalıydım.|كان ينبغي أن أكون أكثر انتباهاً.'],
      dialogue:'A: Sonuç ne olabilir? — ماذا قد تكون النتيجة؟\nB: Belki başarılı oluruz; yeterince çalışmalıyız. — ربما ننجح؛ علينا أن ندرس بما يكفي.',
      task:'اكتب فقرة تجمع احتمالاً واستنتاجاً وشرطاً افتراضياً وتنازلاً.'),
    _lesson(unitId:'b1-u3',number:141,title:'بناء عرض شفهي منظم',
      goal:'تقديم موضوع قصير بمقدمة ونقاط رئيسية وخاتمة واضحة.',
      rule:'ابدأ بـ Bugün ... hakkında konuşacağım (سأتحدث اليوم عن...)، ثم رتّب النقاط بـ öncelikle وikinci olarak، واختم بـ sonuç olarak أو kısacası.',
      term:'hakkında konuşacağım',meaning:'سأتحدث عن',sentence:'Bugün eğitim hakkında konuşacağım.',translation:'سأتحدث اليوم عن التعليم.',
      form:'sonuç olarak',formMeaning:'رابط لتقديم الخلاصة النهائية',
      function:'بناء خطاب منظم بمقدمة وتفاصيل وخاتمة.',
      wordChoices:['سأتحدث عن','سأتوقف عن','سأتحدث بعد','أتحدث بسبب'],
      sentenceChoices:['سأتحدث اليوم عن التعليم.','سأتحدث أمس عن التعليم.','لا أريد الحديث عن التعليم.','سأتحدث رغم التعليم.'],
      formChoices:['sonuç olarak','çünkü','rağmen','belki'],
      functionChoices:['تقديم الخلاصة','تقديم السبب','تقديم التنازل','تقديم الاحتمال'],
      examples:['İlk olarak üç noktayı ele alacağım.|أولاً سأناقش ثلاث نقاط.','Kısacası bu yöntem daha etkili.|باختصار هذه الطريقة أكثر فاعلية.'],
      dialogue:'A: Sunumunun konusu ne? — ما موضوع عرضك؟\nB: Bugün çevre sorunları hakkında konuşacağım. — سأتحدث اليوم عن مشكلات البيئة.',
      task:'قدّم عرضاً شفهياً من دقيقة واحدة عن موضوع تعرفه.'),
    _lesson(unitId:'b1-u3',number:142,title:'وصف مشكلة وتقديم حل',
      goal:'شرح مشكلة وأسبابها وآثارها ثم اقتراح حلول عملية.',
      rule:'استخدم sorun/problem للمشكلة، nedeni للسبب، sonuç/etki للنتيجة، çözüm للحل. اربط الأفكار بـ çünkü وbu nedenle وbuna göre.',
      term:'çözüm',meaning:'حل',sentence:'Bu soruna etkili bir çözüm bulmalıyız.',translation:'ينبغي أن نجد حلاً فعالاً لهذه المشكلة.',
      form:'bu nedenle',formMeaning:'لذلك / لهذا السبب، لربط السبب بالنتيجة',
      function:'شرح علاقة المشكلة بسببها ثم الانتقال إلى حل أو نتيجة.',
      wordChoices:['حل','مشكلة','سبب','نتيجة'],
      sentenceChoices:['ينبغي أن نجد حلاً فعالاً لهذه المشكلة.','ينبغي أن نزيد المشكلة.','لا نعرف المشكلة.','هذه النتيجة غير ممكنة.'],
      formChoices:['bu nedenle','rağmen','gibi','önce'],
      functionChoices:['ربط السبب بالنتيجة','التشبيه','التنازل','التوقيت السابق'],
      examples:['Sorunun nedeni trafik.|سبب المشكلة هو حركة المرور.','Bu nedenle toplu taşıma kullanmalıyız.|لذلك ينبغي أن نستخدم النقل العام.'],
      dialogue:'A: En büyük sorun ne? — ما أكبر مشكلة؟\nB: Zaman kaybı. Bu nedenle plan yapmalıyız. — ضياع الوقت؛ لذلك ينبغي أن نضع خطة.',
      task:'اختر مشكلة يومية واشرح سببها وحلاً مناسباً لها.'),
    _lesson(unitId:'b1-u3',number:143,title:'التعبير عن الأهداف والخطط المستقبلية',
      goal:'شرح هدف شخصي أو مهني وخطوات تحقيقه.',
      rule:'للهدف استخدم amacım ... (هدفي...)، وأفعال المستقبل -acak/-ecek للخطة، و-mek için للغرض: Amacım Türkçemi geliştirmek.',
      term:'amacım',meaning:'هدفي',sentence:'Amacım Türkçemi geliştirmek.',translation:'هدفي هو تطوير لغتي التركية.',
      form:'geliştirmek için',formMeaning:'لكي أطور / من أجل التطوير',
      function:'ذكر الهدف وربطه بخطة أو خطوات مستقبلية.',
      wordChoices:['هدفي','خطتي السابقة','مشكلتي','نتيجتي'],
      sentenceChoices:['هدفي هو تطوير لغتي التركية.','طورت لغتي التركية أمس.','لا أريد تعلم التركية.','هذه مدينتي.'],
      formChoices:['geliştirmek için','geliştirdiğim için','geliştikten sonra','geliştirirken'],
      functionChoices:['التعبير عن الغاية','ذكر السبب الماضي','ترتيب ما بعد الحدث','التزامن'],
      examples:['Gelecek yıl üniversiteye başlayacağım.|سأبدأ الجامعة العام القادم.','Daha iyi konuşmak için pratik yapıyorum.|أتدرب لكي أتحدث بشكل أفضل.'],
      dialogue:'A: Gelecek yıl ne yapacaksın? — ماذا ستفعل العام القادم؟\nB: Yeni bir dil öğrenmek için kursa başlayacağım. — سأبدأ دورة لتعلم لغة جديدة.',
      task:'اشرح هدفاً تريد تحقيقه والخطوات التي ستتخذها.'),
    _lesson(unitId:'b1-u3',number:144,title:'الحديث عن الخبرات والإنجازات',
      goal:'وصف خبرة سابقة وإنجاز وما تعلمته منه.',
      rule:'استخدم -DI للماضي المحدد للأحداث المكتملة، و-miş للخبرة أو المعلومة المنقولة بحسب السياق، مع ifadeler مثل daha önce من قبل وilk kez لأول مرة.',
      term:'daha önce',meaning:'من قبل / سابقاً',sentence:'Daha önce İstanbul’da yaşadım.',translation:'عشت في إسطنبول من قبل.',
      form:'yaşadım',formMeaning:'ماضٍ محدد لتجربة حدثت وانتهت',
      function:'سرد تجربة أو إنجاز سابق بترتيب مفهوم.',
      wordChoices:['من قبل / سابقاً','في المستقبل','في الوقت نفسه','على الرغم من'],
      sentenceChoices:['عشت في إسطنبول من قبل.','سأعيش في إسطنبول.','أعيش الآن في إسطنبول.','لم أزر إسطنبول قط.'],
      formChoices:['yaşadım','yaşayacağım','yaşıyorum','yaşamalıyım'],
      functionChoices:['سرد حدث ماضٍ مكتمل','التعبير عن المستقبل','وصف التزامن','التعبير عن الوجوب'],
      examples:['İlk kez tek başıma seyahat ettim.|سافرت وحدي لأول مرة.','Bu deneyim bana çok şey öğretti.|علمتني هذه التجربة الكثير.'],
      dialogue:'A: Daha önce sunum yaptın mı? — هل قدمت عرضاً من قبل؟\nB: Evet, geçen yıl iki sunum yaptım. — نعم، قدمت عرضين العام الماضي.',
      task:'تحدث عن تجربة أو إنجاز سابق وما الذي تعلمته منه.'),
    _lesson(unitId:'b1-u3',number:145,title:'المبني للمجهول Edilgen Çatı',
      goal:'تركيز الجملة على الفعل أو النتيجة دون ذكر الفاعل.',
      rule:'يُبنى المجهول غالباً بإضافة -ıl/-il/-ul/-ül أو -n بحسب بنية الفعل: açmak → açılmak، yapmak → yapılmak، görmek → görülmek. يتغير التصريف الزمني بعد ذلك.',
      term:'yapıldı',meaning:'تم إنجازه / صُنع',sentence:'Köprü geçen yıl yapıldı.',translation:'بُني الجسر العام الماضي.',
      form:'yapıldı',formMeaning:'ماضٍ مبني للمجهول من yapmak',
      function:'التركيز على الحدث أو المفعول دون تحديد الفاعل.',
      wordChoices:['تم إنجازه / بُني','سيُبنى','يبني','ينبغي أن يبني'],
      sentenceChoices:['بُني الجسر العام الماضي.','سيُبنى الجسر العام القادم.','يبني العمال الجسر الآن.','كان ينبغي بناء الجسر.'],
      formChoices:['yapıldı','yapacak','yapıyor','yapmalı'],
      functionChoices:['مبني للمجهول في الماضي','مبني للمعلوم في المستقبل','مضارع مستمر','ضرورة'],
      examples:['Kapı açıldı.|فُتح الباب.','Yeni kurallar açıklandı.|أُعلنت القواعد الجديدة.'],
      dialogue:'A: Bina ne zaman yapıldı? — متى بُني المبنى؟\nB: 2018 yılında yapıldı. — بُني عام 2018.',
      task:'حوّل ثلاث جمل معلومة بسيطة إلى مبني للمجهول.'),
    _lesson(unitId:'b1-u3',number:146,title:'الأفعال الانعكاسية والمتبادلة',
      goal:'التمييز بين الفعل الذي يعود على فاعله والفعل الذي يحدث بين طرفين.',
      rule:'تُستخدم لاحقة -in/-ın/-un/-ün في بعض الأفعال الانعكاسية مثل giyinmek يرتدي ملابسه وyıkanmak يغتسل. وتُستخدم -iş/-ış/-uş/-üş في أفعال متبادلة مثل görüşmek يتقابل/يتحدث معاً.',
      term:'giyinmek',meaning:'ارتداء الملابس',sentence:'Sabah erken giyiniyorum.',translation:'أرتدي ملابسي باكراً في الصباح.',
      form:'görüşmek',formMeaning:'فعل متبادل يدل على تفاعل طرفين أو أكثر',
      function:'بيان أن الفعل يعود على الفاعل أو يتم بصورة متبادلة.',
      wordChoices:['ارتداء الملابس','الاستحمام','التحدث معاً','الاستيقاظ'],
      sentenceChoices:['أرتدي ملابسي باكراً في الصباح.','أغسل السيارة.','أتحدث مع صديقي أمس.','أذهب إلى المدرسة.'],
      formChoices:['görüşmek','görmek','göstermek','görülmek'],
      functionChoices:['فعل متبادل بين طرفين','فعل مبني للمجهول','فعل سببي','اسم مكان'],
      examples:['Çocuklar bahçede buluştu.|التقى الأطفال في الحديقة.','Her sabah yıkanırım.|أغتسل كل صباح.'],
      dialogue:'A: Arkadaşlarınla ne zaman görüşüyorsun? — متى تلتقي بأصدقائك؟\nB: Genellikle hafta sonları görüşüyoruz. — نلتقي عادةً في عطلة نهاية الأسبوع.',
      task:'اكتب مثالين لفعل انعكاسي ومثالين لفعل متبادل.'),
    _lesson(unitId:'b1-u3',number:147,title:'روابط التقابل oysa وhalbuki وbuna rağmen',
      goal:'إظهار التعارض بين فكرتين أو نتيجة مخالفة للتوقع.',
      rule:'oysa وhalbuki بمعنى «بينما/في حين أن»، وbuna rağmen بمعنى «على الرغم من ذلك»، وaksine بمعنى «على العكس». اختر الرابط وفق نوع التقابل.',
      term:'buna rağmen',meaning:'على الرغم من ذلك',sentence:'Çok yorgundum; buna rağmen çalıştım.',translation:'كنت متعباً جداً؛ ومع ذلك عملت.',
      form:'oysa',formMeaning:'رابط يقدم فكرة مخالفة أو مقارنة متناقضة',
      function:'ربط فكرتين متعارضتين أو إظهار نتيجة غير متوقعة.',
      wordChoices:['على الرغم من ذلك','لذلك','أولاً','ربما'],
      sentenceChoices:['كنت متعباً جداً؛ ومع ذلك عملت.','كنت متعباً لذلك نمت.','أولاً عملت ثم نمت.','ربما أعمل غداً.'],
      formChoices:['oysa','çünkü','sonra','belki'],
      functionChoices:['إظهار التقابل أو التعارض','ذكر السبب','ترتيب الزمن','التعبير عن الاحتمال'],
      examples:['Hava soğuktu, buna rağmen dışarı çıktık.|كان الجو بارداً، ومع ذلك خرجنا.','Ben kahveyi severim, oysa kardeşim çayı tercih eder.|أحب القهوة، بينما يفضل أخي الشاي.'],
      dialogue:'A: Sınav kolay mıydı? — هل كان الامتحان سهلاً؟\nB: Herkes kolay dedi, halbuki bana zor geldi. — قال الجميع إنه سهل، بينما بدا لي صعباً.',
      task:'اربط بين فكرتين متعارضتين باستخدام رابطين مختلفين.'),
    _lesson(unitId:'b1-u3',number:148,title:'التخيير والتناوب ya...ya وister...ister',
      goal:'تقديم خيارين أو بديلين في الجملة.',
      rule:'ya ... ya (da) تعني إما ... أو، وister ... ister تعني سواء ... أو/سواء أكان ... أم. يجب الحفاظ على التوازي بين الخيارين.',
      term:'ya ... ya da',meaning:'إما ... أو',sentence:'Ya otobüsle gidelim ya da yürüyelim.',translation:'إما أن نذهب بالحافلة أو نمشي.',
      form:'ister ... ister',formMeaning:'سواء ... أو، لعرض بديلين دون تفضيل صريح',
      function:'عرض بدائل أو خيارات متعددة.',
      wordChoices:['إما ... أو','ليس ... بل','كلما ... زاد','لا ... ولا'],
      sentenceChoices:['إما أن نذهب بالحافلة أو نمشي.','نذهب بالحافلة لأننا نمشي.','لا نذهب بالحافلة ولا نمشي.','نذهب دائماً مشياً.'],
      formChoices:['ister ... ister','hem ... hem de','ne ... ne de','çünkü ...'],
      functionChoices:['عرض بديلين أو خيارين','الجمع بين شيئين','نفي شيئين','ذكر السبب'],
      examples:['Ya bugün ya yarın görüşelim.|لنلتقِ إما اليوم أو غداً.','İster evde ister dışarıda çalışabilirsin.|يمكنك العمل سواء في المنزل أو خارجه.'],
      dialogue:'A: Nasıl gidelim? — كيف نذهب؟\nB: Ya metroya binelim ya da taksi çağıralım. — إما أن نركب المترو أو نطلب سيارة أجرة.',
      task:'اقترح ثلاثة اختيارات باستخدام ya...ya da وister...ister.'),
    _lesson(unitId:'b1-u3',number:149,title:'الجمع والنفي hem...hem de وne...ne de',
      goal:'الجمع بين عنصرين أو نفيهما معاً.',
      rule:'hem ... hem de تعني كلاهما/ليس هذا فقط بل ذاك أيضاً. ne ... ne de تعني لا ... ولا، وغالباً يبقى الفعل مثبت الشكل مع معنى النفي الذي تحمله البنية.',
      term:'hem ... hem de',meaning:'كلاهما ... وكذلك',sentence:'Hem Türkçe hem de İngilizce öğreniyorum.',translation:'أتعلم التركية والإنجليزية معاً.',
      form:'ne ... ne de',formMeaning:'لا ... ولا، لنفي عنصرين أو أكثر',
      function:'الجمع بين عناصر أو نفيها بصورة مزدوجة.',
      wordChoices:['كلاهما ... وكذلك','إما ... أو','على الرغم من','لأن'],
      sentenceChoices:['أتعلم التركية والإنجليزية معاً.','أتعلم التركية فقط.','لا أتعلم التركية ولا الإنجليزية.','سأتعلم الإنجليزية لاحقاً.'],
      formChoices:['ne ... ne de','ya ... ya da','hem ... hem de','ister ... ister'],
      functionChoices:['نفي عنصرين أو أكثر','عرض خيارين','جمع عنصرين مثبتين','ذكر السبب'],
      examples:['Hem çalışıyor hem de okuyor.|يعمل ويدرس في الوقت نفسه.','Ne kahve ne de çay istiyorum.|لا أريد القهوة ولا الشاي.'],
      dialogue:'A: Kahve mi çay mı? — قهوة أم شاي؟\nB: Ne kahve ne de çay; su istiyorum. — لا قهوة ولا شاي؛ أريد ماءً.',
      task:'اكتب جملتين: واحدة للجمع بـ hem، وأخرى للنفي بـ ne.'),
    _lesson(unitId:'b1-u3',number:150,title:'اختبار شامل ومراجعة تمهيدية للمستوى B1',
      goal:'دمج القواعد والروابط والتراكيب في فهم نص ومحادثة وإنتاج لغوي متماسك.',
      rule:'راجع الجمل التابعة -DIK، ونقل الكلام، وروابط السبب والغاية والزمن، والاحتمال والشرط والتنازل، والمبني للمجهول، والروابط الخطابية. اختر التركيب بحسب العلاقة التي تريد التعبير عنها.',
      term:'kısacası',meaning:'باختصار / خلاصة القول',sentence:'Kısacası, düzenli pratik çok önemlidir.',translation:'باختصار، التدريب المنتظم مهم جداً.',
      form:'düzenli pratik',formMeaning:'تركيب اسمي يصف ممارسة منتظمة',
      function:'تلخيص الأفكار وتقديم استنتاج نهائي واضح.',
      wordChoices:['باختصار / خلاصة القول','على الرغم من ذلك','أولاً','ربما'],
      sentenceChoices:['باختصار، التدريب المنتظم مهم جداً.','التدريب غير مهم.','ربما نتدرب غداً.','تدربت قبل أن أصل.'],
      formChoices:['düzenli pratik','düzensiz pratik','pratikten sonra','pratik yapmak için'],
      functionChoices:['تلخيص الفكرة أو النتيجة','ذكر السبب','التعبير عن الشرط','تحديد التزامن'],
      examples:['Öğrendiğimi günlük hayatta kullanıyorum.|أستخدم ما تعلمته في الحياة اليومية.','Daha akıcı konuşmak için düzenli pratik yapıyorum.|أتدرب بانتظام لكي أتحدث بطلاقة أكبر.'],
      dialogue:'A: B1 seviyesinde ne yapabilirsin? — ماذا تستطيع أن تفعل في مستوى B1؟\nB: Fikirlerimi açıklayabilir, deneyimlerimi anlatabilir ve neden-sonuç ilişkisi kurabilirim. — أستطيع شرح أفكاري وسرد تجاربي وربط السبب بالنتيجة.',
      task:'قدّم حديثاً من دقيقتين يجمع وصف تجربة وسبباً وهدفاً واحتمالاً وخلاصة.'),
  ];

  static B1Lesson? find(String unitId, int lessonNumber) {
    for (final lesson in lessons) {
      if (lesson.unitId == unitId && lesson.lessonNumber == lessonNumber) return lesson;
    }
    return null;
  }
}

class B1LessonScreen extends StatefulWidget {
  const B1LessonScreen({
    super.key, required this.unitId, required this.unitTitle,
    required this.lessonTitle, required this.lessonNumber,
  });
  final String unitId, unitTitle, lessonTitle;
  final int lessonNumber;
  @override
  State<B1LessonScreen> createState() => _B1LessonScreenState();
}

class _B1LessonScreenState extends State<B1LessonScreen> {
  final Map<int, int> answers = {};
  bool checked = false;
  bool saving = false;

  Future<void> _submit(B1Lesson lesson) async {
    if (answers.length != lesson.questions.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('أجب عن الأسئلة الخمسة أولاً.')));
      return;
    }
    setState(() => saving = true);
    final score = lesson.questions.asMap().entries
        .where((entry) => answers[entry.key] == entry.value.answer).length;
    final lessonId = '${widget.unitId}-${widget.lessonNumber}';
    await LearningProgress.recordAttempt(lessonId);
    for (var i = 0; i < lesson.questions.length; i++) {
      final q = lesson.questions[i];
      if (answers[i] != q.answer) {
        await LearningProgress.recordMissedQuestionDetails(
          prompt: q.prompt,
          selectedAnswer: q.options[answers[i]!],
          correctAnswer: q.options[q.answer],
          explanation: q.explanation,
          topic: lesson.title,
          unitId: widget.unitId,
          lessonNumber: widget.lessonNumber,
          lessonTitle: lesson.title,
          source: 'B1 lesson',
        );
      }
    }
    if (score >= 4) await LearningProgress.completeLesson(lessonId);
    if (!mounted) return;
    setState(() { checked = true; saving = false; });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('نتيجتك: $score من ${lesson.questions.length} — ${score >= 4 ? "تم تسجيل إكمال الدرس" : "أعد المحاولة للوصول إلى 4 إجابات صحيحة"}')));
  }

  @override
  Widget build(BuildContext context) {
    final lesson = B1CourseData.find(widget.unitId, widget.lessonNumber);
    if (lesson == null) {
      return Scaffold(appBar: AppBar(title: const Text('درس B1')),
        body: const Center(child: Text('لم يتم العثور على محتوى الدرس.')));
    }
    final score = lesson.questions.asMap().entries
        .where((entry) => answers[entry.key] == entry.value.answer).length;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FC),
      appBar: AppBar(title: Text('B1 • الدرس ${lesson.globalNumber}'),
        backgroundColor: Colors.white, foregroundColor: AppColors.darkGreen, elevation: 0),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 30),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF102B52), Color(0xFF2676B8)]),
              borderRadius: BorderRadius.circular(22)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('LESSON ${lesson.globalNumber} • B1', textDirection: TextDirection.ltr,
                style: const TextStyle(color: Color(0xFFFFD98A), fontWeight: FontWeight.w900, fontSize: 11)),
              const SizedBox(height: 8),
              Text(lesson.title, textAlign: TextAlign.right,
                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
              const SizedBox(height: 8),
              Text(lesson.goal, textAlign: TextAlign.right,
                style: const TextStyle(color: Colors.white70, height: 1.7)),
            ]),
          ),
          const SizedBox(height: 13),
          _section('القاعدة والشرح', lesson.rule),
          _examples(lesson.examples),
          _section('محادثة تطبيقية', lesson.dialogue),
          _section('مهمة التحدث', lesson.speakingTask),
          const SizedBox(height: 10),
          Text('اختبر فهمك • ${lesson.questions.length} أسئلة',
            textAlign: TextAlign.right,
            style: const TextStyle(color: AppColors.darkGreen, fontSize: 18, fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          ...lesson.questions.asMap().entries.map((entry) {
            final index = entry.key;
            final q = entry.value;
            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  Text('السؤال ${index + 1}', textAlign: TextAlign.right,
                    style: const TextStyle(color: AppColors.green, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 7),
                  Text(q.prompt, textAlign: TextAlign.right,
                    style: const TextStyle(color: AppColors.darkGreen, fontWeight: FontWeight.w800, height: 1.6)),
                  const SizedBox(height: 6),
                  ...q.options.asMap().entries.map((option) {
                    final chosen = answers[index] == option.key;
                    final isCorrect = checked && option.key == q.answer;
                    return InkWell(
                      borderRadius: BorderRadius.circular(11),
                      onTap: checked ? null : () => setState(() => answers[index] = option.key),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        padding: const EdgeInsets.all(11),
                        decoration: BoxDecoration(
                          color: isCorrect ? const Color(0xFFE8F7EF) : chosen ? const Color(0xFFEAF2FF) : const Color(0xFFF7F9FC),
                          borderRadius: BorderRadius.circular(11),
                          border: Border.all(color: isCorrect ? const Color(0xFF279765) : chosen ? AppColors.navy : const Color(0xFFE7ECF3))),
                        child: Row(children: [
                          Icon(chosen ? Icons.radio_button_checked : Icons.radio_button_off,
                            color: chosen ? AppColors.navy : AppColors.muted, size: 18),
                          const SizedBox(width: 9),
                          Expanded(child: Text(option.value, textAlign: TextAlign.right,
                            style: const TextStyle(color: AppColors.darkGreen, fontSize: 12))),
                        ]),
                      ),
                    );
                  }),
                  if (checked) ...[
                    const SizedBox(height: 4),
                    Text(answers[index] == q.answer ? 'إجابة صحيحة ✓' : 'الإجابة الصحيحة: ${q.options[q.answer]}',
                      textAlign: TextAlign.right,
                      style: TextStyle(color: answers[index] == q.answer ? const Color(0xFF279765) : const Color(0xFFB45309), fontWeight: FontWeight.w800)),
                    Text(q.explanation, textAlign: TextAlign.right,
                      style: const TextStyle(color: AppColors.muted, height: 1.5, fontSize: 11)),
                  ],
                ]),
              ),
            );
          }),
          const SizedBox(height: 8),
          if (!checked)
            FilledButton.icon(
              onPressed: saving ? null : () => _submit(lesson),
              icon: saving ? const SizedBox(width:16,height:16,child:CircularProgressIndicator(strokeWidth:2,color:Colors.white)) : const Icon(Icons.check_circle_outline),
              label: const Text('تصحيح الاختبار وحفظ التقدم'),
              style: FilledButton.styleFrom(backgroundColor: AppColors.navy, padding: const EdgeInsets.symmetric(vertical: 14)),
            )
          else ...[
            Text('النتيجة: $score / ${lesson.questions.length}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.darkGreen, fontWeight: FontWeight.w900, fontSize: 18)),
            OutlinedButton.icon(
              onPressed: () => setState(() { answers.clear(); checked = false; }),
              icon: const Icon(Icons.refresh_rounded), label: const Text('إعادة الاختبار'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _section(String title, String body) => Card(
    color: Colors.white, margin: const EdgeInsets.only(bottom: 10),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
    child: Padding(padding: const EdgeInsets.all(15), child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text(title, textAlign: TextAlign.right,
          style: const TextStyle(color: AppColors.darkGreen, fontWeight: FontWeight.w900, fontSize: 15)),
        const SizedBox(height: 7),
        Text(body, textAlign: TextAlign.right,
          style: const TextStyle(color: AppColors.muted, height: 1.8, fontSize: 12)),
      ])),
  );

  Widget _examples(List<String> examples) => Card(
    color: Colors.white, margin: const EdgeInsets.only(bottom: 10),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
    child: Padding(padding: const EdgeInsets.all(15), child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const Text('أمثلة تركية مع الترجمة', textAlign: TextAlign.right,
          style: TextStyle(color: AppColors.darkGreen, fontWeight: FontWeight.w900, fontSize: 15)),
        const SizedBox(height: 8),
        ...examples.map((item) {
          final parts = item.split('|');
          return Padding(padding: const EdgeInsets.only(bottom: 9), child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Text(parts.first, textDirection: TextDirection.ltr, textAlign: TextAlign.left,
                style: const TextStyle(color: AppColors.navy, fontWeight: FontWeight.w800, fontSize: 13)),
              const SizedBox(height: 3),
              Text(parts.length > 1 ? parts[1] : '', textAlign: TextAlign.right,
                style: const TextStyle(color: AppColors.muted, fontSize: 11)),
            ]));
        }),
      ])),
  );
}
