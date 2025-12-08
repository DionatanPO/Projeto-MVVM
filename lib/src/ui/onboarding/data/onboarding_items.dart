// lib/src/ui/onboarding/data/onboarding_items.dart
class OnboardingItem {
  final String title;
  final String description;
  final String imageUrl;

  const OnboardingItem({
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  static const List<OnboardingItem> items = [
    OnboardingItem(
      title: "Controle Total\nDo Seu Dinheiro",
      description: "Gerencie suas finanças com inteligência, gráficos detalhados e insights em tempo real.",
      // Imagem de Finanças/Gráficos
      imageUrl: "https://images.unsplash.com/photo-1551288049-bebda4e38f71?q=80&w=1000&auto=format&fit=crop",
    ),
    OnboardingItem(
      title: "Sincronização\nEm Nuvem",
      description: "Seus dados disponíveis no Windows, Android e Web. Tudo conectado instantaneamente.",
      // Imagem de Tecnologia/Conexão
      imageUrl: "https://images.unsplash.com/photo-1519389950473-47ba0277781c?q=80&w=1000&auto=format&fit=crop",
    ),
    OnboardingItem(
      title: "Segurança\nDe Ponta a Ponta",
      description: "Protegemos o que mais importa com criptografia militar e biometria avançada.",
      // Imagem de Segurança/Cadeado
      imageUrl: "https://images.unsplash.com/photo-1563986768609-322da13575f3?q=80&w=1000&auto=format&fit=crop",
    ),
  ];
}