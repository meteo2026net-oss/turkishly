import 'package:flutter_test/flutter_test.dart';
import 'package:turkishly/data/c2_course_data.dart';
import 'package:turkishly/data/course_catalog.dart';
void main(){
 group('C2 lessons 731-930',(){
  final batch=C2CourseData.lessons.where((e)=>e.globalNumber>=731&&e.globalNumber<=930).toList();
  test('C2 has 510 lessons and the new range is continuous',(){
   expect(C2CourseData.lessons,hasLength(780));expect(batch,hasLength(200));
   expect(batch.map((e)=>e.globalNumber).toSet(),Set<int>.from(List<int>.generate(200,(i)=>731+i)));
  });
  test('twenty new units each have ten lessons',(){
   for(var n=32;n<=51;n++){final id='c2-u$n';final u=CourseCatalog.units.firstWhere((e)=>e.id==id);
    expect(u.level,'C2');expect(u.lessons,hasLength(10));
    for(var i=1;i<=10;i++){expect(C2CourseData.find(id,i),isNotNull,reason:'$id lesson $i');}
   }
  });
  test('every new lesson has objectives, examples, dialogue, task and five four-choice questions',(){
   for(final l in batch){expect(l.title,isNotEmpty);expect(l.goal,isNotEmpty);expect(l.rule,isNotEmpty);expect(l.examples,hasLength(2));expect(l.dialogue,isNotEmpty);expect(l.speakingTask,isNotEmpty);expect(l.questions,hasLength(5));
    for(final q in l.questions){expect(q.options,hasLength(4));expect(q.options.toSet(),hasLength(4));expect(q.answer,inInclusiveRange(0,3));expect(q.explanation,isNotEmpty);}
   }
  });
 });
}