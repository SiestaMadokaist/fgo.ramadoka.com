import React, { Component, PropTypes } from 'react';
import { connect } from 'react-redux';
import Helmet from 'react-helmet';
import * as authActions from 'redux/modules/auth';

const STATE = {
  CHANGE_PASSWORD: 0,
  ENTER_CONFIRMATION: 1
};

export default class ChangePassword extends Component {

  state = {
    uiView: STATE.CHANGE_PASSWORD
  };

  render() {
    const styles = require('./ChangePassword.scss');
    if (this.state.uiView === STATE.CHANGE_PASSWORD) {
      return (
        <div className={styles.changePassword}>
          <input type="password" ref="password" placeholder="Enter Your new Password Here" className="form-control"/>
          <input type="password" ref="confirmation-password" placeholder="Re-Enter your password" className="form-control"/>
          <input type="button" ref="submit-button" value="Save" className="fcontrol"/>
        </div>
      );
    } else {
      return (
        <div>
          <input type="text" ref="validation-id" className="form-control"/>
        </div>
      );
    }
  }
}
