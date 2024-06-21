import 'package:eshopee/views/screens/inner_Screens/store_details_screen.dart';
import 'package:flutter/material.dart';

class StoresScreen extends StatefulWidget {
  const StoresScreen({super.key});

  @override
  State<StoresScreen> createState() => _StoresScreenState();
}

class _StoresScreenState extends State<StoresScreen> {
  final List<Map<String, dynamic>> _stores = [
    {
      'name': 'Tech World',
      'logo': 'assets/store_logo1.png',
      'location': '123 Tech Lane, Silicon Valley, CA',
      'category': 'Electronics',
      'hours': '9:00 AM - 6:00 PM',
      'contact': '123-456-7890',
      'rating': 4.5,
    },
    {
      'name': 'Fashion Hub',
      'logo': 'assets/store_logo2.png',
      'location': '456 Trendy Street, New York, NY',
      'category': 'Clothing',
      'hours': '10:00 AM - 8:00 PM',
      'contact': '987-654-3210',
      'rating': 4.7,
    },
    // Add more stores as needed
  ];

  String _searchQuery = '';
  String _selectedCategory = 'All';
  List<String> _categories = ['All', 'Electronics', 'Clothing', 'Furniture'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stores'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: StoreSearch(_stores));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: _selectedCategory,
              items: _categories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategory = newValue!;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredStores().length,
              itemBuilder: (context, index) {
                final store = _filteredStores()[index];
                return StoreCard(store: store);
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _filteredStores() {
    return _stores
        .where((store) =>
            (_selectedCategory == 'All' ||
                store['category'] == _selectedCategory) &&
            (store['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
                store['location']
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase())))
        .toList();
  }
}

class StoreCard extends StatelessWidget {
  final Map<String, dynamic> store;

  const StoreCard({Key? key, required this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: Image.asset(store['logo'],
            width: 50, height: 50, fit: BoxFit.cover),
        title: Text(store['name']),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(store['location']),
            Text('Category: ${store['category']}'),
            Text('Hours: ${store['hours']}'),
            Text('Rating: ${store['rating']}'),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => StoreDetailsScreen(store: store)),
            );
          },
        ),
      ),
    );
  }
}

class StoreSearch extends SearchDelegate {
  final List<Map<String, dynamic>> stores;

  StoreSearch(this.stores);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = stores.where((store) {
      return store['name'].toLowerCase().contains(query.toLowerCase()) ||
          store['location'].toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Image.asset(results[index]['logo'],
              width: 50, height: 50, fit: BoxFit.cover),
          title: Text(results[index]['name']),
          subtitle: Text(results[index]['location']),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      StoreDetailsScreen(store: results[index])),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = stores.where((store) {
      return store['name'].toLowerCase().contains(query.toLowerCase()) ||
          store['location'].toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Image.asset(suggestions[index]['logo'],
              width: 50, height: 50, fit: BoxFit.cover),
          title: Text(suggestions[index]['name']),
          subtitle: Text(suggestions[index]['location']),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      StoreDetailsScreen(store: suggestions[index])),
            );
          },
        );
      },
    );
  }
}
