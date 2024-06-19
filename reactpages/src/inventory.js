import React, { useState, useEffect } from 'react';
import InventoryItem from './components/InventoryItem'; // Import custom component for inventory item
import Navbar from './components/Navbar';
import './Inventory.css'; // Import CSS file for styling

function Inventory() {
  const [data, setData] = useState(null);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState(null);

  const fetchData = async () => {
    setIsLoading(true);
    try {
      const url = 'http://localhost:5000/inventorydat';
      const response = await fetch(url, {
        method: 'GET',
        credentials: 'include'
      });
      if (!response.ok) {
        throw new Error('Network response was not ok');
      }
      const jsonData = await response.json();
      setData(jsonData);
    } catch (error) {
      setError(error);
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    fetchData();
  }, []);

  if (isLoading) {
    return <div>Loading...</div>;
  }

  if (error) {
    return <div>Error: {error.message}</div>;
  }

  return (
    <div className="inventory-container">
      <Navbar />
      <div className="inventory-row">
        {data && data.map((item, index) => (
          <InventoryItem
            key={index}
            data={item}
          />
        ))}
        <button className="add-item-button"></button>
      </div>
    </div>
  );
}

export default Inventory;
