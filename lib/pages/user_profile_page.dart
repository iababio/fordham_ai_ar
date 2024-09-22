import 'package:flutter/material.dart';
import 'package:FordhamAR/pages/widgets/custom_image.dart';
import 'package:FordhamAR/pages/widgets/setting_box.dart';
import 'package:FordhamAR/pages/widgets/setting_item.dart';
import 'package:FordhamAR/utils/color.dart';
import 'package:FordhamAR/utils/data.dart';


class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: isDark ? Colors.black : Colors.white,
            pinned: true,
            snap: true,
            floating: true,
          ),
          SliverToBoxAdapter(child: Container(
              padding: EdgeInsets.only(top: 20),
              child: _buildBody()))
        ],
      ),
    );
  }

  _buildHeader() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Account",
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          _buildProfile(),
          const SizedBox(
            height: 20,
          ),
          _buildRecord(),
          const SizedBox(
            height: 20,
          ),
          _buildSection1(),
          const SizedBox(
            height: 20,
          ),
          _buildSection2(),
          const SizedBox(
            height: 20,
          ),
          _buildSection3(),
        ],
      ),
    );
  }

  Widget _buildProfile() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        CustomImage(
          profile["image"]!,
          width: 70,
          height: 70,
          radius: 20,
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          profile["name"]!,
          style: TextStyle(
            fontSize: 18,
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildRecord() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: SettingBox(
            title: "12 courses",
            icon: "assets/icons/work.svg",
            color: isDark ? Colors.black : Colors.black,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: SettingBox(
            title: "55 hours",
            icon: "assets/icons/time.svg",
            color: isDark ? Colors.black : Colors.black,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: SettingBox(
            title: "4.8",
            icon: "assets/icons/star.svg",
            color: isDark ? Colors.black : Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildSection1() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: isDark ? Colors.black38 : Colors.white38,
        boxShadow: [
          BoxShadow(
            color: AppColor.shadowColor.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          SettingItem(
            title: "Setting",
            leadingIcon: "assets/icons/setting.svg",
            bgIconColor: AppColor.blue, context: context,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 45),
            child: Divider(
              height: 0,
              color: Colors.grey.withOpacity(0.8),
            ),
          ),
          SettingItem(
            title: "Cart",
            leadingIcon: "assets/icons/wallet.svg",
            bgIconColor: AppColor.green, context: context,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 45),
            child: Divider(
              height: 0,
              color: Colors.grey.withOpacity(0.8),
            ),
          ),
          SettingItem(
            title: "Bookmarks",
            leadingIcon: "assets/icons/bookmark.svg",
            bgIconColor: AppColor.primary, context: context,
          ),
        ],
      ),
    );
  }

  Widget _buildSection2() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: isDark ? Colors.black38 : Colors.white38,
        boxShadow: [
          BoxShadow(
            color: AppColor.shadowColor.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          SettingItem(
            title: "Notification",
            leadingIcon: "assets/icons/bell.svg",
            bgIconColor: AppColor.purple, context: context,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 45),
            child: Divider(
              height: 0,
              color: Colors.grey.withOpacity(0.8),
            ),
          ),
          SettingItem(
            title: "Privacy",
            leadingIcon: "assets/icons/shield.svg",
            bgIconColor: AppColor.orange, context: context,
          ),
        ],
      ),
    );
  }

  Widget _buildSection3() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: isDark ? Colors.black38 : Colors.white38,
        boxShadow: [
          BoxShadow(
            color: AppColor.shadowColor.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: SettingItem(
        title: "Log Out",
        leadingIcon: "assets/icons/logout.svg",
        bgIconColor: AppColor.red, context: context,
      ),
    );
  }
}