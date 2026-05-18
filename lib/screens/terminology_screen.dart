import 'package:flutter/material.dart';
import '../data/terminology_data.dart';
import '../widgets/custom_widgets.dart';

class TerminologyScreen extends StatefulWidget {
  const TerminologyScreen({super.key});

  @override
  State<TerminologyScreen> createState() => _TerminologyScreenState();
}

class _TerminologyScreenState extends State<TerminologyScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Term> _filteredTerms = terminologyData;

  void _filterTerms(String query) {
    setState(() {
      _filteredTerms = terminologyData
          .where(
            (term) =>
                term.title.toLowerCase().contains(query.toLowerCase()) ||
                term.definition.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          const ModernHeader(
            title: "Terimler Sözlüğü",
            screenType: TerminologyScreen,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterTerms,
              decoration: InputDecoration(
                hintText: "Terim veya açıklama ara...",
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF1A237E),
                    width: 1.5,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          Expanded(
            child: _filteredTerms.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 64,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Sonuç bulunamadı",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredTerms.length,
                    itemBuilder: (context, index) {
                      final term = _filteredTerms[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                          border: Border.all(color: Colors.grey.shade100),
                        ),
                        child: Theme(
                          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1a365d).withValues(alpha: 0.05),
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                term.title[0].toUpperCase(),
                                style: const TextStyle(
                                  color: Color(0xFF1a365d),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            title: Text(
                              term.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.5,
                                color: Color(0xFF1a365d),
                              ),
                            ),
                            iconColor: const Color(0xFF1a365d),
                            collapsedIconColor: Colors.grey,
                            children: [
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  border: const Border(
                                    top: BorderSide(color: Color(0xFFEEEEEE), width: 0.5),
                                    left: BorderSide(color: Color(0xFF1a365d), width: 4),
                                  ),
                                ),
                                child: Text(
                                  term.definition,
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    color: Colors.grey[800],
                                    height: 1.6,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
