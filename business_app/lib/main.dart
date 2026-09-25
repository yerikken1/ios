import 'package:flutter/material.dart';

void main() => runApp(const BusinessApp());

class BusinessApp extends StatelessWidget {
  const BusinessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ProfileCard(),
    );
  }
}

class ProfileCard extends StatefulWidget {
  const ProfileCard({super.key});

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  bool following = false;
  bool liked = false;
  int followers = 1320;
  int likes = 120;

  void follow() {
    setState(() {
      following = !following;
      following ? followers++ : followers--;
    });
  }

  void like() {
    setState(() {
      liked = !liked;
      liked ? likes++ : likes--;
    });
  }

  void reset() {
    setState(() {
      following = false;
      liked = false;
      followers = 1320;
      likes = 120;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
        child: Container(
          width: 390,
          height: 844,
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(35),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 55,
                backgroundColor: Colors.lime,
                child: Icon(
                  Icons.person,
                  size: 65,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 15),

              const Text(
                'Aydana Yerkengazina',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const Text(
                'IT in Business 4th year student',
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    '$followers Followers',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$likes Likes ❤️',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: follow,
                  child: Text(
                    following ? 'Following' : 'Follow',
                  ),
                ),
              ),

              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: like,
                  child: Text(
                    liked ? 'Liked ❤️' : 'Like ♡',
                  ),
                ),
              ),

              const SizedBox(height: 10),

              TextButton(
                onPressed: reset,
                child: const Text('Reset'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}