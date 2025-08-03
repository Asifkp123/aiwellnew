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
import 'package:aiwel/features/patient/presentation/view_models/patient_view_model.dart';
import 'package:aiwel/features/patient/domain/entities/patient.dart';
import 'package:aiwel/features/pal_creation/presentation/screens/add_pal_splash_screen.dart';
import 'package:aiwel/features/logs/presentation/view_models/logs_view_model.dart';
import 'package:aiwel/features/logs/presentation/widgets/credit_display_widget.dart';
import 'package:aiwel/features/logs/presentation/widgets/mood_selection_bottom_sheet.dart';
import 'package:aiwel/features/logs/presentation/widgets/workout_selection_bottom_sheet.dart';
import 'package:aiwel/features/logs/presentation/widgets/sleep_selection_bottom_sheet.dart';
import 'package:aiwel/features/credit/presentation/view_models/credit_view_model.dart';

import 'package:aiwel/features/medicine_reminder/presentation/screens/medicine_reminder_screen.dart';

import '../logs/presentation/widgets/mood_selection_alert.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/homeScreen';
  final PatientViewModel? patientViewModel;
  final LogsViewModel? logsViewModel;
  final CreditViewModel? creditViewModel; // ← ADD THIS

  const HomeScreen({
    super.key,
    this.patientViewModel,
    this.logsViewModel,
    this.creditViewModel, // ← ADD THIS
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    // Your existing calls
    widget.patientViewModel?.loadPatients();

    // ADD THIS - Load credits when home screen loads
    widget.creditViewModel?.loadCredits();
  }

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
                      child: Column(
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
              CreditDisplayWidget(
                fontSize: 14,
                showIcon: false,
                textColor: const Color(0xFF8E2EFF), // Purple
                creditViewModel: widget.creditViewModel, // ← ADD THIS
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
                  child: widget.logsViewModel != null
                      ? StreamBuilder<LogsState>(
                          stream: widget.logsViewModel!.stateStream,
                          builder: (context, snapshot) {
                            final state = snapshot.data;
                            final todayMoodLogs = _getTodayMoodCount(state);

                            return TrackingCardWidget(
                              icon: null, // No icon for regular content
                              title: "Mood",
                              subtitle: "How are you feeling today?",
                              points: todayMoodLogs
                                  .toString()
                                  .padLeft(2, '0'), // Dynamic points!
                              screenWidth: screenWidth,
                              screenHeight: screenHeight,
                              onAddPressed: () => _showMoodSelection(context),
                            );
                          },
                        )
                      : TrackingCardWidget(
                          icon: null,
                          title: "Mood",
                          subtitle: "How are you feeling today?",
                          points: "00",
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                          onAddPressed: () =>
                              print('❌ LogsViewModel not available'),
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
                    onAddPressed: () => _showWorkoutSelection(context),
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
                print("🔥 Sleep card onAddPressed calledss!");
                _showSleepSelection(context);
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
            // YOUR PAL title with add button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Black60018Text("YOUR PAL"),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, AddPalSplashScreen.routeName);
                  },
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFF8E2EFF),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: screenHeight * 0.025),

            // Patient List Stream Builder
            if (widget.patientViewModel != null)
              StreamBuilder<PatientState>(
                stream: widget.patientViewModel!.stateStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return _buildEmptyPalState(
                        screenWidth, screenHeight, context);
                  }

                  final state = snapshot.data!;

                  switch (state.status) {
                    case PatientStateStatus.loading:
                      return SizedBox(
                        height: screenHeight * 0.25,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF8E2EFF),
                          ),
                        ),
                      );

                    case PatientStateStatus.error:
                      return SizedBox(
                        height: screenHeight * 0.25,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: screenWidth * 0.15,
                              color: Colors.red[400],
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            Text(
                              state.errorMessage ?? 'Error loading patients',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: screenWidth * 0.035,
                                color: Colors.red[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            ElevatedButton(
                              onPressed: () =>
                                  widget.patientViewModel!.loadPatients(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF8E2EFF),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Text(
                                "Retry",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenWidth * 0.035,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );

                    case PatientStateStatus.success:
                      if (state.patients.isEmpty) {
                        return _buildEmptyPalState(
                            screenWidth, screenHeight, context);
                      }
                      return _buildPatientCarousel(
                          state.patients, screenWidth, screenHeight, context);

                    case PatientStateStatus.idle:
                    default:
                      return _buildEmptyPalState(
                          screenWidth, screenHeight, context);
                  }
                },
              )
            else
              _buildEmptyPalState(screenWidth, screenHeight, context),
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

  Widget _buildEmptyPalState(
      double screenWidth, double screenHeight, BuildContext context) {
    return Column(
      children: [
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
    );
  }

  Widget _buildPatientCarousel(List<Patient> patients, double screenWidth,
      double screenHeight, BuildContext context) {
    return SizedBox(
      height: screenHeight * 0.28,
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.85),
        itemCount: patients.length,
        itemBuilder: (context, index) {
          final patient = patients[index];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child:
                _buildPatientCard(patient, screenWidth, screenHeight, context),
          );
        },
      ),
    );
  }

  Widget _buildPatientCard(Patient patient, double screenWidth,
      double screenHeight, BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to patient profile (to be implemented)
        // Navigator.pushNamed(context, PatientProfileScreen.routeName, arguments: patient);
        print("Navigate to patient profile: ${patient.fullName}");
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFF1E6FD).withOpacity(0.8),
              const Color(0xFFE4D6FA).withOpacity(0.9),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            width: 1,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: const Color(0xFF8E2EFF),
                    child: Text(
                      patient.firstName[0].toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          patient.fullName,
                          style: TextStyle(
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF4A1A4A),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${patient.age} Years | ${patient.gender}",
                          style: TextStyle(
                            fontSize: screenWidth * 0.035,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (patient.needsAttention)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.orange[300]!),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.orange[700],
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "Need Attention",
                        style: TextStyle(
                          color: Colors.orange[700],
                          fontSize: screenWidth * 0.03,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFF8E2EFF),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8E2EFF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "View Profile",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.03,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to show mood selection bottom sheet
  void _showMoodSelection(BuildContext context) {
    print("sdkkfskfksdfk");
    if (widget.logsViewModel != null) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        // builder: (context) => MoodSelectionBottomSheet(
        //   logsViewModel: widget.logsViewModel!,
        //   onMoodSelected: (mood) {},
        // ), v
        builder: (context) => MoodTrackerScreen(
          logsViewModel: widget.logsViewModel!,
          onMoodSelected: (mood) {},
        ),
      );
    } else {
      print('❌ LogsViewModel not available');
    }
  }

  // Helper method to show workout selection bottom sheet
  void _showWorkoutSelection(BuildContext context) {
    if (widget.logsViewModel != null) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => WorkoutSelectionBottomSheet(
          logsViewModel: widget.logsViewModel!,
          onWorkoutSelected: (workoutData) {},
        ),
      );
    } else {
      print('❌ LogsViewModel not available');
    }
  }

  // Helper method to show sleep selection bottom sheet
  void _showSleepSelection(BuildContext context) {
    print("🛌 Sleep card tapped!");
    print("LogsViewModel available: ${widget.logsViewModel != null}");
    if (widget.logsViewModel != null) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => SleepSelectionBottomSheet(
          logsViewModel: widget.logsViewModel!,
          onSleepSelected: (sleepData) {
            print('✅ Sleep selected and logged: $sleepData');
            // Additional logic can be added here if needed
          },
        ),
      );
    } else {
      print('❌ LogsViewModel not available');
    }
  }

  // Helper method to get today's mood count for dynamic points display
  int _getTodayMoodCount(LogsState? state) {
    // For now, return a simple count based on logged moods today
    // You can enhance this by:
    // 1. Adding a counter to LogsState
    // 2. Persisting daily counts in local storage
    // 3. Fetching today's logs from API

    if (state?.status == LogsStatus.success && state?.selectedMood != null) {
      // Simple logic: if mood was logged today, show 1, otherwise 0
      // In real implementation, you'd track multiple logs per day
      return 1;
    }
    return 0;
  }
}
