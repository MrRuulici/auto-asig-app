import 'package:auto_asig/core/data/constants.dart';
import 'package:flutter/material.dart';
import 'package:auto_asig/feature/home_screen/cubit/home_screen_cubit.dart';
import 'package:auto_asig/feature/home_screen/cubit/home_screen_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBottomNavigationBar extends StatelessWidget {
  final HomeScreenCubit homeCubit;

  const HomeBottomNavigationBar({super.key, required this.homeCubit});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeScreenCubit, HomeScreenState>(
      builder: (context, state) {
        return BottomAppBar(
          height: 72, // Adjust height if needed
          color: Colors.grey[200],
          shape: const CircularNotchedRectangle(),
          notchMargin: 8.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTabItem(
                icon: Icons.home,
                isSelected: state.activeTab == HomeScreenTabState.home,
                onTap: () => homeCubit.selectTab(HomeScreenTabState.home),
              ),
              _buildTabItem(
                icon: Icons.directions_car,
                isSelected: state.activeTab == HomeScreenTabState.vehicles,
                onTap: () => homeCubit.selectTab(HomeScreenTabState.vehicles),
              ),
              const SizedBox(width: 40), // Space for the FAB
              _buildTabItem(
                icon: Icons.person,
                isSelected: state.activeTab == HomeScreenTabState.personal,
                onTap: () => homeCubit.selectTab(HomeScreenTabState.personal),
              ),
              _buildTabItem(
                icon: Icons.chat,
                isSelected: state.activeTab == HomeScreenTabState.support,
                onTap: () => homeCubit.selectTab(HomeScreenTabState.support),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTabItem({
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: 56, // Explicitly constrain the height
      width: 56, // Constrain width to ensure alignment
      child: Stack(
        alignment: Alignment.center,
        clipBehavior:
            Clip.none, // Allow the indicator to overflow the container
        children: [
          // Icon Button
          Positioned(
            bottom: 0,
            child: IconButton(
              icon: Icon(
                icon,
                color: isSelected ? logoBlue : Colors.grey,
              ),
              onPressed: onTap,
            ),
          ),
          // Indicator
          if (isSelected)
            Positioned(
              top:
                  -8, // Adjust to position the indicator above the BottomAppBar
              child: Container(
                width: 36, // Indicator width
                height: 4, // Indicator height
                decoration: BoxDecoration(
                  color: logoBlue,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}


// class HomeBottomNavigationBar extends StatelessWidget {
//   final HomeScreenCubit homeCubit;

//   const HomeBottomNavigationBar({super.key, required this.homeCubit});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<HomeScreenCubit, HomeScreenState>(
//       builder: (context, state) {
//         return Stack(
//           clipBehavior: Clip.none,
//           alignment: Alignment.bottomCenter,
//           children: [
//             Positioned(
//               bottom: 0,
//               left: 0,
//               right: 0,
//               child: BottomAppBar(
//                 height: 65,
//                 color: Colors.grey[200],
//                 shape: const CircularNotchedRectangle(),
//                 notchMargin: 8.0,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     _buildTabItem(
//                       icon: Icons.home,
//                       isSelected: state.activeTab == HomeScreenTabState.home,
//                       onTap: () => homeCubit.selectTab(HomeScreenTabState.home),
//                     ),
//                     _buildTabItem(
//                       icon: Icons.directions_car,
//                       isSelected:
//                           state.activeTab == HomeScreenTabState.vehicles,
//                       onTap: () =>
//                           homeCubit.selectTab(HomeScreenTabState.vehicles),
//                     ),
//                     const SizedBox(width: 40), // Space for the FAB
//                     _buildTabItem(
//                       icon: Icons.person,
//                       isSelected:
//                           state.activeTab == HomeScreenTabState.personal,
//                       onTap: () =>
//                           homeCubit.selectTab(HomeScreenTabState.personal),
//                     ),
//                     _buildTabItem(
//                       icon: Icons.chat,
//                       isSelected: state.activeTab == HomeScreenTabState.support,
//                       onTap: () =>
//                           homeCubit.selectTab(HomeScreenTabState.support),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Positioned(
//               bottom: 32,
//               child: SizedBox(
//                 width: 65,
//                 height: 65,
//                 child: FloatingActionButton(
//                   onPressed: () {
//                     // Load AddScreen
//                     homeCubit.selectTab(HomeScreenTabState.addNew);
//                     context.push(AddScreen.absolutePath);
//                   },
//                   backgroundColor: logoBlue, // Replace with logoBlue
//                   shape: const CircleBorder(), // Force a perfect circle
//                   child: const Icon(
//                     Icons.add,
//                     size: 20,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildTabItem({
//     required IconData icon,
//     required bool isSelected,
//     required VoidCallback onTap,
//   }) {
//     return Stack(
//       alignment: Alignment.center,
//       clipBehavior: Clip.none,
//       children: [
//         if (isSelected)
//           Positioned(
//             top:
//                 -15, // Adjust to align the indicator exactly at the top of the BottomAppBar
//             child: Container(
//               width: 36, // Width of the indicator bar
//               height: 4, // Height of the indicator bar
//               decoration: BoxDecoration(
//                 color: logoBlue, // Blue if selected
//                 borderRadius: BorderRadius.circular(2), // Rounded edges
//               ),
//             ),
//           ),
//         IconButton(
//           icon: Icon(
//             icon,
//             color: isSelected ? logoBlue : Colors.grey,
//           ),
//           onPressed: onTap,
//         ),
//       ],
//     );
//   }
// }
