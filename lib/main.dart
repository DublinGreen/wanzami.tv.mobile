import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'pages/landing_page.dart';
import 'pages/login_page.dart';
import 'pages/signup_page.dart';

void main() async {
  // Make sure everything Flutter-related is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive (used by graphql_flutter for caching)
  await initHiveForFlutter();

  // Create an HttpLink to your GraphQL endpoint
  final HttpLink httpLink = HttpLink(
    'https://auth.wanzami.tv/graphql', // ✅ Your actual GraphQL endpoint
  );

  // Create the client and wrap it in a ValueNotifier
  final ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(store: HiveStore()),
    ),
  );

  // Run the app wrapped in GraphQLProvider
  runApp(
    GraphQLProvider(
      client: client,
      child: const CacheProvider( // ✅ important for caching support
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Auth Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LandingPage(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
      },
    );
  }
}
