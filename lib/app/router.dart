import 'package:flutter_ftv/features/courts/presentation/courts_screen.dart';
import 'package:flutter_ftv/features/history/presentation/history_screen.dart';
import 'package:flutter_ftv/features/players/presentation/players_screen.dart';
import 'package:flutter_ftv/features/sessions/presentation/create_session_screen.dart';
import 'package:flutter_ftv/features/sessions/presentation/sessions_list_screen.dart';
import 'package:go_router/go_router.dart';

/// Declarative navigation for the app. `/` redirects to the sessions list.
final appRouter = GoRouter(
  initialLocation: '/sessions',
  routes: [
    GoRoute(path: '/', redirect: (_, _) => '/sessions'),
    GoRoute(
      path: '/sessions',
      builder: (_, _) => const SessionsListScreen(),
      routes: [
        GoRoute(path: 'new', builder: (_, _) => const CreateSessionScreen()),
        GoRoute(
          path: ':sessionId/players',
          builder: (_, state) =>
              PlayersScreen(sessionId: state.pathParameters['sessionId']!),
        ),
        GoRoute(
          path: ':sessionId/courts',
          builder: (_, state) =>
              CourtsScreen(sessionId: state.pathParameters['sessionId']!),
        ),
        GoRoute(
          path: ':sessionId/history',
          builder: (_, state) =>
              HistoryScreen(sessionId: state.pathParameters['sessionId']!),
        ),
      ],
    ),
  ],
);
