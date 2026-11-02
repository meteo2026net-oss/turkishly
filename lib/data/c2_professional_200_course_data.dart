import 'b1_course_data.dart';
class C2Professional200CourseData {
 static B1Lesson _build(_LessonSpec s) {
  final tr='Bu çalışmada ${s.title} konusu kanıta dayalı biçimde değerlendirildi.';
  final ar='تناولنا موضوع ${s.title} في هذا الدرس بالتحليل والاستناد إلى الأدلة.';
  final task='أعد دراسة تطبيقية حول «${s.title}» ضمن مجال ${s.theme}، وحدد المشكلة والمعايير والنتائج والتوصيات باللغة التركية.';
  final options=[s.title,'التعبير عن المكان','الزمن الماضي','طلب الإذن'];
  final distract=['لم يبدأ الاجتماع بعد.','سأعود إلى المنزل غداً.','لا تتضمن الجملة هذا المعنى.'];
  final form='ileri uzmanlık yaklaşımı';
  final questions=<B1Question>[
   B1Question('ما موضوع الدرس؟',options,s.n%4,'الموضوع هو ${s.title} ضمن ${s.theme}.'),
   B1Question('ما المعنى الذي تنقله الجملة التركية؟',[ar,...distract],(s.n+1)%4,'المعنى: ${ar}'),
   B1Question('اختر التعبير المرتبط بالمجال.',[form,'geçmiş zaman','istek kipi','yer tamlayıcısı'],(s.n+2)%4,'التعبير المستهدف: ${form}.'),
   B1Question('ما المهارة المطلوبة؟',['تحليل ${s.title}','تحديد المكان فقط','تغيير الزمن فقط','طلب السعر'],(s.n+3)%4,'تحليل الموضوع وتطبيقه ضمن المجال التخصصي.'),
   B1Question('أي مهمة تثبت اكتساب المهارة؟',[task,'حفظ كلمات دون سياق','نسخ نص دون فهم','تجاهل الأدلة'],(s.n+1)%4,task)
  ];
  final shifted=<B1Question>[];
  for(var i=0;i<questions.length;i++){final q=questions[i];final k=(i+s.n)%4;final rotated=List<String>.generate(4,(j)=>q.options[(j-k+4)%4]);shifted.add(B1Question(q.prompt,rotated,k,q.explanation));}
  return B1Lesson(unitId:s.id,globalNumber:s.n,title:s.title,goal:'إتقان ${s.title} وتحليل تطبيقاته ضمن ${s.theme}.',rule:'يعالج هذا الدرس ${s.title} بوصفه مفهوماً تخصصياً. ابدأ بتحديد السياق والمشكلة، ثم افحص الأدلة والمعايير والبدائل، واختم باستنتاج محدود بما تسمح به البيانات.',examples:['${tr} | ${ar}','Farklı seçenekleri ölçütlere göre karşılaştırdık. | قارنا البدائل وفق معايير محددة.'],dialogue:'A: ${s.title} nasıl ele alınmalı? — كيف ينبغي تناول هذا الموضوع؟\nB: Önce bağlamı ve ölçütleri belirlemeliyiz. — ينبغي أولاً تحديد السياق والمعايير.',speakingTask:task,questions:shifted);
 }
 static final List<B1Lesson> lessons=_specs.map(_build).toList(growable:false);
 static final List<_LessonSpec> _specs=[
$data
 ];
}
class _LessonSpec {const _LessonSpec(this.id,this.n,this.title,this.theme,this.area);final String id,title,theme,area;final int n;}
