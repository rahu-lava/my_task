import 'package:graphql/client.dart';

GraphQLClient initializeGraphQLClient() {
  final HttpLink httpLink = HttpLink(
    'http://192.168.0.108:1337/graphql',
  );

  return GraphQLClient(
    cache: GraphQLCache(),
    link: httpLink,
  );
}
