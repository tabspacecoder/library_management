class Privileges {
  static const int SuperAdmin = 1;
  static const int Admin = 2;
  static const int User = 4;
}

class Avail {
  static const int Online = 1;
  static const int Offline = 2;
}

class RequestStatus {
  static const String processing = "PROCESSING";
  static const String approved = "APPROVED";
  static const String declined = "DECLINED";
}

// All the class below here are associated with Header class that of handling  API request and response
class Header {
  static const String Split = "||";
  static const String Error = "Error";
  static const String Ack = "Ack";
  static const String Success = "Success";
  static const String Failed = "Failed";
  static const String Login = "Login";
}

class Error {
  static const String Unauthorized = "Unauthorized";
  static const String Unknown = "Unknown";
  static const String Server = "Server";
  static const String Unavailable = "Unavailable";
  static const String Read = "Read";
  static const String InvalidRequest = "InvalidRequest";
  static const String Exist = "Exists";
}

class Failure {
  static const String Unauthorized = "Unauthorized";
  static const String Unknown = "Unknown";
  static const String Server = "Server";
  static const String Unavailable = "Unavailable";
  static const String Read = "Read";
  static const String InvalidRequest = "InvalidRequest";
  static const String Exist = "Exists";
}

class Handler {
  static const String Adarsh = "Adarsh";
  static const String Mugunth = "Mugunth";
  static const String Nikhil = "Nikhil";
}

class Create {
  static const String User = "CreateUser";
  static const String Admin = "CreateAdmin";
  static const String Users = "CreateUsers";
  static const String Admins = "CreateAdmins";
}

class Update {
  static const String Password = "UpdatePassword";
  static const String Permission = "UpdatePermission";
  static const String BookRecord = "UpdateRecord";
  static const String DigitalBook = "UpdateDigitalBook";
}

class Fetch {
  static const String DigitalBooks = "DigitalFetchBooks";
  static const String BookRecord = "FetchBooks";
  static const String News = "FetchNews";
}

class Search {
  static const String Books = "SearchBooks";
}

class Categories {
  static const String All = "all";
  static const String Business = "business";
  static const String Entertainment = "entertainment";
  static const String General = "general";
  static const String Health = "health";
  static const String Science = "science";
  static const String Sports = "sports";
  static const String Technology = "technology";
}

class Add {
  static const String BookRecord = "AddBookRecord";
}

class Upload {
  static const String DigitalBook = "UploadDigitalBook";
}

const String ip = "192.168.1.3";
const int TCPPort = 24680;
const int WebPort = 13579;