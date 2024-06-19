import logo from './logo.svg';
import './App.css';
import PostButton from './components/postButton';
import GetButton from './components/getButton';
import Frame from './components/Frame';
import Navbar from './components/Navbar';
import  SearchResultsPage from './search'
import  Orders from './orders'
import Inventory from './inventory'

// src/App.js

import React from 'react';
import { BrowserRouter as Router, Routes, Route, Link } from 'react-router-dom'; // Import BrowserRouter, Routes, and Route from react-router-dom
import About from './components/About';
import BookistHomepage from './BookistHomepage';


function Home() {
    return (
        <div>
            <BookistHomepage />
        </div>
    );
}

function App() {
    return (
        <Router>
            <Routes>
                <Route path="/" element={<Home />} />
                <Route path="/about" element={<About />} />
                <Route path="/search" element={<SearchResultsPage />} />
                <Route path="/orders" element={<Orders />} />
                <Route path="/inventory" element={<Inventory />} />

            </Routes>
        </Router>
    );
}

export default App;
