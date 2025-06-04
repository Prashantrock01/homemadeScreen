import 'package:biz_infra/Screens/emergency/send_message_alert.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const _infoMsg = 'Use SOS only in case of Emergency';

class RaiseSOSAlert extends StatelessWidget {
  const RaiseSOSAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: CloseButton(
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.black87,
      body: SizedBox.expand(
        child: Column(
          children: [
            SizedBox(
              height: 250.0,
              width: double.maxFinite,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    height: 120.0,
                    margin: const EdgeInsets.only(
                      bottom: 20.0,
                    ),
                    width: 120.0,
                    child: const Icon(
                      Icons.sos,
                      color: Colors.white,
                      size: 80.0,
                    ),
                  ),
                  const Text(
                    'Raise SOS Alert',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    _infoMsg,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 3 / 4,
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  AlertTypeGridTile(
                    alertIcon: FontAwesomeIcons.briefcaseMedical,
                    iconColor: Colors.green,
                    title: 'Medical Emergency',
                    alertPage: SendMessageAlert(
                      icon: FontAwesomeIcons.briefcaseMedical,
                      iconColor: Colors.green,
                      subtitle: _infoMsg,
                      title: 'Medical Emergency',
                    ),
                  ),
                  AlertTypeGridTile(
                    alertIcon: FontAwesomeIcons.fire,
                    iconColor: Colors.deepOrange,
                    title: 'Fire/Gas Leak Emergency',
                    alertPage: SendMessageAlert(
                      icon: FontAwesomeIcons.fire,
                      iconColor: Colors.deepOrange,
                      subtitle: _infoMsg,
                      title: 'Fire/Gas Leak Emergency',
                    ),
                  ),
                  AlertTypeGridTile(
                    alertIcon: FontAwesomeIcons.elevator,
                    iconColor: Colors.blueGrey,
                    title: 'Lift Emergency',
                    alertPage: SendMessageAlert(
                      icon: FontAwesomeIcons.elevator,
                      iconColor: Colors.blueGrey,
                      subtitle: _infoMsg,
                      title: 'Lift Emergency',
                    ),
                  ),
                  AlertTypeGridTile(
                    alertIcon: FontAwesomeIcons.peopleRobbery,
                    iconColor: Colors.lightBlue,
                    title: 'Theft/Others Emergency',
                    alertPage: SendMessageAlert(
                      icon: FontAwesomeIcons.peopleRobbery,
                      iconColor: Colors.lightBlue,
                      subtitle: _infoMsg,
                      title: 'Theft/Others Emergency',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AlertTypeGridTile extends StatelessWidget {
  const AlertTypeGridTile({
    super.key,
    required this.alertIcon,
    required this.iconColor,
    required this.title,
    required this.alertPage,
  });

  final IconData alertIcon;
  final Color iconColor;
  final String title;
  final Widget alertPage;

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: GestureDetector(
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => alertPage,
            ),
          );
        },
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.grey.shade800,
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 10.0,
                  ),
                  child: FaIcon(
                    alertIcon,
                    color: iconColor,
                    size: 80.0,
                  ),
                ),
                Text(
                  title,
                  softWrap: true,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
