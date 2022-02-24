import React, { Component } from 'react'
import './counter.css'

class Counter extends Component {

    constructor() {
        super()
        this.state = {
            counter : 0
        }
        this.increment = this.increment.bind(this)
        this.reset = this.reset.bind(this)
    }

    render() {
        return (
            <div className="counter">
                <CounterButtons by = {1} incrementMethod = {this.increment}/> 
                <CounterButtons by = {5} incrementMethod = {this.increment}/> 
                <CounterButtons by = {10} incrementMethod = {this.increment}/>
                <CounterButtons by = {-1} incrementMethod = {this.increment}/>
                <CounterButtons by = {-5} incrementMethod = {this.increment}/>
                <CounterButtons by = {-10} incrementMethod = {this.increment}/> 
                <span className="count"> {this.state.counter} </span>
                <div className="reset"><button onClick={this.reset}> Reset </button></div>
                    
            </div>   
        )
    }
    
    reset() {
        this.setState({counter: 0})
    }

    increment(by) {
        console.log(this.props.by)
        this.setState({
            counter: this.state.counter + by
        })
    }
}

class CounterButtons extends Component {
    

    render() {
        return(
            <div className="counter">
                <button onClick={() => {this.props.incrementMethod(this.props.by) }}> {this.props.by}  </button> 
           </div>
            )
    }
    
}

// function Counter() {
//     return (

//         <div className="counter">
//             <button> +1  </button> 
//             <span className="count"> 0 </span>
//         </div>

//     )
// }

export default Counter