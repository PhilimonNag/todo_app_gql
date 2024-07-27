import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLConfig {
  static final HttpLink httpLink = HttpLink(
    'http://localhost:4000/',
  );
  static final GraphQLClient client =
      GraphQLClient(link: httpLink, cache: GraphQLCache()
          // GraphQLCache(store: InMemoryStore()),
          );
}
