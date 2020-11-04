const formatNumber = (value) =>
new Intl.NumberFormat('en-IN', {
  style: 'currency',
  currency: 'vnd'
}).format(value);

exports.formatNumber = formatNumber;