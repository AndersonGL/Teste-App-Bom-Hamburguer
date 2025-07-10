# BOM HAMBURGUER 🍔

✅ Resumo do Projeto
Nome: BOM HAMBURGUER 🍔

Tipo: App de pedidos (Flutter)

Plataforma: Android/iOS

Backend: Sem API – usar armazenamento local ou SQLite

Pagamento: Simulação (nome do cliente)

Regras de desconto: com base na combinação dos itens


📦 Estrutura Sugerida do Projeto Flutter

lib/
├── main.dart
├── models/
│   └── item_model.dart
├── pages/
│   ├── home_page.dart
│   ├── cart_page.dart
│   ├── payment_page.dart
├── widgets/
│   ├── item_tile.dart
│   └── cart_summary.dart
├── controllers/
│   └── cart_controller.dart
└── data/
    └── items_data.dart


---

🧠 Lógica de Negócio (Regras)

Itens

X Burger – R$ 5,00

X Egg – R$ 4,50

X Bacon – R$ 7,00

Batata frita – R$ 2,00

Refrigerante – R$ 2,50


Regras de Desconto

Sanduíche + Batata + Refrigerante → 20%

Sanduíche + Refrigerante → 15%

Sanduíche + Batata → 10%


Validação

Apenas um sanduíche

Apenas um refrigerante

Apenas uma batata



---

🚀 Funcionalidades Requisitadas

Funcionalidade	Status

Listar sanduíches e extras	✅
Adicionar ao carrinho	✅
Mostrar carrinho + cálculo	✅
Finalizar pedido (simulado)	✅
Validação de quantidade	✅



---

🧩 Modelo (Exemplo de classe ItemModel)

class ItemModel {
  final String name;
  final double price;
  final String category;

  ItemModel({required this.name, required this.price, required this.category});
}


---

🛒 Controle do Carrinho (Exemplo)

class CartController extends ChangeNotifier {
  List<ItemModel> _items = [];

  List<ItemModel> get items => _items;

  void addItem(ItemModel item) {
    final existing = _items.where((e) => e.category == item.category);
    if (existing.isNotEmpty) {
      throw Exception('Só é permitido um item da categoria ${item.category}');
    }
    _items.add(item);
    notifyListeners();
  }

  double get total {
    double base = _items.fold(0, (sum, item) => sum + item.price);
    return base - _getDiscount(base);
  }

  double _getDiscount(double base) {
    final hasSandwich = _items.any((e) => e.category == 'sanduiche');
    final hasFries = _items.any((e) => e.name == 'Batata Frita');
    final hasSoda = _items.any((e) => e.name == 'Refrigerante');

    if (hasSandwich && hasFries && hasSoda) return base * 0.2;
    if (hasSandwich && hasSoda) return base * 0.15;
    if (hasSandwich && hasFries) return base * 0.10;

    return 0.0;
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}


---

💰 Pagamento (Simulado)

Formulário com campo: Nome do Cliente

Botão "Finalizar Pedido"

Ao clicar:

Exibir mensagem com resumo e total

Limpar carrinho




---

📂 Publicação no GitHub

Quando o projeto estiver estruturado, você pode:

git init
git remote add origin https://github.com/AndersonGL/App-Bom-Hamburguer.git
git add .
git commit -m "Primeiro commit"
git push -u origin main


---