import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for currency formatting

// Assuming Devicesize is a utility class providing screen dimensions
import 'package:gold/Utils/deviceSize.dart';
// Assuming Golddata is your data model
import 'package:gold/data/models/goldData.dart';
// Assuming Datarepository handles data fetching
import 'package:gold/data/repository/datarepository.dart';
// Assuming Button is a custom button widget (this import might become unused after removing the button)
// import 'package:gold/widgets/button.dart'; // Removed as the custom Button widget is no longer used

// Assuming you have an EditDataScreen widget for editing
// import 'package:gold/screens/editDataScreen.dart'; // Uncomment and replace with your actual import


class DataScreen extends StatefulWidget {
  // Constructor requiring id and currentGoldPrice
  DataScreen({super.key, required this.id, required this.currentGoldPrice});

  final int id;
  final double currentGoldPrice;

  @override
  State<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  // Index for the currently displayed image
  int _currentImageIndex = 0;

  // Function to handle data deletion
  void _deleteData(int id) {
    // TODO: Implement actual deletion logic using Datarepository
    print("Deleting data with ID: ${widget.id}");
    Datarepository.delete(id);
    // Example: Datarepository.deleteData(widget.id);

    // After deletion, navigate back
    Navigator.pop(context);
  }

  // Function to handle data editing
  void _editData() {
    print("Attempting to edit data with ID: ${widget.id}");
    // TODO: Implement navigation to an edit screen or show an edit form
    // Example of navigating to a new screen:
    /*
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditDataScreen(id: widget.id), // Replace EditDataScreen with your actual edit screen widget
      ),
    ).then((result) {
      // Optional: If the edit screen returns a result (e.g., true if saved),
      // you might want to refresh the data on this screen.
      if (result != null && result == true) {
        // TODO: Implement data refresh if needed
        print("Data potentially updated, consider refreshing.");
      }
    });
    */

    // For now, we'll keep the SnackBar as a fallback if navigation is not implemented
     ScaffoldMessenger.of(context).showSnackBar(
       const SnackBar(
         content: Text('Navigate to edit screen functionality needs implementation.'),
         duration: Duration(seconds: 2),
       ),
     );
  }

  // Helper function to format currency
  String _formatCurrency(double amount) {
    final format = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0); // Indian Rupees, 0 decimal places
    return format.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    // Fetch the gold data using the provided id
    final Golddata data = Datarepository.getData(widget.id);

    // Calculate current value and percentage change
    final double currentValue = widget.currentGoldPrice * data.weight;
    final double purchasePrice = data.price.toDouble();
    final double priceChange = currentValue - purchasePrice;
    final double percentageChange = purchasePrice != 0 ? (priceChange / purchasePrice) * 100 : 0;

    // Determine color and icon for percentage change
    Color changeColor = Colors.black87;
    IconData changeIcon = Icons.remove; // Default or no change
    if (percentageChange > 0) {
      changeColor = Colors.green;
      changeIcon = Icons.arrow_upward;
    } else if (percentageChange < 0) {
      changeColor = Colors.red;
      changeIcon = Icons.arrow_downward;
    }


    // Combine photo and bill images into a single list for swiping
    List<Uint8List> images = [];
    images.addAll(data.photo);
    images.addAll(data.bill);

    // Use DeviceSize to initialize if needed (assuming it's done elsewhere,
    // but good practice to ensure it's ready before using)
    // Devicesize.init(context); // Uncomment if Devicesize needs context for initialization

    return Scaffold(
      appBar: AppBar(
        title: const Text("Asset Data"), // Use const for static text
        centerTitle: true, // Center the app bar title
        actions: [
          // Edit Button in AppBar
          IconButton(
            icon: const Icon(Icons.edit), // Edit icon
            tooltip: 'Edit Asset', // Tooltip for accessibility
            onPressed: _editData, // Call the edit function
          ),
          // Delete Button in AppBar
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Delete Asset', // Tooltip for accessibility
            onPressed: () {
              // Show a confirmation dialog before deleting
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Confirm Delete"),
                    content: const Text("Are you sure you want to delete this asset?"),
                    actions: <Widget>[
                      TextButton(
                        child: const Text("Cancel"),
                        onPressed: () {
                          Navigator.of(context).pop(); // Dismiss the dialog
                        },
                      ),
                      TextButton(
                        child: const Text("Delete"),
                        onPressed: () {
                          Navigator.of(context).pop(); // Dismiss the dialog
                          _deleteData(widget.id); // Call the delete function

                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: SafeArea( // Use SafeArea to avoid notches and system overlays
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Consistent horizontal padding
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Align children to the start
              children: [
                // Image Gallery with Horizontal Swiping
                GestureDetector(
                  onHorizontalDragEnd: (details) {
                    // Swipe left
                    if (details.primaryVelocity! < 0) {
                      if (_currentImageIndex < images.length - 1) {
                        setState(() {
                          _currentImageIndex++;
                          print("Current image index: $_currentImageIndex");
                        });
                      }
                    }
                    // Swipe right
                    if (details.primaryVelocity! > 0) {
                      if (_currentImageIndex > 0) {
                        setState(() {
                          _currentImageIndex--;
                          print("Current image index: $_currentImageIndex");
                        });
                      }
                    }
                  },
                  child: Container(
                    height: Devicesize.height != null ? Devicesize.height! / 4 : 200, // Use null check and provide a fallback height
                    width: double.infinity, // Make container take full width
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 235, 228, 228), // Background color
                      borderRadius: BorderRadius.circular(12), // Slightly smaller rounded corners
                      image: images.isNotEmpty // Check if images list is not empty
                          ? DecorationImage(
                              image: Image.memory(images[_currentImageIndex]).image,
                              fit: BoxFit.cover, // Cover the container area
                            )
                          : null, // No image if list is empty
                    ),
                    alignment: Alignment.center, // Center content if no image
                    child: images.isEmpty // Display text if no images are available
                        ? const Text("No images available")
                        : null,
                  ),
                ),
                const SizedBox(height: 16), // Add vertical space after the image

                // Asset Name
                Text(
                  data.name,
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900), // Slightly adjusted font size
                ),
                const SizedBox(height: 8), // Reduced space after asset name

                // Asset Type, Metal, and Purity Tags
                Row(
                  children: [
                    if (data.type.isNotEmpty) // Only show if type is not empty
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0), // Space after the chip
                        child: Chip(
                          label: Text(data.type),
                          backgroundColor: Colors.deepPurple[200], // Purple background
                          labelStyle: const TextStyle(color: Colors.black87), // Text color
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0), // Padding inside chip
                        ),
                      ),
                    if (data.metal.isNotEmpty) // Only show if metal is not empty
                      Padding(
                         padding: const EdgeInsets.only(right: 8.0), // Space after the chip
                        child: Chip(
                          label: Text(data.metal),
                          backgroundColor: Colors.amber[200], // Golden background
                           labelStyle: const TextStyle(color: Colors.black87), // Text color
                           padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0), // Padding inside chip
                        ),
                      ),
                    if (data.purity.isNotEmpty) // Only show if purity is not empty
                      Chip(
                        label: Text(data.purity),
                        backgroundColor: Colors.tealAccent[100], // Teal background
                         labelStyle: const TextStyle(color: Colors.black87), // Text color
                         padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0), // Padding inside chip
                      ),
                  ],
                ),
                const SizedBox(height: 16), // Add vertical space before the next card

                // Purchase Price and Current Value Card (Updated)
                Card(
                  elevation: 2.0, // Add a subtle shadow
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), // Rounded corners for the card
                  color: Colors.white, // Applied white background
                  child: Padding(
                    padding: const EdgeInsets.all(16.0), // Increased padding inside the card
                    child: Row(
                      children: [
                        // Purchase Price Section
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start, // Align text to the start
                            children: [
                              const Text(
                                "Purchase Price",
                                style: TextStyle(fontSize: 16, color: Colors.grey), // Smaller font and grey color for label
                              ),
                              const SizedBox(height: 4), // Small space
                              Text(
                                _formatCurrency(purchasePrice), // Format purchase price
                                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.black87), // Larger and bolder value
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 60, // Adjusted height for the divider
                          child: VerticalDivider(thickness: 1), // Vertical divider
                        ),
                        // Current Value Section
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start, // Align text to the start
                            children: [
                              const Text(
                                "Current Value",
                                style: TextStyle(fontSize: 16, color: Colors.grey), // Smaller font and grey color for label
                              ),
                              const SizedBox(height: 4), // Small space
                              Text(
                                _formatCurrency(currentValue), // Format current value
                                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.black87), // Larger and bolder value
                              ),
                              const SizedBox(height: 4), // Small space
                              Row(
                                children: [
                                  Icon(
                                    changeIcon,
                                    color: changeColor,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "${percentageChange.toStringAsFixed(1)}%", // Display percentage change
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: changeColor,
                                      fontWeight: FontWeight.w500,
                                    ),
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
                const SizedBox(height: 16), // Add vertical space

                // Purchase Details Card (Updated)
                Card(
                   elevation: 2.0, // Add a subtle shadow
                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), // Rounded corners for the card
                   color: Colors.white, // Applied white background
                  child: Padding(
                    padding: const EdgeInsets.all(16.0), // Increased padding inside the card
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // Align content to the start
                      children: [
                        const Text(
                          "Purchase Details",
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold), // Slightly smaller font for section title
                        ),
                        const SizedBox(height: 16), // Space after title

                        // Helper function to build detail rows with icons
                        _buildDetailRowWithIcon(Icons.calendar_today, "Purchase Date", data.date.toString().split(' ')[0]),
                        _buildDetailRowWithIcon(Icons.person_outline, "Jeweller", data.billingName),
                        _buildDetailRowWithIcon(Icons.scale_outlined, "Weight", "${data.weight} grams"), // Added grams unit
                        _buildDetailRowWithIcon(Icons.attach_money, "Wastage", "${data.wastage}%"), // Added % unit
                        _buildDetailRowWithIcon(Icons.watch_later_outlined, "Age", "${data.yearsOld} years old"), // Added years old
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16), // Add vertical space

                // Purchase Breakdown Card (Updated)
                Card(
                   elevation: 2.0, // Add a subtle shadow
                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), // Rounded corners for the card
                   color: Colors.white, // Applied white background
                  child: Padding(
                    padding: const EdgeInsets.all(16.0), // Increased padding inside the card
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // Align content to the start
                      children: [
                        const Text(
                          "Price Breakdown", // Changed title to Price Breakdown
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold), // Section title
                        ),
                        const SizedBox(height: 16), // Space after title

                        Card(
                          color: Colors.white, // Applied white background to inner card
                          elevation: 0, // No shadow for inner card
                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), // Rounded corners
                          child: Padding(
                            padding: const EdgeInsets.all(12.0), // Padding inside the inner card
                            child: Column(
                              children: [
                                _buildBreakdownRow("Base Price", data.price.toDouble()), // Pass double for formatting
                                _buildBreakdownRow("Tax", data.tax.toDouble()), // Pass double for formatting
                                _buildBreakdownRow("Other Charges", double.tryParse(data.others) ?? 0.0), // Handle potential non-numeric 'others'
                                const Divider(height: 20, thickness: 1), // Divider
                                _buildBreakdownRow("Total", data.price.toDouble(), isTotal: true), // Pass double and highlight total
                                // TODO: Add other breakdown details if needed
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Removed the Edit Details Button
                // const SizedBox(height: 24), // Removed space before the button
                // Center(
                //   child: Button(
                //     text: "Edit Details",
                //     function: _editData,
                //   ),
                // ),
                 const SizedBox(height: 16), // Add space at the bottom
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper widget to build a single detail row with an icon
  Widget _buildDetailRowWithIcon(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0), // Increased vertical padding for each row
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Align items to the start vertically
        children: [
          // Icon on the left
          Icon(
            icon,
            color: Colors.grey[600], // Icon color
            size: 24,
          ),
          const SizedBox(width: 16), // Space between icon and text

          // Label and Value column
          Expanded( // Allow text to take available space
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Align text to the start
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 16, color: Colors.grey), // Label style
                ),
                const SizedBox(height: 2), // Small space between label and value
                Text(
                  value,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black87), // Value style
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  // Helper widget to build a single breakdown row (Updated)
  Widget _buildBreakdownRow(String label, double value, {bool isTotal = false}) {
     // Handle potential non-numeric 'others' by providing a default of 0.0
    double numericValue = value;


    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0), // Vertical padding
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space out label and value
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal, // Bold for total
              color: isTotal ? Colors.black : Colors.black87, // Darker color for total
            ),
          ),
          Text(
            _formatCurrency(numericValue), // Format the numeric value
            style: TextStyle(
              fontSize: 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal, // Bold for total
              color: isTotal ? Colors.black : Colors.black87, // Darker color for total
            ),
          ),
        ],
      ),
    );
  }
}
