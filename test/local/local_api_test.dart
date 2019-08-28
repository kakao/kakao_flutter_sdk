import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk/src/local/local_api.dart';
import 'package:kakao_flutter_sdk/src/local/model/coord.dart';
import 'package:kakao_flutter_sdk/src/local/model/place.dart';

import '../helper.dart';
import '../mock_adapter.dart';

void main() {
  MockAdapter _adapter;
  LocalApi _api;
  Dio _dio;

  setUp(() {
    _dio = Dio();
    _adapter = MockAdapter();
    _dio.httpClientAdapter = _adapter;
    _api = LocalApi(_dio);
  });

  group("all", () {
    test("address.json", () async {
      final body = await loadJson("local/address.json");
      final map = jsonDecode(body);
      _adapter.setResponseString(body, 200);
      final response = await _api.address("query");

      final meta = response.meta;
      final expectedMeta = map["meta"];
      final addresses = response.documents;
      final expected = map["documents"];

      expect(meta.totalCount, expectedMeta["total_count"]);
      expect(meta.pageableCount, expectedMeta["pageable_count"]);
      expect(meta.isEnd, expectedMeta["is_end"]);

      addresses.asMap().forEach((index, address) {
        final curr = expected[index];
        expect(address.addressName, curr["address_name"]);
        expect(address.x, double.tryParse(curr["x"]));
        expect(address.y, double.tryParse(curr["y"]));
        // expect(address.addressType, curr["address_type"]);

        final old = address.address;
        final expectedOld = curr["address"];

        expect(old.addressName, expectedOld["address_name"]);
        expect(old.region1depthName, expectedOld["region_1depth_name"]);
        expect(old.region2depthName, expectedOld["region_2depth_name"]);
        expect(old.region3depthName, expectedOld["region_3depth_name"]);
        expect(old.region3depthHName, expectedOld["region_3depth_h_name"]);
        expect(old.hCode, expectedOld["h_code"]);
        expect(old.bCode, expectedOld["b_code"]);
        expect(old.mountainYn, expectedOld["mountain_yn"]);
        expect(old.mainAddressNo, expectedOld["main_address_no"]);
        expect(old.subAddressNo, expectedOld["sub_address_no"]);
        expect(old.zipCode, expectedOld["zip_code"]);
        expect(old.x, double.tryParse(expectedOld["x"]));
        expect(old.y, double.tryParse(expectedOld["y"]));

        final road = address.roadAddress;
        final expectedRoad = curr["road_address"];
        expect(road.addressName, expectedRoad["address_name"]);
        expect(road.region1depthName, expectedRoad["region_1depth_name"]);
        expect(road.region2depthName, expectedRoad["region_2depth_name"]);
        expect(road.region3depthName, expectedRoad["region_3depth_name"]);
        expect(road.roadName, expectedRoad["road_name"]);
        expect(road.undergroundYn, expectedRoad["underground_yn"]);
        expect(road.mainBuildingNo, expectedRoad["main_building_no"]);
        expect(road.subBuildingNo, expectedRoad["sub_building_no"]);
        expect(road.buildingName, expectedRoad["building_name"]);
        expect(road.zoneNo, expectedRoad["zone_no"]);
        expect(road.x, double.tryParse(expectedRoad["x"]));
        expect(road.y, double.tryParse(expectedRoad["y"]));
      });
      response.toString();
    });

    test("coord2region", () async {
      final body = await loadJson("local/region.json");
      final map = jsonDecode(body);
      _adapter.setResponseString(body, 200);
      final response = await _api.coord2Region(1.2, 3.4);
      final meta = response.meta;
      final expectedMeta = map["meta"];
      expect(meta.totalCount, expectedMeta["total_count"]);

      final documents = response.documents;
      final expectedDocuments = map["documents"];
      documents.asMap().forEach((index, region) {
        final expected = expectedDocuments[index];
        expect(region.regionType, expected["region_type"]);
        expect(region.addressName, expected["address_name"]);
        expect(region.region1depthName, expected["region_1depth_name"]);
        expect(region.region2depthName, expected["region_2depth_name"]);
        expect(region.region3depthName, expected["region_3depth_name"]);
        expect(region.region4depthName, expected["region_4depth_name"]);
        expect(region.code, expected["code"]);
        expect(region.x, expected["x"]);
        expect(region.y, expected["y"]);
      });
      response.toString();
    });
    test("coord2address", () async {
      final body = await loadJson("local/coord2address.json");
      final map = jsonDecode(body);
      _adapter.setResponseString(body, 200);

      final response = await _api.coord2Address(1.2, 3.4);
      response.documents.asMap().forEach((index, address) {
        final expected = map["documents"][index];
        expect(address.addressName, expected["address_name"]);
        expect(address.addressType, expected["address_type"]);

        final old = address.address;
        final expectedOld = expected["address"];

        expect(old.addressName, expectedOld["address_name"]);
        expect(old.region1depthName, expectedOld["region_1depth_name"]);
        expect(old.region2depthName, expectedOld["region_2depth_name"]);
        expect(old.region3depthName, expectedOld["region_3depth_name"]);
        expect(old.region3depthHName, expectedOld["region_3depth_h_name"]);
        expect(old.hCode, expectedOld["h_code"]);
        expect(old.bCode, expectedOld["b_code"]);
        expect(old.mountainYn, expectedOld["mountain_yn"]);
        expect(old.mainAddressNo, expectedOld["main_address_no"]);
        expect(old.subAddressNo, expectedOld["sub_address_no"]);
        expect(old.zipCode, expectedOld["zip_code"]);
        expect(old.x, expectedOld["x"]);
        expect(old.y, expectedOld["y"]);

        final road = address.roadAddress;
        final expectedRoad = expected["road_address"];

        expect(road.addressName, expectedRoad["address_name"]);
        expect(road.region1depthName, expectedRoad["region_1depth_name"]);
        expect(road.region2depthName, expectedRoad["region_2depth_name"]);
        expect(road.region3depthName, expectedRoad["region_3depth_name"]);
        expect(road.roadName, expectedRoad["road_name"]);
        expect(road.undergroundYn, expectedRoad["underground_yn"]);
        expect(road.mainBuildingNo, expectedRoad["main_building_no"]);
        expect(road.subBuildingNo, expectedRoad["sub_building_no"]);
        expect(road.buildingName, expectedRoad["building_name"]);
        expect(road.zoneNo, expectedRoad["zone_no"]);
        expect(road.x, expectedRoad["x"]);
        expect(road.y, expectedRoad["y"]);
      });
      response.toString();
    });

    test("transcord.json", () async {
      final body = await loadJson("local/transcord.json");
      final map = jsonDecode(body);
      _adapter.setResponseString(body, 200);
      final response = await _api.transformCoord(1.2, 3.4, CoordType.WGS84);

      response.documents.asMap().forEach((index, coord) {
        final expected = map["documents"][index];
        expect(coord.x, expected["x"]);
        expect(coord.y, expected["y"]);
      });
      response.toString();
    });

    test("keyword.json", () async {
      final body = await loadJson("local/keyword.json");
      final map = jsonDecode(body);
      _adapter.setResponseString(body, 200);
      final response = await _api.placesWithKeyword("query");

      final meta = response.meta;
      final expectedMeta = map["meta"];
      expect(meta.totalCount, expectedMeta["total_count"]);
      expect(meta.pageableCount, expectedMeta["pageable_count"]);
      expect(meta.isEnd, expectedMeta["is_end"]);

      final regionInfo = meta.regionInfo;
      final expectedRegionInfo = expectedMeta["same_name"];

      expect(regionInfo.keyword, expectedRegionInfo["keyword"]);
      expect(regionInfo.selectedRegion, expectedRegionInfo["selected_region"]);

      response.documents.asMap().forEach((index, place) {
        final expected = map["documents"][index];
        expect(place.id, expected["id"]);
        expect(place.placeName, expected["place_name"]);
        expect(place.categoryName, expected["category_name"]);
        if (place.categoryGroupCode != CategoryGroup.UNKNOWN) {
          expect(describeEnum(place.categoryGroupCode),
              expected["category_group_code"]);
        }
        expect(place.categoryGroupName, expected["category_group_name"]);
        expect(place.phone, expected["phone"]);
        expect(place.addressName, expected["address_name"]);
        expect(place.roadAddressName, expected["road_address_name"]);
        expect(place.placeUrl.toString(), expected["place_url"]);
        expect(place.distance, int.tryParse(expected["distance"]));
      });
      response.toString();
    });
    test("category.json", () async {
      // print(TestEnum.ENUM2.index);
      final body = await loadJson("local/category.json");
      final map = jsonDecode(body);
      _adapter.requestAssertions = (RequestOptions options) {
        final params = options.queryParameters;
        expect(params["category_group_code"], "AC5");
      };
      _adapter.setResponseString(body, 200);
      final response = await _api.placesWithCategory(CategoryGroup.AC5);

      final meta = response.meta;
      expect(meta.regionInfo, map["meta"]["same_name"]);
    });
  });
}
