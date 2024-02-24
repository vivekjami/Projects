import React, { useState, useEffect } from 'react';
import { Projects_backend } from 'declarations/Projects_backend';

function App() {
  const [greeting, setGreeting] = useState('');
  const [weather, setWeather] = useState(null);
  const [location, setLocation] = useState('London'); // default location

  useEffect(() => {
    fetch(`http://api.openweathermap.org/data/2.5/weather?q=${location}&appid=c75ba923f1f8e9130caee26bbfbbebca`)
      .then(response => response.json())
      .then(data => setWeather(data));
  }, [location]);

  const handleLocationChange = (event) => {
    setLocation(event.target.value);
  }

  function handleSubmit(event) {
    event.preventDefault();
    const name = event.target.elements.name.value;
    Projects_backend.greet(name).then((greeting) => {
      setGreeting(greeting);
    });
    return false;
  }

  return (
    <main>
      <img src="/logo2.svg" alt="DFINITY logo" />
      <br />
      <br />

      <form action="#" onSubmit={handleSubmit}>
      <label htmlFor="name">Enter your name: &nbsp;</label>
        <input id="name" alt="Name" type="text" />
        <br />
        <br />
        <label htmlFor="location">Enter location: &nbsp;</label>
        <input id="location" alt="Location" type="text" onChange={handleLocationChange} value={location} />
        <button type="submit">Click Me!</button>
      </form>
      <section id="greeting">{greeting}</section>
      <section id="weather">
        {weather && (
          <div>
            <h2>Weather in {weather.name}</h2>
            <p>{weather.weather[0].description}</p>
            <p>Temperature: {weather.main.temp}°K</p>
          </div>
        )}
        {/* though location is correct i don't know what is the problem here :(   */}
      </section>
    </main>
  );
}

export default App;
