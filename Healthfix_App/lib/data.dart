import 'package:healthfix/models/Product.dart';

String ICON_KEY = "icon";
String IMAGE_LOCATION_KEY = "image_location";
String TITLE_KEY = "title";
String PRODUCT_TYPE_KEY = "product_type";

final pdctCategories = <Map>[
  <String, dynamic>{
    ICON_KEY: "assets/icons/app/icons-dumbell.svg",
    IMAGE_LOCATION_KEY: "assets/icons/app/icons-dumbell.svg",
    TITLE_KEY: "All Products",
    PRODUCT_TYPE_KEY: ProductType.All,
  },
  <String, dynamic>{
    ICON_KEY: "assets/icons/app/icons-dumbell.svg",
    IMAGE_LOCATION_KEY: "assets/images/menu/Nutritions.png",
    TITLE_KEY: "Sports Nutrition",
    PRODUCT_TYPE_KEY: ProductType.Nutrition,
  },
  <String, dynamic>{
    ICON_KEY: "assets/icons/app/icons-suppliment.svg",
    IMAGE_LOCATION_KEY: "assets/images/menu/Supplements.png",
    TITLE_KEY: "Vitamin/Supplement",
    PRODUCT_TYPE_KEY: ProductType.Supplements,
  },
  <String, dynamic>{
    ICON_KEY: "assets/icons/app/icons-veg.svg",
    IMAGE_LOCATION_KEY: "assets/images/menu/Drinks.png",
    TITLE_KEY: "Health Food & Drink",
    PRODUCT_TYPE_KEY: ProductType.Food,
  },
  <String, dynamic>{
    ICON_KEY: "assets/icons/app/icons-shop.svg",
    IMAGE_LOCATION_KEY: "assets/images/menu/Clothing.png",
    TITLE_KEY: "Clothing Apparel",
    PRODUCT_TYPE_KEY: ProductType.Clothing,
  },
  <String, dynamic>{
    ICON_KEY: "assets/icons/app/icons-explore.svg",
    IMAGE_LOCATION_KEY: "assets/images/menu/Explore.png",
    TITLE_KEY: "Explore Fitness",
    PRODUCT_TYPE_KEY: ProductType.Explore,
  },
];

final PdctSubCategories = {
  "All Products": [
    "Sports Nutrition",
    "Vitamin/Supplement",
    "Health Food & Drink",
    "Clothing Apparel",
    "Explore Fitness",
  ],
  "Sports Nutrition": [
    // "All Sports Nutrition",
    "Proteins",
    "Gainers",
    "Protein Foods",
    "Pre/Post Workout",
  ],
  "Vitamin/Supplement": [
    // "All Vitamin/Supplement",
    "Omega Fatty Acids ",
    "Multi-Vitamins",
    "Minerals",
    "Vitamins",
    "All Vitamins",
  ],
  "Health Food & Drink": [
    // "All Health Food & Drink",
    "Weight Loss Foods",
    "Vinegar & Health Juices",
    "Protein Foods & Bars",
    "Family Nutrition",
    "Healthy Beverages",
  ],
  "Clothing Apparel": [
    // "All Clothing Apparel",
    "Men Clothing",
    "Women Clothing",
    "Fitness Clothing",
    "Sports Apparel",
  ],
  "Explore Fitness": [
    // "All Explore Fitness",
    "Gym Equipment",
    "Gym Accessories",
    "Gym Supports",
    "Gym Essentials",
    "Fitness Clothings",
  ],
};

List<Map> payMethods = [
  {
    "id": "cash",
    "heading": "Cash Payment",
    "sub": "Cash on Delivery",
    "url": "https://cdn.iconscout.com/icon/free/png-256/cash-2065963-1746112.png",
  },
  {
    "id": "esewa",
    "heading": "Esewa",
    "sub": "Pay with Esewa",
    "url": "https://www.nepalitimes.com/wp-content/uploads/2021/07/Esewa-Remittance-Payment.png",
  },
  {
    "id": "bank",
    "heading": "Fone Pay",
    "sub": "Transfer directly to Bank",
    "url": "https://login.fonepay.com/assets/img/fonepay_payments_fatafat.png"
  },
];

Map status = {
  "done": ["Delivered", "Your Package has been Delivered."],
  "delivering": ["Out for Delivery", "You Package is currently out for delivery by Spaceko Logistics."],
  "preparing": ["Package being Prepared", "Your Package is being prepared by the Seller."],
  "placed": ["Order Received", "Your Order has been placed."],
};

Map<String, List<String>> nepalZonesAndDistricts = {
  "Bagmati": ["Bhaktapur", "Dhading", "Kathmandu", "Kavrepalanchok", "Lalitpur", "Nuwakot", "Rasuwa", "Sindhupalchok"],
  "Bheri": ["Banke", "Bardiya", "Dailekh", "Jajarkot", "Surkhet"],
  "Dhawalagiri": ["Baglung", "Mustang", "Myagdi", "Parbat"],
  "Gandaki": ["Gorkha", "Kaski", "Lamjung", "Manang", "Syangja", "Tanahu"],
  "Janakpur": ["Dhanusa", "Dholkha", "Mahottari", "Ramechhap", "Sarlahi", "Sindhuli"],
  "Karnali": ["Dolpa", "Humla", "Jumla", "Kalikot", "Mugu"],
  "Koshi": ["Bhojpur", "Dhankuta", "Morang", "Sankhuwasabha", "Sunsari", "Terhathum"],
  "Lumbini": ["Arghakhanchi", "Gulmi", "Kapilvastu", "Nawalparasi", "Palpa", "Rupandehi"],
  "Mahakali": ["Baitadi", "Dadeldhura", "Darchula", "Kanchanpur"],
  "Mechi": ["Ilam", "Jhapa", "Panchthar", "Taplejung"],
  "Narayani": ["Bara", "Chitwan", "Makwanpur", "Parsa", "Rautahat"],
  "Rapti": ["Dang Deukhuri", "Pyuthan", "Rolpa", "Rukum", "Salyan"],
  "Sagarmatha": ["Khotang", "Okhaldhunga", "Saptari", "Siraha", "Solukhumbu", "Udayapur"],
  "Seti": ["Achham", "Bajhang", "Bajura", "Doti", "Kailali"],
};
