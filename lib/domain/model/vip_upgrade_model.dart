import './product_vip_coin_model.dart';

class VipUpgradeModel {
  final int? id;
  final int? type;
  final String? pName;
  final String? img;
  final String? secondImg;
  final int? price;
  final int? promoPrice;
  final int? discount;
  final int? validDate;
  final int? coins;
  final int? freeCoins;
  final int? sortOrder;
  final String? description;
  final int? vipLevel;
  final int? showMore;
  final int? visibleType;
  final String? giveTip;
  final int? ticketNum;
  final int? beUpgraded;
  final int? upgradeable;
  final int? payCoins;
  final String? priceYuan;
  final String? promoPriceYuan;
  final List<Right> right;

  VipUpgradeModel(
      {this.id,
      this.type,
      this.pName,
      this.img,
      this.secondImg,
      this.price,
      this.promoPrice,
      this.discount,
      this.validDate,
      this.coins,
      this.freeCoins,
      this.sortOrder,
      this.description,
      this.vipLevel,
      this.showMore,
      this.visibleType,
      this.giveTip,
      this.ticketNum,
      this.beUpgraded,
      this.upgradeable,
      this.payCoins,
      this.priceYuan,
      this.promoPriceYuan,
      required this.right});

  factory VipUpgradeModel.fromJson(Map<String, dynamic> json) {
    return VipUpgradeModel(
      id: json['id'],
      type: json['type'],
      pName: json['pname'],
      img: json['img'],
      secondImg: json['second_img'],
      price: json['price'],
      promoPrice: json['promo_price'],
      discount: json['discount'],
      validDate: json['valid_date'],
      coins: json['coins'],
      freeCoins: json['free_coins'],
      sortOrder: json['sort_order'],
      description: json['description'],
      vipLevel: json['vip_level'],
      showMore: json['show_more'],
      visibleType: json['visible_type'],
      giveTip: json['give_tip'],
      ticketNum: json['ticket_num'],
      beUpgraded: json['be_upgraded'],
      upgradeable: json['upgradeable'],
      payCoins: json['pay_coins'],
      priceYuan: json['price_yuan'],
      promoPriceYuan: json['promo_price_yuan'],
      right: List.from(
          json['right'].map((rightJson) => Right.fromJson(rightJson))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'pname': pName,
      'img': img,
      'second_img': secondImg,
      'price': price,
      'promo_price': promoPrice,
      'discount': discount,
      'valid_date': validDate,
      'coins': coins,
      'free_coins': freeCoins,
      'sort_order': sortOrder,
      'description': description,
      'vip_level': vipLevel,
      'show_more': showMore,
      'visible_type': visibleType,
      'give_tip': giveTip,
      'ticket_num': ticketNum,
      'be_upgraded': beUpgraded,
      'upgradeable': upgradeable,
      'pay_coins': payCoins,
      'price_yuan': priceYuan,
      'promo_price_yuan': promoPriceYuan,
      'right': right.map((right) => right.toJson()).toList(),
    };
  }
}

class VipPayedModel {
  final int? id;
  final int? type;
  final String? pname;
  final String? img;
  final String? secondImg;
  final int? price;
  final int? promoPrice;
  final int? discount;
  final int? validDate;
  final int? coins;
  final int? freeCoins;
  final int? sortOrder;
  final String? description;
  final int? vipLevel;
  final int? showMore;
  final int? visibleType;
  final String? giveTip;
  final int? ticketNum;
  final int? beUpgraded;
  final int? upgradeable;
  final String? priceYuan;
  final String? promoPriceYuan;

  VipPayedModel(
      {this.id,
      this.type,
      this.pname,
      this.img,
      this.secondImg,
      this.price,
      this.promoPrice,
      this.discount,
      this.validDate,
      this.coins,
      this.freeCoins,
      this.sortOrder,
      this.description,
      this.vipLevel,
      this.showMore,
      this.visibleType,
      this.giveTip,
      this.ticketNum,
      this.beUpgraded,
      this.upgradeable,
      this.priceYuan,
      this.promoPriceYuan});

  factory VipPayedModel.fromJson(Map<String, dynamic> json) {
    return VipPayedModel(
      id: json['id'],
      type: json['type'],
      pname: json['pname'],
      img: json['img'],
      secondImg: json['second_img'],
      price: json['price'],
      promoPrice: json['promo_price'],
      discount: json['discount'],
      validDate: json['valid_date'],
      coins: json['coins'],
      freeCoins: json['free_coins'],
      sortOrder: json['sort_order'],
      description: json['description'],
      vipLevel: json['vip_level'],
      showMore: json['show_more'],
      visibleType: json['visible_type'],
      giveTip: json['give_tip'],
      ticketNum: json['ticket_num'],
      beUpgraded: json['be_upgraded'],
      upgradeable: json['upgradeable'],
      priceYuan: json['price_yuan'],
      promoPriceYuan: json['promo_price_yuan'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'pname': pname,
      'img': img,
      'second_img': secondImg,
      'price': price,
      'promo_price': promoPrice,
      'discount': discount,
      'valid_date': validDate,
      'coins': coins,
      'free_coins': freeCoins,
      'sort_order': sortOrder,
      'description': description,
      'vip_level': vipLevel,
      'show_more': showMore,
      'visible_type': visibleType,
      'give_tip': giveTip,
      'ticket_num': ticketNum,
      'be_upgraded': beUpgraded,
      'upgradeable': upgradeable,
      'price_yuan': priceYuan,
      'promo_price_yuan': promoPriceYuan,
    };
  }
}
