import React, {Component} from 'react'
import {BrowserRouter as Router, Routes, Route, useNavigate, useLocation} from 'react-router-dom'
// import { use } from 'react-router';

function TodoApp() {
    const navigate = useLocation();
    return (
        <div>
            <Router>
                <Routes>
                    <Route path="" element={<LoginComponent navigate = {navigate}/>}/>
                    <Route path="/welcome" element={<WelcomeComponent />}/>
                </Routes>
            </Router>
            
        </div>
    )
}

// class TodoApp extends Component {

//     render() {
//         return (
//             <div>
//                 <Router>
//                     <Routes>
//                         <Route path="" element={<LoginComponent />}/>
//                         <Route path="/welcome" element={<WelcomeComponent />}/>
//                     </Routes>
//                 </Router>
                
//             </div>
//         )

//     }
// }

class WelcomeComponent extends Component {
    render() {
        return(
            <div>
                Welcome Component
            </div>
        ) 
    }
}

class LoginComponent extends Component {

    constructor(props) {
        super(props);
        this.state = {
            username: "pabby",
            password: "",
            isLoginSuccessful: false,
            showFailedmessage: false
        }
    this.handleChange = this.handleChange.bind(this)
    this.loginClicekd = this.loginClicekd.bind(this)
    // let history = useNavigate()
    }

    render() {
        return (
            <div>
                <LoginStatus hasLoginFailed={this.state.isLoginSuccessful} showFailedmessag={this.state.showFailedmessage}/>
                User Name: <input type="text" name="username" value={this.state.username} onChange={this.handleChange}/>
                Password: <input type="password" name="password" value={this.state.password} onChange={this.handleChange}/>
                <button onClick={this.loginClicekd}> Login </button>
            </div>  
        )
    }

    loginClicekd() {
        if (this.state.username === "pabby" && this.state.password==="a") {
            console.log(this)
            this.props.navigate("/welcome")
            
            // this.setState({
            //     isLoginSuccessful: true,
            //     showFailedmessage: true
            // })
        }
        else {
            this.setState({
                isLoginSuccessful: false,
                showFailedmessage: true
            })
        }
    }

    handleChange(event) {
        this.setState({
            [event.target.name]: event.target.value
        }) 
    }

}

function LoginStatus(props) {
    if (props.showFailedmessag) {
        if (props.hasLoginFailed) {
            return <div>Login Successful</div>
        }else{
            return <div>Login Failed</div>
        }
    }
    return null
}

export default TodoApp;