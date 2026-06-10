import 'package:graphql_flutter/graphql_flutter.dart';

class DeployFlowGraphQLClient {
  static GraphQLClient create() {
    final httpLink = HttpLink('http://192.168.178.94/graphql');

    return GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(store: InMemoryStore()),
    );
  }
}
