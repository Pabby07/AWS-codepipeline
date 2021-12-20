import logo from './logo.svg';
import './App.css';
import { Component } from 'react';
import Comp1 from './components/examples/comp1.js'
import Comp2 from './components/examples/comp2.js'
import Comp3 from './components/examples/comp3.js'
import Counter from './components/counter/counter.jsx'

class App extends Component {
  render () {
    return (
      <div>
        <Counter />
      </div>
    )
  }

}

class Test extends Component {
  render () {
    return (
      <div className="App">
        Hello World :)
        <Comp1 />
        <Comp2 />
        <Comp3 />
      </div>
      
    ); 
  }
}



export default App;
