import React, { useEffect, useState } from 'react';
import { useLocation } from 'react-router-dom';
import Navbar from './components/Navbar';
import Frame from './components/Frame';

const SearchResultsPage = () => {
  const [searchResults, setSearchResults] = useState([]);
  const [numResults, setNumResults] = useState(0);
  const location = useLocation();

  useEffect(() => {
    const searchParams = new URLSearchParams(location.search);
    const query = searchParams.get('query');
    // Fetch search results using the query parameter from the URL
    fetch(`http://localhost:5000/search?query=${query}`)
      .then(response => response.json())
      .then(data => {
        setSearchResults(data);
        setNumResults(data.length); // Update number of results
      })
      .catch(error => {
        console.error('Error fetching search results:', error);
      });
  }, [location.search]);

  
  return (
    <div style={{ textAlign: 'center' }}>
      <Navbar />
      <p style={{ color: 'gray' }}>{numResults} results found</p>
      {searchResults.map((result, index) => {
        return (
          <div key={index}>
            <Frame title={result[0]} storeName={result[14]} description={result[4]} imageURL={'https://img.freepik.com/premium-vector/modern-flat-icon-landscape_203633-11062.jpg'} data = {result} price = {result[10]} qty = {result[11]} />
            <br />
          </div>
        );
      })}
    </div>
  );
};

export default SearchResultsPage;
