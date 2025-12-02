class OfficialGroupModel {
  final OfficeContactList? officeContact;
  final List<DownloadLink>? downloadLink;

  OfficialGroupModel({
    this.officeContact,
    this.downloadLink,
  });

  OfficialGroupModel.fromJson(Map<String, dynamic> json)
      : officeContact = json['office_contact'] != null
            ? OfficeContactList.fromJson(json['office_contact'])
            : null,
        downloadLink = json['download_link'] != null
            ? List.from(
                json['download_link'].map((e) => DownloadLink.fromJson(e)))
            : null;

  Map<String, dynamic> toJson() => {
        'office_contact': officeContact?.toJson(),
        'download_link': downloadLink?.map((e) => e.toJson()).toList()
      };
}

class OfficeContactList {
  final List<OfficeContact>? data;

  OfficeContactList({
    this.data,
  });

  OfficeContactList.fromJson(Map<String, dynamic> json)
      : data = json['data'] != null
            ? List.from(json['data'].map((e) => OfficeContact.fromJson(e)))
            : null;

  Map<String, dynamic> toJson() =>
      {'data': data?.map((e) => e.toJson()).toList()};
}

class OfficeContact {
  final String? name;
  final String? decs;
  final List<Contact>? list;

  OfficeContact({
    this.name,
    this.decs,
    this.list,
  });

  OfficeContact.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String?,
        decs = json['decs'] as String?,
        list = json['list'] != null
            ? List.from(json['list'].map((e) => Contact.fromJson(e)))
            : null;

  Map<String, dynamic> toJson() => {
        'name': name,
        'decs': decs,
        'list': list?.map((e) => e.toJson()).toList()
      };
}

class Contact {
  final String? name;
  final String? decs;
  final String? type;
  final String? url;

  Contact({
    this.name,
    this.decs,
    this.type,
    this.url,
  });

  Contact.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String?,
        decs = json['decs'] as String?,
        type = json['type'] as String?,
        url = json['url'] as String?;

  Map<String, dynamic> toJson() =>
      {'name': name, 'decs': decs, 'type': type, 'url': url};
}

class DownloadLink {
  final String? name;
  final String? value;

  DownloadLink({
    this.name,
    this.value,
  });

  DownloadLink.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String?,
        value = json['value'] as String?;

  Map<String, dynamic> toJson() => {'name': name, 'value': value};
}
