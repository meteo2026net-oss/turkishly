import 'b1_course_data.dart';
class C2CompletionData {
 static B1Question _question(String prompt,List<String> choices,int answer,String why)=>B1Question(prompt,List<String>.generate(4,(i)=>choices[(i-answer+4)%4]),answer,why);
 static B1Lesson _lesson(_S s){
  final tr='Bu derste ${s.title} konusu uzmanlık bağlamında incelenir.';
  final ar='يتناول هذا الدرس ${s.title} ضمن سياق ${s.theme}.';
  final task='أعد تحليلاً تطبيقياً لموضوع «${s.title}» ضمن ${s.theme}. اعرض السياق والمشكلة والمعايير والأدلة والبدائل، ثم قدم استنتاجاً وتوصية باللغة التركية.';
  final dialogue='A: ${s.title} konusunda hangi ölçütler kullanılmalı? — ما المعايير التي ينبغي استخدامها في هذا الموضوع؟\nB: Bağlamı, kanıtları ve olası sonuçları birlikte değerlendirmeliyiz. — ينبغي تقييم السياق والأدلة والنتائج المحتملة معاً.';
  return B1Lesson(unitId:s.unit,globalNumber:s.n,title:s.title,goal:'إتقان مفردات ومفاهيم ${s.title} وتوظيفها في نقاش تركي متقدم.',rule:'عند مناقشة ${s.title}، ابدأ بتحديد المجال والسياق، ثم عرّف المصطلحات بدقة، وافصل بين الوقائع والتفسيرات، وقارن البدائل وفق معايير معلنة، واختم باستنتاج متوازن تدعمه الأدلة.',examples:['${tr} | ${ar}','Farklı yaklaşımları ortak ölçütlere göre karşılaştırdık. | قارنا المناهج المختلفة وفق معايير مشتركة.'],dialogue:dialogue,speakingTask:task,questions:[
 _question('ما الموضوع المحوري للدرس؟',['${s.title}','وصف مكان سياحي','الحديث عن عطلة سابقة','طلب شراء منتج'],0,'الموضوع المحوري هو ${s.title} ضمن ${s.theme}.'),
 _question('ما المعنى الأقرب للجملة التركية؟',['يتناول هذا الدرس ${s.title} ضمن سياق ${s.theme}.','سأزور صديقي الأسبوع القادم.','الطقس بارد في الصباح.','أين تقع محطة القطار؟'],0,'الجملة تقدم موضوع الدرس وسياقه التخصصي.'),
 _question('أي تعبير تركي يناسب الكتابة التخصصية؟',['kanıta dayalı değerlendirme','dün akşam','çok güzel bir ev','nerede oturuyorsun'],0,'التقييم القائم على الأدلة تعبير مناسب للسياق الأكاديمي.'),
 _question('ما الخطوة المنهجية التي تسبق إصدار التوصية؟',['تحليل الأدلة والمعايير','تجاهل المعطيات','اختيار النتيجة مسبقاً','حذف البدائل'],0,'يجب تحليل الأدلة والمعايير قبل التوصية.'),
 _question('أي مهمة تقيس توظيف المفهوم في سياق حقيقي؟',[task,'حفظ عنوان الدرس فقط','نسخ جملة دون تفسير','قراءة الخيارات دون اختيار'],0,'المهمة التطبيقية تتطلب تحليلاً وحجة وتوصية.')]);
 }
 static final List<B1Lesson> lessons=_specs.map(_lesson).toList(growable:false);
 static final List<_S> _specs=[
$lines
];
}
class _S {const _S(this.unit,this.n,this.title,this.theme,this.area);final String unit,title,theme,area;final int n;}
