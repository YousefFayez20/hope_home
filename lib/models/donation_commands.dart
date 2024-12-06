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
  Future<void> undo() async {
    // Undo is not required for AddDonationCommand.
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
        (deletedDonation!['amount'] as num).toDouble(),
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

  UpdateDonationCommand(
      this.donationManager,
      this.donationId,
      this.newDonorName,
      this.newAmount,
      this.newDonationType,
      );

  @override
  Future<void> execute() async {
    await donationManager.updateDonation(
      donationId,
      newDonorName,
      newAmount,
      newDonationType,
    );
  }

  @override
  Future<void> undo() async {
    print("Undo not implemented for UpdateDonationCommand.");
  }
}
