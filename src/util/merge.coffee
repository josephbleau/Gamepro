_ = require 'lodash'

module.exports = (dest, objs) ->
  _.forEach objs, (obj) -> _.merge dest, obj
  return dest
