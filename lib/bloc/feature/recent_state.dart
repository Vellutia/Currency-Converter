part of 'recent_bloc.dart';

abstract class RecentState {
  const RecentState();
}

class Recent extends RecentState {
  final List<Currency> listCurr;

  const Recent(this.listCurr);
}