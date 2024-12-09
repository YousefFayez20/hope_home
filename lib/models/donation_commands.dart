import '../data/database_helper.dart';
import '../models/command.dart';
import '../managers/donation_manager.dart';
import '../models/notification_commands.dart';
import '../managers/notification_manager.dart';

/// Command to Add a Donation
class AddDonationCommand implements Command {
  final DonationManager donationManager;
  final String donorName;
  final double amount;
  final String donationType;

  AddDonationCommand(this.donationManager, this.donorName, this.amount, this.donationType);

  @override
  Future<void> execute() async {
    await donationManager.addDonation(donorName, amount, donationType);

    // Log the action
    final logCommand = LogActionCommand(
      "Add Donation",
      "Donation added for $donorName with amount $amount.",
      NotificationManager.instance.logList,
    );
    await logCommand.execute();
  }

  @override
  Future<void> undo() async {
    print("Undo not implemented for AddDonationCommand.");
    return;
  }
}

/// Command to Delete a Donation

class DeleteDonationCommand implements Command {
  final DatabaseHelper databaseHelper;
  final int donationId;
  Map<String, dynamic>? deletedDonation;

  DeleteDonationCommand(this.databaseHelper, this.donationId);

  @override
  Future<void> execute() async {
    deletedDonation = await databaseHelper.getDonationById(donationId);

    if (deletedDonation != null) {
      await databaseHelper.deleteDonation(donationId);

      // Log the action
      final logCommand = LogActionCommand(
        "Delete Donation",
        "Donation deleted for ${deletedDonation!['donorName']}.",
        NotificationManager.instance.logList,
      );
      await logCommand.execute();
    }
    else {
      print("No donation found with ID $donationId to delete.");
    }
  }

  @override
  Future<void> undo() async {
    if (deletedDonation != null) {
      await databaseHelper.insertDonation(
        deletedDonation!['donorName'],
        deletedDonation!['amount'],
        deletedDonation!['donationType'],
      );

      print("Undo: Donation restored for ${deletedDonation!['donorName']}.");
    }
    else {
      print("Undo not possible: No deleted donation data available.");
    }
  }
}

/// Command to Update a Donation
class UpdateDonationCommand implements Command {
  final DonationManager donationManager;
  final int donationId;
  final String newDonorName;
  final double newAmount;
  final String newDonationType;

  Map<String, dynamic>? previousDonation;

  UpdateDonationCommand(
      this.donationManager,
      this.donationId,
      this.newDonorName,
      this.newAmount,
      this.newDonationType,
      );

  @override
  Future<void> execute() async {
    // Fetch the current donation details before updating
    previousDonation = await donationManager.getDonationById(donationId);

    if (previousDonation != null) {
      await donationManager.updateDonation(
        donationId,
        newDonorName,
        newAmount,
        newDonationType,
      );

      // Log the action
      final logCommand = LogActionCommand(
        "Update Donation",
        "Donation for ${previousDonation!['donorName']} updated to $newDonorName with amount $newAmount.",
        NotificationManager.instance.logList,
      );
      await logCommand.execute();
    } else {
      print("No donation found with ID $donationId to update.");
    }
  }

  @override
  Future<void> undo() async {
    if (previousDonation != null) {
      await donationManager.updateDonation(
        donationId,
        previousDonation!['donorName'],
        previousDonation!['amount'],
        previousDonation!['donationType'],
      );

      print(
          "Undo: Donation reverted to ${previousDonation!['donorName']} with amount ${previousDonation!['amount']} and type ${previousDonation!['donationType']}.");
    } else {
      print("Undo not possible: No previous donation data available.");
    }
    return;
  }
}