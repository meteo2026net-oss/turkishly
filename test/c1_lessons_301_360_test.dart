import 'package:flutter_test/flutter_test.dart';
import 'package:turkishly/data/c1_course_data.dart';
import 'package:turkishly/data/course_catalog.dart';
void main(){group('C1 lessons 301-360',(){
 test('sixty lessons have continuous unique global numbering',(){final l=C1CourseData.lessons.where((e)=>e.globalNumber>=301&&e.globalNumber<=360).toList();expect(l,hasLength(60));final n=l.map((e)=>e.globalNumber).toList()..sort();expect(n,List<int>.generate(60,(i)=>301+i));});
 test('six units expose ten lessons through lookup',(){for(var u=1;u<=6;u++){final id='c1-u$u';final c=CourseCatalog.units.firstWhere((e)=>e.id==id);expect(c.level,'C1');expect(c.lessons,hasLength(10));for(var i=1;i<=10;i++){expect(C1CourseData.find(id,i),isNotNull);}}});
 test('every lesson has complete examples, dialogue, task and five valid questions',(){for(final l in C1CourseData.lessons){expect(l.questions,hasLength(5),reason:l.title);expect(l.questions.map((q)=>q.answer).toSet().length,greaterThan(1),reason:l.title);expect(l.examples,hasLength(2));expect(l.examples.every((e)=>e.trim().isNotEmpty),isTrue);expect(l.dialogue.trim(),isNotEmpty);expect(l.speakingTask.trim(),isNotEmpty);for(final q in l.questions){expect(q.options,hasLength(4));expect(q.options.toSet(),hasLength(4));expect(q.answer,inInclusiveRange(0,3));expect(q.explanation.trim(),isNotEmpty);}}});
});}
