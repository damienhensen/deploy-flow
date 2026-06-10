import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mobile/data_layer/repositories/auth_repository.dart';

class DeployFlowGraphQLClient {
  static GraphQLClient create(AuthRepository authRepository) {
    final authLink = AuthLink(
      getToken: () async {
        final token = await authRepository.getAccessToken();

        if (token == null) {
          return null;
        }

        return 'Bearer $token';
      },
    );

    final httpLink = HttpLink('http://192.168.178.126/graphql');
    final link = authLink.concat(httpLink);

    return GraphQLClient(
      link: link,
      cache: GraphQLCache(store: InMemoryStore()),
    );
  }
}
