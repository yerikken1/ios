import 'package:flutter/material.dart';

void main() {
  runApp(const BusinessApp());
}

class BusinessApp extends StatelessWidget {
  const BusinessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfileCardScreen(),
    );
  }
}

class ProfileCardScreen extends StatefulWidget {
  const ProfileCardScreen({super.key});

  @override
  State<ProfileCardScreen> createState() => _ProfileCardScreenState();
}

class _ProfileCardScreenState extends State<ProfileCardScreen> {
  bool _isFollowing = false;
  bool _isLiked = false;

  int _followerCount = 1320;
  int _likesCount = 120;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.lime,
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 16),

                const Text(
                  'Aydana Yerkengazina',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const Text(
                  'IT in Business 4th year student',
                  style: TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text(
                          '$_followerCount',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text('Followers'),
                      ],
                    ),

                    Column(
                      children: [
                        Text(
                          '$_likesCount',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text('Likes ❤️'),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _toggleFollow,
                      icon: Icon(
                        _isFollowing
                            ? Icons.check
                            : Icons.person_add,
                      ),
                      label: Text(
                        _isFollowing ? 'Following' : 'Follow',
                      ),
                    ),

                    const SizedBox(width: 10),

                    OutlinedButton.icon(
                      onPressed: _toggleLike,
                      icon: Icon(
                        _isLiked
                            ? Icons.favorite
                            : Icons.favorite_border,
                      ),
                      label: Text(
                        _isLiked ? 'Liked' : 'Like',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                TextButton(
                  onPressed: _reset,
                  child: const Text('Reset'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Follow / Following
  void _toggleFollow() {
    setState(() {
      _isFollowing = !_isFollowing;

      if (_isFollowing) {
        _followerCount++;
      } else {
        _followerCount--;
      }
    });
  }

  // Like / Unlike
  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;

      if (_isLiked) {
        _likesCount++;
      } else {
        _likesCount--;
      }
    });
  }

  // Reset everything
  void _reset() {
    setState(() {
      _isFollowing = false;
      _isLiked = false;
      _followerCount = 1320;
      _likesCount = 120;
    });
  }
}