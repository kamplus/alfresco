import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alfresco Search',
      home: SearchScreen(),
    );
  }
}

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = "";
  List<Map<String, dynamic>> _searchResults = [];

  Future<void> _search() async {
    final String alfrescoServer = "http://34.95.246.115";
    //final String searchApiUrl = "$alfrescoServer/alfresco/api/-default-/public/search/versions/1/search";
    //final String authUrl = "$alfrescoServer/alfresco/api/-default-/public/authentication/versions/1/tickets";
    final String username = "admin";
    final String password = "dreamteam";

    final Uri authUrl = Uri.parse("$alfrescoServer/alfresco/api/-default-/public/authentication/versions/1/tickets");

    final Uri searchApiUrl = Uri.parse("$alfrescoServer/alfresco/api/-default-/public/search/versions/1/search");

    // Encode credentials for basic authentication
    final String credentials = base64Encode(utf8.encode("$username:$password"));

    // Request authentication ticket
    final Map<String, String> authData = {
      "userId": username,
      "password": password,
    };

    final Map<String, String> authHeaders = {
      "Content-Type": "application/json",
      "Accept": "application/json",
    };

    final authResponse = await http.post(authUrl, body: jsonEncode(authData), headers: authHeaders);

    if (authResponse.statusCode == 201) {
      final authTicket = authResponse.body.trim();

      final Map<String, String> searchHeaders = {
        "Authorization": "Basic $credentials",
        "Content-Type": "application/json",
        "Accept": "application/json",
      };

      final Map<String, dynamic> searchBody = {
        "query": {
          "language": "afts",
          "query": _searchTerm,
        },
        "paging": {
          "maxItems": 10,
          "skipCount": 0,
        },
        "highlight": {
          "fragmentSize": 300,
          "prefix": "¿",
          "postfix": "?",
          "mergeContiguous": true,
          "fields": [
            {
              "field": "cm:content",
            },
            {
              "field": "description",
              "prefix": "(",
              "postfix": ")",
            },
          ],
        },
        "localization": {"locales": ["pt_BR"]},
        "scope": {
          "locations": "nodes",
        },
      };

      final searchResponse = await http.post(searchApiUrl, body: jsonEncode(searchBody), headers: searchHeaders);

      if (searchResponse.statusCode == 200) {
        final Map<String, dynamic> searchResult = jsonDecode(searchResponse.body);
        final List<dynamic> entries = searchResult["list"]["entries"];

        List<Map<String, dynamic>> results = [];

        for (dynamic entry in entries) {
          final String name = entry["entry"]["name"];
          String snippet;

          try {
            snippet = entry["entry"]["search"]["highlight"][0]["snippets"];
          } catch (e) {
            snippet = "Não foi possível obter o trecho do texto";
          }

          snippet = snippet[0].replaceAll('\n', '').replaceAll('..', '').replaceAll('\t', '');
          final String downloadLink = "$alfrescoServer/alfresco/api/-default-/public/cmis/versions/1.1/atom/content?id=${entry["entry"]["id"]}";

          results.add({
            "name": name,
            "snippet": snippet,
            "downloadLink": downloadLink,
          });
        }

        setState(() {
          _searchResults = results;
        });
      } else {
        print("Erro ao fazer a solicitação de pesquisa: Código de Status ${searchResponse.statusCode}");
        print(searchResponse.body);
      }
    } else {
      print("Erro ao obter o token de autenticação: Código de Status ${authResponse.statusCode}");
      print(authResponse.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alfresco Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(labelText: 'Digite o termo de pesquisa'),
              onChanged: (value) {
                setState(() {
                  _searchTerm = value;
                });
              },
            ),
          ),
          ElevatedButton(
            onPressed: _search,
            child: Text('Pesquisar'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final result = _searchResults[index];
                return ListTile(
                  title: Text("Nome do Arquivo: ${result["name"]}"),
                  subtitle: Text("Texto Destacado: ...${result["snippet"]}..."),
                  onTap: () {
                    // Handle tapping on the result (e.g., open download link)
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
