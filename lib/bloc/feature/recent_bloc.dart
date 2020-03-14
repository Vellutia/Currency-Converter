import 'dart:async';

import 'package:currency_converter/services/dialog_service.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../locator.dart';
import '../../model/currency_list.dart';

part 'recent_event.dart';
part 'recent_state.dart';

class RecentBloc extends HydratedBloc<RecentEvent, RecentState> {
  final DialogService _dialogService = locator<DialogService>();

  @override
  RecentState get initialState => super.initialState ?? Recent(<Currency>[]);

  @override
  Stream<RecentState> mapEventToState(
    RecentEvent event,
  ) async* {
    if (event is RecentAdd) {
      if ((state as Recent)
          .listCurr
          .any((e) => e.currencyId == event.curr.currencyId)) {
        yield Recent((state as Recent).listCurr
          ..removeWhere((e) => e.currencyId == event.curr.currencyId)
          ..insert(0, event.curr));
      } else {
        yield Recent((state as Recent).listCurr..insert(0, event.curr));
      }
    } else if (event is RecentRemove) {
      final value = await confirm(event.curr);

      if (value) {
        final updatedCurr = (state as Recent)
            .listCurr
            .where((e) => e.currencyId != event.curr.currencyId)
            .toList();
        yield Recent(updatedCurr);
      }
    }
  }

  @override
  RecentState fromJson(Map<String, dynamic> json) {
    List<Currency> recent = List<Currency>();

    try {
      final parsed = json['recent'] as List;

      for (var json in parsed) {
        recent.add(Currency.fromJson(json));
      }

      return Recent(recent);
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic> toJson(RecentState state) {
    try {
      final recent = (state as Recent).listCurr.map((e) => e.toJson()).toList();
      return {'recent': recent};
    } catch (_) {
      return null;
    }
  }

  Future<bool> confirm(Currency curr) async {
    return await _dialogService
        .showConfirmationDialog(
          title: '${curr.currencyName}',
          cancelTitle: 'CANCEL',
          confirmationTitle: 'REMOVE',
          description: 'Remove from search history?',
        )
        .then((value) => value.confirmed);
  }
}
