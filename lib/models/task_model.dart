// =========================================================
// Task Model
// =========================================================

// هذا الـ Model بحدد شكل الـ Task عندنا
// يعني كل Task لازم يكون فيها اسم ووصف وحالة Priority وحالة Completion
class TaskModel {

  // اسم التاسك
  final String taskName;

  // وصف التاسك
  final String taskDescription;

  // بتحدد إذا التاسك High Priority أو لا
  final bool isHighPriority;

  // بتحدد إذا التاسك خلصت أو لسا
  final bool isCompleted;


  // =========================================================
  // Constructor
  // =========================================================

  // هذا الـ Constructor بنستخدمه لما بدنا نعمل Task جديدة
  TaskModel({
    required this.taskName,
    required this.taskDescription,
    required this.isHighPriority,
    required this.isCompleted,
  });


  // =========================================================
  // تحويل Task إلى Map
  // =========================================================

  // بنستخدم هاي الدالة لما بدنا نحول الـ Task
  // من Object إلى Map
  Map<String, dynamic> toMap() {

    // كل معلومة من الـ Task بنحطها داخل Map
    return {
      "taskName": taskName,
      "taskDescription": taskDescription,
      "isHighPriority": isHighPriority,
      "isCompleted": isCompleted,
    };
  }


  // =========================================================
  // تحويل Task إلى JSON
  // =========================================================

  // هاي بنستخدمها لما بدنا نحول الـ Task لصيغة JSON
  // وهي بنفسها بتستخدم toMap()
  Map<String, dynamic> toJson() {
    return toMap();
  }


  // =========================================================
  // إنشاء Task من Map
  // =========================================================

  // factory بنستخدمها عشان ننشئ TaskModel جديدة
  // بناءً على البيانات الموجودة داخل الـ Map
  factory TaskModel.fromMap(
      Map<String, dynamic> map) {

    return TaskModel(

      // بنجيب اسم التاسك من الـ Map
      // وإذا ما لقيناه بنحط String فاضي
      taskName: map["taskName"] ?? "",


      // بنجيب وصف التاسك
      // وإذا ما كان موجود بنحط String فاضي
      taskDescription:
      map["taskDescription"] ?? "",


      // بنجيب حالة High Priority
      // وإذا ما كانت موجودة بنخليها false
      isHighPriority:
      map["isHighPriority"] ?? false,


      // بنجيب حالة إكمال التاسك
      // وإذا ما كانت موجودة بنخليها false
      isCompleted:
      map["isCompleted"] ?? false,
    );
  }


  // =========================================================
  // إنشاء Task من JSON
  // =========================================================

  // لما نقرأ Task محفوظة بصيغة JSON
  // بنستخدم هاي الدالة عشان نرجعها لـ TaskModel
  factory TaskModel.fromJson(
      Map<String, dynamic> json) {

    // بنستخدم fromMap بدل ما نكرر نفس الكود
    return TaskModel.fromMap(json);
  }


  // =========================================================
  // تعديل جزء من الـ Task
  // =========================================================

  // بنستخدم هاي الدالة لما بدنا نغير جزء معين من الـ Task
  // بدون ما نعيد كتابة كل بياناتها من البداية
  TaskModel copyWith({

    // ممكن نغير اسم التاسك
    // وعشان يكون اختياري حطينا ?
    String? taskName,

    // ممكن نغير وصف التاسك
    String? taskDescription,

    // ممكن نغير حالة High Priority
    bool? isHighPriority,

    // ممكن نغير حالة إكمال التاسك
    bool? isCompleted,
  }) {

    // بنرجع TaskModel جديدة
    return TaskModel(

      // إذا أعطينا اسم جديد بنستخدمه
      // وإذا لا بنستخدم الاسم القديم
      taskName: taskName ?? this.taskName,


      // إذا أعطينا وصف جديد بنستخدمه
      // وإذا لا بنستخدم الوصف القديم
      taskDescription:
      taskDescription ?? this.taskDescription,


      // إذا غيرنا High Priority بنستخدم القيمة الجديدة
      // وإذا لا بنخلي القيمة القديمة
      isHighPriority:
      isHighPriority ?? this.isHighPriority,


      // إذا غيرنا حالة التاسك بنستخدم القيمة الجديدة
      // وإذا لا بنخلي الحالة القديمة
      isCompleted:
      isCompleted ?? this.isCompleted,
    );
  }
}