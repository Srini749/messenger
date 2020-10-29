class Call {
  String callerID;
  String callerName;
  String callerPic;
  String receiverPic;
  String receiverName;
  String receiverID;
  String channelID;
  bool hasDialed;

  Call(
      {this.hasDialed, this.channelID, this.receiverID, this.receiverName, this.receiverPic, this.callerPic, this.callerID, this.callerName});


  Map<String, dynamic> toMap(Call call) {
    Map<String, dynamic> callMap = Map();
    callMap["callerID"] = call.callerID;
    callMap["callerName"] = call.callerName;
    callMap["callerPic"] = call.callerPic;
    callMap["receiverPic"] = call.receiverPic;
    callMap["receiverName"] = call.receiverName;
    callMap["receiverID"] = call.receiverID;
    callMap["channelID"] = call.channelID;
    callMap["hasDialed"] = call.hasDialed;
    return callMap;
  }

  Call.fromMap(Map callMap){
    this.callerID = callMap["callerID"] ;
    this.callerName = callMap["callerName"];
    this.callerPic = callMap["callerPic"];
    this.receiverPic = callMap["receiverPic"] ;
    this.receiverName = callMap["receiverName"];
    this.receiverID = callMap["receiverID"] ;
    this.channelID = callMap["channelID"] ;
    this.hasDialed = callMap["hasDialed"] ;
  }
}