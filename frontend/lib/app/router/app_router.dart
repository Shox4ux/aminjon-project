import 'package:go_router/go_router.dart';
import 'package:factory_management/shared/widgets/app_scaffold.dart';
import 'package:factory_management/features/factory/presentation/pages/factory_page.dart';
import 'package:factory_management/features/product/presentation/pages/product_page.dart';
import 'package:factory_management/features/factory_category/presentation/pages/factory_category_page.dart';

final appRouter = GoRouter(
  initialLocation: '/factories',
  routes: [
    ShellRoute(
      builder: (context, state, child) => AppScaffold(child: child),
      routes: [
        GoRoute(path: '/factories', builder: (ctx, st) => const FactoryPage()),
        GoRoute(path: '/products', builder: (ctx, st) => const ProductPage()),
        GoRoute(path: '/categories', builder: (ctx, st) => const FactoryCategoryPage()),
      ],
    ),
  ],
);
