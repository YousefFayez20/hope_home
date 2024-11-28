import 'command.dart';
import '../managers/donation_manager.dart';

class AddDonationCommand implements Command {
  final DonationManager donationManager;
  final String donorName;
  final double amount;
  final String donationType;

  AddDonationCommand(this.donationManager, this.donorName, this.amount, this.donationType);

  @override
  Future<void> execute() async {
    await donationManager.addDonation(donorName, amount, donationType);
  }

  @override
  void undo() {
    print("Undo not implemented for AddDonationCommand.");
  }
  Future<double> calculateTotalDonations() async {
    final List<Map<String, dynamic>> donations = await donationManager.databaseHelper.getDonations();
    final double total = donations.fold(0.0, (total, donation) {
      final double amount = (donation['amount'] as num).toDouble();
      return total + amount;
    });

    return total;
  }
}

class DeleteDonationCommand implements Command {
  final DonationManager donationManager;
  final int donationId;
  Map<String, dynamic>? deletedDonation;

  DeleteDonationCommand(this.donationManager, this.donationId);

  @override
  Future<void> execute() async {
    deletedDonation = await donationManager.getDonationById(donationId);
    if (deletedDonation != null) {
      await donationManager.deleteDonation(donationId);
    }
  }

  @override
  Future<void> undo() async {
    if (deletedDonation != null) {
      await donationManager.addDonation(
        deletedDonation!['donorName'],
        deletedDonation!['amount'],
        deletedDonation!['donationType'],
      );
    }
  }
}

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
    previousDonation = await donationManager.getDonationById(donationId);
    if (previousDonation != null) {
      await donationManager.updateDonation(
        donationId,
        newDonorName,
        newAmount,
        newDonationType,
      );
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
    }
  }
}
