import React, { useState } from 'react';
import './Frame.css';
import QuantityPopup from './QuantityPopup'; // Import the QuantityPopup component
import ErrorOverlay from './ErrorOverlay'; // Import the ErrorOverlay component

const SearchResultCard = ({ title, description, storeName, imageURL, data, price, qty }) => {
  const [showQuantityPopup, setShowQuantityPopup] = useState(false);
  const [showErrorOverlay, setShowErrorOverlay] = useState(false);
  const [error, setError] = useState(null);

  const buyAction = async (quantity) => {
    try {
      const requestData = { ...data, quantity };
      const response = await fetch('http://localhost:5000/buyhandler', {
        method: 'POST',
        credentials: 'include', // Include cookies in the request
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(requestData),
      });

      if (!response.ok) {
        throw new Error('Network response was not ok');
      }

      const responseData = await response.json();
      console.log(responseData);

      
    } catch (error) {
      console.error('There was a problem with your fetch operation:', error);
      setError("Insufficient stock error!/Managers can't buy items");
      setShowErrorOverlay(true); // Show the error overlay
      setShowQuantityPopup(false);
    }
  };

  const openQuantityPopup = () => {
    setShowQuantityPopup(true);
  };

  const closeQuantityPopup = () => {
    setShowQuantityPopup(false);
  };

  const closeErrorOverlay = () => {
    setShowErrorOverlay(false);
    setError(null); // Reset error state when closing overlay
  };

  return (
    <div className="search-result-container">
      <div className="search-result-card">
        <div className="image-container">
          <img src={imageURL} alt={title} />
        </div>
        <div className="details-container">
          <h2>{title}</h2>
          <p>{description}</p>
          <p>Store: {storeName}</p>
          <p>Price: {price}</p>
          <p>Quantity left: {qty}</p>
        </div>
        <div className="button-section">
          <button className="buy-button" onClick={openQuantityPopup}>Buy</button>
          <button className="add-to-cart-button">Add to Cart</button>
        </div>
      </div>
      {showQuantityPopup && (
        <QuantityPopup onClose={closeQuantityPopup} onGo={buyAction} />
      )}
      {showErrorOverlay && (
        <ErrorOverlay error={error} onClose={closeErrorOverlay} />
      )}
    </div>
  );
};

export default SearchResultCard;
