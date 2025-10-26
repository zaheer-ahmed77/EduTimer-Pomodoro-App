import 'package:flutter/material.dart';
import 'pomodoro_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_theme.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryLightBlue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 2),

            ClipOval(
              child: Image.asset(
                'assets/images/logo.png',
                height: 150,
                width: 150,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 20),

            Stack(
              children: [
                Text(
                  "EduTimer",
                  style: GoogleFonts.fredoka(
                    fontSize: 65,
                    fontWeight: FontWeight.w600,

                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 2.0
                      ..color = AppColors.primaryDarkText,
                  ),
                ),

                Text(
                  "EduTimer",
                  style: GoogleFonts.fredoka(
                    fontSize: 65,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryOffWhite,
                  ),
                ),
              ],
            ),

            const Spacer(flex: 3),

            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const PomodoroScreen(),
                  ),
                );
              },

              child: Text(
                "Get Started",
                style: GoogleFonts.nunito(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const Spacer(flex: 3),

            Text(
              "Created By:\nAISHA and ZAHEER",
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                color: AppColors.primaryDarkText,
                fontSize: 16,
                height: 1.5,
              ),
            ),

            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}
