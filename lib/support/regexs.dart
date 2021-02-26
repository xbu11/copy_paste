class Regexs {
  static var regexName = RegExp(r"[a-zA-Z]\w+|[a-zA-Z]");
  static var regexDl = RegExp(r"[A-Z]\d{3}-\d{4}-\d{4}-\d{2}");
  static var regexDate = RegExp(r"(0[1-9]|1[012])[- \/.](0[1-9]|[12][0-9]|3[01])[- \/.](19|20)\d\d");
  
}