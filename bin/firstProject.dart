import 'dart:io';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

late String name; //
late String bornLocation; //
late String dateBorn; //
late String religion;
late String gender;
late String job;
late String address;
late String nomorKtp;

String getNama(){
  String inputNama ='';
  while(inputNama.isEmpty){
    print("Masukkan nama anda : ");
    inputNama = (stdin.readLineSync() ?? '').trim();
    if(inputNama.isEmpty){
      print("Nama tidak dapat dikosongkan. Silakan coba lagi.");
    }
  }
  return inputNama;
}
String getBornLocation(){
  String inputBornLocation ='';
  while(inputBornLocation.isEmpty){
    print("Masukkan Tempat lahir anda : ");
    inputBornLocation = (stdin.readLineSync() ?? '').trim();
    if(inputBornLocation.isEmpty){
      print("Tempat lahir tidak dapat dikosongkan. Silakan coba lagi.");
    }
  }
  return inputBornLocation;
}
Future<String> getDateBorn() async {
  await initializeDateFormatting('id_ID', null);
  String inputDate = '';
  DateTime? parsedDate;
  List<String> formats = [
    'd/M/yyyy', 'd-M-yyyy', 'd M yyyy',
    'dd/MM/yyyy', 'dd-MM-yyyy', 'dd MM yyyy',
    'd/M/yy', 'd-M-yy', 'd M yy'
  ];
  while (parsedDate == null) {
    print("Masukkan Tanggal lahir anda : ");
    inputDate = (stdin.readLineSync() ?? '').trim();
    if (inputDate.isEmpty) {
      print("Tanggal lahir tidak dapat dikosongkan. Silakan coba lagi.\n");
      continue;
    }
    for (String format in formats) {
      try {
        parsedDate = DateFormat(format).parseStrict(inputDate);
        break; // Jika berhasil diubah menjadi DateTime, keluar dari loop pengecekan format
      } catch (e) {
      //
      }
    }
    if (parsedDate == null) {
      print("Format tanggal salah atau tanggal tidak valid. Silakan coba lagi.\n");
    }
  }
  String hasilFormat = DateFormat('dd MMMM yyyy', 'id_ID').format(parsedDate);
  return hasilFormat; 
}
String getReligion(){
  String inputReligion ='';
  while(inputReligion.isEmpty){
    print("Masukkan Agama anda : ");
    inputReligion = (stdin.readLineSync() ?? '').trim();
    if(inputReligion.isEmpty){
      print("Agama tidak dapat dikosongkan. Silakan coba lagi.");
    }
  }
  return inputReligion;
}
String getGender(){
  String inputGender='';
  while(inputGender.isEmpty){
    print("Masukkan Jenis Kelamin anda : ");
    inputGender = (stdin.readLineSync() ?? '').trim();
    if(inputGender.isEmpty){
      print("Jenis kelamin tidak dapat dikosongkan. Silakan coba lagi.");
    } else if (inputGender.toLowerCase() != 'laki-laki' && inputGender.toLowerCase() != 'perempuan') {
      print("Input tidak valid. Silakan masukkan 'Laki-laki' atau 'Perempuan'.");
      inputGender = '';
    }
  }
  return inputGender;
}
String getJobInfo(){
  String inputJob ='';
  while(inputJob.isEmpty){
    print("Masukkan Pekerjaan anda : ");
    inputJob = (stdin.readLineSync() ?? '').trim();
    if(inputJob.isEmpty){
      print("Pekerjaan tidak dapat dikosongkan. Silakan coba lagi.");
    }
  }
  return inputJob;
}
String getAddress(){
  String inputAddress ='';
  while(inputAddress.isEmpty){
    print("Masukkan Alamat anda : ");
    inputAddress = (stdin.readLineSync() ?? '').trim();
    if(inputAddress.isEmpty){
      print("Alamat tidak dapat dikosongkan. Silakan coba lagi.");
    }
  }
  return inputAddress;
}
String generateNomorKtp(){
  Random random = Random();
  String randint = '';
  for(int i=0;i<16;i++){
    randint += random.nextInt(16).toString();
  }
  return randint;
}
String padCenter(String text, int width) {
  if (text.length >= width) return text;
  int totalPadding = width - text.length;
  int paddingLeft = totalPadding ~/ 2;
  return text.padLeft(text.length + paddingLeft).padRight(width);
}
void main() async{
  const italicStart = '\x1B[3m';
  const resetFormat = '\x1B[0m';
  print("Selamat datang di program simulasi KTP");
  print("$italicStart *anda akan diminta untuk memasukan data pribadi anda $resetFormat");
  print("$italicStart *data anda hanya akan digunakan untuk keperluan simulasi dan tidak akan disimpan atau dibagikan kepada pihak manapun $resetFormat");
  name = getNama();
  bornLocation = getBornLocation();
  dateBorn = await getDateBorn();
  religion = getReligion();
  gender = getGender();
  job = getJobInfo();
  address = getAddress();
  nomorKtp = generateNomorKtp();
  void buildKTP(){
    print("------------------------------------------------------------------------");
    print("|${padCenter("KARTU TANDA PENDUDUK", 70)}|");
    print("|${padCenter(nomorKtp.toString(), 70)}|");
    print("|----------------------------------------------------------------------|");
    print("| ${"Nama           : $name".padRight(70 - 2)} |");
    print("| ${"Tempat Lahir   : $bornLocation".padRight(70 - 2)} |");
    print("| ${"Tanggal Lahir  : $dateBorn".padRight(70 - 2)} |");
    print("| ${"Agama          : $religion".padRight(70 - 2)} |");
    print("| ${"Jenis Kelamin  : $gender".padRight(70 - 2)} |");
    print("| ${"Pekerjaan      : $job".padRight(70 - 2)} |");
    print("| ${"Alamat         : $address".padRight(70 - 2)} |");
    print("| ${"Berlaku Hingga : SEUMUR HIDUP".padRight(70 - 2)} |");
    print("|----------------------------------------------------------------------|");
    
    // Khusus teks catatan kaki, teksnya sangat panjang jadi kita buat tanpa padRight manual
    String catatan = "*Data di atas adalah hasil simulasi semata";
    print("|$italicStart ${catatan.padRight(70 - 2)} $resetFormat|");
    print("------------------------------------------------------------------------");
  }
  print("Membuat KTP...");
  await Future.delayed(Duration(seconds: 2));
  print("Berikut adalah KTP anda");
  buildKTP();
}