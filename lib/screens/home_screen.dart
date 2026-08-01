import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/task_model.dart';
import 'add_task.dart';


// شاشة الـ Home
// هون بنعرض التاسكات والـ progress والـ high priority tasks
class HomeScreen extends StatefulWidget {
  final String name;

  // بنستقبل اسم المستخدم من شاشة الـ Welcome
  const HomeScreen({
    super.key,
    required this.name,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


// هون بنحط كل اللوجيك والتغييرات الخاصة بالـ Home
class _HomeScreenState extends State<HomeScreen> {

  // ليستة بنخزن فيها كل التاسكات
  List<TaskModel> tasks = [];


  // أول ما تفتح شاشة الـ Home بنقرأ التاسكات المحفوظة
  @override
  void initState() {
    super.initState();

    loadTasks();
  }


  // =========================================================
  // قراءة التاسكات من SharedPreferences
  // =========================================================

  // بنجيب التاسكات اللي كانت محفوظة على الجهاز
  Future<void> loadTasks() async {

    // بنفتح SharedPreferences
    final pref = await SharedPreferences.getInstance();


    // بنجيب ليستة التاسكات المحفوظة
    // إذا ما في تاسكات بنرجع ليستة فاضية
    final List<String> savedTasks =
        pref.getStringList("tasks") ?? [];


    // ليستة مؤقتة بنحط فيها التاسكات بعد فك الـ JSON
    final List<TaskModel> loadedTasks = [];


    // بنمر على كل Task محفوظ
    for (final task in savedTasks) {

      // بنفك الـ JSON ونرجعه لـ Map
      final Map<String, dynamic> decoded =
      jsonDecode(task);


      // بنحوّل الـ Map إلى TaskModel
      loadedTasks.add(
        TaskModel.fromJson(decoded),
      );
    }


    // نتأكد إن الشاشة لسا موجودة
    if (!mounted) return;


    // بنحدث الشاشة ونحط التاسكات اللي قرأناها
    setState(() {
      tasks = loadedTasks;
    });
  }


  // =========================================================
  // حفظ كل التاسكات
  // =========================================================

  // بنحفظ التاسكات بعد أي تعديل عليها
  Future<void> saveTasks() async {

    // بنفتح SharedPreferences
    final pref = await SharedPreferences.getInstance();


    // بنحوّل كل Task من Model إلى JSON
    final List<String> encodedTasks = tasks
        .map(
          (task) => jsonEncode(task.toJson()),
    )
        .toList();


    // بنحفظ كل التاسكات كـ List<String>
    await pref.setStringList(
      "tasks",
      encodedTasks,
    );
  }


  // =========================================================
  // تغيير حالة المهمة
  // =========================================================

  // هاي بتشتغل لما نضغط على الـ Checkbox
  // value بتكون true إذا خلصنا التاسك و false إذا لا
  Future<void> changeTaskStatus(
      int index,
      bool value,
      ) async {

    // بنغير حالة التاسك
    setState(() {
      tasks[index] = tasks[index].copyWith(
        isCompleted: value,
      );
    });


    // بعد التعديل بنحفظ التغيير
    await saveTasks();
  }


  @override
  Widget build(BuildContext context) {

    // بنحسب عدد التاسكات اللي خلصت
    final completedTasks =
        tasks.where((task) => task.isCompleted).length;


    // العدد الكلي للتاسكات
    final totalTasks = tasks.length;


    // بنحسب نسبة الإنجاز
    // إذا ما في Tasks بنخلي النسبة 0
    final double progress = totalTasks == 0
        ? 0
        : completedTasks / totalTasks;


    // بنجيب بس التاسكات اللي عليها High Priority
    final highPriorityTasks = tasks
        .where((task) => task.isHighPriority)
        .toList();


    return Scaffold(
      backgroundColor: const Color(0xFF181818),


      // =====================================================
      // زر إضافة Task جديد
      // =====================================================

      floatingActionButton:
      FloatingActionButton.extended(

        // لون زر الإضافة
        backgroundColor: const Color(0xFF52C070),


        // شو بصير لما نضغط على الزر
        onPressed: () async {

          // بنروح على شاشة إضافة Task
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddTask(),
            ),
          );


          // لما نرجع من شاشة الإضافة
          // بنعيد قراءة التاسكات عشان تظهر الجديدة
          await loadTasks();
        },


        // علامة + داخل الزر
        icon: const Icon(
          Icons.add,
          color: Colors.white,
        ),


        // النص الموجود داخل الزر
        label: const Text(
          "Add New Task",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),


      // =====================================================
      // محتوى الصفحة
      // =====================================================

      body: SafeArea(
        child: SingleChildScrollView(

          // مسافات حول محتوى الصفحة
          padding: const EdgeInsets.fromLTRB(
            15,
            12,
            15,
            100,
          ),


          // Column بترتب كل أقسام الصفحة تحت بعض
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              // =====================================================
              // Header
              // =====================================================

              Row(
                children: [

                  // =================================================
                  // صورة البروفايل
                  // =================================================

                  Container(
                    width: 44,
                    height: 44,

                    decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.circular(8),

                      // الإطار البنفسجي حول الصورة
                      border: Border.all(
                        color:
                        const Color(0xFF9747FF),
                        width: 2,
                      ),
                    ),

                    child: ClipRRect(
                      // بنخلي الصورة نفسها حوافها دائرية
                      borderRadius:
                      BorderRadius.circular(6),

                      child: Image.asset(
                        "assets/images/profile.png",
                        fit: BoxFit.cover,
                      ),

                      // =================================================
                      // طريقة اضافة نفس الصورة بس امتداد svg عشان الصورة تكون اوضح
                      //
                      // =================================================
                      //
                      // child: SvgPicture.asset(
                      //   "assets/images/profile.svg",
                      //   fit: BoxFit.cover,
                      // ),
                    ),
                  ),


                  // مسافة بين صورة البروفايل والاسم
                  const SizedBox(width: 7),


                  // Expanded عشان النص ياخذ المساحة المتوفرة
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      children: [

                        // تحية المستخدم مع اسمه
                        Text(
                          "Good Evening, ${widget.name}",

                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight:
                            FontWeight.w500,
                          ),
                        ),


                        // مسافة صغيرة بين السطرين
                        const SizedBox(height: 2),


                        // الجملة اللي تحت اسم المستخدم
                        const Text(
                          "One task at a time. One step\ncloser.",

                          style: TextStyle(
                            color:
                            Color(0xFFBDBDBD),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),


                  // =================================================
                  // زر الإعدادات
                  // =================================================

                  Container(
                    width: 34,
                    height: 34,

                    decoration: BoxDecoration(
                      color:
                      const Color(0xFF2A2A2A),

                      shape: BoxShape.circle,
                    ),

                    child: const Icon(
                      Icons.settings,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ],
              ),


              // مسافة بعد الـ Header
              const SizedBox(height: 25),


              // =====================================================
              // العنوان الرئيسي
              // =====================================================

              const Text(
                "Yuhuu, Your work Is",

                style: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.w400,
                ),
              ),

              const Text(
                "almost done! 👋🏻",

                style: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.w400,
                ),
              ),


              const SizedBox(height: 16),


              // =====================================================
              // Achieved Tasks
              // =====================================================

              Container(
                width: double.infinity,

                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),

                decoration: BoxDecoration(
                  color:
                  const Color(0xFF292929),

                  borderRadius:
                  BorderRadius.circular(15),
                ),


                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,

                  children: [

                    // معلومات الـ Achieved Tasks
                    Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      children: [

                        const Text(
                          "Achieved Tasks",

                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight:
                            FontWeight.w500,
                          ),
                        ),


                        const SizedBox(height: 3),


                        // عدد التاسكات اللي خلصناها
                        const Text(
                          "0 Out of 0 Done",

                          style: TextStyle(
                            color:
                            Color(0xFFBDBDBD),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),


                    // =================================================
                    // دائرة الـ Progress
                    // =================================================

                    SizedBox(
                      width: 40,
                      height: 40,

                      child: Stack(
                        alignment:
                        Alignment.center,

                        children: [

                          // دائرة التقدم
                          CircularProgressIndicator(
                            value: progress,

                            strokeWidth: 2,

                            backgroundColor:
                            const Color(
                              0xFF4A4A4A,
                            ),

                            color:
                            const Color(
                              0xFF00D084,
                            ),
                          ),


                          // النسبة داخل الدائرة
                          Text(
                            "${(progress * 100).toInt()}%",

                            style:
                            const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),


              // =====================================================
              // High Priority Tasks
              // =====================================================

              // هذا القسم بظهر بس إذا في Tasks عليها High Priority
              if (highPriorityTasks.isNotEmpty) ...[
                const SizedBox(height: 12),

                Container(
                  width: double.infinity,

                  padding:
                  const EdgeInsets.all(10),

                  decoration: BoxDecoration(
                    color:
                    const Color(0xFF292929),

                    borderRadius:
                    BorderRadius.circular(15),
                  ),

                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [

                      const Text(
                        "High Priority Tasks",

                        style: TextStyle(
                          color:
                          Color(0xFF00D084),
                          fontSize: 11,
                        ),
                      ),


                      const SizedBox(height: 5),


                      // بنعرض كل الـ High Priority Tasks
                      ...highPriorityTasks.map(
                            (task) {

                          // بنجيب رقم التاسك داخل الليستة الأصلية
                          final index =
                          tasks.indexOf(task);

                          return Row(
                            children: [

                              // Checkbox لتحديد إذا التاسك خلصت
                              Checkbox(
                                value:
                                task.isCompleted,

                                onChanged:
                                    (value) {

                                  // نتأكد إن القيمة مش null
                                  if (value !=
                                      null) {

                                    changeTaskStatus(
                                      index,
                                      value,
                                    );
                                  }
                                },

                                activeColor:
                                const Color(
                                  0xFF00D084,
                                ),

                                checkColor:
                                Colors.white,

                                side:
                                const BorderSide(
                                  color:
                                  Colors.white54,
                                ),

                                visualDensity:
                                VisualDensity
                                    .compact,
                              ),


                              // اسم التاسك
                              Expanded(
                                child: Text(
                                  task.taskName,

                                  maxLines: 1,

                                  overflow:
                                  TextOverflow
                                      .ellipsis,

                                  style: TextStyle(
                                    color:
                                    Colors.white,

                                    fontSize: 11,

                                    // إذا خلصت التاسك
                                    // بنحط خط عليها
                                    decoration: task
                                        .isCompleted
                                        ? TextDecoration
                                        .lineThrough
                                        : null,

                                    decorationColor:
                                    Colors
                                        .white54,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],


              // =====================================================
              // My Tasks
              // =====================================================

              const SizedBox(height: 18),


              const Text(
                "My Tasks",

                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),


              const SizedBox(height: 8),


              // إذا ما في Tasks بنعرض رسالة
              if (tasks.isEmpty)
                const Padding(
                  padding:
                  EdgeInsets.symmetric(
                    vertical: 30,
                  ),

                  child: Center(
                    child: Text(
                      "No tasks yet",

                      style: TextStyle(
                        color:
                        Color(0xFF707070),
                      ),
                    ),
                  ),
                ),


              // =====================================================
              // عرض كل التاسكات
              // =====================================================

              if (tasks.isNotEmpty)
                ListView.builder(

                  // بخلي الـ ListView تاخذ حجم العناصر الموجودة
                  shrinkWrap: true,

                  // لأن عندنا SingleChildScrollView من برا
                  // ما بدنا ListView تعمل Scroll لحالها
                  physics:
                  const NeverScrollableScrollPhysics(),

                  itemCount: tasks.length,


                  // بناء كل Task
                  itemBuilder:
                      (context, index) {

                    final task =
                    tasks[index];


                    return Container(

                      // مسافة بين التاسكات
                      margin:
                      const EdgeInsets.only(
                        bottom: 7,
                      ),

                      padding:
                      const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 4,
                      ),

                      decoration:
                      BoxDecoration(
                        color:
                        const Color(
                          0xFF292929,
                        ),

                        borderRadius:
                        BorderRadius.circular(
                          13,
                        ),
                      ),


                      child: Row(
                        children: [

                          // Checkbox الخاص بالتاسك
                          Checkbox(
                            value:
                            task.isCompleted,

                            onChanged:
                                (value) {

                              if (value !=
                                  null) {

                                changeTaskStatus(
                                  index,
                                  value,
                                );
                              }
                            },

                            activeColor:
                            const Color(
                              0xFF00D084,
                            ),

                            checkColor:
                            Colors.white,

                            side:
                            const BorderSide(
                              color:
                              Colors.white54,
                            ),

                            visualDensity:
                            VisualDensity
                                .compact,
                          ),


                          // معلومات التاسك
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,

                              children: [

                                // اسم التاسك
                                Text(
                                  task.taskName,

                                  maxLines: 1,

                                  overflow:
                                  TextOverflow
                                      .ellipsis,

                                  style:
                                  TextStyle(
                                    color:
                                    Colors.white,

                                    fontSize: 11,

                                    // إذا التاسك خلصت بنحط خط عليها
                                    decoration: task
                                        .isCompleted
                                        ? TextDecoration
                                        .lineThrough
                                        : null,

                                    decorationColor:
                                    Colors
                                        .white54,
                                  ),
                                ),


                                // وصف التاسك إذا كان موجود
                                if (task
                                    .taskDescription
                                    .isNotEmpty)
                                  Text(
                                    task
                                        .taskDescription,

                                    maxLines: 1,

                                    overflow:
                                    TextOverflow
                                        .ellipsis,

                                    style:
                                    const TextStyle(
                                      color:
                                      Color(
                                        0xFFBDBDBD,
                                      ),

                                      fontSize: 9,
                                    ),
                                  ),
                              ],
                            ),
                          ),


                          // زر الثلاث نقاط
                          const Icon(
                            Icons.more_vert,
                            color:
                            Color(0xFF858585),
                            size: 18,
                          ),
                        ],
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),


      // =====================================================
      // Bottom Navigation
      // =====================================================

      bottomNavigationBar:
      BottomNavigationBar(

        backgroundColor:
        const Color(0xFF181818),

        // بنخلي كل الـ items ظاهرين
        type: BottomNavigationBarType.fixed,


        // لون الـ item المختار
        selectedItemColor:
        const Color(0xFF00D084),


        // لون الـ items اللي مش مختارة
        unselectedItemColor:
        Colors.white70,


        // أول صفحة هي Home
        currentIndex: 0,


        showSelectedLabels: true,
        showUnselectedLabels: true,

        selectedFontSize: 9,
        unselectedFontSize: 9,


        // عناصر الـ Bottom Navigation
        items: const [

          // Home
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon:
            Icon(Icons.home),
            label: "Home",
          ),


          // To Do
          BottomNavigationBarItem(
            icon:
            Icon(Icons.description_outlined),
            label: "To Do",
          ),


          // Completed
          BottomNavigationBarItem(
            icon:
            Icon(Icons.fact_check_outlined),
            label: "Completed",
          ),


          // Profile
          BottomNavigationBarItem(
            icon:
            Icon(Icons.person_outline),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}