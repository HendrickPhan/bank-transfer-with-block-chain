const formatNumber = (value) =>
new Intl.NumberFormat('vi-VN', {
  style: 'currency',
  currency: 'vnd'
}).format(value);

exports.formatNumber = formatNumber;