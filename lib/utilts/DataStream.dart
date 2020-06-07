import 'dart:convert';
import 'dart:io';

import 'package:naqelapp/models/driver/DriverQuestions.dart';
import 'package:naqelapp/models/driver/Permit.dart';
import 'package:naqelapp/models/driver/documents/IdentityCard.dart';
import 'package:naqelapp/models/commons/CompletedJob.dart';
import 'package:naqelapp/models/driver/jobs/JobOfferPosts.dart';
import 'package:naqelapp/models/driver/jobs/JobRequests.dart';
import 'package:naqelapp/models/driver/Trailer.dart';
import 'package:naqelapp/models/driver/Trucks.dart';
import 'package:naqelapp/models/driver/DriverProfile.dart';
import 'package:naqelapp/models/driver/documents/DrivingLicence.dart';
import 'package:naqelapp/models/driver/documents/EntryExitCard.dart';
import 'package:naqelapp/models/commons/OngoingJob.dart';
import 'package:naqelapp/models/driver/jobs/TraderRequestPackages.dart';
import 'package:naqelapp/models/trader/TraderProfile.dart';
import 'package:naqelapp/models/trader/TraderQuestions.dart';
import 'package:naqelapp/models/trader/documents/CommercialRegisterCertificate.dart';
import 'package:naqelapp/models/trader/documents/TraderIdentityCard.dart';
import 'package:naqelapp/models/trader/jobs/DriverRequestPackages.dart';
import 'package:naqelapp/models/trader/jobs/JobOfferTrader.dart';
import 'package:naqelapp/models/trader/jobs/JobRequestPosts.dart';

import 'UI/toast_utility.dart';
import 'URLs.dart';

class DataStream{



  static String token;
  static DriverProfile driverProfile;
  static TraderProfile traderProfile;
  static Trucks truck;

  static List<Trailer> trailers;
  static List<Permit> permit;
  static List<JobRequests> requests;
  static List<JobOfferPosts> joboffersposts;
  static List<CompletedJobPackages> compleatedJobspackage;
  static List<JobRequestPosts> traderJobRequestPosts;
  static List<JobOfferPackages> traderJobOfferPackages;
  static List<TraderRequestPackages> traderRequestPackages;
  static List<DriverRequestPackages> driverrRequestPackages;
  static List<DriverQuestions> questions;
  static List<TraderQuestions> traderquestions;



  static OngoingJob ongoingJob;
  static EntryExitCard entryExitCard;
  static IdentityCard identityCard;
  static DrivingLicence drivingLicence;
  static TraderIdentityCard traderIdentityCard;
  static CommercialRegisterCertificate commercialRegisterCertificate;

  static List<DriverQuestions> parseQuestions(data){
    var list = data as List;
    List<DriverQuestions> trailers= list.map((data) => DriverQuestions.fromJson(data)).toList();
    return trailers;
  }

  static List<TraderQuestions> parseTraderQuestions(data){
    var list = data as List;
    List<TraderQuestions> trailers= list.map((data) => TraderQuestions.fromJson(data)).toList();
    return trailers;

  }

  static List<Trailer> parseTrailer(data){
    var list = data as List;
    List<Trailer> trailers= list.map((data) => Trailer.fromJson(data)).toList();
    return trailers;

  }
  static List<Permit> parsePermit(data){
    var list = data as List;
    List<Permit> permit= list.map((data) => Permit.fromJson(data)).toList();
    return permit;

  }
  static List<JobRequests> parseRequests(data){
    var list = data as List;
    List<JobRequests> requests= list.map((data) => JobRequests.fromJson(data)).toList();
    return requests;

  }

  static List<JobOfferPosts> parseJobOffer(data){
    var list = data as List;
    List<JobOfferPosts> offers= list.map((data) => JobOfferPosts.fromJson(data)).toList();
    return offers;

  }

  static List<CompletedJobPackages> parseCompletedJobs(data){
    var list = data as List;
    List<CompletedJobPackages> offers= list.map((data) => CompletedJobPackages.fromJson(data)).toList();
    return offers;

  }

  static List<JobRequestPosts> parsetraderJobRequestPosts(data){
    var list = data as List;
    List<JobRequestPosts> offers= list.map((data) => JobRequestPosts.fromJson(data)).toList();
    return offers;

  }

  static List<JobOfferPackages> parsetraderJobOfferPackages(data){
    var list = data as List;
    List<JobOfferPackages> offers= list.map((data) => JobOfferPackages.fromJson(data)).toList();
    return offers;
  }
  static List<TraderRequestPackages> parseTraderRequestPackages(data){
    var list = data as List;
    List<TraderRequestPackages> offers= list.map((data) => TraderRequestPackages.fromJson(data)).toList();
    return offers;
  }
  static List<DriverRequestPackages> parseDriverRequestPackages(data){
    var list = data as List;
    List<DriverRequestPackages> offers= list.map((data) => DriverRequestPackages.fromJson(data)).toList();
    return offers;
  }


}
