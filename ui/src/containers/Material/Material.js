import React, { Component, PropTypes } from 'react';
import { connect } from 'react-redux';
import { IndexLink } from 'react-router';

@connect(state => ({}))
export default class Material extends Component {
  render() {
    const styles = require('./Material.scss');
    return (
      <div className={styles.material}>
        material
      </div>
    );
  }
}
