class Account {
  final String login;
  final bool activated;
  final List<dynamic> authorities;
  final String firstName;
  final String lastName;

  const Account(
      {required this.login,
      required this.activated,
      required this.authorities,
      required this.firstName,
      required this.lastName});

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
        login: json['login'],
        activated: json['activated'],
        authorities: json['authorities'],
        firstName: json['firstName'],
        lastName: json['lastName']);
  }
}
