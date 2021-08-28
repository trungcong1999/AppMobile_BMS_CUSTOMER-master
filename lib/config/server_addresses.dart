class ServerAddresses {
  //Server address of your project should go here
  static const serverAddress = 'api.phanmembanhang.com';// 'woocommerce.openflutterproject.com';
  static const serverAddressURL = 'http://api.phanmembanhang.com';
  //?consumer_key=ck_*****&consumer_secret=cs_**** goes here
  static const _woocommerceKeys = '';
  static const _categorySuffix = '/api/Category/ProductListLoyalty';// '/wp-json/wc/v3/products/categories/'; //id
  static const _productSuffix = '/api/Category/ProductListV2';// '/wp-json/wc/v3/products/categories/';
  static const _promoSuffix = ' /wp-json/wc/v3/reports/coupons/';
  static const signUp = ''; // TODO need an endpoint for this
  static const forgotPassword = '';// TODO need an endpoint for this
  static const changePassword = 'api/Customer/ChangePwd';
  static const getConfig = serverAddressURL + '/api/Common/GetConfig';
  /// For more information about wp-rest-api plugin
  /// https://wordpress.org/plugins/jwt-authentication-for-wp-rest-api/
  static const authToken = 'api/Customer/login';// 'wp-json/jwt-auth/v1/token';

  static const orderSuffix = '/api/Customer/AddNewPurchaseOrder';
  static const orderDetailSuffix = '/api/PurchaseOrder/GetPurchaseOrderDetail';
  static const myOrderSuffix = '/api/Customer/PurchaseOrderList';
  static const generateOrderIdSuffix = '/api/PurchaseOrder/GetNewCode';
  static const productSuffix = '/api/Category/GetProductInfo';

  //point
  static const getCurrentPoint = serverAddressURL+'/api/SelOrder/GetCurrentPoint';
  static const getPointHistory = serverAddressURL+'/api/SelOrder/GetPointHistory';

  //NEWS
  static const getHotNews = serverAddressURL+'/api/Crm/GetNewsListByCategory';
  static const getFeatureNews = serverAddressURL+'/api/Crm/GetFeatureNews';
  static const getNewsList = serverAddressURL+'/api/Crm/GetNewsList';
  static const getHomeNews = serverAddressURL+'/api/Crm/GetHomeNews';

  //order
  static const purchaseOrderList = serverAddressURL+'/api/Customer/PurchaseOrderList';

// group
  static const getCustomerInfo = serverAddressURL+'/api/Category/GetCustomerInfo';
  //CACHED API (for test purposes only)
  static const _productCategoriesCached = '/cachedapi/v3/products/categories.json';
  static const _productsCached = '/cachedapi/v3/products/products.json';
  static const _promosCached = '/cachedapi/v3/coupon.json';

  static bool useStatic = !_woocommerceKeys.isEmpty;

  static String get productCategories => serverAddressURL  +
    (useStatic ? _productCategoriesCached 
      : _categorySuffix + _woocommerceKeys);

  static String get products => serverAddressURL  +
    (useStatic ? _productsCached 
      : _productSuffix + _woocommerceKeys);

  static String get promos => serverAddress  +
    (useStatic ? _promosCached 
      : serverAddress  +_promoSuffix + _woocommerceKeys);

  static String get orderUrl => serverAddressURL + orderSuffix;
  static String get myOrderUrl => serverAddressURL + myOrderSuffix;
  static String get genOrderIdUrl => serverAddressURL + generateOrderIdSuffix;
  static String get productDetailUrl => serverAddressURL + productSuffix;
  static String get orderDetailUrl => serverAddressURL + orderDetailSuffix;
  static String get changePasswordUrl => serverAddressURL + changePassword;
}
