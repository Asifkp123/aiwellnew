import 'dart:ui';
import 'package:aiwel/features/home/widgets/add_pal_button.dart';
import 'package:aiwel/features/home/widgets/home_section_card.dart';
import 'package:aiwel/features/home/widgets/music_suggestion_widget.dart';
import 'package:aiwel/features/home/widgets/tracking_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:aiwel/components/constants.dart';
import 'package:aiwel/components/theme/light_theme.dart';
import 'package:aiwel/components/text_widgets/text_widgets.dart';

import 'package:aiwel/features/medicine_reminder/presentation/screens/medicine_reminder_screen.dart';



class HomeScreen extends StatelessWidget {
  static const String routeName = '/homeScreen';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            // SVG Background - HERE is where the SVG is used
            Positioned.fill(
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
                child: SvgPicture.asset(
                  'assets/svg/SplashscreenGradient.svg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Content layer on top
            SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.04,
                        vertical: 20,
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header with points
                            _buildHeader(context, screenWidth, customColors),

                            SizedBox(height: screenHeight * 0.03),

                            // Greeting Section
                            _buildGreetingSection(screenWidth),

                            SizedBox(height: screenHeight * 0.04),

                            // Tracking Cards (Mood, Workout, Sleep)
                            _buildTrackingCards(
                                context, screenWidth, screenHeight),

                            // SizedBox(height: screenHeight * 0.0001),
                          ]),
                    ),
                    // Your Pal Section
                    _buildYourPalSection(context, screenWidth, screenHeight),

                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.04,
                        vertical: 20,
                      ),
                      child:  Column(
                        children: [
                          SizedBox(height: screenHeight * 0.02),

                          // Medication Section
                          MeditationSection(context, screenWidth, screenHeight),

                          SizedBox(height: screenHeight * 0.05),

                          // Music Suggestion Section
                          MusicSuggestionWidget(
                            screenWidth: screenWidth,
                            onConnectSpotify: () {
                              // Handle Spotify connection
                            },
                          ),

                          SizedBox(height: screenHeight * 0.1),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildHeader(
      BuildContext context, double screenWidth, CustomColors customColors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFF1E6FD), // Light purple background
            borderRadius: BorderRadius.circular(32),
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                '$svgPath/purple_love.svg', // Your SVG asset path
                width: 16,
                height: 16,
              ),
              const SizedBox(width: 4),
              const Text(
                '120',
                style: TextStyle(
                  color: Color(0xFF8E2EFF), // Purple
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGreetingSection(double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LargePurpleText("Good Morning Arjun,"),
        const SizedBox(height: 8),
        MediumPurpleText("You are doing amazing work!"),
      ],
    );
  }

  Widget _buildTrackingCards(
      BuildContext context, double screenWidth, double screenHeight) {
    return RepaintBoundary(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TrackingCardWidget(
                    icon: null, // No icon for regular content
                    title: "Mood",
                    subtitle: "How are you feeling today?",
                    points: "05",
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                    onAddPressed: () {
                      // Handle mood tracking
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TrackingCardWidget(
                    icon: null, // No icon for regular content
                    title: "Workout",
                    subtitle: "Did you workout today?",
                    points: "05",
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                    onAddPressed: () {
                      // Handle workout tracking
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            TrackingCardWidget(
              icon:
              '$svgPath/smile.svg', // Only the full-width Sleep card gets an icon
              title: "Sleep",
              subtitle: "How was your sleep yesterday?",
              points: "05",
              screenWidth: screenWidth,
              screenHeight: screenHeight,
              iconSize: 20, // Controllable size for the smile.svg
              isFullWidth: true,
              onAddPressed: () {
                // Handle sleep tracking
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildYourPalSection(
      BuildContext context, double screenWidth, double screenHeight) {
    return HomeSectionCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // YOUR PAL title
            Black60018Text("YOUR PAL"),

            SizedBox(height: screenHeight * 0.025),

            // Illustration placeholder - person caring for elderly

            // SizedBox(height: screenHeight * 0.010),

            // Description text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Black40016Text(
                  align: TextAlign.center,
                  "Who are you caring for? Add your Pal to get started."),
            ),

            SizedBox(height: screenHeight * 0.025),

            // Add Your Pal button
            Center(
                child: AddPalButtonWidget(context,
                    buttonHeight: 35, buttonWidth: 110)),
          ],
        ),
      ),
    );
  }

  Widget MeditationSection(
      BuildContext context, double screenWidth, double screenHeight) {
    return MeditationSectionCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // YOUR PAL title
            Black60018Text("Medication"),

            SizedBox(height: screenHeight * 0.025),

            // Illustration placeholder - person caring for elderly

            // SizedBox(height: screenHeight * 0.010),

            // Description text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Black40016Text(
                  align: TextAlign.center,
                  "Add your daily medications so that we can remind you to take care of yourself"),
            ),

            SizedBox(height: screenHeight * 0.025),

            // Add Your Pal button
            Center(
                child: AddPalButtonWidget(context,
                    buttonHeight: 35, buttonWidth: 110)),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicationSection(
      BuildContext context, double screenWidth, double screenHeight) {
    return HomeSectionCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Medication title
            Text(
              "Medication",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF6B46C1),
              ),
            ),
            SizedBox(height: screenHeight * 0.025),

            // Medication illustration
            Center(
              child: Container(
                width: screenWidth * 0.6,
                height: screenHeight * 0.15,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Background
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue.withOpacity(0.1),
                            Colors.green.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    // Medicine bottles
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Bottle 1
                        Container(
                          width: 25,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.blue[300],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Container(
                            margin: EdgeInsets.only(top: 8),
                            decoration: BoxDecoration(
                              color: Colors.blue[400],
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        // Bottle 2
                        Container(
                          width: 25,
                          height: 45,
                          decoration: BoxDecoration(
                            color: Colors.green[300],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Container(
                            margin: EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                              color: Colors.green[400],
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        // Bottle 3
                        Container(
                          width: 25,
                          height: 38,
                          decoration: BoxDecoration(
                            color: Colors.purple[300],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Container(
                            margin: EdgeInsets.only(top: 8),
                            decoration: BoxDecoration(
                              color: Colors.purple[400],
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Pills at bottom
                    Positioned(
                      bottom: 10,
                      child: Row(
                        children: [
                          Container(
                            width: 30,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.red[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CircleAvatar(
                                    radius: 3,
                                    backgroundColor: Colors.red[400]),
                                CircleAvatar(
                                    radius: 3,
                                    backgroundColor: Colors.red[400]),
                                CircleAvatar(
                                    radius: 3,
                                    backgroundColor: Colors.red[400]),
                              ],
                            ),
                          ),
                          SizedBox(width: 10),
                          Container(
                            width: 30,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.pink[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CircleAvatar(
                                    radius: 3,
                                    backgroundColor: Colors.pink[400]),
                                CircleAvatar(
                                    radius: 3,
                                    backgroundColor: Colors.pink[400]),
                                CircleAvatar(
                                    radius: 3,
                                    backgroundColor: Colors.pink[400]),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: screenHeight * 0.025),

            // Description text
            Text(
              "Add your daily medications so that we can remind you to take care of yourself",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF6B46C1),
                height: 1.4,
              ),
            ),

            SizedBox(height: screenHeight * 0.025),

            // Add Now button
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF8B5CF6),
                    const Color(0xFF7C3AED),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: MaterialButton(
                onPressed: () {
                  Navigator.pushNamed(
                      context, MedicineReminderScreen.routeName);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                child: Text(
                  "Add Now",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/svg/Hearts.svg',
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
            ),
            activeIcon: SvgPicture.asset(
              'assets/svg/Hearts.svg',
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                  Theme.of(context).primaryColor, BlendMode.srcIn),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/svg/Document.svg',
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
            ),
            activeIcon: SvgPicture.asset(
              'assets/svg/Document.svg',
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                  Theme.of(context).primaryColor, BlendMode.srcIn),
            ),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/svg/store.svg',
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
            ),
            activeIcon: SvgPicture.asset(
              'assets/svg/store.svg',
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                  Theme.of(context).primaryColor, BlendMode.srcIn),
            ),
            label: 'Store',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/svg/chat.svg',
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
            ),
            activeIcon: SvgPicture.asset(
              'assets/svg/chat.svg',
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                  Theme.of(context).primaryColor, BlendMode.srcIn),
            ),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/svg/profile.svg',
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
            ),
            activeIcon: SvgPicture.asset(
              'assets/svg/profile.svg',
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                  Theme.of(context).primaryColor, BlendMode.srcIn),
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
