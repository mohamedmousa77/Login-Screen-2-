import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LocalAuthentication localAuthentication = LocalAuthentication();
  bool supportState = false;
  bool isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    localAuthentication.isDeviceSupported();
    localAuthentication
        .isDeviceSupported()
        .then((bool isSupported) => setState(() {
              supportState = isSupported;
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: <Widget>[
            const Icon(Icons.arrow_back_rounded, color: Colors.white),
            const SizedBox(
              height: 200,
            ),
            const Center(
                child: Text(
              'Login',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            )),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            Container(
              padding: const EdgeInsets.only(left: 20, top: 20),
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.07,
              decoration: BoxDecoration(
                  color: const Color.fromRGBO(40, 40, 40, 1),
                  borderRadius: BorderRadius.circular(10)),
              child: const Text(
                'Email Address',
                style: TextStyle(
                    color: Color.fromRGBO(75, 75, 75, 1), fontSize: 15),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            Container(
              padding: const EdgeInsets.only(left: 20, top: 20),
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.07,
              decoration: BoxDecoration(
                  color: const Color.fromRGBO(40, 40, 40, 1),
                  borderRadius: BorderRadius.circular(10)),
              child: const Text(
                'Email Address',
                style: TextStyle(
                    color: Color.fromRGBO(75, 75, 75, 1), fontSize: 15),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.1),
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: MediaQuery.of(context).size.height * 0.07,
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [
                        Color.fromRGBO(255, 188, 52, 1),
                        Color.fromRGBO(189, 111, 95, 1),
                        Color.fromRGBO(255, 96, 92, 1)
                      ]),
                      borderRadius: BorderRadius.circular(10)),
                  child: const Center(
                      child: Text(
                    'Login',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  )),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.02,
                ),
                GestureDetector(
                  onTap: _authenticate,
                  child: Container(
                      padding: const EdgeInsets.all(10),
                      height: MediaQuery.of(context).size.height * 0.07,
                      width: MediaQuery.of(context).size.width * 0.18,
                      decoration: BoxDecoration(
                          color: const Color.fromRGBO(40, 40, 40, 1),
                          borderRadius: BorderRadius.circular(10)),
                      child: SvgPicture.asset(
                        'assets/fingerprint-svgrepo-com.svg',
                        color: const Color.fromRGBO(133, 89, 47, 1),
                      )),
                ),
              ],
            ),
          ],
        ));
  }

  Future<void> _getAvailableBiometrics() async {
    final List<BiometricType> availableBiometrics =
        await localAuthentication.getAvailableBiometrics();
    debugPrint('List of Available Biometrics: $availableBiometrics');
    if (!mounted) {
      return;
    }
  }

  Future<void> _authenticate() async {
    try {
      bool isAuthenticated = await localAuthentication.authenticate(
          localizedReason: 'Authenticate to access the app',
          options: const AuthenticationOptions(
              stickyAuth: true, biometricOnly: true));
      setState(() {
        this.isAuthenticated = isAuthenticated;
      });
      if (isAuthenticated) {
        _showDialog();
      }
    } on PlatformException catch (error) {
      debugPrint('Error during authentication: $error');
    }
  }

  _showDialog() {
    showDialog(
        context: context,
        builder: (context) {
          Future.delayed(const Duration(seconds: 5), () {
            Navigator.of(context).pop(true);
          });
          return Stack(
            children: [
              Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration:
                      BoxDecoration(color: Colors.black.withOpacity(0.6))),
              Container(
                  color: Colors.black54,
                  margin: const EdgeInsets.only(top: 200),
                  child: SvgPicture.asset('assets/welcome-illustration 1.svg')),
            ],
          );
        });
  }
}
