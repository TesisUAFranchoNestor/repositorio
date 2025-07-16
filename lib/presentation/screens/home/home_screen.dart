import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mbarete_padel/presentation/providers/auth/login_provider.dart';
import 'package:mbarete_padel/presentation/widgets/widgets.dart';

import 'views/views.dart';

class HomeScreen extends ConsumerStatefulWidget {
  static String get routeName => 'home';
  static String get routeLocation => '/$routeName';
  final int pageIndex;

  const HomeScreen({
    super.key, 
    required this.pageIndex
  });

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> with AutomaticKeepAliveClientMixin{
  
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    
    ref.read( loginProvider.notifier ).actualizarUsuario();


    pageController = PageController(
      keepPage: true
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  final viewRoutes = const <Widget>[
    HomeView(),
    ReservationsView(),
    ProfileView()
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if( pageController.hasClients ){
      pageController.animateToPage(
        widget.pageIndex,  
        duration: const Duration(milliseconds: 250), 
        curve: Curves.easeOut
      );
    }

    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        children: viewRoutes,
      ),
      bottomNavigationBar: CustomBottomNavigation(currentIndex: widget.pageIndex),
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}