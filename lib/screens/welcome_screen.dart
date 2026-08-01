import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';


// شاشة الترحيب اللي بتظهر أول ما نفتح التطبيق
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}


// هون بنحط كل اللوجيك والتعديلات الخاصة بشاشة الـ Welcome
class _WelcomeScreenState extends State<WelcomeScreen> {

  // هذا المفتاح بنستخدمه عشان نتحكم بالـ Form
  // وبنستخدمه كمان عشان نعمل validation للـ input
  final _formKey = GlobalKey<FormState>();


  // Controller بخلينا نوصل للنص اللي المستخدم بكتبه داخل خانة الاسم
  final TextEditingController controller =
  TextEditingController();


  // لما نخلص من الشاشة بنعمل dispose للـ controller
  // عشان ما يضل حاجز مساحة بالذاكرة
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }


  // =========================================================
  // حفظ اسم المستخدم والانتقال للصفحة الرئيسية
  // =========================================================

  // async لأنه في عمليات بتحتاج وقت مثل حفظ البيانات
  Future<void> saveUserName() async {

    // بنجيب الاسم اللي كتبه المستخدم
    // trim() بشيل المسافات الزايدة من البداية والنهاية
    final name = controller.text.trim();


    // بنفتح SharedPreferences
    // عشان نقدر نخزن اسم المستخدم على الجهاز
    final pref = await SharedPreferences.getInstance();


    // بنحفظ الاسم باستخدام مفتاح اسمه username
    await pref.setString(
      "username",
      name,
    );


    // نتأكد إن الشاشة لسا موجودة قبل ما نعمل Navigation
    if (!mounted) return;


    // بننتقل للـ HomeScreen
    // pushReplacement يعني بنشيل شاشة الـ Welcome من الـ stack
    // عشان المستخدم لما يرجع ما يرجع على شاشة الـ Welcome
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HomeScreen(
          name: name,
        ),
      ),
    );
  }


  // =========================================================
  // بناء واجهة شاشة الـ Welcome
  // =========================================================

  @override
  Widget build(BuildContext context) {

    // بنستخدم AnnotatedRegion عشان نتحكم بشكل الـ Status Bar
    // مثل لونها ولون الأيقونات اللي فيها
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(

        // خلفية الـ Status Bar شفافة
        statusBarColor: Colors.transparent,

        // أيقونات الـ Status Bar لونها فاتح
        statusBarIconBrightness: Brightness.light,

        // تحديد شكل الإضاءة للـ Status Bar
        statusBarBrightness: Brightness.dark,
      ),


      // Scaffold هو الهيكل الأساسي للشاشة
      child: Scaffold(

        // لون خلفية التطبيق
        backgroundColor: const Color(0xFF181818),


        // SafeArea بتخلينا نبعد المحتوى عن أشياء زي
        // الساعة والبطارية والـ notch
        body: SafeArea(

          // إذا الشاشة صغيرة أو الكيبورد فتح
          // بقدر المستخدم يعمل scroll
          child: SingleChildScrollView(

            // بنضيف مسافة 24 من اليمين واليسار
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),


              // Form بخلينا نعمل validation على خانة الاسم
              child: Form(
                key: _formKey,


                // Column بترتب العناصر تحت بعض
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: [

                    // مسافة من فوق قبل اللوجو
                    const SizedBox(height: 18),


                    // =====================================================
                    // اللوجو واسم التطبيق
                    // =====================================================

                    Row(
                      // بخلي اللوجو واسم التطبيق بالنص
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [

                        // صورة لوجو التطبيق
                        Image.asset(
                          "assets/images/logo.png",
                          width: 48,
                          height: 48,
                        ),


                        // مسافة بين اللوجو واسم التطبيق
                        const SizedBox(width: 10),


                        // اسم التطبيق
                        const Text(
                          "Tasky",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),


                    // مسافة كبيرة بين اللوجو والترحيب
                    const SizedBox(height: 108),


                    // =====================================================
                    // عنوان الترحيب
                    // =====================================================

                    const Text(
                      "Welcome To Tasky 👋🏻",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),


                    // مسافة صغيرة بين العنوان والوصف
                    const SizedBox(height: 8),


                    // النص اللي تحت عنوان الترحيب
                    const Text(
                      "Your productivity journey starts here.",
                      style: TextStyle(
                        color: Color(0xFFD0D0D0),
                        fontSize: 14,
                      ),
                    ),


                    // مسافة قبل صورة الـ Task
                    const SizedBox(height: 20),


                    // =====================================================
                    // الصورة الرئيسية
                    // =====================================================

                    Image.asset(
                      "assets/images/task.png",
                      width: 180,
                      height: 180,
                    ),


                    // مسافة بين الصورة وخانة الاسم
                    const SizedBox(height: 28),


                    // =====================================================
                    // خانة الاسم
                    // =====================================================

                    // Align عشان نخلي كلمة Full Name تبدأ من اليسار
                    const Align(
                      alignment: Alignment.centerLeft,

                      child: Text(
                        "Full Name",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),


                    // مسافة بين عنوان الخانة والـ TextField
                    const SizedBox(height: 10),


                    // المكان اللي المستخدم بكتب فيه اسمه
                    TextFormField(

                      // ربطنا الـ TextField بالـ controller
                      // عشان نقدر نجيب الاسم اللي المستخدم كتبه
                      controller: controller,


                      // لون النص اللي المستخدم بكتبه
                      style: const TextStyle(
                        color: Colors.white,
                      ),


                      // ===================================================
                      // التحقق من الاسم
                      // ===================================================

                      validator: (value) {

                        // إذا المستخدم ما كتب أي اسم
                        // بنظهرله رسالة خطأ
                        if (value == null ||
                            value.trim().isEmpty) {
                          return "Please enter your name";
                        }

                        // إذا الاسم موجود ما في مشكلة
                        return null;
                      },


                      // شكل خانة الإدخال
                      decoration: InputDecoration(

                        // النص اللي بظهر قبل ما المستخدم يكتب
                        hintText: "e.g. Sarah Khalid",


                        // شكل ولون الـ hint
                        hintStyle: const TextStyle(
                          color: Color(0xFF707070),
                        ),


                        // بخلي خلفية الـ TextField معبّية
                        filled: true,


                        // لون خلفية خانة الاسم
                        fillColor: const Color(0xFF242424),


                        // المسافة بين النص وحدود الـ TextField
                        contentPadding:
                        const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),


                        // شكل حدود الـ TextField
                        border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(16),

                          // شلنا الـ border نفسه
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),


                    // مسافة بين TextField والزر
                    const SizedBox(height: 24),


                    // =====================================================
                    // زر Let's Get Started
                    // =====================================================

                    SizedBox(
                      // الزر ياخذ عرض الشاشة كامل
                      width: double.infinity,

                      // ارتفاع الزر
                      height: 55,


                      child: ElevatedButton(

                        // شو بصير لما المستخدم يضغط على الزر
                        onPressed: () {

                          // أول إشي بنعمل validation للاسم
                          if (_formKey.currentState!.validate()) {

                            // إذا الاسم صحيح بنحفظه
                            // وبعدين بنروح على HomeScreen
                            saveUserName();
                          }
                        },


                        // شكل وتصميم الزر
                        style: ElevatedButton.styleFrom(

                          // لون الزر الأخضر
                          backgroundColor:
                          const Color(0xFF52C070),

                          // بنشيل الظل من الزر
                          elevation: 0,


                          // بخلي حواف الزر دائرية
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(30),
                          ),
                        ),


                        // النص الموجود داخل الزر
                        child: const Text(
                          "Let's Get Started",

                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}