import React, { Component, PropTypes } from 'react';
import { connect } from 'react-redux';
import Helmet from 'react-helmet';
import * as authActions from 'redux/modules/auth';
import { ChangePassword } from 'components';

@connect(state => ({}))
export default class Profile extends Component {
  static propTypes = {
    openPassword: PropTypes.bool
  }

  constructor(props) {
    super(props);
  }

  render() {
    const styles = require('./Profile.scss');
    // <input type="text" ref="username" placeholder="Your new Username" className="form-control"/>
    return (
      <div className={styles.profilePage}>
        <form id={styles.profileBox} onSubmit={this.handleSubmit}>
          <ChangePassword />
        </form>
      </div>
    );
  }
}
