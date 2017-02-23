import React, { Component, PropTypes } from 'react';
import { connect } from 'react-redux';
import { IndexLink } from 'react-router';

@connect(state => ({}))
export default class OauthBox extends Component {
  static propTypes = {
    oauthRef: PropTypes.string.isRequired,
    handleClick: PropTypes.func.isRequired
  }

  render() {
    const { oauthRef, handleClick } = this.props;
    const styles = require('./OauthBox.scss');
    return (
        <div className={styles.oauthBox[oauthRef]}>
          <button className="btn btn-primary" onClick={handleClick}>
            <i className="fa fa-sign-in"/>{' '}Login Via Facebook
          </button>
        </div>
    );
  }
}
