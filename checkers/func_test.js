fetch('./func_test.wasm').then(response =>
  response.arrayBuffer()
).then(bytes => WebAssembly.instantiate(bytes)).then(results => {
  console.log("Loaded WASM module");
  instance = results.instance;
  console.log("Instance", instance);

  var black = 1;
  var white = 2;
  var crowned_black = 5;
  var crowned_white = 6;

  console.log("Calling offset");
  var offset = instance.exports.offsetForPosition(3, 4);
  console.log("Offset for 3, 4 is ", offset);

  console.log("White is white", instance.exports.isWhite(white));
  console.log("Black is Black", instance.exports.isBlack(black));
  console.log("Black is not White", instance.exports.isWhite(black));
  console.log("White is not Black", instance.exports.isBlack(white));
  console.log("Uncrowned White", instance.exports.isWhite(instance.exports.withoutCrown(crowned_white)));
  console.log("Uncrowned Black", instance.exports.isBlack(instance.exports.withoutCrown(crowned_black)));
  console.log("Crowned is crowned", instance.exports.isCrowned(crowned_black));
  console.log("Uncrowned is uncrowned (b)", instance.exports.isCrowned(crowned_white));
})
