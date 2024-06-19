import React from 'react';
import './ErrorOverlay.css'; // Import the ErrorOverlay component CSS file

const ErrorOverlay = ({ error, onClose }) => {
  const handleClose = (e) => {
    // Only call onClose if the click is on the overlay (not on the popup itself)
    if (e.target === e.currentTarget) {
      onClose();
    }
  };

  return (
    <div className="overlay" onClick={handleClose}>
      <div className="popup">
        <div className="error-message">{error}</div>
      </div>
    </div>
  );
};

export default ErrorOverlay;
