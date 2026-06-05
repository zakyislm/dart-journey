

class Orang {
  String nama = "Fulan";
  String? alamat;
  final String negara = "Indonesia";
}
class MethodExpressionBody {
  String getNama()=>'Fulan';
  String? getAlamat()=>null;
  String getNegara()=> "Indonesia";
}


extension ExtensionMethod on Orang {
  void printInfo() {
    print("Halo, nama saya adalah $nama, saya tinggal di $alamat, dan saya berasal dari $negara");
  }
}

void main(){
  print(MethodExpressionBody().getNama());
  var orang1 =  Orang();
  orang1.printInfo();
  print(orang1.nama);
  print(orang1.alamat);
  print(orang1.negara);
  Orang orang2 = Orang();
  print(orang2);
}