import "./App.css";
import { BrowserRouter as Router, Routes, Route, Link } from "react-router-dom";
import Product from "./components/Product";
import Products from "./components/Products";

function App() {
  return (
    <div className="App">
      <Router>
        <Routes>
          <Route path="/fetch" element={<Product />} />
          <Route path="/" element={<Products />} />
        </Routes>
      </Router>
    </div>
  );
}

export default App;
