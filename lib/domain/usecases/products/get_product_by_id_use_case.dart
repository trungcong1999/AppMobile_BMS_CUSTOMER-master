import 'package:hosco/data/model/product.dart';
import 'package:hosco/data/repositories/abstract/product_repository.dart';
import 'package:hosco/domain/usecases/base_use_case.dart';
import 'package:hosco/locator.dart';

abstract class GetProductByIdUseCase
    implements BaseUseCase<ProductDetailsResults, ProductDetailsParams> {}

    
class GetProductByIdUseCaseImpl implements GetProductByIdUseCase {

  @override
  Future<ProductDetailsResults> execute(ProductDetailsParams params) async {
    //TODO: replace fetch from API
    //TEMP solution
    ProductRepository productRepository = sl();
    //TODO:
    Product product = await productRepository.getProduct(params.productId);

    List<Product> products =
        await productRepository.getProducts(categoryId: params.categoryId);
    /*
    Product product;
    products.forEach((Product f) => {
        if ( f.id == params.productId) product = f
      }
    );*/
    return ProductDetailsResults(
      productDetails: product,
      similarProducts: products);
  }
}

class ProductDetailsResults{
  final Product productDetails;
  final List<Product> similarProducts;

  ProductDetailsResults({this.productDetails, this.similarProducts});
}
class ProductDetailsParams{
  final String productId;
  final String categoryId;

  ProductDetailsParams({this.productId, this.categoryId});
}