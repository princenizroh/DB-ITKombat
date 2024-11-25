function getExpTimestamp(seconds: number) {
  const currentTimeMillis = Date.now();
  const secondsIntoMillis = seconds * 1000;
  const expirationTimeMillis = currentTimeMillis + secondsIntoMillis;
  const expirationDate = new Date(expirationTimeMillis);
  console.log("Current Time:", new Date(currentTimeMillis).toLocaleString());
  console.log("Expiration Time:", expirationDate.toLocaleString());
  return Math.floor(expirationTimeMillis / 1000);
}

export { getExpTimestamp };
