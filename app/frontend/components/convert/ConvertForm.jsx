import React, { useState } from 'react';

const ConvertForm = () => {
  const [file, setFile] = useState(null);

  const handleFileChange = (event) => {
    setFile(event.target.files[0]);
  };

  const handleSubmit = async (event) => {
    event.preventDefault();
    const formData = new FormData();
    formData.append('file', file);

    const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

    const response = await fetch('/documents/convert', {
      method: 'POST',
      headers: {
        'X-CSRF-Token': csrfToken,
      },
      body: formData,
    });

    if (response.ok) {
      const blob = await response.blob();
      const url = window.URL.createObjectURL(blob);
      const a = document.createElement('a');
      a.href = url;
      a.download = 'converted.pdf';
      document.body.appendChild(a);
      a.click();
      a.remove();
    } else {
      console.error('Failed to convert document.');
    }
  };

  return (
    <form onSubmit={handleSubmit}>
      <div>
        <label>File:</label>
        <input type="file" name="file" onChange={handleFileChange} />
      </div>
      <button type="submit">Convert</button>
    </form>
  );
};

export default ConvertForm;
