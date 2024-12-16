import 'dart:convert';

import 'package:test/test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

import 'package:fightme_webapp/Models/httpservice.dart';

class MockHttpClient extends Mock implements Client {}

class MockResponse extends Mock implements Response {}

class FakeUri extends Fake implements Uri {}

void main() {
  final Client httpClient = MockHttpClient();
  final Response response = MockResponse();
  final Response response2 = MockResponse();
  final HttpService httpService = HttpService(httpClient: httpClient);

  setUpAll(() => registerFallbackValue(FakeUri()));

  test('Get all users', () async {
    when(() => httpClient.get(any())).thenAnswer((_) async => response);
    when(() => response.statusCode).thenReturn(200);
    when(() => response.body).thenReturn(
      jsonEncode([
        {
          "id": 1,
          "name": "Josh",
          "email": "Josh@mail.com",
          "password": "testpass123",
          "dateCreated": 0,
          "gamerScore": 0,
          "attackScore": 0,
          "defenseScore": 0,
          "magicScore": 0
        },
        {
          "id": 2,
          "name": "Sara",
          "email": "Sara@mail.com",
          "password": "testpass123",
          "dateCreated": 0,
          "gamerScore": 0,
          "attackScore": 0,
          "defenseScore": 0,
          "magicScore": 0
        },
      ]),
    );
    final users = await httpService.getUsers();
    expect(users.length, 2);
  });

  test('Get one user by id', () async {
    when(() => httpClient.get(any())).thenAnswer((_) async => response);
    when(() => response.statusCode).thenReturn(200);
    when(() => response.body).thenReturn(
      jsonEncode(
        {
          "id": 1,
          "name": "Josh",
          "email": "Josh@mail.com",
          "password": "testpass123",
          "dateCreated": 3,
          "gamerScore": 0,
          "attackScore": 0,
          "defenseScore": 0,
          "magicScore": 0
        },
      ),
    );
    final user = await httpService.getUserByID(1);
    expect(user.name, "Josh");
    expect(user.dateCreated, 3);
  });

  test('Get friends', () async {
    when(() => httpClient
            .get(Uri.parse("http://localhost:8080/api/users/3/friends")))
        .thenAnswer((_) async => response);
    when(() => httpClient.get(Uri.parse("http://localhost:8080/api/users/1")))
        .thenAnswer((_) async => response2);
    when(() => response.statusCode).thenReturn(200);
    when(() => response2.statusCode).thenReturn(200);
    when(() => response.body).thenReturn(
      jsonEncode([1]),
    );
    when(() => response2.body).thenReturn(
      jsonEncode(
        {
          "id": 1,
          "name": "Josh",
          "email": "Josh@mail.com",
          "password": "testpass123",
          "dateCreated": 3,
          "gamerScore": 0,
          "attackScore": 0,
          "defenseScore": 0,
          "magicScore": 0
        },
      ),
    );
    final users = await httpService.getFriends(3);
    expect(users.length, 1);
  });

  test("Signup User", () async {
    when(() => response.statusCode).thenReturn(200);
    when(() => response.body).thenReturn(jsonEncode(7));
    when(() => response.headers)
        .thenReturn({"Content-Type": "application/json"});
    //print(jsonEncode(7));
    when(() => httpClient.post(any(),
        body: any(named: 'body'),
        headers: any(named: 'headers'))).thenAnswer((_) async => response);

    final id =
        await httpService.signupUser("John", "john@mail.com", "testpass123");
    expect(id, 7);
  });

  test("Login User", () async {
    
  })
}
