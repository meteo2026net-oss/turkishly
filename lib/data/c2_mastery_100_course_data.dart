import 'b1_course_data.dart';

class C2Mastery100CourseData {
 static List<String> _rotate(List<String> v,int a)=>List<String>.generate(v.length,(i)=>v[(i-a+v.length)%v.length]);
 static B1Question _q(String p,List<String> o,int a,String e)=>B1Question(p,_rotate(o,a),a,e);
 static B1Lesson _build(_D d)=>B1Lesson(
  unitId:d.unit,globalNumber:d.n,title:d.title,
  goal:'إتقان موضوع «${d.title}» وتوظيف مصطلحاته في سياق تركي متخصص.',
  rule:'المصطلح «${d.term}» يشير إلى «${d.meaning}». افهمه في سياقه، واربطه بوظيفته وحدوده وأدلته.',
  examples:['${d.tr} | ${d.ar}',d.example],dialogue:d.dialogue,speakingTask:d.task,
  questions:[
   _q('ما المقصود بموضوع «${d.term}»؟',[d.meaning,'التعبير عن المكان','التعبير عن الزمن الماضي','طلب الإذن'],d.n%4,'المقصود هو: ${d.meaning}.'),
   _q('ما الترجمة الأدق للجملة التركية؟',[d.ar,'لم يبدأ الاجتماع بعد.','سأعود إلى المنزل غداً.','لا تتضمن الجملة هذا المعنى.'],(d.n+1)%4,d.ar),
   _q('أي صيغة ترتبط مباشرة بموضوع الدرس؟',[d.form,'geçmiş zaman','istek kipi','yer tamlayıcısı'],(d.n+2)%4,'الصيغة المستهدفة: ${d.form}.'),
   _q('ما الوظيفة التطبيقية للمهارة؟',[d.fn,'تحديد المكان فقط','تغيير زمن الجملة فقط','طلب السعر'],(d.n+3)%4,d.fn),
   _q('أي نشاط يثبت اكتساب المهارة؟',[d.task,'حفظ كلمات دون سياق','نسخ نص دون فهم','تجاهل القرائن'],(d.n+1)%4,d.task),
  ]);
 static final List<B1Lesson> lessons=_data.map(_build).toList(growable:false);
 static final List<_D> _data=[
$data
 ];
}
class _D{
 const _D(this.unit,this.n,this.title,this.term,this.meaning,this.tr,this.ar,this.form,this.fn,this.task,this.example,this.dialogue);
 final String unit,title,term,meaning,tr,ar,form,fn,task,example,dialogue; final int n;
}
