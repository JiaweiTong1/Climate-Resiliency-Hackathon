This Solidity smart contract, DisasterReliefFund, facilitates a transparent and secure system for managing donations intended for disaster relief efforts. It enables donors to contribute funds directly to approved beneficiaries, such as government bodies or verified NGOs, while ensuring accountability and tracking of donations.

Features
1. Owner Control
The contract has an owner, typically a government entity or a verified NGO, who has exclusive rights to add beneficiaries.
2. Donation Management
The contract allows users to donate funds to specific beneficiaries. Donations are recorded with details about the donor, beneficiary, amount, and timestamp.
Each donation increases the total amount received by the respective beneficiary.
3. Beneficiary Tracking
Beneficiaries are managed through a mapping that tracks their addresses, total amounts withdrawn, and total amounts received.
The owner can add new beneficiaries, enabling them to receive donations and withdraw funds.
4. Fund Withdrawal
Approved beneficiaries can withdraw their donations as needed. The contract ensures that beneficiaries can only withdraw funds they have received and have not yet withdrawn.
5. Events for Transparency
The contract emits events for major actions such as receiving donations, adding beneficiaries, and withdrawing funds. This enhances transparency and allows anyone to monitor the contract’s activities.
