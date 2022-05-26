List findVariantWithKey(String value, String key, List json) {
  List index = [];
  for (var i = 0; i < json.length; i++) {
    if (json[i][key].toString().toLowerCase() ==
        value.toString().toLowerCase()) index.add(i);
  }
  return index;

  print(value);
}

List fetchValuesFromVariant(String key, List indices, List json) {
  List value = [];
  indices.forEach((i) {
    value.add(json[i][key]);
  });
  return value;
}
