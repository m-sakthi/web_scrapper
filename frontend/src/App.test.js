import { render, screen } from '@testing-library/react';
import App from './App';

test('renders Products text', () => {
  render(<App />);
  const textElement = screen.getByText(/Products/i);
  expect(textElement).toBeInTheDocument();
});
