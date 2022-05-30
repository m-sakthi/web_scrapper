import { useState, useEffect } from "react";
import { request } from "../utils";

const BASE_API_URL = "http://localhost:3000/api/v1";

const Product = () => {
  const [product, setProduct] = useState([]);
  const [enteredUrl, setEnteredUrl] = useState();

  useEffect(() => {
    const updateProduct = async () => {
      let response = await request(BASE_API_URL + "/products/update", "PUT", {
        products: { url: enteredUrl },
      });
  
      setProduct(response);
    };
  
    const fetchProductByUrl = async () => {
      let response = await request(
        BASE_API_URL + "/products/fetch?url=" + enteredUrl
      );
  
      if (response.error || (response && response.expired)) {
        setTimeout(updateProduct, 3000);
      }
      setProduct(response);
    };

    const id = setTimeout(fetchProductByUrl, 3000);

    return () => clearTimeout(id);
  }, [enteredUrl]);


  const urlOnChangeHandler = (event) => {
    const { value } = event.target;
    setEnteredUrl(value);
  };

  return (
    <div className="product">
      <h1>Product</h1>

      <label>Enter the Url</label> <br/>
      <input type="text" name="url" onChange={urlOnChangeHandler} /> <br/>

      <table>
        <thead>
          <tr>
            <th>Url</th>
            <th>Title</th>
            <th>Expired</th>
            <th>Price</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td>{product.url}</td>
            <td>{product.title}</td>
            <td>{product.expired}</td>
            <td>{product.price}</td>
          </tr>
        </tbody>
      </table>
    </div>
  );
};

export default Product;
