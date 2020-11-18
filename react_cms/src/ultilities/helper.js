import Settings from 'settings';

const getBaseUrl = () => {
  let path = Settings.BASE_URL;
  return path;
};

exports.getBaseUrl=getBaseUrl;
