

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mbarete_padel/config/theme/app_theme.dart';
import 'package:mbarete_padel/presentation/providers/providers.dart';
import 'package:mbarete_padel/presentation/screens/home/views/views.dart';

class ReservationsView extends ConsumerStatefulWidget {

  const ReservationsView({super.key});

  @override
  ReservationViewState createState() => ReservationViewState();
}

class ReservationViewState extends ConsumerState<ReservationsView> 
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
     
     int idUsuario =  ref.read(loginProvider.notifier).retornarIdUsuario();
     ref.read(reservaProvider.notifier).listarReservasPorUsuario(idUsuario);

    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final colors = Theme.of(context).colorScheme;
    
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        toolbarHeight: kTextTabBarHeight,
        title: Text(
          "Reservas",
          style: titleTextStyle,
        ),
        backgroundColor: colors.background,
        elevation: 0.0,
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelStyle: tabBarTextStyle,
          labelColor: colors.primary,
          unselectedLabelColor: colors.secondary,
          indicatorColor: colors.primary,
          tabs: const [
            Tab(
              text: "Pendientes",
            ),
            Tab(
              text: "Historial",
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          OrderScreen(),
          HistoryScreen(),
        ],
      ),
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}
