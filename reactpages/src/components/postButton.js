import React from 'react';

class PostButton extends React.Component {
  handleClick = async () => {
    try {
      const response = await fetch('http://localhost:5000/endpoint', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json', // Adjust content type if needed
        },
        body: JSON.stringify({"hello":"pelo"}),
      });

      if (!response.ok) {
        throw new Error('Network response was not ok');
      }

      const data = await response.json();
      console.log(data); // Handle response data as needed
    } catch (error) {
      console.error('There was a problem with your fetch operation:', error);
    }
  };

  render() {
    return (
      <button onClick={this.handleClick}>
        Post Request
      </button>
    );
  }
}

export default PostButton;