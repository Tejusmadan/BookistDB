// InventoryItem.js
import React from 'react';
import './InventoryItem.css'; // Import CSS file for styling

function InventoryItem({ data }) {
  return (
    <div className="inventory-card">
      <img className="inventory-image" src='https://img.freepik.com/premium-vector/modern-flat-icon-landscape_203633-11062.jpg' alt="Item" />
      <div className="inventory-details">
        <h2 className="item-title">{data[12]} ({data[1]})</h2> {/* Title */}
        <p className="item-info">{data[13]} | {data[15]} | {data[18]} | {data[19]}</p>
        <p className="item-description">{data[16]}</p>
        <p className="item-price">Price: ${parseFloat(data[2]).toFixed(2)}</p> {/* Price */}
        <p className="item-quantity">Quantity: {data[3]}</p> {/* Quantity */}
        <p className="item-date">Date added: {data[4]}</p>
      </div>
    </div>
  );
}

export default InventoryItem;
