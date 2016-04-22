Crafty.c("EnemyCreator", {
  init: function() {
    Crafty.e("Delay").delay(function() {
      Crafty.e("Enemy");
    }, 2000, -1);
  }

});

Crafty.c("Enemy", {
  init: function() {
    this.addComponent("2D, Canvas, Color, Motion, Collision, Gravity");
    this.attr({x: 550, y: 150, w: 10, h: 10});
    this.color("red");
    this.gravity("Floor");
    this.velocity().x = Game.speed;
    this.checkHits("Player");
  },
  events:  {
    "HitOn": function() {
      Crafty.trigger("SlowDown", this);
      this.destroy();
    }
  }
});

Crafty.c("BackgroundCreator", {
  init: function() {
    Crafty.e("Background").place(0,0);
    Crafty.e("Background").place(500,0);
  },
  events: {
    "EnterFrame": function() {
      if (Crafty("Background").get()[0].x < -498) {
        Crafty.e("Background").place(500,0);
        Crafty("Background").get()[0].destroy();
      }
    }
  }
});

Crafty.c("Background", {
  init: function() {
    this.addComponent("2D, Canvas, Color, Motion, Image");
    this.h = 200;
    this.w = 500;
    this.z = -10;
    this.velocity().x = Game.speed;
    this.image("background.png");
  },
  place: function(x, y) {
    this.x = x;
    this.y = y;
  },
  color: function(c) {
    this.color(c);
  }
});

Crafty.c("Player", {
  init: function() {
    this.addComponent("2D, Canvas, Color, Motion, Collision, Jumper, Gravity, Twoway");
    this.attr({x: 60, y: 150, w: 20, h: 10});
    this.gravity("Floor");
    this.color("grey");
    this.jumper(200, ['UP_ARROW', 'W', 'SPACE']);
  }
});

Crafty.c("SpeedHandler", {
  init: function() {

  },
  events: {
    "SlowDown": function() {
      console.log("Slow");
      Game.speed += 10;
      Crafty("Background").get().forEach(function (bg) {
        bg.velocity().x += 10;
      });
    }
  }
});
