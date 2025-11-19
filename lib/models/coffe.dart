class Coffee {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final double price;
  final String imageUrl; 
  final double rating;
  final int reviewCount;
  final String category; 

  Coffee({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.category, 
  });
}

final List<Coffee> dummyCoffeeList = [
  Coffee(
    id: '1',
    title: 'Espresso',
    subtitle: 'With Extra Shot',
    description: 'A concentrated form of coffee brewed with high pressure...',
    price: 3.00,
    imageUrl: 'assets/images/espresso.jpg', 
    rating: 4.9,
    reviewCount: 200,
    category: 'Hot Coffee', 
  ),
  Coffee(
    id: '2',
    title: 'Vanilla Latte',
    subtitle: 'With Almond Milk',
     description: 'A classic latte with a sweet touch of vanilla syrup...',
    price: 2.50,
    imageUrl: 'assets/images/vanilla_latte.jpg',
    rating: 4.7,
    reviewCount: 158,
    category: 'Latte', 
  ),
  Coffee(
    id: '3',
    title: 'Iced Coffee',
    subtitle: 'With Whipped Cream',
     description: 'Chilled coffee served over ice, perfect for a refreshing boost...',
    price: 3.50,
    imageUrl: 'assets/images/iced_coffee.jpeg',
    rating: 4.8,
    reviewCount: 230,
    category: 'Iced Coffee', 
  ),
  Coffee(
    id: '4',
    title: 'Pumpkin Spice',
    subtitle: 'Seasonal Favorite',
    description: 'Our seasonal favorite, Pumpkin Spice Latte, is back! 🎃',
    price: 4.50,
    imageUrl: 'assets/images/pumpkin_spice.jpeg',
    rating: 4.9,
    reviewCount: 500,
    category: 'Hot Coffee', 
  ),
  Coffee(
    id: '5',
    title: 'Cappuccino',
    subtitle: 'With Foam',
    description: 'A classic Italian coffee drink prepared with espresso, hot milk, and steamed milk foam.',
    price: 3.75,
    imageUrl: 'assets/images/cappuccino.jpeg',
    rating: 4.8,
    reviewCount: 180,
    category: 'Hot Coffee', 
  ),
  Coffee(
    id: '6',
    title: 'Mocha',
    subtitle: 'With Chocolate',
    description: 'A delicious blend of espresso, steamed milk, and rich chocolate syrup.',
    price: 4.20,
    imageUrl: 'assets/images/mocha.jpeg',
    rating: 4.9,
    reviewCount: 215,
    category: 'Mocha', 
  ),
  Coffee(
    id: '7',
    title: 'Caramel Frappé',
    subtitle: 'Iced & Blended',
    description: 'Blended ice, espresso, milk, and caramel syrup.',
    price: 4.80,
    imageUrl: 'assets/images/frappuccino.jpeg', 
    rating: 4.7,
    reviewCount: 190,
    category: 'Frappuccino', 
  ),
];