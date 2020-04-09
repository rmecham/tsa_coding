process.stdin.resume();
process.stdin.setEncoding('utf8');

process.stdin.on('data', function(text) {
    console.log('Hello world!')
    process.exit();
});
