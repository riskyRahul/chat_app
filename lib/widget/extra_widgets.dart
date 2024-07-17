import 'package:animate_do/animate_do.dart';
import 'package:chat_app/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:slide_to_act/slide_to_act.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.black,
        body: Stack(children: [
      Padding(
        padding: const EdgeInsets.only(left: 16.0, top: 64, right: 16),
        child: Column(children: [
          FadeInDown(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: MediaQuery.of(context).size.width * 0.7,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: const DecorationImage(
                    image: AssetImage('assets/images/NFT_4.png'),
                    fit: BoxFit.cover),
              ),
            ),
          ),
          const SizedBox(height: 70),
          FadeInLeft(
              child: const Text(
            'Create Your Crypto Wallet App',
            style: TextStyle(
                color: Colors.black87,
                fontSize: 41,
                fontWeight: FontWeight.bold,
                fontFamily: ''),
          )),
          const SizedBox(height: 20),
          FadeInLeft(
              child: const Text(
            'Transfer your crypto securely with our 100% secure wallet, backed by zero-knowledge proof.',
            style: TextStyle(color: Colors.grey, fontSize: 18),
          )),
          const SizedBox(height: 100)
        ]),
      ),
      Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: Builder(builder: (context) {
            final GlobalKey<SlideActionState> key = GlobalKey();
            return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SlideAction(
                    sliderRotate: false,
                    outerColor: Colors.white,
                    innerColor: Colors.black87,
                    key: key,
                    sliderButtonIcon: const Icon(IconlyBroken.arrow_right,
                        color: Colors.white),
                    onSubmit: () {
                      return Future.delayed(
                        const Duration(seconds: 1),
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomePage()),
                          );
                        },
                      );
                    },
                    child: FadeInRight(
                        child: const Text(
                      'Swipe to get started',
                      style: TextStyle(color: Colors.black, fontSize: 17),
                    ))));
          }))
    ]));
  }
}
