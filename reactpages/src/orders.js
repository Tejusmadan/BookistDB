// Orders.js
import React, { useState, useEffect } from 'react';
import OrderCard from './components/OrderCard';
import Navbar from './components/Navbar';

function Orders() {
  // State to store the fetched data
  const [data, setData] = useState(null);
  // State to track loading status
  const [isLoading, setIsLoading] = useState(false);
  // State to track errors
  const [error, setError] = useState(null);

  // Function to fetch data
  const fetchData = async () => {
    setIsLoading(true);
    try {
      // URL to which the GET request will be sent
      const url = 'http://localhost:5000/orderdat';
      // Making the GET request using fetch
      const response = await fetch(url, {
        method: 'GET',
        credentials: 'include' // Include cookies in the request
      });
      // Check if the response is successful
      if (!response.ok) {
        throw new Error('Network response was not ok');
      }
      // Parse the response body as JSON
      const jsonData = await response.json();
      // Update state with fetched data
      setData(jsonData);
    } catch (error) {
      // Handle any errors that occurred during the fetch
      setError(error);
    } finally {
      setIsLoading(false);
    }
  };

  // Fetch data when component mounts
  useEffect(() => {
    fetchData();
  }, []);

  // JSX to render loading state
  if (isLoading) {
    return <div>Loading...</div>;
  }

  // JSX to render error state
  if (error) {
    return <div>Error: {error.message}</div>;
  }

  // JSX to render fetched data
  return (
    <div>
      <Navbar />
      <div className="order-groups">
        {data && data.orders.reduce((acc, order) => {
          if (!acc[order.order_id]) {
            acc[order.order_id] = {
              date_placed: order.date_placed, // Store placed on date
              orders: [order]
            };
          } else {
            acc[order.order_id].orders.push(order);
          }
          return acc;
        }, []).map((group, index) => (
          <OrderCard key={index} order={group} />
        ))}
      </div>
    </div>
  );
}

export default Orders;
