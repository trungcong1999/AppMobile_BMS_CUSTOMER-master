import 'package:hosco/data/local/data_source.dart';
import 'package:hosco/domain/entities/hashtag/product_hashtag_entity.dart';

class ProductHashTagDataSource extends DataSource {
  @override
  Future<List<ProductHashTagEntity>> all() async {
    checkDatabaseConnection();

    final List<Map<String, dynamic>> maps = await db.query(tableName);

    return List.generate(maps.length, (i) {
      return ProductHashTagEntity(
        id: maps[i]['id'],
        hashTagId: maps[i]['hashTagId'],
        productId: maps[i]['productId'],
      );
    });
  }

  @override
  Future<ProductHashTagEntity> get(String id) async {
    checkDatabaseConnection();

    final List<Map<String, dynamic>> maps =
        await db.query(tableName, where: '$primaryKey = ?', whereArgs: [id]);

    return ProductHashTagEntity(
      id: maps[0]['id'],
      hashTagId: maps[0]['hashTagId'],
      productId: maps[0]['productId'],
    );
  }

  @override
  String get tableName => 'ProductHashTag';

  @override
  String get primaryKey => 'id';
}
