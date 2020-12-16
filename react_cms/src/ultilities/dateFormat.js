const getDateString = (date) => {
  let dateString = date.getFullYear() + '-' + (date.getMonth() + 1) + '-' + date.getDate();
  console.log(dateString)
  return dateString;
};

exports.getDateString=getDateString;
