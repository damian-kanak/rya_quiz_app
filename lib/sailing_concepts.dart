import 'package:flutter/material.dart';
import 'points_of_sail_screen.dart';

// Color constants
const Color kBackgroundColor = Color.fromRGBO(255, 255, 255, 0.1);
const Color kBorderColor = Color.fromRGBO(255, 255, 255, 0.2);
const Color kTextColor = Color.fromRGBO(255, 255, 255, 0.8);
const Color kDeepBlue = Color(0xFF1B4B82);
const Color kOceanBlue = Color(0xFF2C7DA0);
const Color kWhite = Colors.white;

class SailingConcept {
  final String title;
  final String description;
  final IconData icon;
  final String content;
  final String? visualAidType;
  final String? visualAidData;

  const SailingConcept({
    required this.title,
    required this.description,
    required this.icon,
    required this.content,
    this.visualAidType,
    this.visualAidData,
  });
}

class SailingConceptsScreen extends StatelessWidget {
  SailingConceptsScreen({super.key});

  final List<SailingConcept> concepts = [
    SailingConcept(
      title: 'Points of Sail',
      description: 'Learn about different points of sail including close-hauled, beam reach, broad reach, and running.',
      icon: Icons.navigation,
      content: 'The points of sail are the different angles a sailboat can sail relative to the wind. The main points of sail are:\n\n'
          '1. Into the Wind (No-Go Zone)\n'
          '2. Close Hauled\n'
          '3. Beam Reach\n'
          '4. Broad Reach\n'
          '5. Running\n\n'
          'Each point of sail requires different sail trim and boat handling techniques.',
      visualAidType: 'points_of_sail',
    ),
    SailingConcept(
      title: 'Wind Direction',
      description: 'Understanding wind direction and how it affects sailing, including apparent wind vs true wind.',
      icon: Icons.air,
      content: 'Wind direction is the angle at which the wind is blowing relative to the boat. It affects the sailboat\'s speed, course, and stability.',
    ),
    SailingConcept(
      title: 'Tides and Currents',
      description: 'Basic understanding of tides, currents, and their impact on navigation.',
      icon: Icons.water,
      content: 'Tides are the rise and fall of sea levels caused by the gravitational pull of the moon and sun. Currents are the movement of water in a specific direction.',
    ),
    SailingConcept(
      title: 'Navigation Basics',
      description: 'Essential navigation concepts including charts, compass, and basic plotting.',
      icon: Icons.map,
      content: 'Navigation is the process of determining a boat\'s position and course. Essential tools include charts, a compass, and basic plotting techniques.',
    ),
    SailingConcept(
      title: 'Safety Procedures',
      description: 'Important safety procedures, equipment, and emergency protocols.',
      icon: Icons.safety_check,
      content: 'Safety procedures are essential for a safe sailing experience. This includes understanding emergency protocols, using appropriate safety equipment, and following best practices.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              kDeepBlue,
              kOceanBlue,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App Bar
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: kBackgroundColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: kWhite),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Sailing Concepts',
                      style: TextStyle(
                        color: kWhite,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              // Main Content
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: concepts.length,
                  itemBuilder: (context, index) {
                    final concept = concepts[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: kBackgroundColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: kBorderColor,
                          width: 1,
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            if (concept.title == 'Points of Sail') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const PointsOfSailScreen()),
                              );
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  backgroundColor: kDeepBlue,
                                  title: Text(
                                    concept.title,
                                    style: const TextStyle(color: kWhite),
                                  ),
                                  content: Text(
                                    concept.description,
                                    style: const TextStyle(color: kWhite),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Close'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: kBorderColor,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    concept.icon,
                                    color: kWhite,
                                    size: 32,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        concept.title,
                                        style: TextStyle(
                                          color: kWhite,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        concept.description,
                                        style: TextStyle(
                                          color: kTextColor,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: kTextColor,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ConceptDetailScreen extends StatelessWidget {
  final SailingConcept concept;

  const ConceptDetailScreen({
    super.key,
    required this.concept,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              kDeepBlue,
              kOceanBlue,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App Bar
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: kBackgroundColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: kWhite),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      concept.title,
                      style: TextStyle(
                        color: kWhite,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              // Main Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: kBackgroundColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: kBorderColor,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: kBorderColor,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    concept.icon,
                                    color: kWhite,
                                    size: 32,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    concept.description,
                                    style: TextStyle(
                                      color: kWhite,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Text(
                              concept.content,
                              style: TextStyle(
                                color: kWhite,
                                fontSize: 16,
                              ),
                            ),
                            if (concept.visualAidType != null) ...[
                              const SizedBox(height: 24),
                              Container(
                                height: 300,
                                decoration: BoxDecoration(
                                  color: kBorderColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Text(
                                    'Visual Aid: ${concept.visualAidType}',
                                    style: TextStyle(
                                      color: kTextColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
      ),
    );
  }
} 