import React, { useEffect, useState } from "react";
import { ethers } from "ethers";
import { contractAddress, contractABI } from "./config";

function App() {
  const [donations, setDonations] = useState([]);
  const [feedback, setFeedback] = useState("");
  const [recipientFeedback, setRecipientFeedback] = useState({});

  useEffect(() => {
    const fetchDonations = async () => {
      const provider = new ethers.providers.Web3Provider(window.ethereum);
      const contract = new ethers.Contract(contractAddress, contractABI, provider);
      const donationsArray = await contract.getAllDonations();
      
      const formattedDonations = donationsArray.map((donation) => ({
        donor: donation.donor,
        recipient: donation.beneficiary,
        amount: ethers.utils.formatEther(donation.amount),
        timestamp: new Date(donation.timestamp * 1000).toLocaleString()
      }));
      
      setDonations(formattedDonations);
    };
    
    fetchDonations();
  }, []);

  const addFeedback = async (recipient, feedback) => {
    setRecipientFeedback((prev) => ({ ...prev, [recipient]: feedback }));
  };

  return (
    <div>
      <h1>Donation Records</h1>
      <table>
        <thead>
          <tr>
            <th>Donor</th>
            <th>Recipient</th>
            <th>Amount (ETH)</th>
            <th>Timestamp</th>
            <th>Feedback</th>
          </tr>
        </thead>
        <tbody>
          {donations.map((donation, index) => (
            <tr key={index}>
              <td>{donation.donor}</td>
              <td>{donation.recipient}</td>
              <td>{donation.amount}</td>
              <td>{donation.timestamp}</td>
              <td>
                <input
                  type="text"
                  placeholder="Add feedback"
                  onChange={(e) => setFeedback(e.target.value)}
                />
                <button onClick={() => addFeedback(donation.recipient, feedback)}>
                  Submit
                </button>
                <p>{recipientFeedback[donation.recipient]}</p>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}

export default App;
