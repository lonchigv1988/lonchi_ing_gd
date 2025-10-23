import 'package:flutter/material.dart';
import 'package:lonchi_ing_gd/acero/AISCProp.dart';
import 'Demanda.dart';
import 'package:lonchi_ing_gd/concreto/Refuerzo.dart';

class DemProvider with ChangeNotifier {
  int? Tipo;
  double? LSel;
  double? wCPSel;
  double? wCTSel;
  Deman? ApSel;
  double? Ancho;
  double? PesProp;
  double? Ixx;
  double? EE;

  DemProvider({this.Tipo, this.LSel, this.wCPSel, this.wCTSel, this.ApSel, this.Ancho, this.PesProp, this.Ixx, this.EE});

  getTipo() => Tipo;
  getLSel() => LSel;
  getwCPSel() => wCPSel;
  getwCTSel() => wCTSel;
  getApSel() => ApSel;
  getAncho() => Ancho;
  getPesProp() => PesProp;
  getIxx() => Ixx;
  getEE() => EE;

  void setTipo(int a) {
    Tipo = a;
    notifyListeners();
  }
  void setLSel(double? a) {
    LSel = a;
    notifyListeners();
  }
  void setwCPSel(double a) {
    wCPSel = a;
    notifyListeners();
  }
  void setwCTSel(double a) {
    wCTSel = a;
    notifyListeners();
  }
  void setApSel(Deman? a) {
    ApSel = a;
    notifyListeners();
  }
  void setAncho(double? a) {
    Ancho = a;
    notifyListeners();
  }
  void setPesProp(double a) {
    PesProp = a;
    notifyListeners();
  }
  void setIxx(double a) {
    Ixx = a;
    notifyListeners();
  }
  void setEE(double a) {
    EE = a;
    notifyListeners();
  }
}

class ResultProvider with ChangeNotifier {
  double? L;
  double? DefCP;
  double? DefCT;
  double? DefServ;
  double? Mupos;
  double? Muneg;
  double? Vumax;
  double? fMnpos;
  double? fMnneg;
  double? fVnmax;

  ResultProvider({this.L, this.DefCP, this. DefCT, this.DefServ,
    this.Mupos, this.Muneg, this.Vumax,
    this.fMnpos, this.fMnneg, this.fVnmax,});

  getL() => L;
  getDefCP() => DefCP;
  getDefCT() => DefCT;
  getDefServ() => DefServ;
  getMupos() => Mupos;
  getMuneg() => Muneg;
  getVumax() => Vumax;
  getfMnpos() => fMnpos;
  getfMnneg() => fMnneg;
  getfVnmax() => fVnmax;

  void setL(double a) {
    L = a;
    notifyListeners();
  }
  void setDefCP(double a) {
    DefCP = a;
    notifyListeners();
  }
  void setDefCT(double a) {
    DefCT = a;
    notifyListeners();
  }
  void setDefServ(double a) {
    DefServ = a;
    notifyListeners();
  }
  void setMupos(double a) {
    Mupos = a;
    notifyListeners();
  }
  void setMuneg(double a) {
    Muneg = a;
    notifyListeners();
  }
  void setVumax(double a) {
    Vumax = a;
    notifyListeners();
  }
  void setfMnpos(double a) {
    fMnpos = a;
    notifyListeners();
  }
  void setfMnneg(double a) {
    fMnneg = a;
    notifyListeners();
  }
  void setfVnmax(double a) {
    fVnmax = a;
    notifyListeners();
  }
}

class WProvider with ChangeNotifier {
  WProp2? WSizeSel;
  WProp? WSel;
  Deman? DemSel;
  // double LSel;
  double? LbSel;
  Acero? AceroSel;
  double? PPSel;

  WProvider({this.WSizeSel, this.WSel, this.DemSel,
    this.LbSel, this.AceroSel, this.PPSel});

  getSecSizeSel() => WSizeSel;
  getSecSel() => WSel;
  getDemSel() => DemSel;
  // getLSel() => LSel;
  getLbSel() => LbSel;
  getAceroSel() => AceroSel;
  getPPSel() => PPSel;

  void setSecSize(a){
    WSizeSel = a;
    notifyListeners();
  }
  void setSecSel(a){
    WSel = a;
    notifyListeners();
  }
  void setDemSel(Deman a){
    DemSel = a;
    notifyListeners();
  }
  // void setLSel(double a){
  //   LSel = a;
  //   notifyListeners();
  // }
  void setLbSel(double a){
    LbSel = a;
    notifyListeners();
  }
  void setAceroSel(a){
    AceroSel = a;
    notifyListeners();
  }
  void setPPSel(double a){
    PPSel = a;
    notifyListeners();
  }
}

class VigProvider with ChangeNotifier {
  double? BVig;
  double? HVig;
  int? fc;
  int? fy;
  int? fyv;
  double? rec;
  int? Nsup1;
  int? Nsup2;
  int? Ninf1;
  int? Ninf2;
  Rebar? Bsup1;
  Rebar? Bsup2;
  Rebar? Binf1;
  Rebar? Binf2;
  Rebar? Baro;
  double? sep;
  double? Asup;
  double? Ainf;
  double? Av;

  VigProvider({this.BVig, this.HVig, this.fc, this.fy, this.fyv, this.rec,
    this.Baro, this.Nsup1, this.Nsup2, this.Ninf1, this.Ninf2, this.Bsup1,
    this.Bsup2, this.Binf1, this.Binf2, this.Asup, this.Ainf, this.sep,
  this.Av});

  getBVig() => BVig;
  getHVig() => HVig;
  getfc() => fc;
  getfy() => fy;
  getfyv() => fyv;
  getrec() => rec;
  getBaro() => Baro;
  getsep() => sep;
  getNsup1() => Nsup1;
  getNsup2() => Nsup2;
  getNinf1() => Ninf1;
  getNinf2() => Ninf2;
  getBsup1() => Bsup1;
  getBsup2() => Bsup2;
  getBinf1() => Binf1;
  getBinf2() => Binf2;
  getAsup() => Asup;
  getAinf() => Ainf;
  getAv() => Av;

  void setBVig(double? a){
    BVig = a;
    notifyListeners();
  }
  void setHVig(double? a){
    HVig = a;
    notifyListeners();
  }
  void setfc(int a){
    fc = a;
    notifyListeners();
  }
  void setfy(int a){
    fy = a;
    notifyListeners();
  }
  void setfyv(int a){
    fyv = a;
    notifyListeners();
  }
  void setrec(double a){
    rec = a;
    notifyListeners();
  }
  void setBaro(Rebar a){
    Baro = a;
    notifyListeners();
  }
  void setsep(double a){
    sep = a;
    notifyListeners();
  }
  void setNsup1(int a){
    Nsup1 = a;
    notifyListeners();
  }
  void setNsup2(int a){
    Nsup2 = a;
    notifyListeners();
  }
  void setNinf1(int a){
    Ninf1 = a;
    notifyListeners();
  }
  void setNinf2(int a){
    Ninf2 = a;
    notifyListeners();
  }
  void setBsup1(Rebar? a){
    Bsup1 = a;
    notifyListeners();
  }
  void setBsup2(Rebar? a){
    Bsup2 = a;
    notifyListeners();
  }
  void setBinf1(Rebar? a){
    Binf1 = a;
    notifyListeners();
  }
  void setBinf2(Rebar? a){
    Binf2 = a;
    notifyListeners();
  }
  void setAsup(double a){
    Asup = a;
    notifyListeners();
  }
  void setAinf(double a){
    Ainf = a;
    notifyListeners();
  }
  void setAv(double a){
    Av = a;
    notifyListeners();
  }
}

class LosaProvider with ChangeNotifier {
  double? BVig;
  double? HVig;
  int? fc;
  int? fy;
  int? fyv;
  double? rec;
  int? Nsup1;
  int? Nsup2;
  int? Ninf1;
  int? Ninf2;
  Rebar? Bsup1;
  Rebar? Bsup2;
  Rebar? Binf1;
  Rebar? Binf2;
  Rebar? Baro;
  double? sep;
  double? Asup;
  double? Ainf;
  double? Av;

  LosaProvider({this.BVig, this.HVig, this.fc, this.fy, this.fyv, this.rec,
    this.Baro, this.Nsup1, this.Nsup2, this.Ninf1, this.Ninf2, this.Bsup1,
    this.Bsup2, this.Binf1, this.Binf2, this.Asup, this.Ainf, this.sep,
    this.Av});

  getBVig() => BVig;
  getHVig() => HVig;
  getfc() => fc;
  getfy() => fy;
  getfyv() => fyv;
  getrec() => rec;
  getBaro() => Baro;
  getsep() => sep;
  getNsup1() => Nsup1;
  getNsup2() => Nsup2;
  getNinf1() => Ninf1;
  getNinf2() => Ninf2;
  getBsup1() => Bsup1;
  getBsup2() => Bsup2;
  getBinf1() => Binf1;
  getBinf2() => Binf2;
  getAsup() => Asup;
  getAinf() => Ainf;
  getAv() => Av;

  void setBVig(double a){
    BVig = a;
    notifyListeners();
  }
  void setHVig(double? a){
    HVig = a;
    notifyListeners();
  }
  void setfc(int a){
    fc = a;
    notifyListeners();
  }
  void setfy(int a){
    fy = a;
    notifyListeners();
  }
  void setfyv(int a){
    fyv = a;
    notifyListeners();
  }
  void setrec(double a){
    rec = a;
    notifyListeners();
  }
  void setBaro(Rebar a){
    Baro = a;
    notifyListeners();
  }
  void setsep(double a){
    sep = a;
    notifyListeners();
  }
  void setNsup1(int a){
    Nsup1 = a;
    notifyListeners();
  }
  void setNsup2(int a){
    Nsup2 = a;
    notifyListeners();
  }
  void setNinf1(int a){
    Ninf1 = a;
    notifyListeners();
  }
  void setNinf2(int a){
    Ninf2 = a;
    notifyListeners();
  }
  void setBsup1(Rebar? a){
    Bsup1 = a;
    notifyListeners();
  }
  void setBsup2(Rebar? a){
    Bsup2 = a;
    notifyListeners();
  }
  void setBinf1(Rebar? a){
    Binf1 = a;
    notifyListeners();
  }
  void setBinf2(Rebar? a){
    Binf2 = a;
    notifyListeners();
  }
  void setAsup(double a){
    Asup = a;
    notifyListeners();
  }
  void setAinf(double a){
    Ainf = a;
    notifyListeners();
  }
  void setAv(double a){
    Av = a;
    notifyListeners();
  }
}