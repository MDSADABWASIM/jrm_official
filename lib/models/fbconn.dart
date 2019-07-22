import 'package:jrm/models/data.dart';

class FbConn {
  Map objectData = new Map();

  FbConn(this.objectData);

  int getDataSize() {
    int size = objectData.keys.length;
    return size;
  }

  Object getValue(String key) {
    Object value;
    for (int s = 0; s < objectData.keys.length; s++) {
      value = objectData[objectData.keys.elementAt(s)][key];
    }
    return value == null ? "" : value;
  }

  String getKeyID() {
    Object value;
    for (int s = 0; s < objectData.keys.length; s++) {
      value = objectData[objectData.keys.elementAt(s)][AppData.keyID];
    }
    return value == null ? "" : value.toString();
  }

  String getProfileImage() {
    Object value = objectData[AppData.profileImgURL];
    return value == null ? "" : value.toString();
  }

  String getUserID() {
    Object value = objectData[AppData.userID];
    return value == null ? "" : value.toString();
  }

  List<String> getKeyIDasList() {
    List<String> value = new List();
    for (int s = 0; s < objectData.keys.length; s++) {
      // Map val = objectData[objectData.keys.elementAt(s)];
      value.add(objectData[AppData.keyID]);
    }
    return value;
  }

  List<String> getAdminMessageSenderIDasList() {
    List<String> value = new List();
    int lastItem;
    for (int s = 0; s < objectData.keys.length; s++) {
      //Map val = objectData[objectData.keys.elementAt(s)];
      Map map1 = objectData[objectData.keys.elementAt(s)];
      lastItem = map1.keys.length - 1;
      Map map2 = map1[map1.keys.elementAt(lastItem)];
      value.add(map2[AppData.messageSenderUID]);
    }
    return value;
  }

  List<String> getAdminMessageSenderImage() {
    List<String> value = new List();
    int lastItem;
    for (int s = 0; s < objectData.keys.length; s++) {
      //Map val = objectData[objectData.keys.elementAt(s)];
      Map map1 = objectData[objectData.keys.elementAt(s)];
      lastItem = map1.keys.length - 1;
      Map map2 = map1[map1.keys.elementAt(lastItem)];
      value.add(map2[AppData.messageSenderImage]);
    }
    return value;
  }

  List<String> getAdminMessageTextasList() {
    List<String> value = new List();
    int lastItem;
    for (int s = 0; s < objectData.keys.length; s++) {
      //Map val = objectData[objectData.keys.elementAt(s)];
      Map map1 = objectData[objectData.keys.elementAt(s)];
      lastItem = map1.keys.length - 1;
      Map map2 = map1[map1.keys.elementAt(lastItem)];
      value.add(map2[AppData.messageText]);
    }
    return value;
  }

  List<String> getAdminSenderNameAsList() {
    List<String> value = new List();
    int lastItem;
    for (int s = 0; s < objectData.keys.length; s++) {
      //Map val = objectData[objectData.keys.elementAt(s)];
      Map map1 = objectData[objectData.keys.elementAt(s)];
      lastItem = map1.keys.length - 1;
      Map map2 = map1[map1.keys.elementAt(lastItem)];
      value.add(map2[AppData.messageSenderName]);
    }
    return value;
  }

  List<int> getAdminMessageTimeAsList() {
    List<int> value = new List();
    int lastItem;
    for (int s = 0; s < objectData.keys.length; s++) {
      //Map val = objectData[objectData.keys.elementAt(s)];
      Map map1 = objectData[objectData.keys.elementAt(s)];
      lastItem = map1.keys.length - 1;
      Map map2 = map1[map1.keys.elementAt(lastItem)];
      value.add(map2[AppData.messageTime]);
    }
    return value;
  }

  List<String> getMessageIDasList() {
    List<String> value = new List();
    for (int s = 0; s < objectData.keys.length; s++) {
      Map val = objectData[objectData.keys.elementAt(s)];
      value.add(val[AppData.messageID]);
    }
    return value;
  }

  List<String> getMessageKeyIDasList() {
    List<String> value = new List();
    for (int s = 0; s < objectData.keys.length; s++) {
      Map val = objectData[objectData.keys.elementAt(s)];
      value.add(val[AppData.messageKeyID]);
    }
    return value;
  }

  List<String> getMessageSenderIDasList() {
      List<String> value = new List();
    for (int s = 0; s < objectData.keys.length; s++) {
      Map val = objectData[objectData.keys.elementAt(s)];
      value.add(val[AppData.messageSenderUID]);
    }
    return value;
  }

  List<String> getMessageReceiverIDasList() {
    List<String> value = new List();
    Map val = objectData;
    value.add(val[AppData.messageReceiverUID]);

    return value;
  }

  List<String> getMessageSenderNameAsList() {
    List<String> value = new List();
    for (int s = 0; s < objectData.keys.length; s++) {
      Map val = objectData[objectData.keys.elementAt(s)];
      value.add(val[AppData.messageSenderName]);
    }
    return value;
  }

  List<String> getMessageTextAsList() {
    List<String> value = new List();
    for (int s = 0; s < objectData.keys.length; s++) {
      Map val = objectData[objectData.keys.elementAt(s)];
      value.add(val[AppData.messageText]);
    }
    return value;
  }

  List<int> getMessageTimeAsList() {
    List<int> value = new List();
    for (int s = 0; s < objectData.keys.length; s++) {
      Map val = objectData[objectData.keys.elementAt(s)];
      value.add(val[AppData.messageTime]);
    }
    return value;
  }

  List<bool> getMessageSeen() {
    List<bool> value = new List();
    for (int s = 0; s < objectData.keys.length; s++) {
      Map val = objectData[objectData.keys.elementAt(s)];
      value.add(val[AppData.messageSeen]);
    }
    return value;
  }

  List<bool> getMessageRead() {
    List<bool> value = new List();
    for (int s = 0; s < objectData.keys.length; s++) {
      Map val = objectData[objectData.keys.elementAt(s)];
      value.add(val[AppData.messageRead]);
    }
    return value;
  }

  List<String> getSenderImageAsList() {
    List<String> value = new List();
    for (int s = 0; s < objectData.keys.length; s++) {
      Map val = objectData[objectData.keys.elementAt(s)];
      value.add(val[AppData.messageSenderImage]);
    }
    return value;
  }

  List<String> getSenderEmailAsList() {
    List<String> value = new List();
    for (int s = 0; s < objectData.keys.length; s++) {
      Map val = objectData[objectData.keys.elementAt(s)];
      value.add(val[AppData.messageSenderEmail]);
    }
    return value;
  }

  List<bool> getIsFavoriteAsList() {
    List<bool> value = new List();
    for (int s = 0; s < objectData.keys.length; s++) {
      // Map val = objectData[objectData.keys.elementAt(s)];
      value.add(objectData[AppData.isFavorite]);
    }
    return value;
  }
}
