import 'dart:math';

import '../../../core/network/NetworkManager.dart';
import '../../../product/base_model/book_response_mode.dart';
import '../model/searched_book_model.dart';
import 'package:english_words/english_words.dart';

abstract class ISearchBookService {
  NetworkManager manager;

  ISearchBookService(this.manager);

  Future<SearchBookModel?> searchByName(String nameofBook);
  Future<SearchBookModel?> searchRandom();
  Future<BookResponseModel?> searchByCategories(String bookName, String categorieName);
  Future<BookResponseModel?> randomSearchWithCategories(String categorie);
}

class SearchBookService extends ISearchBookService {
  SearchBookService(NetworkManager manager) : super(manager);
  Random _random = Random();

  @override
  Future<SearchBookModel?> searchByName(String nameofBook) async {
    final response = await manager.dio.get("volumes?q=intitle:$nameofBook}");

    if (response.statusCode == 200) {
      return SearchBookModel.fromJson(response.data);
    }
    return null;
  }

  @override
  Future<SearchBookModel?> searchRandom() async {
    final Iterable<String> word = nouns.take(200);
    final response = await manager.dio.get("volumes?q=${word.elementAt(_random.nextInt(199))}");

    if (response.statusCode == 200) {
      return SearchBookModel.fromJson(response.data);
    }
    return null;
  }

  Future<BookResponseModel?> searchByCategories(String bookName, String categorieName) async {
    final _response = await manager.dio.get("volumes?q=$bookName:subject:$categorieName");
    if (_response.statusCode == 200) {
      return BookResponseModel.fromJson(_response.data);
    }
  }

  @override
  Future<BookResponseModel?> randomSearchWithCategories(String categorie) async {
    final Iterable<String> word = nouns.take(200);
    final _response =
        await manager.dio.get("volumes?q=${word.elementAt(_random.nextInt(199))}:subject:$categorie");
    if (_response.statusCode == 200) {
      return BookResponseModel.fromJson(_response.data);
    }
  }
}
