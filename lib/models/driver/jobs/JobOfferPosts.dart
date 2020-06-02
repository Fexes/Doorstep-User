
class JobOfferPosts {

   JobOffer jobOffer;
   Trader trader;
   DriverRequest driverRequest;


  JobOfferPosts({
    this.jobOffer,
     this.trader,
     this.driverRequest
  });

  factory JobOfferPosts.fromJson(Map<String, dynamic> parsedJson){
    return JobOfferPosts(
      jobOffer: JobOffer.fromJson(parsedJson["JobOffer"]),
      trader : Trader.fromJson(parsedJson["Trader"]),
      driverRequest : DriverRequest.fromJson(parsedJson["DriverRequest"]),
    );
  }




}

class JobOffer {


  int JobOfferID;
  int TraderID;
  String LoadingPlace;
  String UnloadingPlace;
  String TripType;
  String Price;
  int WaitingTime;
  String TimeCreated;
  String CargoType;
  int CargoWeight;
  String LoadingLocation;
  String UnloadingLocation;
  String LoadingDate;
  String LoadingTime;
  String TruckModel;
  String DriverNationality;
  int EntryExit;
  int AcceptedDelay;
  String JobOfferType;


  JobOffer({
    this.JobOfferID,
    this.TraderID,
    this.LoadingPlace,
    this.UnloadingPlace,
    this.TripType,
    this.Price,
    this.WaitingTime,
    this.TimeCreated,
    this. CargoType,
    this.CargoWeight,
    this. LoadingLocation,
    this. UnloadingLocation,
    this. LoadingDate,
    this. LoadingTime,
    this. TruckModel,
    this. DriverNationality,
    this.EntryExit,
    this.AcceptedDelay,
    this. JobOfferType,
  });

  factory JobOffer.fromJson(Map<String, dynamic> parsedJson){
    return JobOffer(
      JobOfferID: parsedJson['JobOfferID'],
      TraderID : parsedJson['TraderID'],
      LoadingPlace : parsedJson ['LoadingPlace'],
      UnloadingPlace : parsedJson['UnloadingPlace'],
      TripType : parsedJson['TripType'],
      Price : parsedJson['Price'].toString(),
      WaitingTime : parsedJson['WaitingTime'],
      TimeCreated : parsedJson['TimeCreated'],
      CargoType: parsedJson['CargoType'],
      CargoWeight : parsedJson['CargoWeight'],
      LoadingLocation : parsedJson ['LoadingLocation'],
      UnloadingLocation : parsedJson['UnloadingLocation'],
      LoadingDate : parsedJson['LoadingDate'],
      LoadingTime : parsedJson['LoadingTime'],
      TruckModel : parsedJson['TruckModel'],
      DriverNationality : parsedJson['DriverNationality'],
      EntryExit : parsedJson['EntryExit'],
      AcceptedDelay : parsedJson['AcceptedDelay'],
      JobOfferType : parsedJson['JobOfferType'],
    );
  }


}

class Trader {
  String FirstName;
  String LastName;
  String PhotoURL;
  Trader({
    this.FirstName,
    this.LastName,
    this.PhotoURL,
  });
  factory Trader.fromJson(Map<String, dynamic> parsedJson){
    return Trader(
      FirstName : parsedJson['FirstName'],
      LastName : parsedJson ['LastName'],
      PhotoURL : parsedJson ['PhotoURL'],
    );
  }


}

class DriverRequest {
  int DriverRequestID;
  int DriverID;
  int JobOfferID;
  String Price;
  String Created;


  DriverRequest({
    this.DriverRequestID,
    this.DriverID,
    this.JobOfferID,
    this.Price,
    this.Created,
  });
  factory DriverRequest.fromJson(Map<String, dynamic> parsedJson){
    if(parsedJson!=null) {
      return DriverRequest(
        DriverRequestID: parsedJson['DriverRequestID'],
        DriverID: parsedJson ['DriverID'],
        JobOfferID: parsedJson['JobOfferID'],
        Price: parsedJson ['Price'].toString(),
        Created: parsedJson['Created'],
      );
    }else{
      return null;
    }
  }

}