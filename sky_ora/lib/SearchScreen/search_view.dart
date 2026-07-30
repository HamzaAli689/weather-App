import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'search_logic.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ensure kar lein ke controller theek se put ho raha hai
    final SearchLogic controller = Get.put(SearchLogic(), permanent: true);
    final TextEditingController textController = TextEditingController();

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F172A), // Deep Navy Top
              Color(0xFF1E3A8A), // Rich Blue
              Color(0xFF090D16), // Dark Bottom
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Bar with Back Button & Search Input
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.07),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.15),
                          ),
                        ),
                        child: TextField(
                          controller: textController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: "Search city...",
                            hintStyle: TextStyle(color: Colors.white54),
                            border: InputBorder.none,
                          ),
                          onSubmitted: (value) {
                            controller.searchAndReturnCity(value);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      icon: const Icon(Icons.search, color: Colors.white),
                      onPressed: () {
                        controller.searchAndReturnCity(textController.text);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Section Title for History
                const Text(
                  "Recent Searches",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),

                // Dynamic Recent Searches List
                Expanded(
                  child: Obx(() {
                    if (controller.recentSearches.isEmpty) {
                      return const Center(
                        child: Text(
                          "No search history yet.\nSearch a city to see it here.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 14,
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: controller.recentSearches.length,
                      itemBuilder: (context, index) {
                        String cityName = controller.recentSearches[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.04),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.08),
                            ),
                          ),
                          child: ListTile(
                            leading: const Icon(
                              Icons.history,
                              color: Colors.white70,
                            ),
                            title: Text(
                              cityName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.close,
                                color: Colors.white54,
                                size: 18,
                              ),
                              onPressed: () {
                                controller.removeSearchItem(cityName);
                              },
                            ),
                            onTap: () {
                              // History item par click karne se bhi wahi city select ho kar dashboard jaye gi
                              Get.back(result: cityName);
                            },
                          ),
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}