var casper = require('casper').create();

casper.start();
casper.viewport(1200, 860);
casper.userAgent('Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_3) AppleWebKit/604.5.6 (KHTML, like Gecko) Version/11.0.3 Safari/604.5.6');

casper.thenOpen('http://PUBLIC_IP/', function() {
  this.echo(this.getTitle());
});

casper.thenOpen('http://PUBLIC_IP/detail.html?id=819e1fbf-8b7e-4f6d-811f-693534916a8b', function() {
  this.echo(this.getTitle());
});

casper.run();