import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class VisualVocabularyScreen extends StatefulWidget { const VisualVocabularyScreen({super.key}); @override State<VisualVocabularyScreen> createState()=>_VisualVocabularyScreenState(); }
class _VisualVocabularyScreenState extends State<VisualVocabularyScreen>{
 static const _words=<({String tr,String ar,String image,String example,String translation})>[
(tr:"Masa",ar:"طاولة",image:'assets/images/vocabulary/table.svg',example:"Masa odanın ortasında.",translation:"الطاولة في وسط الغرفة."),
(tr:"Sandalye",ar:"كرسي",image:'assets/images/vocabulary/chair.svg',example:"Bir sandalye alabilir miyim?",translation:"هل يمكنني أخذ كرسي؟"),
(tr:"Kitap",ar:"كتاب",image:'assets/images/vocabulary/book.svg',example:"Bu kitap çok ilginç.",translation:"هذا الكتاب ممتع جداً."),
(tr:"Kalem",ar:"قلم",image:'assets/images/vocabulary/pen.svg',example:"Mavi kalemim nerede?",translation:"أين قلمي الأزرق؟"),
(tr:"Ev",ar:"منزل",image:'assets/images/vocabulary/house.svg',example:"Evimiz çok güzel.",translation:"منزلنا جميل جداً."),
(tr:"Araba",ar:"سيارة",image:'assets/images/vocabulary/car.svg',example:"Araba kapının önünde.",translation:"السيارة أمام الباب."),
(tr:"Su",ar:"ماء",image:'assets/images/vocabulary/water.svg',example:"Bir bardak su istiyorum.",translation:"أريد كأس ماء."),
(tr:"Ekmek",ar:"خبز",image:'assets/images/vocabulary/bread.svg',example:"Taze ekmek aldım.",translation:"اشتريت خبزاً طازجاً."),
(tr:"Elma",ar:"تفاحة",image:'assets/images/vocabulary/apple.svg',example:"Kırmızı bir elma yiyorum.",translation:"آكل تفاحة حمراء."),
(tr:"Bardak",ar:"كأس",image:'assets/images/vocabulary/glass.svg',example:"Bardak masanın üzerinde.",translation:"الكأس فوق الطاولة."),
(tr:"Kapı",ar:"باب",image:'assets/images/vocabulary/door.svg',example:"Kapıyı lütfen kapat.",translation:"أغلق الباب من فضلك."),
(tr:"Pencere",ar:"نافذة",image:'assets/images/vocabulary/window.svg',example:"Pencere açık.",translation:"النافذة مفتوحة."),
(tr:"Telefon",ar:"هاتف",image:'assets/images/vocabulary/phone.svg',example:"Telefonum çantamda.",translation:"هاتفي في حقيبتي."),
(tr:"Çanta",ar:"حقيبة",image:'assets/images/vocabulary/bag.svg',example:"Çantam çok ağır.",translation:"حقيبتي ثقيلة جداً."),
(tr:"Anahtar",ar:"مفتاح",image:'assets/images/vocabulary/key.svg',example:"Anahtar masanın üzerinde.",translation:"المفتاح فوق الطاولة."),
(tr:"Saat",ar:"ساعة",image:'assets/images/vocabulary/clock.svg',example:"Saat kaç?",translation:"كم الساعة؟")
 ];
 final _random=Random(); int _index=0; int? _selected; bool _reading=false; late List<int> _options;
 @override void initState(){super.initState();_makeOptions();}
 void _makeOptions(){final s=<int>{_index};while(s.length<4){s.add(_random.nextInt(_words.length));}_options=s.toList()..shuffle(_random);_selected=null;_reading=false;}
 void _next(){setState((){_index=(_index+1)%_words.length;_makeOptions();});}
 @override Widget build(BuildContext context){final w=_words[_index];final answered=_selected!=null;final correct=answered&&_selected==_index;return Scaffold(backgroundColor:const Color(0xFFF5F7FC),appBar:AppBar(title:const Text('التدريب بالصور'),backgroundColor:Colors.white,foregroundColor:AppColors.darkGreen,elevation:0),body:SafeArea(child:ListView(padding:const EdgeInsets.all(18),children:[
 Container(padding:const EdgeInsets.all(17),decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(20),border:Border.all(color:AppColors.border)),child:Column(crossAxisAlignment:CrossAxisAlignment.end,children:[const Text('اختر الكلمة التركية المناسبة للصورة',style:TextStyle(color:AppColors.darkGreen,fontSize:19,fontWeight:FontWeight.w900)),const SizedBox(height:5),const Text('انظر إلى الصورة، فكّر، ثم اختر الإجابة أو تدرب على قراءة الكلمة.',textAlign:TextAlign.right,style:TextStyle(color:AppColors.muted,height:1.6)),const SizedBox(height:12),LinearProgressIndicator(value:(_index+1)/_words.length,minHeight:7,borderRadius:BorderRadius.circular(8)),const SizedBox(height:7),Text('الصورة ${_index+1} من ${_words.length}',style:const TextStyle(color:AppColors.muted,fontSize:12))]),
 const SizedBox(height:15),Container(padding:const EdgeInsets.all(14),decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(24),boxShadow:[BoxShadow(color:AppColors.navy.withValues(alpha:.07),blurRadius:18,offset:const Offset(0,6))]),child:Column(children:[ClipRRect(borderRadius:BorderRadius.circular(18),child:Image.asset(w.image,height:245,width:double.infinity,fit:BoxFit.contain,errorBuilder:(_,__,___)=>const SizedBox(height:200,child:Icon(Icons.image_not_supported_outlined,size:60)))),const SizedBox(height:12),if(_reading)...[Text(w.tr,textDirection:TextDirection.ltr,style:const TextStyle(fontSize:30,fontWeight:FontWeight.w900,color:AppColors.navy)),Text(w.ar,style:const TextStyle(fontSize:18,color:AppColors.muted)),Text(w.example,textDirection:TextDirection.ltr,textAlign:TextAlign.center,style:const TextStyle(color:AppColors.navy,fontWeight:FontWeight.w700)),Text(w.translation,style:const TextStyle(color:AppColors.muted))]else const Text('ما اسم هذا الشيء باللغة التركية؟',style:TextStyle(color:AppColors.darkGreen,fontWeight:FontWeight.w800))])),
 const SizedBox(height:14),..._options.map((i){final option=_words[i];final chosen=_selected==i;final isCorrect=answered&&i==_index;final wrong=chosen&&!correct;return Padding(padding:const EdgeInsets.only(bottom:9),child:OutlinedButton(onPressed:answered?null:()=>setState(()=>_selected=i),style:OutlinedButton.styleFrom(minimumSize:const Size.fromHeight(56),backgroundColor:isCorrect?const Color(0xFFE5F7EC):wrong?const Color(0xFFFFECEC):Colors.white,foregroundColor:isCorrect?const Color(0xFF187A45):wrong?Colors.red:AppColors.navy,side:BorderSide(color:isCorrect?const Color(0xFF2BA568):wrong?Colors.red:AppColors.border,width:chosen?2:1),shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(15))),child:Text(option.tr,textDirection:TextDirection.ltr,style:const TextStyle(fontSize:19,fontWeight:FontWeight.w900))));}),
 if(answered)Container(padding:const EdgeInsets.all(14),decoration:BoxDecoration(color:correct?const Color(0xFFE5F7EC):const Color(0xFFFFF2E4),borderRadius:BorderRadius.circular(15)),child:Text(correct?'Doğru! • إجابة صحيحة':'Doğru cevap: ${w.tr} • الإجابة الصحيحة: ${w.ar}',textAlign:TextAlign.center,style:TextStyle(color:correct?const Color(0xFF187A45):const Color(0xFF9A5B12),fontWeight:FontWeight.w900))),
 const SizedBox(height:12),Row(children:[Expanded(child:OutlinedButton.icon(onPressed:()=>setState(()=>_reading=!_reading),icon:const Icon(Icons.menu_book_rounded),label:Text(_reading?'إخفاء القراءة':'تدرب على القراءة'),style:OutlinedButton.styleFrom(minimumSize:const Size.fromHeight(52),foregroundColor:AppColors.navy))),const SizedBox(width:10),Expanded(child:FilledButton.icon(onPressed:answered?_next:null,icon:const Icon(Icons.arrow_back_rounded),label:const Text('التالي'),style:FilledButton.styleFrom(minimumSize:const Size.fromHeight(52),backgroundColor:AppColors.navy)))])
])));}
}
