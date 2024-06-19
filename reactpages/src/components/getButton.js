import React, { useState } from 'react';

function MyComponent() {
  // State to store the fetched data
  const [data, setData] = useState(null);
  // State to track loading status
  const [isLoading, setIsLoading] = useState(false);
  // State to track errors
  const [error, setError] = useState(null);

  // Function to fetch data
  const fetchData = async () => {
    try {
      // URL to which the GET request will be sent
      const url = 'http://localhost:5000/endpoint';
      // Making the GET request using fetch
      const response = await fetch(url);
      // Check if the response is successful
      if (!response.ok) {
        throw new Error('Network response was not ok');
      }
      // Parse the response body as JSON
      const jsonData = await response.json();
      // Update state with fetched data
      setData(jsonData);
      setIsLoading(false);
    } catch (error) {
      // Handle any errors that occurred during the fetch
      setError(error);
      setIsLoading(false);
    }
  };

  // Function to handle button click and initiate data fetching
  const handleClick = () => {
    setIsLoading(true);
    fetchData();
  };

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
      <h1>Data:</h1>
      <pre>{JSON.stringify(data, null, 2)}</pre>
      <button onClick={handleClick}>Get Request</button>
    </div>
  );
}

export default MyComponent;
