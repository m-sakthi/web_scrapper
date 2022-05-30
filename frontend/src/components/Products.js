import { useState, useEffect } from "react";
import { request, BASE_API_URL } from "../utils";

const Products = () => {
  const [products, setProducts] = useState([]);
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    fetchProducts();
  }, []);

  const fetchProducts = async () => {
    setLoading(true);
    const response = await request(BASE_API_URL + "/products");
    setProducts(response);
    setLoading(false);
  };

  if (loading)
    return <div className="loader">Loading data..!!.</div>;

  return (
    <div className="products">
      <h1>Products</h1>
      <table>
        <thead>
          <tr>
            <th>ID</th>
            <th>Url</th>
            <th>Title</th>
            <th>Price</th>
          </tr>
        </thead>
        <tbody>
          {products.map((p) => (
            <tr key={p.id}>
              <td>{p.id}</td>
              <td>{p.url}</td>
              <td>{p.title}</td>
              <td>{p.price}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
};

export default Products;
