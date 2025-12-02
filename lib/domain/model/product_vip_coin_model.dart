class ProductOfVipOrCoin {
  final List<Product> products;
  final String vipText;
  final String coinText;

  ProductOfVipOrCoin({
    required this.products,
    required this.vipText,
    required this.coinText,
  });

  factory ProductOfVipOrCoin.fromJson(Map<String, dynamic> json) {
    return ProductOfVipOrCoin(
      products: List.from(
          json['product'].map((productJson) => Product.fromJson(productJson))),
      vipText: json['product_vip_text'] as String,
      coinText: json['product_coins_text'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'products': products.map((product) => product.toJson()).toList(),
      'vipText': vipText,
      'coinText': coinText,
    };
  }
}

class Product {
  final int id;
  final String pName;
  final String giveTip;
  final String promoPriceYuan;
  final String priceYuan;
  final List<Right> rights;
  final String bgImg;
  final List<Pay> pays;
  final String description;

  Product({
    required this.id,
    required this.bgImg,
    required this.pays,
    required this.pName,
    required this.giveTip,
    required this.promoPriceYuan,
    required this.priceYuan,
    required this.rights,
    required this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      bgImg: json['bg_img'],
      pays: List.from(json['pay'].map((payJson) => Pay.fromJson(payJson))),
      pName: json['pname'] as String,
      giveTip: json['give_tip'] ?? '未知',
      promoPriceYuan: json['promo_price_yuan'] ?? '',
      priceYuan: json['price_yuan'] ?? '',
      description: json['description'] ?? '',
      rights: List.from(
          json['right'].map((rightJson) => Right.fromJson(rightJson))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pName': pName,
      'giveTip': giveTip,
      'promoPriceYuan': promoPriceYuan,
      'bg_img': bgImg,
      'rights': rights.map((right) => right.toJson()).toList(),
      'pays': pays.map((pay) => pay.toJson()).toList(),
    };
  }
}

class Right {
  final int id;
  final String name;
  final String img;
  final String desc;

  Right({
    required this.id,
    required this.name,
    required this.img,
    required this.desc,
  });

  factory Right.fromJson(Map<String, dynamic> json) {
    return Right(
      id: json['id'] as int,
      name: json['name'] as String,
      img: json['img'] as String,
      desc: json['desc'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'img': img,
      'desc': desc,
    };
  }
}

class Pay {
  final int id;
  final String channel;
  final String name;

  Pay({
    required this.id,
    required this.channel,
    required this.name,
  });

  factory Pay.fromJson(Map<String, dynamic> json) {
    return Pay(
      id: json['id'] as int,
      channel: json['channel'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'channel': channel,
      'name': name,
    };
  }
}
