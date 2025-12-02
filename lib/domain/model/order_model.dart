class Order {
  Order({
    this.id,
    this.uuid,
    this.oauthType,
    this.productId,
    this.appOrder,
    this.descp,
    this.orderType,
    this.amount,
    this.payAmount,
    this.payway,
    this.payUrl,
    this.status,
    this.msg,
    this.channel,
    this.updatedAt,
    this.createdAt,
    this.expiredAt,
    this.payType,
    this.descImg,
    this.giftDiamond,
    this.buildId,
    this.statusText,
  });

  final int? id;
  final String? uuid;
  final String? oauthType;
  final int? productId;
  final String? appOrder;
  final String? descp;
  final int? orderType;
  final String? amount;
  final String? payAmount;
  final String? payway;
  final String? payUrl;
  final int? status;
  final String? msg;
  final String? channel;
  final String? updatedAt;
  final String? createdAt;
  final int? expiredAt;
  final String? payType;
  final String? descImg;
  final int? giftDiamond;
  final String? buildId;
  final String? statusText;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json['id'],
        uuid: json['uuid'],
        oauthType: json['oauth_type'],
        productId: json['product_id'],
        appOrder: json['app_order'],
        descp: json['descp'],
        orderType: json['order_type'],
        amount: json['amount'],
        payAmount: json['pay_amount'],
        payway: json['payway'],
        payUrl: json['pay_url'],
        status: json['status'],
        msg: json['msg'],
        channel: json['channel'],
        updatedAt: json['updated_at'],
        createdAt: json['created_at'],
        expiredAt: json['expired_at'],
        payType: json['pay_type'],
        descImg: json['desc_img'],
        giftDiamond: json['gift_diamond'],
        buildId: json['build_id'],
        statusText: json['status_text'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'uuid': uuid,
        'oauth_type': oauthType,
        'product_id': productId,
        'app_order': appOrder,
        'descp': descp,
        'order_type': orderType,
        'amount': amount,
        'pay_amount': payAmount,
        'payway': payway,
        'pay_url': payUrl,
        'status': status,
        'msg': msg,
        'channel': channel,
        'updated_at': updatedAt,
        'created_at': createdAt,
        'expired_at': expiredAt,
        'pay_type': payType,
        'desc_img': descImg,
        'gift_diamond': giftDiamond,
        'build_id': buildId,
        'status_text': statusText,
      };
}
