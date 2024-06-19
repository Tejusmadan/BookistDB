import React from 'react';
import { Link } from 'react-router-dom';

function About() {
    return (
        <div>
            <h2>About Page</h2>
            <p>This is the about page content.</p>
            <Link to="/">Go back to Home</Link> {/* Link to the root path to go back to the Home page */}
        </div>
    );
}


export default About;
