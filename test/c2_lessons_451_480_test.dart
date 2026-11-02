import 'package:flutter_test/flutter_test.dart';
import 'package:turkishly/data/c2_course_data.dart';
import 'package:turkishly/data/course_catalog.dart';
void main(){group('C2 lessons 451-480',(){
 test('C2 contains sixty lessons and new lessons have continuous numbering',(){expect(C2CourseData.lessons,hasLength(90));final l=C2CourseData.lessons.where((e)=>e.globalNumber>=451&&e.globalNumber<=480).toList();expect(l,hasLength(30));final n=l.map((e)=>e.globalNumber).toList()..sort();expect(n,List<int>.generate(30,(i)=>451+i));});
 test('C2 units four through six expose ten lessons each',(){for(var u=4;u<=6;u++){final id='c2-u$u';final unit=CourseCatalog.units.firstWhere((e)=>e.id==id);expect(unit.level,'C2');expect(unit.lessons,hasLength(10));for(var i=1;i<=10;i++){expect(C2CourseData.find(id,i),isNotNull,reason:'$id lesson $i');}}});
 test('all new lessons have complete content and five varied questions',(){for(final l in C2CourseData.lessons.where((e)=>e.globalNumber>=451&&e.globalNumber<=480)){expect(l.questions,hasLength(5));expect(l.questions.map((q)=>q.answer).toSet().length,greaterThan(1));expect(l.examples,hasLength(2));expect(l.dialogue,isNotEmpty);expect(l.speakingTask,isNotEmpty);for(final q in l.questions){expect(q.options,hasLength(4));expect(q.options.toSet(),hasLength(4));expect(q.answer,inInclusiveRange(0,3));expect(q.explanation,isNotEmpty);}}});
});}
