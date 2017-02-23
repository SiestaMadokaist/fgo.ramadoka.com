import React, {Component, PropTypes} from 'react';
import {connect} from 'react-redux';
import Helmet from 'react-helmet';
import * as authActions from 'redux/modules/auth';
import { OauthBox } from 'components';
import ApiClient from 'helpers/ApiClient.js';

@connect(
  state => ({user: state.auth.user}),
  authActions)
export default class Login extends Component {
  static propTypes = {
    user: PropTypes.object,
    login: PropTypes.func,
    logout: PropTypes.func,
    jwtLogin: PropTypes.func
  }

  handleSubmit = (event) => {
    event.preventDefault();
    const input = this.refs.username;
    this.props.login(input.value);
    input.value = '';
  }

  handleMessage = (popup) => {
    return (event) => {
      // TODO: ntar aja
      // if(event.origin !== ""){ return }
      const { data } = event;
      if (data.success) {
        popup.close();
        const loginResult = this.props.jwtLogin(data.jwt_token);
        window.lr = loginResult;
        return undefined;
      }
    };
  }

  /*
   * @params oauthService {String}
   * e.g: facebook/google/path/account-kit
   * though for now only facebook implemented
   */
  handleOauthLogin = (oauthService) => {
    return (event) => {
      event.preventDefault();
      const client = new ApiClient();
      const popupURL = client.apiUrl(`/oauth/${oauthService}/login`);
      const popup = window.open(popupURL, `fb-login`, `height=400&width=400`);
      window.addEventListener(`message`, this.handleMessage(popup), false);
    };
  }

  render() {
    const {user, logout} = this.props;
    const styles = require('./Login.scss');
    return (
      <div className={styles.loginPage + ' container'}>
        <Helmet title="Login"/>
        <h1>Login</h1>
        {!user &&
        <div>
          <OauthBox oauthRef="facebook" handleClick={this.handleOauthLogin('facebook')}/>
          <OauthBox oauthRef="facebook" handleClick={this.handleOauthLogin('facebook')}/>
          <OauthBox oauthRef="facebook" handleClick={this.handleOauthLogin('facebook')}/>
          <form className="login-form form-inline" onSubmit={this.handleSubmit}>
            <div className="form-group">
              <input type="text" ref="username" placeholder="Enter a username" className="form-control"/>
            </div>
            <button className="btn btn-success" onClick={this.handleSubmit}><i className="fa fa-sign-in"/>{' '}Log In
            </button>
          </form>
          <p>This will "log you in" as this user, storing the username in the session of the API server.</p>
        </div>
        }
        {user &&
        <div>
          <p>You are currently logged in as {user.name}.</p>

          <div>
            <button className="btn btn-danger" onClick={logout}><i className="fa fa-sign-out"/>{' '}Log Out</button>
          </div>
        </div>
        }
      </div>
    );
  }
}
