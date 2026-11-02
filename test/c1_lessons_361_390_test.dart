import 'package:flutter_test/flutter_test.dart';
import 'package:turkishly/data/c1_course_data.dart';
import 'package:turkishly/data/course_catalog.dart';
void main(){group('C1 lessons 361-390',(){
 test('C1 now contains ninety lessons and the new thirty have unique numbering',(){expect(C1CourseData.lessons,hasLength(120));final l=C1CourseData.lessons.where((e)=>e.globalNumber>=361&&e.globalNumber<=390).toList();expect(l,hasLength(30));final n=l.map((e)=>e.globalNumber).toList()..sort();expect(n,List<int>.generate(30,(i)=>361+i));});
 test('C1 units seven through nine expose ten lessons each',(){for(var u=7;u<=9;u++){final id='c1-u$u';final unit=CourseCatalog.units.firstWhere((e)=>e.id==id);expect(unit.level,'C1');expect(unit.lessons,hasLength(10));for(var i=1;i<=10;i++){expect(C1CourseData.find(id,i),isNotNull);}}});
 test('all new lessons have complete content and five valid varied questions',(){for(final l in C1CourseData.lessons.where((e)=>e.globalNumber>=361&&e.globalNumber<=390)){expect(l.questions,hasLength(5));expect(l.questions.map((q)=>q.answer).toSet().length,greaterThan(1));expect(l.examples,hasLength(2));expect(l.dialogue,isNotEmpty);expect(l.speakingTask,isNotEmpty);for(final q in l.questions){expect(q.options,hasLength(4));expect(q.options.toSet(),hasLength(4));expect(q.answer,inInclusiveRange(0,3));expect(q.explanation,isNotEmpty);}}});
});}
