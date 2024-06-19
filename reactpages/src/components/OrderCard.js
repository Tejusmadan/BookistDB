// OrderCard.js
import React from 'react';
import './OrderCard.css'; // Import the CSS file

const OrderCard = ({ order }) => {
  return (
    <div className="order-group">
      <h2>Order ID: {order.orders[0].order_id}</h2>
      <p>Placed on: {order.date_placed}</p>
      <div className="order-items">
        <h3>Items Ordered:</h3>
        <ul className="order-item-list">
          {order.orders.map((book, index) => (
            <li key={index}>
              {book.quantity} x {book.book_id} 
            </li>
          ))}
        </ul>
      </div>
    </div>
  );
};

export default OrderCard;
