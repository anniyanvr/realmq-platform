const account = require('./account');
const auth = require('./auth');
const authList = require('./auth-list');
const channel = require('./channel');
const channelList = require('./channel-list');
const realm = require('./realm');
const realmList = require('./realm-list');
const subscription = require('./subscription');
const subscriptionList = require('./subscription-list');
const user = require('./user');
const userList = require('./user-list');

/**
 * @class AdminApiV1Mappers
 */
module.exports = {
  account,
  auth,
  authList,
  channel,
  channelList,
  realm,
  realmList,
  subscription,
  subscriptionList,
  user,
  userList,
};
