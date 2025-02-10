const args = process.argv.slice(2);

if (args.length === 0) {
  console.error("Usage: node cartesi-backdor.js <string>");
  process.exit(1);
}

const inputString = args.join(" "); // Join arguments in case of spaces
const escapedString = encodeURIComponent(inputString);

console.log(`curl http://localhost:8080/inspect/${escapedString}`);
