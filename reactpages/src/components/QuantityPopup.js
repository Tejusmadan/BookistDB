import React, { useState } from 'react';
import './QuantityPopup.css';

const QuantityPopup = ({ onClose, onGo }) => {
  const [quantity, setQuantity] = useState(1);

  const handleGo = () => {
    onGo(quantity);
    onClose();
  };

  return (
    <div className="popup-container" onClick={onClose}>
      <div className="popup" onClick={(e) => e.stopPropagation()}>
        <h3>Enter Quantity</h3>
        <input type="number" value={quantity} onChange={(e) => setQuantity(e.target.value)} />
        <button className="go-button" onClick={handleGo}>Go</button>
      </div>
    </div>
  );
};

export default QuantityPopup;
