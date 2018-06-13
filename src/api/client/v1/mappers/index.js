const auth = require('./auth');
const authList = require('./auth-list');
const channel = require('./channel');
const channelList = require('./channel-list');
const subscription = require('./subscription');
const subscriptionList = require('./subscription-list');
const user = require('./user');
const userList = require('./user-list');

/**
 * @class ClientApiV1Mappers
 */
module.exports = {
  auth,
  authList,
  channel,
  channelList,
  subscription,
  subscriptionList,
  user,
  userList,
};
