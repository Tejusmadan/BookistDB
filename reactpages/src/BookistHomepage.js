import React from 'react';
import './BookistHomepage.css'; // Import the CSS file
import { useNavigate } from 'react-router-dom';
import { useState } from 'react';

function BookistHomepage() {
  const navigate = useNavigate();
  const [searchQuery, setSearchQuery] = useState('');

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
  const handleLogout = async (quantity) => {
    try {
      const requestData = {"Logout":true};
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
    <div className="bookist-container">
      <img src="/bookistlogo.png" alt="Bookist Logo" className="bookist-logo" />
      <div className="bookist-search">
        <input type="text" onKeyDown={handleKeyPress} value={searchQuery} onChange={handleInputChange} className="bookist-input" placeholder="Search for books..." />
        <button className="bookist-button" onClick={handleSearch}>Search</button>
      </div>
      {/* Logout button */}
      <button className="logout-button" onClick={handleLogout}>Logout</button>
    </div>
  );
}

export default BookistHomepage;
