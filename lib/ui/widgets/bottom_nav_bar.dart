import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/bottom_nav_cubit.dart';

class BottomNavBar extends StatelessWidget {
  /// It is okay not to use a const constructor here.
  /// Using const breaks updating of selected BottomNavigationBarItem.
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
      return BlocBuilder<BottomNavCubit, int>(
          builder: (BuildContext context, int state) {
        return NavigationBar(
          // currentIndex: state,
          selectedIndex: state,
           onDestinationSelected: (int index) =>
               context.read<BottomNavCubit>().updateIndex(index),
          
          // type: BottomNavigationBarType.fixed,
          // selectedItemColor: Theme.of(context).colorScheme.primary,
          // unselectedItemColor: Theme.of(context).textTheme.bodySmall!.color,
          // items: <BottomNavigationBarItem>[
          //   BottomNavigationBarItem(
          //     icon: const Icon(Icons.home),
          //     label: tr('bottom_nav_first'),
          //   ),
          //   BottomNavigationBarItem(
          //     icon: const Icon(Ionicons.information_circle_outline),
          //     label: tr('bottom_nav_second'),
          //   ),
          // ],
          destinations: <Widget>[
            NavigationDestination(icon: const Icon(Icons.home), label: tr('bottom_nav_first')),
            NavigationDestination(icon: const Icon(Icons.star), label: tr('bottom_nav_second'))
            ],
        );
      });
  }
}
