import 'package:flutter/material.dart';
import 'package:gold/Utils/deviceSize.dart';
import 'package:gold/data/models/goldData.dart';
import 'package:gold/data/repository/datarepository.dart';
import 'package:gold/screens/data.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

String formatIndianCurrency(double amount) {
  var format = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);
  return format.format(amount);
}

class Hometab extends StatefulWidget {
  const Hometab({super.key});

  @override
  State<Hometab> createState() => _HometabState();
}

class _HometabState extends State<Hometab> {
  final ValueNotifier<double> _currentGoldPrice = ValueNotifier<double>(0.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 235, 228, 228),
      body: SizedBox(
        height: Devicesize.height! / 1.05,
        child: Center(
          child: Column(
            children: [
              PriceCard(onPriceChanged: (newPrice) {
                _currentGoldPrice.value = newPrice;
              }),
              Value(currentGoldPrice: _currentGoldPrice),
              Saved(
                data: Datarepository.getAllData(),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _currentGoldPrice.dispose();
    super.dispose();
  }
}

class PriceCard extends StatefulWidget {
  const PriceCard({super.key, required this.onPriceChanged});
  final ValueChanged<double> onPriceChanged;

  @override
  _PriceCardState createState() => _PriceCardState();
}

class _PriceCardState extends State<PriceCard> {
  final TextEditingController _priceController = TextEditingController();
  bool _isEditing = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _lastUpdated = DateFormat('dd-MM-yyyy hh:mm a').format(DateTime.now());
  late SharedPreferences _prefs;
  double _previousPrice = 5500.0;
  String _priceChangePercentage = "+0.0%";

  @override
  void initState() {
    super.initState();
    _loadSavedPrice();
  }

  Future<void> _loadSavedPrice() async {
    _prefs = await SharedPreferences.getInstance();

    setState(() {
      String? savedPrice = _prefs.getString('goldPrice');
      _priceController.text = savedPrice?.replaceAll(',', '') ?? "5500";
      _lastUpdated = _prefs.getString('lastUpdated') ??
          DateFormat('dd-MM-yyyy hh:mm a').format(DateTime.now());
      _previousPrice = _prefs.getDouble('previousPrice') ?? 5500.0;
      _priceChangePercentage =
          _prefs.getString('priceChangePercentage') ?? "+0.0%";
      widget.onPriceChanged(double.tryParse(savedPrice!.replaceAll(',', '')) ??
          5500.0); // Notify initial price
    });
  }

  Future<void> _savePrice(String price) async {
    final cleanedPrice = price.replaceAll(',', '');
    await _prefs.setString('goldPrice', cleanedPrice);
    await _prefs.setString('lastUpdated', _lastUpdated);
    double? currentPrice = double.tryParse(cleanedPrice);
    if (currentPrice != null) {
      await _prefs.setDouble('previousPrice', currentPrice);
    }
    await _prefs.setString('priceChangePercentage', _priceChangePercentage);
    if (currentPrice != null) {
      widget.onPriceChanged(currentPrice); // Notify price change
    }
  }

  String _getPriceChangePercentage(String currentPriceString) {
    final cleanedPrice = currentPriceString.replaceAll(',', '');
    double? currentPrice = double.tryParse(cleanedPrice);
    if (currentPrice == null) {
      return "+0.0%";
    }
    double priceChange = currentPrice - _previousPrice;
    double percentageChange = (priceChange / _previousPrice) * 100;
    return "${percentageChange > 0 ? '+' : ''}${percentageChange.toStringAsFixed(2)}%";
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(color: Colors.grey.shade200, width: 1),
        ),
        padding: const EdgeInsets.all(12.0), // Reduced padding
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      "Gold Price (22K)",
                      style: TextStyle(
                        fontSize: 16, // Reduced font size
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      if (!_isEditing)
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _isEditing = true;
                            });
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.grey,
                            size: 20,
                          ),
                          hoverColor: Colors.transparent,
                          splashColor: Colors.transparent,
                        ),
                      if (_isEditing)
                        IconButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _isEditing = false;
                                _lastUpdated = DateFormat('dd-MM-yyyy hh:mm a')
                                    .format(DateTime.now());
                                _priceChangePercentage = _getPriceChangePercentage(
                                    _priceController.text);
                                _savePrice(_priceController.text);
                              });
                            }
                          },
                          icon: const Icon(
                            Icons.save,
                            color: Colors.green,
                            size: 20,
                          ),
                          hoverColor: Colors.transparent,
                          splashColor: Colors.transparent,
                        ),
                    ],
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  const Text(
                    "₹",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900, // Made it W900
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 4),
                  if (_isEditing)
                    SizedBox(
                      width: 100,
                      child: TextFormField(
                        controller: _priceController,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: false),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900, // Made it W900
                          color: Colors.black,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          errorStyle: TextStyle(fontSize: 10),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter price';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Invalid number';
                          }
                          return null;
                        },
                      ),
                    )
                  else
                    Text(
                      _priceController.text,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900, // Made it W900
                        color: Colors.black,
                      ),
                    ),
                  const Text(
                    "/g",
                    style: TextStyle(fontSize: 16, color: Colors.grey), // Reduced font size
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _priceChangePercentage,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              Text(
                "Last updated: $_lastUpdated",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DataProvider {
  static double getPurchaseVal() {
    return Datarepository.getPurchaseVal();
  }

  static double getCurrentVal(double currentPrice) {
    return Datarepository.getTotalWeight() * currentPrice;
  }
}

class Value extends StatefulWidget {
  const Value({super.key, required this.currentGoldPrice});
  final ValueNotifier<double> currentGoldPrice;

  @override
  State<Value> createState() => _ValueState();
}

class _ValueState extends State<Value> {
  @override
  Widget build(BuildContext context) {
    double purchaseValue = DataProvider.getPurchaseVal();

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(color: Colors.grey.shade200, width: 1),
        ),
        padding: const EdgeInsets.all(12.0), // Reduced padding.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Collection Value",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
            const SizedBox(height: 8),
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Purchase Value",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      Text(
                        formatIndianCurrency(purchaseValue),
                        style: const TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 20),
                      ),
                    ],
                  ),
                  const VerticalDivider(
                    color: Colors.grey,
                    width: 20,
                    thickness: 1,
                  ),
                  ValueListenableBuilder<double>(
                    valueListenable: widget.currentGoldPrice,
                    builder: (context, currentPrice, child) {
                      double currentValue =
                          DataProvider.getCurrentVal(currentPrice);
                      String percentageDifference =
                          _calculatePercentageDifference(
                              purchaseValue, currentValue);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Current Value",
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          Text(
                            formatIndianCurrency(currentValue),
                            style: const TextStyle(
                                fontWeight: FontWeight.w900, fontSize: 20),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Divider(
              height: 1,
            ),
            const SizedBox(height: 8),
            ValueListenableBuilder<double>(
              valueListenable: widget.currentGoldPrice,
              builder: (context, currentPrice, child) {
                double currentValue = DataProvider.getCurrentVal(currentPrice);
                String percentageDifference =
                    _calculatePercentageDifference(purchaseValue, currentValue);
                return Row(
                  children: [
                    Text(
                      percentageDifference,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: percentageDifference.startsWith('+')
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                    const Text(
                      " (0 profitable, 0 unprofitable)",
                      style: TextStyle(
                          fontSize: 12,
                          color: Color.fromARGB(255, 117, 117, 117)),
                    ),
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }

  String _calculatePercentageDifference(
      double purchaseValue, double currentValue) {
    if (purchaseValue == 0) {
      return "+0.0%";
    }
    double difference = currentValue - purchaseValue;
    double percentage = (difference / purchaseValue) * 100;
    return "${percentage > 0 ? '+' : ''}${percentage.toStringAsFixed(2)}%";
  }
}

class CategoryRow extends StatelessWidget {
  const CategoryRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Category",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: Devicesize.height! / 12,
                      width: Devicesize.width! / 5,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(40)),
                      child: const Icon(Icons.earbuds),
                    ),
                    const Text("Ring")
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: Devicesize.height! / 12,
                      width: Devicesize.width! / 5,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(40)),
                      child: const Icon(Icons.earbuds),
                    ),
                    const Text("Necklace")
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: Devicesize.height! / 12,
                      width: Devicesize.width! / 5,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(40)),
                      child: const Icon(Icons.diamond),
                    ),
                    const Text("Gold")
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class Saved extends StatelessWidget {
  const Saved({super.key, required this.data});
  final List<Golddata> data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SizedBox(
        height: Devicesize.height! / 3.5,
        child: GridView.builder(
            itemCount: Datarepository.getDataSize(),
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
            itemBuilder: (context, index) {
              return Cards(
                data: data[index],
              );
            }),
      ),
    );
  }
}

class Cards extends StatelessWidget {
  const Cards({super.key, required this.data});
  final Golddata data;

  showData(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DataScreen(
                  id: data.id,
                )));
  }

  @override
  Widget build(BuildContext context) {
    // Calculate currentPrice and priceChangePercentage
    double currentPrice = data.price;
    double purchasePrice = data.price;
    double priceChangePercentage =
        ((currentPrice - purchasePrice) / purchasePrice) * 100;

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: GestureDetector(
        onTap: () {
          showData(context);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: Devicesize.height! / 4.5,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: Image.memory(data.photo[0]).image,
                          fit: BoxFit.cover),
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(15)),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade800,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        data.metal,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${data.type} • ${data.purity}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Purchase',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Text(
                          '₹${data.price.toStringAsFixed(0)}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Weight',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Text(
                          '${data.weight} g',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Date',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Text(
                          data.date.toString().split(' ')[0],
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '₹${currentPrice.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              priceChangePercentage >= 0
                                  ? Icons.arrow_drop_up
                                  : Icons.arrow_drop_down,
                              color: priceChangePercentage >= 0
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            Text(
                              '${priceChangePercentage.toStringAsFixed(1)}%',
                              style: TextStyle(
                                color: priceChangePercentage >= 0
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.trending_up,
                              color: Colors.orange,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

