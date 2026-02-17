import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weatherly/core/widgets/app_icon.dart';
import 'package:weatherly/features/home/presentation/pages/home_page.dart';

final hasSeenOnboardingProvider = FutureProvider<bool>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('has_seen_onboarding') ?? false;
});

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingContent> _pages = [
    OnboardingContent(
      title: 'Welcome to Weatherly',
      description:
          'Your personal weather companion with accurate forecasts and detailed weather information.',
      isAppIcon: true,
    ),
    OnboardingContent(
      title: 'Location Services',
      description:
          'We need your location to provide accurate weather data for your area. You can also search for any location worldwide.',
      icon: Icons.location_on,
      color: Colors.blue,
    ),
    OnboardingContent(
      title: 'Weather Alerts',
      description:
          'Stay informed with real-time weather alerts and notifications for severe weather conditions.',
      icon: Icons.notifications_active,
      color: Colors.red,
    ),
    OnboardingContent(
      title: 'Get Started',
      description: 'Choose your preferences and start exploring the weather!',
      icon: Icons.check_circle,
      color: Colors.green,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_onboarding', true);

    if (mounted) {
      // Navigate to home page and remove the onboarding page from the stack
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemBuilder: (context, index) {
                  return _buildPage(_pages[index]);
                },
              ),
            ),
            _buildIndicator(),
            const SizedBox(height: 20),
            _buildButton(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingContent content) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (content.isAppIcon)
            const AppIcon(size: 120)
          else
            Icon(content.icon, size: 120, color: content.color),
          const SizedBox(height: 40),
          Text(
            content.title,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            content.description,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _pages.length,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentPage == index ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: _currentPage == index
                ? Theme.of(context).primaryColor
                : Colors.grey[300],
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  Widget _buildButton() {
    final isLastPage = _currentPage == _pages.length - 1;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () {
            if (isLastPage) {
              _completeOnboarding();
            } else {
              _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          },
          child: Text(
            isLastPage ? 'Get Started' : 'Next',
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}

class OnboardingContent {
  final String title;
  final String description;
  final IconData? icon;
  final Color? color;
  final bool isAppIcon;

  OnboardingContent({
    required this.title,
    required this.description,
    this.icon,
    this.color,
    this.isAppIcon = false,
  });
}
