import 'package:flutter/material.dart';
import '/src/core/ui/helpers/size_extensions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final screenShortestSide = context.screenShortestSide;
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Container(
              height: screenShortestSide * .175,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'img/logo.png',
                  ),
                  fit: BoxFit.fill,
                ),
              ), // Altura do retângulo no topo
            ),
            DecoratedBox(
              decoration: const BoxDecoration(
                color: Color(
                    0xFF576A59), // Use 0xFF para especificar uma cor sólida com transparência completa
              ),
              child: SizedBox(
                height: screenShortestSide * .075,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton.icon(

                      onPressed: () {
                        // Adicione a lógica para a opção "Início" aqui
                      },
                      icon: const Icon(Icons.home),
                      label: const Text('Início'),
                      style: TextButton.styleFrom(
                        foregroundColor:
                            Colors.white, // Define a cor do texto do botão
                        textStyle: TextStyle(fontSize: 25),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Adicione a lógica para a opção "Apresentação" aqui
                      },
                      style: TextButton.styleFrom(
                        foregroundColor:
                            Colors.white,
                        textStyle: TextStyle(fontSize: 25), // Define a cor do texto do botão
                      ),
                      child: Text('Apresentação'),
                    ),
                    TextButton(
                      onPressed: () {
                        // Adicione a lógica para a opção "Fale Conosco" aqui
                      },
                      style: TextButton.styleFrom(
                        foregroundColor:
                            Colors.white, 
                        textStyle: TextStyle(fontSize: 25),// Define a cor do texto do botão
                      ),
                      child: Text('Fale Conosco'),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: screenShortestSide * .45,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'img/camuflado.jpg',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              height: screenShortestSide * .15,
              decoration: const BoxDecoration(
                color: Color(0xFFE2F0D9),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed:(){}, 
                    style: ButtonStyle(
                      
                      backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF576A59)), 
                      minimumSize: MaterialStateProperty.all<Size>(Size(200.0, 70.0)),  
                       
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                      Icon(Icons.library_books), 
                      SizedBox(width: 8.0), 
                      Text("Periódicos"),
                    ],
                  ),
                  ),
                  
                  ElevatedButton(
                    onPressed:(){}, 
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF576A59)), 
                      minimumSize: MaterialStateProperty.all<Size>(Size(200.0, 70.0)),   
                    ),
                  child:  const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                      Icon(Icons.filter), 
                      SizedBox(width: 8.0), 
                      Text('Publicações'),
                    ],
                  ),
                  ),                   
                  
                  ElevatedButton(
                    onPressed:(){}, 
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF576A59)), 
                      minimumSize: MaterialStateProperty.all<Size>(Size(200.0, 70.0)),  
                    ),
                    child:  const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                      Icon(Icons.import_contacts), 
                      SizedBox(width: 8.0), 
                      Text('Trabalhos Acadêmicos'),
                    ],
                  ),
                  ), 
                   
                  
                  ElevatedButton(
                    onPressed:(){}, 
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF576A59)), 
                      minimumSize: MaterialStateProperty.all<Size>(Size(200.0, 70.0)),  
                    ),
                    child:  const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                      Icon(Icons.public), 
                      SizedBox(width: 8.0), 
                      Text('Crises/Guerras e Conflitos Atuais'),
                    ],
                  ),
                  ), 
                   
                  
                  ElevatedButton(
                    onPressed:(){}, 
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF576A59)), 
                      minimumSize: MaterialStateProperty.all<Size>(Size(200.0, 70.0)),   
                    ),
                    child:  const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                      Icon(Icons.tungsten), 
                      SizedBox(width: 8.0), 
                      Text('Produção do CDDCFN'),
                    ],
                  ),
                  ),                 
                ],
              ),
            ),
           
              Container(
              height: screenShortestSide * .150,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'img/rodape.png',
                  ),
                  fit: BoxFit.fill,
                ),
              ), // Altura do retângulo no topo
            ),
          ],
        ),
      ),
    );
  }
}
