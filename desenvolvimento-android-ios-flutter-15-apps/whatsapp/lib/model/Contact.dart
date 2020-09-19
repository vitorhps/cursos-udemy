class Contact {

  String _name;
  String _imageUrl;

  Contact(this._name, this._imageUrl);

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get imageUrl => _imageUrl;

  set imageUrl(String value) {
    _imageUrl = value;
  }

}