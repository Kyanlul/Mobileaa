import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _suggestions = [
    'kitchen essentials',
    'sweatshirts',
    'wireless earbuds',
    'air fryer'
  ];
  List<String> _filteredSuggestions = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _filteredSuggestions = _suggestions;
  }

  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
      _filteredSuggestions = _suggestions
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF42A5F5),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // Xử lý back
          },
        ),
        title: TextField(
          controller: _searchController,
          onChanged: _updateSearchQuery,
          decoration: const InputDecoration(
            hintText: 'Search',
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search, color: Colors.white),
          ),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (_searchQuery.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _filteredSuggestions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_filteredSuggestions[index]),
                  onTap: () {
                    // Xử lý chọn gợi ý
                  },
                );
              },
            ),
        ]),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String title;
  final bool isTrending;

  const ProductCard({super.key, required this.title, required this.isTrending});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.grey[300],
              child:
                  const Center(child: Text('Image')), // Placeholder for product image
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Text(
                  isTrending ? 'BIG SALE' : 'SALE 50%',
                  style: const TextStyle(fontSize: 12, color: Colors.red),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
