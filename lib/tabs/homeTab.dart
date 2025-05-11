import 'package:flutter/material.dart';
import 'package:gold/Utils/deviceSize.dart'; // Assuming this utility exists
import 'package:gold/data/models/goldData.dart'; // Assuming this model exists
import 'package:gold/data/repository/datarepository.dart'; // Assuming this repository exists
import 'package:gold/screens/data.dart'; // Assuming this screen exists
import 'package:flutter/services.dart';
import 'package:intl/intl.dart'; // For date and currency formatting
import 'package:shared_preferences/shared_preferences.dart'; // For local storage
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Import Font Awesome icons
import 'dart:typed_data'; // Required for Uint8List

// Helper function to format currency in Indian Rupees
String formatIndianCurrency(double amount) {
  // Ensure amount is not null, NaN, or infinite before formatting
  if (amount.isNaN || amount.isInfinite) return "N/A";
  var format = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);
  return format.format(amount);
}

// Helper function to format date
String formatDate(DateTime date) {
  return DateFormat('dd-MM-yyyy').format(date);
}

// Main Hometab widget, a StatefulWidget to manage state
class Hometab extends StatefulWidget {
  const Hometab({super.key});

  @override
  State<Hometab> createState() => _HometabState();
}

// Remove the global category variable as selection is managed by ValueNotifier
// String category = "";

class _HometabState extends State<Hometab> {
  // ValueNotifier to hold the current gold price (double).
  // Used to notify widgets that depend on the gold price.
  final ValueNotifier<double> _currentGoldPrice = ValueNotifier<double>(0.0);
  // ValueNotifier to hold the set of selected category names (Set<String>).
  // Used to notify widgets (like Saved) when category filters change.
  final ValueNotifier<Set<String>> _selectedCategories = ValueNotifier<Set<String>>({});

  @override
  void initState() {
    super.initState();
    // You might want to load initial selected categories from SharedPreferences here if needed
    // For simplicity, starting with an empty set.
    _selectedCategories.value = {};
  }

  @override
  Widget build(BuildContext context) {
    // Initialize Devicesize (assuming it needs context)
    // If Devicesize is static and doesn't need context, this can be moved
    // Devicesize.init(context); // Uncomment if Devicesize.init needs context

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 235, 228, 228),
      body: SingleChildScrollView(
        // Wrap the entire body with SingleChildScrollView for vertical scrolling
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20), // Add bottom padding to the whole content
            child: Column(
              children: [
                // PriceCard widget to display and edit gold price.
                // It uses a callback to update _currentGoldPrice ValueNotifier.
                PriceCard(onPriceChanged: (newPrice) {
                  _currentGoldPrice.value = newPrice; // Update the notifier when price changes
                }),
                // Value widget to show total collection value.
                // It listens to _currentGoldPrice changes using ValueListenableBuilder.
                Value(currentGoldPrice: _currentGoldPrice),
                // CategoryRow widget for selecting categories.
                // It updates the _selectedCategories ValueNotifier on tap.
                CategoryRow(selectedCategories: _selectedCategories),
                // Saved widget to display saved gold items based on filters.
                // It listens to both _currentGoldPrice and _selectedCategories notifiers
                // to filter and display items.
                Saved(
                  data: Datarepository.getAllData(), // Assuming this fetches all data
                  currentGoldPrice: _currentGoldPrice,
                  selectedCategories: _selectedCategories,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose all ValueNotifiers to prevent memory leaks when the widget is removed
    _currentGoldPrice.dispose();
    _selectedCategories.dispose();
    super.dispose();
  }
}

// PriceCard widget to display and allow editing the current gold price per gram.
class PriceCard extends StatefulWidget {
  const PriceCard({super.key, required this.onPriceChanged});
  final ValueChanged<double> onPriceChanged; // Callback to notify parent of price change

  @override
  _PriceCardState createState() => _PriceCardState();
}

class _PriceCardState extends State<PriceCard> {
  final TextEditingController _priceController = TextEditingController();
  bool _isEditing = false; // State to manage editing mode (true when the price is being edited)
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Key for form validation
  String _lastUpdated = DateFormat('dd-MM-yyyy hh:mm a').format(DateTime.now()); // Timestamp for last update
  late SharedPreferences _prefs; // SharedPreferences instance for local persistence
  double _previousPrice = 5500.0; // Store previous price for percentage calculation
  String _priceChangePercentage = "+0.0%"; // Percentage change string (e.g., "+1.2%", "-0.5%")

  @override
  void initState() {
    super.initState();
    _loadSavedPrice(); // Load price and related data from SharedPreferences on initialization
  }

  // Load price and related data from SharedPreferences
  Future<void> _loadSavedPrice() async {
    _prefs = await SharedPreferences.getInstance();

    setState(() {
      // Load price string, remove commas, default to "5500" if not found
      String? savedPrice = _prefs.getString('goldPrice');
      _priceController.text = savedPrice?.replaceAll(',', '') ?? "5500";
      // Load last updated timestamp, default to current time if not found
      _lastUpdated = _prefs.getString('lastUpdated') ??
          DateFormat('dd-MM-yyyy hh:mm a').format(DateTime.now());
      // Load previous price for percentage calculation, default to 5500.0
      _previousPrice = _prefs.getDouble('previousPrice') ?? 5500.0;
      // Load price change percentage, default to "+0.0%"
      _priceChangePercentage =
          _prefs.getString('priceChangePercentage') ?? "+0.0%";

      // Notify the parent widget (Hometab) with the loaded price.
      // Handle potential null after replaceAll and parsing.
      widget.onPriceChanged(double.tryParse(_priceController.text.replaceAll(',', '')) ?? 5500.0);
    });
  }

  // Save current price and related data to SharedPreferences
  Future<void> _savePrice(String price) async {
    final cleanedPrice = price.replaceAll(',', '');
    await _prefs.setString('goldPrice', cleanedPrice);
    await _prefs.setString('lastUpdated', _lastUpdated);
    double? currentPrice = double.tryParse(cleanedPrice);
    if (currentPrice != null) {
       // Only update previousPrice if a valid new price was entered
      await _prefs.setDouble('previousPrice', currentPrice);
    }
    await _prefs.setString('priceChangePercentage', _priceChangePercentage);

    // Notify the parent widget (Hometab) with the new price.
    if (currentPrice != null) {
      widget.onPriceChanged(currentPrice);
    }
  }

  // Calculate the percentage change from the previous price
  String _getPriceChangePercentage(String currentPriceString) {
    final cleanedPrice = currentPriceString.replaceAll(',', '');
    double? currentPrice = double.tryParse(cleanedPrice);
    // Ensure currentPrice is valid and previousPrice is not zero before calculation
    if (currentPrice == null || _previousPrice == 0) {
      return "+0.0%";
    }
    double priceChange = currentPrice - _previousPrice;
    double percentageChange = (priceChange / _previousPrice) * 100;
    // Format with sign and two decimal places
    return "${percentageChange >= 0 ? '+' : ''}${percentageChange.toStringAsFixed(2)}%";
  }

  @override
  void dispose() {
    _priceController.dispose(); // Dispose the text editing controller
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
        padding: const EdgeInsets.all(12.0), // Padding inside the card
        child: Form(
          key: _formKey, // Assign form key for validation
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
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      // Show edit icon when not editing
                      if (!_isEditing)
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _isEditing = true; // Enter editing mode
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
                      // Show save icon when editing
                      if (_isEditing)
                        IconButton(
                          onPressed: () {
                            // Validate the form before saving
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _isEditing = false; // Exit editing mode
                                // Update previous price before calculating new percentage change
                                _previousPrice = double.tryParse(_priceController.text.replaceAll(',', '')) ?? _previousPrice;
                                _lastUpdated = DateFormat('dd-MM-yyyy hh:mm a')
                                    .format(DateTime.now());
                                _priceChangePercentage = _getPriceChangePercentage(
                                    _priceController.text);
                                _savePrice(_priceController.text); // Save the new price
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
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 4),
                  // Show TextFormField when editing
                  if (_isEditing)
                    SizedBox(
                      width: 100, // Fixed width for the input field
                      child: TextFormField(
                        controller: _priceController,
                        keyboardType:
                            const TextInputType.numberWithOptions(decimal: false),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly, // Allow only digits
                        ],
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none, // No border
                          contentPadding: EdgeInsets.symmetric(vertical: 0), // Adjust padding
                          isDense: true, // Make input field dense
                          errorStyle: TextStyle(fontSize: 10), // Smaller error text
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter price'; // Validation message
                          }
                          if (int.tryParse(value) == null) {
                            return 'Invalid'; // Validation message
                          }
                          return null; // Valid input
                        },
                      ),
                    )
                  // Show price as Text when not editing
                  else
                    Text(
                      _priceController.text,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                  const Text(
                    "/g",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(width: 8),
                  // Display price change percentage
                  Text(
                    _priceChangePercentage,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      // Color based on positive or negative change
                      color: _priceChangePercentage.startsWith('+') ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
              // Display the last updated timestamp
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

// DataProvider class to fetch aggregate values (Purchase and Current)
// This class interacts with the Datarepository.
class DataProvider {
  static double getPurchaseVal() {
    // Assuming Datarepository.getPurchaseVal calculates the total purchase value
    return Datarepository.getPurchaseVal();
  }

  static double getCurrentVal(double currentPrice) {
    // Assuming Datarepository.getTotalWeight calculates the total weight
    // Total current value is total weight * current price per gram
    return Datarepository.getTotalWeight() * currentPrice;
  }
}

// Value widget to display collection purchase and current value
class Value extends StatefulWidget {
  const Value({super.key, required this.currentGoldPrice});
  final ValueNotifier<double> currentGoldPrice; // Accept the ValueNotifier

  @override
  State<Value> createState() => _ValueState();
}

class _ValueState extends State<Value> {
  @override
  Widget build(BuildContext context) {
    // Get the total purchase value
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
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Collection Value",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
            const SizedBox(height: 8),
            IntrinsicHeight( // Ensures columns have the same height
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Column for Purchase Value
                  Expanded( // Use Expanded to allow flexible spacing
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Purchase Value",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        Text(
                          formatIndianCurrency(purchaseValue),
                          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  // Vertical Divider
                  const VerticalDivider(
                    color: Colors.grey,
                    width: 20,
                    thickness: 1,
                    indent: 4, // Adjust indent for better alignment
                    endIndent: 4, // Adjust endIndent for better alignment
                  ),
                  // Column for Current Value (Listens to gold price changes)
                  Expanded( // Use Expanded to allow flexible spacing
                    child: ValueListenableBuilder<double>(
                      valueListenable: widget.currentGoldPrice,
                      builder: (context, currentPrice, child) {
                        // Calculate the current value based on the latest gold price
                        double currentValue = DataProvider.getCurrentVal(currentPrice);
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Current Value",
                              style: TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                            Text(
                              formatIndianCurrency(currentValue),
                              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Divider(
              height: 1,
            ),
            const SizedBox(height: 8),
            // Display percentage difference (Listens to gold price changes)
            ValueListenableBuilder<double>(
              valueListenable: widget.currentGoldPrice,
              builder: (context, currentPrice, child) {
                double currentValue = DataProvider.getCurrentVal(currentPrice);
                String percentageDifference = _calculatePercentageDifference(purchaseValue, currentValue);

                // Note: Calculating profitable/unprofitable items requires iterating through individual items,
                // which is not done within DataProvider's aggregate methods.
                // The placeholder text remains as in the original code.
                // int profitableCount = 0; // Placeholder
                // int unprofitableCount = 0; // Placeholder

                return Row(
                  children: [
                    Text(
                      percentageDifference,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: percentageDifference.startsWith('+') ? Colors.green : Colors.red,
                      ),
                    ),
                    // Keeping the original placeholder text for profitable/unprofitable count
                    const Text(
                      " (0 profitable, 0 unprofitable)",
                      style: TextStyle(fontSize: 12, color: Color.fromARGB(255, 117, 117, 117)),
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

  // Helper to calculate percentage difference
  String _calculatePercentageDifference(double purchaseValue, double currentValue) {
    // Avoid division by zero if purchase value is 0
    if (purchaseValue == 0) {
      return "+0.0%";
    }
    double difference = currentValue - purchaseValue;
    double percentage = (difference / purchaseValue) * 100;
    // Format with sign and two decimal places
    return "${percentage >= 0 ? '+' : ''}${percentage.toStringAsFixed(2)}%";
  }
}

// CategoryRow widget allows selecting one or more categories using icons.
class CategoryRow extends StatefulWidget {
  const CategoryRow({super.key, required this.selectedCategories});
  final ValueNotifier<Set<String>> selectedCategories; // Accept the ValueNotifier

  @override
  State<CategoryRow> createState() => _CategoryRowState();
}

class _CategoryRowState extends State<CategoryRow> {
  // Map category names to appropriate Font Awesome icons
  final Map<String, IconData> categoryIcons = {
    "Ring": FontAwesomeIcons.ring, // or FontAwesomeIcons.ringsWedding
    "Necklace": FontAwesomeIcons.gem, // Often used to represent jewelry with stones
    "Bangle": FontAwesomeIcons.circleNotch, // Represents a circular, open form
    "Chain": FontAwesomeIcons.link, // Already appropriate for a chain
    "Earring": FontAwesomeIcons.star, // Directly represents an ear, where earrings are worn
    "Others": FontAwesomeIcons.ellipsisH, // A standard icon for "more" or "others"
  };

  @override
  Widget build(BuildContext context) {
    // Use ValueListenableBuilder to rebuild CategoryRow when selected categories change.
    // This updates the UI (icon color and background) based on selection.
    return ValueListenableBuilder<Set<String>>(
      valueListenable: widget.selectedCategories,
      builder: (context, selectedCats, child) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Align children to start
            children: [
              const Text(
                "Categories",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
              const SizedBox(height: 8), // Add spacing below the title
              SingleChildScrollView(
                // Make the category row horizontally scrollable
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start, // Align items to the start horizontally
                  children: categoryIcons.entries.map((entry) {
                    String categoryName = entry.key;
                    IconData iconData = entry.value;
                    // Check if the current category is in the selected categories set
                    bool isSelected = selectedCats.contains(categoryName);

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0), // Adjusted padding between items
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Toggle selection in the selected categories set.
                              // Need to create a new set or modify and reassign
                              // to trigger ValueNotifier listener effectively.
                              Set<String> updatedSelection = Set.from(selectedCats);
                              if (isSelected) {
                                updatedSelection.remove(categoryName);
                              } else {
                                updatedSelection.add(categoryName);
                              }
                              // Assign the updated set to the notifier's value.
                              // This will trigger the ValueListenableBuilder in Saved.
                              widget.selectedCategories.value = updatedSelection;
                              // No need to call notifyListeners explicitly after assigning a new value
                            },
                            child: Container(
                              height: Devicesize.height! / 18,
                              width: Devicesize.width! / 8,
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.amber.shade800 : Colors.white, // Background color changes on selection
                                borderRadius: BorderRadius.circular(40),
                                border: isSelected ? Border.all(color: Colors.amber.shade800, width: 2) : null, // Optional border for selection
                                boxShadow: [ // Add a subtle shadow
                                  BoxShadow(
                                    color: Colors.grey.shade200,
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                iconData,
                                color: isSelected ? Colors.white : Colors.black54, // Icon color changes on selection
                                size: 20, // Adjust icon size
                              ),
                            ),
                          ),
                          const SizedBox(height: 4), // Spacing between icon and text
                          Text(
                            categoryName,
                            style: TextStyle(
                              fontSize: 12, // Smaller font size for text
                              color: isSelected ? Colors.black87 : Colors.grey.shade700, // Text color changes on selection
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal, // Bold text for selected
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Saved widget displays the list of saved gold items, filtered by selected categories.
// It listens to changes in both current gold price and selected categories.
class Saved extends StatelessWidget {
  const Saved({
    super.key,
    required this.data, // The complete list of gold data
    required this.currentGoldPrice, // ValueNotifier for current gold price
    required this.selectedCategories, // ValueNotifier for selected categories
  });
  final List<Golddata> data;
  final ValueNotifier<double> currentGoldPrice;
  final ValueNotifier<Set<String>> selectedCategories;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      // Use ValueListenableBuilder for current gold price changes.
      // This rebuilds the widget tree below when the gold price changes.
      child: ValueListenableBuilder<double>(
        valueListenable: currentGoldPrice,
        builder: (context, currentPriceValue, _) { // 'currentPriceValue' is the actual double price
          // Use another ValueListenableBuilder for selected categories changes.
          // This rebuilds the widget tree below when the set of selected categories changes.
          return ValueListenableBuilder<Set<String>>(
            valueListenable: selectedCategories,
            builder: (context, selectedCats, __) {
              // Filter the data based on the selected categories.
              // If no categories are selected (set is empty), show all data.
              // Otherwise, show only items whose type is present in the selectedCats set.
              final filteredData = selectedCats.isEmpty
                  ? data
                  : data.where((item) => selectedCats.contains(item.type)).toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Align children to start
                children: [
                  const Text(
                    "My Collection",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  const SizedBox(height: 8), // Add spacing below the title
                  // Show a message if the filtered list is empty
                  if (filteredData.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 40.0),
                        child: Text(
                          "No items found for the selected categories.",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  // If filtered data exists, display it in a GridView (configured as a list)
                  else
                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(), // Prevent GridView from scrolling independently
                      shrinkWrap: true, // Make GridView take only necessary space
                      itemCount: filteredData.length, // Use the count of filtered data
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1, // Displaying one item per row, effectively a list
                        mainAxisSpacing: 10, // Add spacing between rows (items)
                        crossAxisSpacing: 10, // Add spacing between columns (not visible with crossAxisCount: 1)
                        // childAspectRatio: 0.8, // Keep aspect ratio default or adjust if needed
                      ),
                      itemBuilder: (context, index) {
                        // Use the filtered data for displaying cards.
                        // Pass the actual double price from the outer ValueListenableBuilder.
                        return Cards(
                          data: filteredData[index], // Pass the filtered item data
                          currentGoldPrice: currentPriceValue, // Pass the double value
                        );
                      },
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

// Cards widget to display individual gold item details in a card format.
class Cards extends StatelessWidget {
  const Cards({super.key, required this.data, required this.currentGoldPrice});
  final Golddata data; // Data for the individual item
  final double currentGoldPrice; // The current gold price per gram (double)

  // Navigate to the details screen when the card is tapped
  void showData(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DataScreen(
                  id: data.id,
                  currentGoldPrice: currentGoldPrice,
                )));
  }

  @override
  Widget build(BuildContext context) {
    // Calculate the current value and percentage change for this specific item
    double currentItemValue = data.weight * currentGoldPrice;
    double purchasePrice = data.price;
    // Calculate percentage change, handle division by zero if purchase price is 0
    double priceChangePercentage = (purchasePrice == 0) ? 0 : ((currentItemValue - purchasePrice) / purchasePrice) * 100;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0), // Add vertical padding for separation between cards
      child: GestureDetector(
        onTap: () {
          showData(context); // Trigger navigation on tap
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300, // Lighter shadow
                spreadRadius: 1, // Reduced spread radius
                blurRadius: 4, // Reduced blur radius
                offset: const Offset(0, 2), // Adjusted offset
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stack for item image and metal type badge
              Stack(
                children: [
                  Container(
                    height: Devicesize.height! / 4.5, // Set a fixed height for the image area
                    decoration: BoxDecoration(
                      // Display image if available, otherwise show placeholder color
                      image: data.photo.isNotEmpty
                          ? DecorationImage(image: Image.memory(data.photo[0]).image, fit: BoxFit.cover)
                          : null,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                       color: data.photo.isEmpty ? Colors.grey.shade200 : null, // Placeholder color if no photo
                    ),
                    // Add a placeholder icon if no photo
                     child: data.photo.isEmpty
                        ? const Center(child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey))
                        : null,
                  ),
                  // Positioned badge for metal type
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
              // Padding for item details below the image
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Item Name
                    Text(
                      data.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Item Type, Purity, and Billing Name
                    Text(
                      '${data.type} • ${data.purity} • ${data.billingName}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    // Purchase Price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Purchase',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Text(
                          formatIndianCurrency(data.price),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Item Weight
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
                    // Purchase Date
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Date',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Text(
                          formatDate(data.date), // Format the date using the helper
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Current Value and Percentage Change
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Current Item Value
                        Text(
                          formatIndianCurrency(currentItemValue),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Percentage Change with icon and color
                        Row(
                          children: [
                             Icon(
                              priceChangePercentage >= 0 ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                              color: priceChangePercentage >= 0 ? Colors.green : Colors.red,
                            ),
                            Text(
                              '${priceChangePercentage.toStringAsFixed(1)}%',
                              style: TextStyle(
                                color: priceChangePercentage >= 0 ? Colors.green : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
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
