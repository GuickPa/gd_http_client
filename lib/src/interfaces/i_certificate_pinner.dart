import 'dart:io';

abstract class ICertificatePinner {
  Map<String, List<String>> get allowedDomainShas;
  bool verify(X509Certificate cert, String host, int port);
}
