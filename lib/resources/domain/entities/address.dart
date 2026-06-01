///
/// This file defines the Address entity, which represents a physical address with its components.
/// 
class Address {
  final String address;
  final String city;
  final String regionOrState;
  final String country;

  /// Constructor for the Address class, requiring all fields to be provided.
  Address({
    required this.address,
    required this.city,
    required this.regionOrState,
    required this.country,
  });

  /// A computed property that returns the full address as a single string.
  String get fullAddress {
    return '$address, $city, $regionOrState, $country';
  }
}
