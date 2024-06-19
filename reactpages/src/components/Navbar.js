import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import "./Navbar.css";

function Navbar() {
  const [data, setData] = useState(null);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState(null);
  const [searchQuery, setSearchQuery] = useState('');
  const navigate = useNavigate();

  const fetchData = async () => {
    setIsLoading(true);
    try {
      const url = 'http://localhost:5000/getsession';
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

  const handleSearch = () => {
    navigate(`/search?query=${encodeURIComponent(searchQuery)}`);
  };

  const handleInputChange = (e) => {
    setSearchQuery(e.target.value);
  };

  const handleKeyPress = (e) => {
    if (e.key === 'Enter') {
      handleSearch();
    }
  };

  const handleLogout = async () => {
    try {
      const requestData = { "Logout": true };
      const response = await fetch('http://localhost:5000/logouthandler', {
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
    }
    window.location.href = 'http://localhost:5000/login';
  };

  return (
    <nav className="navbar">
      <div className="navbar-container">
        <div className="logo">
          <a href="/">
            <img src="/bookistlogo.png" alt="Logo" />
          </a>
        </div>
        <div className="search-box">
          <input type="text" value={searchQuery} onKeyDown={handleKeyPress} onChange={handleInputChange} placeholder="Search..." />
          <button onClick={handleSearch}>Search</button>
        </div>
        <div className="links">
          {data && data.type === 'manager' ? (
            <a href="/inventory">Inventory</a>
          ) : (
            <a href="/orders">Orders</a>
          )}
          {/* Add more links as needed */}
        </div>
        <button className="logout-button" onClick={handleLogout}>Logout</button>
      </div>
    </nav>
  );
}

export default Navbar;
