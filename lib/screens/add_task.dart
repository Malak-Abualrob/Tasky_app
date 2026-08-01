import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/task_model.dart';


// شاشة إضافة Task جديدة
class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}


// هون بنحط اللوجيك والتغييرات الخاصة بشاشة إضافة التاسك
class _AddTaskState extends State<AddTask> {

  // Controller عشان نقدر نقرأ اسم التاسك اللي المستخدم بكتبه
  final TextEditingController titleController =
  TextEditingController();


  // Controller عشان نقدر نقرأ وصف التاسك
  final TextEditingController descriptionController =
  TextEditingController();


  // هاي بتحدد إذا التاسك High Priority أو لا
  // بالبداية خليتها true يعني مفعّلة
  bool isHighPriority = true;


  // لما نطلع من الشاشة بنعمل dispose للـ Controllers
  // عشان ما يضلوا مستخدمين مساحة بالذاكرة
  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();

    super.dispose();
  }


  // =========================================================
  // إضافة وحفظ التاسك
  // =========================================================

  // هاي الدالة مسؤولة عن إضافة التاسك وحفظها
  Future<void> addTask() async {

    // بنجيب اسم التاسك اللي المستخدم كتبه
    // trim() بشيل المسافات الزايدة
    final taskName = titleController.text.trim();


    // =======================================================
    // التأكد إن اسم التاسك موجود
    // =======================================================

    // اسم التاسك إجباري، فما بنسمح بإضافة Task بدون اسم
    if (taskName.isEmpty) {

      // بنظهر رسالة صغيرة للمستخدم تحت الشاشة
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter a task name"),
        ),
      );


      // بنوقف الدالة هون
      // يعني ما بنكمل عملية الحفظ
      return;
    }


    // بنفتح SharedPreferences
    // عشان نقدر نوصل للتاسكات المحفوظة على الجهاز
    final pref = await SharedPreferences.getInstance();


    // =======================================================
    // قراءة التاسكات القديمة
    // =======================================================

    // بنجيب كل التاسكات اللي كانت محفوظة قبل
    // وإذا ما في أي Tasks بنرجع List فاضية
    final List<String> savedTasks =
        pref.getStringList("tasks") ?? [];


    // =======================================================
    // إنشاء Task جديدة
    // =======================================================

    // هون بنعمل object جديد من TaskModel
    final task = TaskModel(

      // اسم التاسك اللي أخدناه من TextField
      taskName: taskName,

      // وصف التاسك اللي كتبه المستخدم
      taskDescription:
      descriptionController.text.trim(),

      // بنحفظ حالة High Priority الحالية
      isHighPriority: isHighPriority,

      // أي Task جديدة بالبداية بتكون مش مكتملة
      isCompleted: false,
    );


    // =======================================================
    // تحويل الـ Task إلى JSON
    // =======================================================

    // SharedPreferences ما بتخزن TaskModel مباشرة
    // عشان هيك بنحوّلها لـ JSON String
    final String taskJson =
    jsonEncode(task.toJson());


    // =======================================================
    // إضافة التاسك الجديدة
    // =======================================================

    // بنضيف التاسك الجديدة على التاسكات القديمة
    savedTasks.add(taskJson);


    // =======================================================
    // حفظ القائمة مرة ثانية
    // =======================================================

    // بنحفظ كل التاسكات بعد ما أضفنا التاسك الجديدة
    await pref.setStringList(
      "tasks",
      savedTasks,
    );


    // نتأكد إن الشاشة لسا موجودة
    if (!mounted) return;


    // بنرجع للشاشة السابقة
    // وهي HomeScreen
    Navigator.pop(context);
  }


  // =========================================================
  // بناء واجهة الشاشة
  // =========================================================

  @override
  Widget build(BuildContext context) {

    // Scaffold هو الهيكل الأساسي للشاشة
    return Scaffold(

      // لون خلفية الشاشة
      backgroundColor: const Color(0xFF181818),


      // =====================================================
      // App Bar
      // =====================================================

      appBar: AppBar(

        // نفس لون خلفية التطبيق
        backgroundColor: const Color(0xFF181818),

        // بنشيل الظل اللي تحت الـ AppBar
        elevation: 0,


        // زر الرجوع
        leading: IconButton(

          // لما نضغط عليه بنرجع للشاشة السابقة
          onPressed: () {
            Navigator.pop(context);
          },


          // شكل زر الرجوع
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),


        // عنوان الصفحة
        title: const Text(
          "New Task",

          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
          ),
        ),
      ),


      // =====================================================
      // محتوى الصفحة
      // =====================================================

      body: SafeArea(
        child: Column(
          children: [

            // Expanded بخلي محتوى الإدخال ياخذ المساحة المتوفرة
            Expanded(
              child: Padding(

                // مسافة من اليمين واليسار
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 13,
                ),


                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [

                    const SizedBox(height: 8),


                    // =================================================
                    // Task Name
                    // =================================================

                    const Text(
                      "Task Name",

                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),


                    // مسافة بين العنوان وخانة الإدخال
                    const SizedBox(height: 8),


                    // خانة كتابة اسم التاسك
                    TextField(

                      // ربطناها بالـ controller
                      // عشان نقدر نجيب الاسم بعدين
                      controller: titleController,


                      // لون النص اللي المستخدم بكتبه
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),


                      // =================================================
                      // شكل خانة اسم التاسك
                      // =================================================

                      decoration: InputDecoration(

                        // النص اللي بظهر قبل ما المستخدم يكتب
                        hintText:
                        "Finish UI design for login screen",


                        // شكل الـ hint
                        hintStyle:
                        const TextStyle(
                          color: Color(0xFF707070),
                          fontSize: 13,
                        ),


                        // بخلي للخانة خلفية
                        filled: true,


                        // لون خلفية الخانة
                        fillColor:
                        const Color(0xFF242424),


                        // المسافة بين النص وحواف الخانة
                        contentPadding:
                        const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 14,
                        ),


                        // شكل حدود الخانة
                        border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(14),

                          // بدون Border ظاهر
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),


                    const SizedBox(height: 16),


                    // =================================================
                    // Task Description
                    // =================================================

                    const Text(
                      "Task Description",

                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),


                    const SizedBox(height: 8),


                    // خانة كتابة وصف التاسك
                    TextField(

                      // ربطناها بالـ descriptionController
                      controller:
                      descriptionController,


                      // بخلي المستخدم يقدر يكتب أكثر من سطر
                      maxLines: 5,


                      // لون النص
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),


                      decoration: InputDecoration(

                        // مثال للنص اللي ممكن المستخدم يكتبه
                        hintText:
                        "Finish onboarding UI and hand off to\ndevs by Thursday.",


                        // شكل الـ hint
                        hintStyle:
                        const TextStyle(
                          color: Color(0xFF707070),
                          fontSize: 13,
                        ),


                        // خلفية الخانة
                        filled: true,


                        fillColor:
                        const Color(0xFF242424),


                        // المسافة داخل الخانة
                        contentPadding:
                        const EdgeInsets.all(12),


                        // شكل حدود الخانة
                        border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(14),

                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),


                    const SizedBox(height: 16),


                    // =================================================
                    // High Priority
                    // =================================================

                    // Row عشان نخلي كلمة High Priority
                    // والـ Switch جنب بعض
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,

                      children: [

                        // اسم الخيار
                        const Text(
                          "High Priority",

                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),


                        // Switch لتشغيل أو إيقاف High Priority
                        Switch(
                          value: isHighPriority,


                          // بتشتغل لما المستخدم يغير حالة الـ Switch
                          onChanged: (value) {

                            // بنحدث قيمة isHighPriority
                            setState(() {
                              isHighPriority = value;
                            });
                          },


                          // لون الدائرة لما تكون مفعلة
                          activeColor: Colors.white,


                          // لون الخلفية الخضراء للـ Switch
                          activeTrackColor:
                          const Color(0xFF52C070),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),


            // =====================================================
            // زر Add Task
            // =====================================================

            // هذا الجزء ثابت تحت الشاشة
            Container(
              width: double.infinity,


              // مسافات حول الزر
              padding: const EdgeInsets.fromLTRB(
                13,
                8,
                13,
                24,
              ),


              // نفس لون خلفية الشاشة
              color: const Color(0xFF181818),


              child: SizedBox(
                height: 45,


                // زر إضافة التاسك
                child: ElevatedButton(

                  // لما نضغط على الزر بنشغل addTask
                  onPressed: addTask,


                  // =================================================
                  // شكل الزر
                  // =================================================

                  style:
                  ElevatedButton.styleFrom(

                    // لون الزر الأخضر
                    backgroundColor:
                    const Color(0xFF52C070),


                    // بدون ظل
                    elevation: 0,


                    // حواف دائرية
                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(25),
                    ),
                  ),


                  // محتوى الزر
                  child: const Row(
                    mainAxisAlignment:
                    MainAxisAlignment.center,

                    children: [

                      // علامة +
                      Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 17,
                      ),


                      // مسافة بين الـ + والنص
                      SizedBox(width: 7),


                      // اسم الزر
                      Text(
                        "Add Task",

                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}