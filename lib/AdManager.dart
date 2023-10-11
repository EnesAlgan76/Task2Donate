import 'dart:math';

import 'package:applovin_max/applovin_max.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'PageB.dart';
import 'controllers/ValuesController.dart';
import 'main.dart';

class AdManager {
  final String _interstitial_ad_unit_id = "9d0304ae12c62410";
  late int _interstitialRetryAttempt;
  final String _rewarded_ad_unit_id = "2c384806262b4557";
  late int _rewardedRetryAttempt;

  final valuesController = Get.put(ValuesController());
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  AdManager()
      : _interstitialRetryAttempt = 0,
        _rewardedRetryAttempt = 0;



  Future<void> initApplovin() async {
    await AppLovinMAX.initialize(
      "LLyxefiqREW2U3KT_76iReQ0M9OGMUBq7gUVC3THt7fFyDQxF8NhzTvIvAu0cbV3lmLJf3CkbnvEdRgwzT4906",
    );

    List<String> testDeviceIds = ["53d7cc40-aac2-4971-9768-18bb1e53acbb","2b3b8ada-170d-44d0-94c7-2d8b5a0daba7"];
    AppLovinMAX.setTestDeviceAdvertisingIds(testDeviceIds);
  }



  void initializeInterstitialAds() {
    AppLovinMAX.setInterstitialListener(InterstitialListener(
      onAdLoadedCallback: (ad) {
        printWarning('Interstitial ad loaded from ' + ad.networkName);
        if(valuesController.reklamBekleniyorMu.value){
          showInterstitialAd();
        }
        _interstitialRetryAttempt = 0;
      },
      onAdLoadFailedCallback: (adUnitId, error) {
        addError(error.toString());
        _interstitialRetryAttempt = _interstitialRetryAttempt + 1;
        int retryDelay = pow(2, min(6, _interstitialRetryAttempt)).toInt();

        printWarning('Interstitial ad failed to load with code ' + error.code.toString() + ' - retrying in ' + retryDelay.toString() + 's');

        Future.delayed(Duration(milliseconds: retryDelay * 1000), () {
          AppLovinMAX.loadInterstitial(_interstitial_ad_unit_id);
        });
      },
      onAdDisplayedCallback: (ad) {
       updateWatchedAds();
      },
      onAdDisplayFailedCallback: (ad, error) {},
      onAdClickedCallback: (ad) {},
      onAdHiddenCallback: (ad) {},
    ));

    AppLovinMAX.loadInterstitial(_interstitial_ad_unit_id);
  }



  Future<void> showInterstitialAd() async {
    bool isReady = (await AppLovinMAX.isInterstitialReady(_interstitial_ad_unit_id))!;
    if (isReady) {
      printWarning("*********** HAZIR *********");
      AppLovinMAX.showInterstitial(_interstitial_ad_unit_id);
      valuesController.reklamBekleniyorMu.value = false;
    } else {
      printWarning("Interstitial ad hazır değil. Yenisi yükleniyor...");
      AppLovinMAX.loadInterstitial(_interstitial_ad_unit_id);
    }
  }

  /// REWARDED AD ///

  void initializeRewardedAds() {
    AppLovinMAX.setRewardedAdListener(RewardedAdListener(
        onAdLoadedCallback: (ad) {
          printWarning('Rewarded ad loaded from ${ad.networkName}');
          if(valuesController.reklamBekleniyorMu.value){
            showRewardedAd();
          }
          _rewardedRetryAttempt = 0;

      }, onAdLoadFailedCallback: (adUnitId, error) {
          addError(error.toString());
          _rewardedRetryAttempt = _rewardedRetryAttempt + 1;
          int retryDelay = pow(2, min(6, _rewardedRetryAttempt)).toInt();

          printWarning('Rewarded ad failed to load with code ' + error.code.toString() + ' - retrying in ' + retryDelay.toString() + 's');
          Future.delayed(Duration(milliseconds: retryDelay * 1000), () {
            AppLovinMAX.loadRewardedAd(_rewarded_ad_unit_id);
          });

    }, onAdDisplayedCallback: (ad) {
          updateWatchedAds();
      printWarning('Rewarded ad displayed');

    }, onAdDisplayFailedCallback: (ad, error) {
      printWarning('Rewarded ad failed to display with code ${error.code} and message ${error.message}');

    }, onAdClickedCallback: (ad) {
      printWarning('Rewarded ad clicked');

    }, onAdHiddenCallback: (ad) {
      printWarning('Rewarded ad hidden');

    }, onAdReceivedRewardCallback: (ad, reward) {
      printWarning('Rewarded ad granted reward');

    }, onAdRevenuePaidCallback: (ad) {
      printWarning('Rewarded ad revenue paid: ${ad.revenue}');
    }));

    AppLovinMAX.loadRewardedAd(_rewarded_ad_unit_id);


  }


  Future<void> showRewardedAd() async {
    bool isReady = (await AppLovinMAX.isRewardedAdReady(_rewarded_ad_unit_id))!;
    if (isReady) {
      printWarning("*********** Rewarded Ad HAZIR *********");
      valuesController.reklamBekleniyorMu.value = false;
      AppLovinMAX.showRewardedAd(_rewarded_ad_unit_id);
    } else {
      printWarning("Rewarded ad hazır değil. Yenisi yükleniyor...");
      AppLovinMAX.loadRewardedAd(_rewarded_ad_unit_id);
    }
  }

  Future<void> updateWatchedAds() async {
    final DocumentReference docRef = firestore.collection("users").doc(valuesController.currentUserId.value);
    firestore.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(docRef);
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        int currentWatchedAds = data['watched_ads'] ?? 0;
        int newWatchedAds = currentWatchedAds + 1;

        transaction.update(docRef, {'watched_ads': newWatchedAds});
      }
    });
  }

  Future<void> addError(String error) async {
    final DocumentReference docRef = firestore.collection("users").doc(valuesController.currentUserId.value);
    try{
      await docRef.update({'errors': FieldValue.arrayUnion([error])});
    }catch(e){

    }
  }





}