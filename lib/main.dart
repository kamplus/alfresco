import 'dart:html';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Alfresco Search',
      home: SearchScreen(),
    );
  }
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  _SearchScreenState({
    required this._searchController,
    required this._searchTerm,
    required this._searchResults
  });
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = "";
  List<Map<String, dynamic>> _searchResults = [];



  

  Future<void> _search() async {
    const String alfrescoServer = "http://34.95.246.115";
    //final String searchApiUrl = "$alfrescoServer/alfresco/api/-default-/public/search/versions/1/search";
    //final String authUrl = "$alfrescoServer/alfresco/api/-default-/public/authentication/versions/1/tickets";
    const String username = "admin";
    const String password = "dreamteam";

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
    var authResponse;
    try{
      authResponse = await http.post(authUrl, body: jsonEncode(authData), headers: authHeaders);
      }catch(e){
        print('pegou'+e.toString());
        }
        
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
          "prefix": "<strong>",
          "postfix": "</strong>",
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
      var searchResponse;
      try{
        searchResponse = await http.post(searchApiUrl, body: jsonEncode(searchBody), headers: searchHeaders);

      }catch(e){
        print(e.toString());
      } 
      if (searchResponse.statusCode == 200) {
        final Map<String, dynamic> searchResult = jsonDecode(searchResponse.body);
        final List<dynamic> entries = searchResult["list"]["entries"];

        List<Map<String, dynamic>> results = [];

        for (dynamic entry in entries) {
          final String name = entry["entry"]["name"];
          String snippet;

          try {
            
            var search = entry["entry"]['search'];
            var highlight = search['highlight'];
            var snippets = highlight[0]['snippets'];
            snippet = snippets[0];
          } catch (e) {
            snippet = "Não foi possível obter o trecho do texto";
          }

          snippet = snippet.replaceAll(RegExp(r'\s+'), ' ');
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
      }
    } else {
      print("Erro ao obter o token de autenticação: Código de Status ${authResponse.statusCode}");     
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
                  title: Text(" ${result["name"]}"),
                  subtitle: Text("${result["snippet"]}"),
                  onTap: () {
                    
                    
                    download_file(result["downloadLink"],result["name"]);
                    
                    
                    
                    //result["downloadLink"]// Handle tapping on the result (e.g., open download link)
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  
  Future<void> download_file(String endereco, String nome) async {
    final url = Uri.parse(endereco);
 // Credenciais
    final username = 'admin';
    final password = 'dreamteam';

    final client = http.Client();
    try {
      final response = await client.get(
        url,
        headers: {
          HttpHeaders.authorizationHeader: 'Basic ${base64Encode(utf8.encode('$username:$password'))}',
        },
      );

      if (response.statusCode == 200) {
        final downloadsDirectory = await DownloadsPathProvider.downloadsDirectory;

        // Nome do arquivo que será salvo
        final filename = "arquivo_downloadado.txt";

        final file = File("${downloadsDirectory.path}/$filename");
        await file.writeAsBytes(response.bodyBytes);

        
      } else {
        
      }
    } catch (e) {
      
    } finally {
      client.close();
    }
  }
}
