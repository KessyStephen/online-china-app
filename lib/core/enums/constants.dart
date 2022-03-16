const int PER_PAGE_COUNT = 25;
const String TERMS_URL = 'https://www.shamwaa.shop/terms.html';
const String APP_NAME = 'Shamwaa';
const String API_ENDPONT = 'api.shamwaa.shop';
// const String API_ENDPONT = 'dev.onlinechina.co:3000';
// const String API_ENDPONT = '127.0.0.1:3000';

//use this language, if translation not available
const String FALLBACK_LANG = 'en';

//use this currency if not selected
const String DEFAULT_CURRENCY = 'TZS';
const String SELECTED_CURRENCY_KEY =
    'prefferedCurrency'; //key for local storage

const String PLACEHOLDER_IMAGE = 'assets/images/logo.png';

//zero based index of cart tab
const int CART_INDEX = 2;
const int ORDERS_INDEX = 3;

//product types
const String PRODUCT_TYPE_SIMPLE = 'simple';
const String PRODUCT_TYPE_VARIABLE = 'variable';

enum ProductAction { None, AddToItems, BuyNow, Update }

const String ORDER_STATUSCODE_CANCELLED = 'cancelled';

//Discount types
const String DISCOUNT_AMOUNT = 'discountAmount';
const String DISCOUNT_PERCENT = 'discountPercent';
const String DISCOUNT_FIXED_PRICE = 'fixedPrice';

// Rule Types
const String PRICING_RULE_TYPE_BULK = 'bulk';

// Shipping Methods
const String SHIPPING_METHOD_AIR_KEY = 'AirCargo';
const String SHIPPING_METHOD_AIR_VALUE = 'Air Cargo';
const String SHIPPING_METHOD_SEA_KEY = 'SeaFreight';
const String SHIPPING_METHOD_SEA_VALUE = 'Sea Freight';

// Shipping Price Modes
const String SHIPPING_PRICE_MODE_PER_KG = 'perKg';
const String SHIPPING_PRICE_MODE_PER_CBM = 'perCBM';
const String SHIPPING_PRICE_MODE_FLAT = 'flat';
