import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/register_screen.dart';
import '../features/auth/screens/forgot_password_screen.dart';
import '../features/chat/screens/chats_screen.dart';
import '../features/chat/screens/chat_detail_screen.dart';
import '../features/chat/screens/search_screen.dart';
import '../features/profile/screens/profile_screen.dart';

/// App Router
final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    // Auth Routes
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
      routes: [
        GoRoute(
          path: 'register',
          name: 'register',
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: 'forgot-password',
          name: 'forgot-password',
          builder: (context, state) => const ForgotPasswordScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/register',
      name: 'register-page',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/forgot-password',
      name: 'forgot-password-page',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),

    // Chat Routes
    GoRoute(
      path: '/chats',
      name: 'chats',
      builder: (context, state) => const ChatsScreen(),
    ),
    GoRoute(
      path: '/chat/:chatId',
      name: 'chat-detail',
      builder: (context, state) {
        final chatId = state.pathParameters['chatId']!;
        return ChatDetailScreen(chatId: chatId);
      },
    ),
    GoRoute(
      path: '/chat',
      name: 'start-chat',
      builder: (context, state) {
        final userId = state.uri.queryParameters['userId'];
        // Handle start new chat with userId
        return ChatsScreen();
      },
    ),
    GoRoute(
      path: '/search',
      name: 'search',
      builder: (context, state) => const SearchScreen(),
    ),

    // Profile Routes
    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (context, state) => const ProfileScreen(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Route not found: ${state.location}'),
    ),
  ),
);
