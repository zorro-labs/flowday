import 'package:flutter/material.dart';

void main() => runApp(const FlowdayApp());

class FlowdayApp extends StatelessWidget {
  const FlowdayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flowday',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF117A4F)),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const StartScreen(),
    );
  }
}

class FlowdayColors {
  static const deepGreen = Color(0xFF117A4F);
  static const green = Color(0xFF159660);
  static const cardGreen = Color(0xFF0E6D49);
  static const tile = Color(0xFF063D42);
  static const lime = Color(0xFFB6E46D);
  static const gold = Color(0xFFF5B23D);
}

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlowBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const BrandHeader(centered: true),
                const Spacer(),
                const Text('Local Database', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w800)),
                const SizedBox(height: 110),
                FlowButton(
                  text: 'CREATE NEW DATABASE (!)',
                  colors: const [Color(0xFFE31554), Color(0xFF7E0B30)],
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileSetupScreen())),
                ),
                const SizedBox(height: 24),
                FlowButton(
                  text: 'SELECT EXISTING DATABASE (!)',
                  colors: const [Color(0xFF2F83C9), Color(0xFF06214B)],
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PlannerHomeScreen())),
                ),
                const Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileSetupScreen extends StatelessWidget {
  const ProfileSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlowBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                const BrandHeader(centered: true),
                const SizedBox(height: 86),
                const Text('Create personal profile', style: TextStyle(color: Colors.white, fontSize: 25)),
                const SizedBox(height: 32),
                const CircleAvatar(radius: 62, backgroundColor: Color(0xFFD9D9D9), child: Icon(Icons.camera_alt_outlined, size: 34, color: Colors.white70)),
                const SizedBox(height: 22),
                const FlowTextField(hint: 'Name or Nick Name'),
                const SizedBox(height: 20),
                const FlowTextField(hint: 'Date of Birth (optional)'),
                const SizedBox(height: 20),
                const FlowTextField(hint: 'Your Profession (optional)'),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(fixedSize: const Size(130, 40), backgroundColor: const Color(0xFFE1E1E1), foregroundColor: Colors.black),
                  onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const PlannerHomeScreen())),
                  child: const Text('Create'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PlannerHomeScreen extends StatefulWidget {
  const PlannerHomeScreen({super.key});

  @override
  State<PlannerHomeScreen> createState() => _PlannerHomeScreenState();
}

class _PlannerHomeScreenState extends State<PlannerHomeScreen> {
  int tab = 0;
  bool moodOpen = false;

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeGridScreen(onMood: () => setState(() => moodOpen = true)),
      const TasksDoneScreen(),
      const ProfileScreen(),
    ];
    return Scaffold(
      body: Stack(children: [pages[tab], if (moodOpen) MoodOverlay(onClose: () => setState(() => moodOpen = false))]),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.black,
        indicatorColor: Colors.transparent,
        selectedIndex: tab,
        onDestinationSelected: (value) => setState(() => tab = value),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.calendar_month), label: 'Planner'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class HomeGridScreen extends StatelessWidget {
  const HomeGridScreen({super.key, required this.onMood});
  final VoidCallback onMood;

  @override
  Widget build(BuildContext context) {
    final hours = List.generate(24, (i) => ScheduleHour(i + 1, _emojiFor(i), _colorFor(i)));
    return FlowScaffold(
      child: Column(
        children: [
          const BrandHeader(),
          const StreakBar(title: 'Four Day Streak 👏'),
          Expanded(
            child: FlowCard(
              child: Column(
                children: [
                  const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('29 May 2025', style: TextStyle(color: Colors.white70)), Text('3:00 PM', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)), Text('Thursday', style: TextStyle(color: Colors.white70))]),
                  const SizedBox(height: 26),
                  const Text('Regular . Mon - Fri', style: TextStyle(color: Colors.white70, fontSize: 16)),
                  const SizedBox(height: 18),
                  Expanded(child: TimeGrid(hours: hours)),
                  Row(children: [const Text('Edit ⚙️', style: TextStyle(color: Colors.white)), const Spacer(), const Text('score: ', style: TextStyle(color: Colors.white)), const Text('98% 🔥', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)), const Text(' | ', style: TextStyle(color: Colors.white54)), const Text('Balanced day', style: TextStyle(color: Colors.amber)), IconButton(onPressed: onMood, icon: const Icon(Icons.download_done, color: Colors.white))]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TimeGrid extends StatelessWidget {
  const TimeGrid({super.key, required this.hours});
  final List<ScheduleHour> hours;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, mainAxisSpacing: 12, crossAxisSpacing: 18, childAspectRatio: 1.12),
      itemCount: hours.length,
      itemBuilder: (context, index) => Stack(
        clipBehavior: Clip.none,
        children: [
          if (index % 4 != 3) Positioned(right: -20, top: 28, child: Container(width: 22, height: 4, color: hours[index].connector)),
          AnimatedContainer(
            duration: const Duration(milliseconds: 240),
            decoration: BoxDecoration(color: FlowdayColors.tile, borderRadius: BorderRadius.circular(9), border: index == 10 ? Border.all(color: Colors.yellowAccent) : null),
            child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Text(hours[index].emoji, style: const TextStyle(fontSize: 22)), Text('${hours[index].hour} ${hours[index].hour < 12 ? 'AM' : 'PM'}', style: const TextStyle(color: Colors.white))])),
          ),
        ],
      ),
    );
  }
}

class TasksDoneScreen extends StatelessWidget {
  const TasksDoneScreen({super.key});
  static const tasks = [
    '8 hours sleep',
    '7 AM Brush',
    '8 - 9 AM exercise',
    '10 AM to 2 PM work',
    '2 PM Lunch',
    '3 PM to 6 PM work',
    '7 PM - 8 PM meditation',
    '8 PM lunch',
    '9 PM to 10 PM reading',
    '10 PM brush',
    '10 PM - 11 PM on to bed.',
  ];

  @override
  Widget build(BuildContext context) {
    return FlowScaffold(
      child: Column(
        children: [
          const BrandHeader(),
          const StreakBar(title: 'Streak starts ✅', starEnd: true),
          Expanded(
            child: FlowCard(
              child: Column(
                children: [
                  const Text('Tasks done', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 22),
                  ...tasks.map(
                    (task) => CheckboxListTile(
                      value: false,
                      onChanged: (_) {},
                      title: Text(task, style: const TextStyle(color: Colors.white, fontSize: 17)),
                      controlAffinity: ListTileControlAffinity.leading,
                      dense: true,
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    color: Colors.black,
                    child: Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        onPressed: () {},
                        child: const Text('Evaluate My day', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) => FlowScaffold(child: Column(children: [const BrandHeader(), const Row(children: [CircleAvatar(radius: 26, backgroundColor: Color(0xFFD9D9D9)), SizedBox(width: 16), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Username', style: TextStyle(color: Colors.white, fontSize: 17)), Text('Average Score 82%', style: TextStyle(color: Colors.white70, fontSize: 16))])]), const SizedBox(height: 50), const Text('Week Stars - 16 ⭐', style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold)), const Text('Check Star Year', style: TextStyle(color: Colors.white70, fontSize: 21)), const SizedBox(height: 45), Wrap(spacing: 25, runSpacing: 30, children: List.generate(16, (_) => const Text('⭐', style: TextStyle(fontSize: 55))))]));
}

class MoodOverlay extends StatelessWidget {
  const MoodOverlay({super.key, required this.onClose});
  final VoidCallback onClose;
  static const moods = ['😃 Happy', '😫 Tired', '🤗 Satisfied', '😩 Drained', '😌 Calm', '😖 Irritated', '😊 Relaxed', '😤 Frustrated', '☘️ Content', '😠 Annoyed', '😉 Good', '😞 dissatisfied', '🫣 Ecstatic', '😐 Neutral', '😁 Blissful', '👌 Okay', '🤩 Jubilated', '✌️ Alright', '😎 Euphoric', '🧊 Cold', '🧐 Focused', '🚀 Driven', '💪 Motivated', '❄️ Clear-Headed'];
  @override
  Widget build(BuildContext context) => GestureDetector(onTap: onClose, child: Container(color: Colors.black26, alignment: Alignment.center, child: Container(margin: const EdgeInsets.all(20), padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: const Color(0xFFA9BDE8), borderRadius: BorderRadius.circular(6)), child: GridView.count(shrinkWrap: true, crossAxisCount: 2, childAspectRatio: 4, children: moods.map((m) => Text(m, style: const TextStyle(fontSize: 24, color: Colors.black))).toList()))));
}

class FlowScaffold extends StatelessWidget {
  const FlowScaffold({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => FlowBackground(child: SafeArea(child: Padding(padding: const EdgeInsets.all(20), child: child)));
}

class FlowBackground extends StatelessWidget {
  const FlowBackground({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [FlowdayColors.green, FlowdayColors.deepGreen], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: Stack(
          children: [
            Positioned(right: -65, top: 4, child: CircleAvatar(radius: 100, backgroundColor: Colors.lightGreenAccent.withOpacity(.28))),
            Positioned(left: -30, top: 0, bottom: 0, child: Transform.rotate(angle: -.18, child: Container(width: 130, decoration: BoxDecoration(border: Border.all(color: Colors.white24))))),
            Positioned(right: 70, top: 85, child: CircleAvatar(radius: 30, backgroundColor: Colors.lightGreenAccent.withOpacity(.22))),
            child,
          ],
        ),
      );
}

class BrandHeader extends StatelessWidget {
  const BrandHeader({super.key, this.centered = false});
  final bool centered;
  @override
  Widget build(BuildContext context) => Row(mainAxisAlignment: centered ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween, children: [const Text('Flowday', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900, letterSpacing: 1.2)), if (!centered) const Icon(Icons.menu, color: Colors.white, size: 38)]);
}

class StreakBar extends StatelessWidget {
  const StreakBar({super.key, required this.title, this.starEnd = false});
  final String title;
  final bool starEnd;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 22),
        child: Column(
          children: [
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            Row(
              children: List.generate(
                7,
                (i) => Expanded(
                  child: Row(
                    children: [
                      CircleAvatar(radius: 7, backgroundColor: i < 4 ? Colors.orangeAccent : Colors.white70),
                      if (i < 6) Expanded(child: Container(height: 3, color: i < 4 ? Colors.orangeAccent : Colors.white70)),
                    ],
                  ),
                ),
              ),
            ),
            if (starEnd) const Align(alignment: Alignment.centerRight, child: Text('⭐', style: TextStyle(fontSize: 32))),
          ],
        ),
      );
}

class FlowCard extends StatelessWidget {
  const FlowCard({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => Container(width: double.infinity, padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: FlowdayColors.cardGreen.withOpacity(.82), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.black26)), child: child);
}

class FlowButton extends StatelessWidget {
  const FlowButton({super.key, required this.text, required this.colors, required this.onTap});
  final String text;
  final List<Color> colors;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: colors),
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 6, offset: Offset(0, 5))],
          ),
          child: Text(text, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        ),
      );
}

class FlowTextField extends StatelessWidget {
  const FlowTextField({super.key, required this.hint});
  final String hint;
  @override
  Widget build(BuildContext context) => TextField(decoration: InputDecoration(filled: true, fillColor: const Color(0xFFE0E0E0), hintText: hint, border: InputBorder.none));
}

class ScheduleHour {
  ScheduleHour(this.hour, this.emoji, this.connector);
  final int hour;
  final String emoji;
  final Color connector;
}

String _emojiFor(int index) {
  if (index < 6 || index > 21) return '💤';
  if (index < 8) return '🪥';
  if (index < 16) return '💠';
  if (index == 17) return '🛌';
  if (index == 18) return '🧘';
  if (index == 19) return '🍴';
  if (index == 20) return '📗';
  return '🪥';
}

Color _colorFor(int index) {
  if (index < 6 || index > 21) return Colors.black;
  if (index < 8) return Colors.tealAccent;
  if (index < 16) return Colors.blueAccent;
  if (index < 20) return Colors.orange;
  return Colors.greenAccent;
}
