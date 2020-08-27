const int PER_PAGE_COUNT = 25;
const String APP_NAME = 'Shamwaa';
const String API_ENDPONT = 'api.shamwaa.com';
// const String API_ENDPONT = 'dev.onlinechina.co:3000';
// const String API_ENDPONT = '127.0.0.1:3000';

//use this language, if translation not available
const String FALLBACK_LANG = 'en';

const String PLACEHOLDER_IMAGE = 'assets/images/logo.png';

//zero based index of cart tab
const int CART_INDEX = 2;
const int ORDERS_INDEX = 3;

//product types
const String PRODUCT_TYPE_SIMPLE = 'simple';
const String PRODUCT_TYPE_VARIABLE = 'variable';

enum ProductAction { None, AddToItems, BuyNow, Update }

const String ORDER_STATUSCODE_CANCELLED = 'cancelled';
