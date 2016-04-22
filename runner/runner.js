Game = {
  speed: -80,
  start: function() {
    Crafty.init(500, 200);
    Crafty.scene("Level 1");
  }
};


Crafty.scene("Level 1", function() {
  Crafty.e("2D, Canvas, Color, Floor")
    .attr({x: 0, y: 160, w: 600, h: 10});

  Crafty.e("EnemyCreator");
  Crafty.e("Player");
  Crafty.e("BackgroundCreator");
  Crafty.e("SpeedHandler");

});
