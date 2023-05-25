import 'dart:async';
import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:figuras_flame/figures.dart';
import 'package:flame/sprite.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'globals.dart' as globals;
import 'Score.dart';
import 'db.dart';
import 'drag_component.dart';
import 'flower_player.dart';

class MyGame extends FlameGame with KeyboardEvents{

  

  final sizeOfPlayer = Vector2(80, 180);
  late final FlowerPlayer player;
  late final JoystickComponent joystick;
  DB db=new DB();
  double TiempoFigura=0;
  double TiempoGenerarFigura=5;
  double vel=1;
  int Puntos=0;
  int vidas=5;
  bool play=true;

  
  

  // PARA ACTIVAR EL DEBUG
  @override
  bool get debugMode => true;

  @override
  Color backgroundColor() {
    return const Color.fromARGB(255, 200, 200, 200);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }

  @override
  Future<void> onLoad() async {
    children.register<Flower>();
    children.register<TextComponent<TextRenderer>>();
    await db.score();

    final image = await images.load('joystick.png');
    final sheet = SpriteSheet.fromColumnsAndRows(
      image: image,
      columns: 6,
      rows: 1,
    );
    joystick = JoystickComponent(
      knob: SpriteComponent(
        sprite: sheet.getSpriteById(1),
        size: Vector2.all(100),
      ),
      background: SpriteComponent(
        sprite: sheet.getSpriteById(0),
        size: Vector2.all(150),
      ),
      margin: const EdgeInsets.only(left: 40, bottom: 120),
      position: Vector2(0, 0),
    );
    player = FlowerPlayer(
      position: Vector2(size.x / 2, size.y - sizeOfPlayer.y),
      paint: Paint()..color = Colors.pink,
      size: sizeOfPlayer,
      joystick: joystick,
    );
    await add(player);
    //await add(joystick);

    // await add(Flower(
    //   position: Vector2(size.x / 2, size.y - sizeOfPlayer.y),
    //   paint: Paint()..color = Colors.pink,
    //   size: sizeOfPlayer,
    // ));
    //await add(TapButton(moverDerecha)
    //  ..position = Vector2(size.x - 50, 75)
    //  ..size = Vector2(100, 100));
    //await add(TapButton(moverIzquierda)
    //  ..position = Vector2(50, 75)
    //  ..size = Vector2(100, 100));
    await add(DragComponent(moverIzquierda, moverDerecha)
      ..position = Vector2(0, size.y - 100)
      ..size = Vector2(size.x, 100));
    
    await children.add(TextComponent(
         priority: 100,
         text: Puntos.toString(),
         position: Vector2(size.x-50,60),
         size: Vector2(100, 50),
        ),);
    await children.add(TextComponent(
         priority: 100,
         text:"Best: "+globals.pointers.points.toString(),
         position: Vector2(10,60),
         size: Vector2(100, 50),
        ),);
    await children.add(TextComponent(
         priority: 100,
         text:"lives: "+vidas.toString(),
         position: Vector2(10,120),
         size: Vector2(100, 50),
        ),);
  }

  @override
  void update(double dt) {
    if (children.isNotEmpty) {
      final Flower flower = children.query<Flower>().first;
      flower.position = Vector2(flower.position.x, size.y - sizeOfPlayer.y);
    }

    if (vidas > 0) {
      TiempoFigura+=dt;
      if(TiempoFigura>TiempoGenerarFigura){

        var RanPos=Random();
        var RanTam=Random();
        var RanFig=Random();

        double Tam=(RanTam.nextDouble()/2)+.5;

        switch(RanFig.nextInt(16)){
          case 0:
            add(Pinguino(position: Vector2(RanPos.nextDouble()*(size.x-50),0), 
              size: Vector2(Tam*50,Tam*100), 
              paint: Paint()..color=Colors.blue)
            );
          break;
          case 1:
            add(Stickman(position: Vector2(RanPos.nextDouble()*(size.x-50),0), 
              size: Vector2(Tam*50,Tam*100), 
              paint: Paint()..color=Colors.orange)
            );
          break;
          case 2:
            add(Mochila(position: Vector2(RanPos.nextDouble()*(size.x-50),0), 
              size: Vector2(Tam*100,Tam*50), 
              paint: Paint()..color=Colors.brown)
            );
          break;
          case 3:
            add(Iguana(position: Vector2(RanPos.nextDouble()*(size.x-50),0), 
              size: Vector2(Tam*50,Tam*100), 
              paint: Paint()..color=Colors.green)
            );
          break;
          case 4:
            add(Caballo(position: Vector2(RanPos.nextDouble()*(size.x-50),0), 
              size: Vector2(Tam*100,Tam*50), 
              paint: Paint()..color=Colors.brown)
            );
          break;
          case 5:
            add(Caballito(position: Vector2(RanPos.nextDouble()*(size.x-50),0), 
              size: Vector2(Tam*50,Tam*100), 
              paint: Paint()..color=Colors.orange)
            );
          break;
          case 6:
            add(Ballena(position: Vector2(RanPos.nextDouble()*(size.x-50),0), 
              size: Vector2(Tam*100,Tam*50), 
              paint: Paint()..color=Colors.blue)
            );
          break;
          case 7:
            add(Proyector(position: Vector2(RanPos.nextDouble()*(size.x-50),0), 
              size: Vector2(Tam*100,Tam*50), 
              paint: Paint()..color=Colors.white)
            );
          break;
          case 8:
            add(Tractor(position: Vector2(RanPos.nextDouble()*(size.x-50),0), 
              size: Vector2(Tam*100,Tam*50), 
              paint: Paint()..color=Colors.green)
            );
          break;
          case 9:
            add(Libreta(position: Vector2(RanPos.nextDouble()*(size.x-50),0), 
              size: Vector2(Tam*50,Tam*100), 
              paint: Paint()..color=Colors.orange)
            );
          break;
          case 10:
            add(Grillo(position: Vector2(RanPos.nextDouble()*(size.x-50),0), 
              size: Vector2(Tam*50,Tam*50), 
              paint: Paint()..color=Colors.green)
            );
          break;
          case 11:
            add(Tree(position: Vector2(RanPos.nextDouble()*(size.x-50),0), 
              size: Vector2(Tam*50,Tam*100), 
              paint: Paint()..color=Colors.green)
            );
          break;
          case 12:
            add(Puerta(position: Vector2(RanPos.nextDouble()*(size.x-50),0), 
              size: Vector2(Tam*50,Tam*100), 
              paint: Paint()..color=Colors.brown)
            );
          break;
          case 13:
            add(Mouse(position: Vector2(RanPos.nextDouble()*(size.x-50),0), 
              size: Vector2(Tam*100,Tam*50), 
              paint: Paint()..color=Colors.grey)
            );
          break;
          case 14:
            add(Elefante(position: Vector2(RanPos.nextDouble()*(size.x-50),0), 
              size: Vector2(Tam*100,Tam*50), 
              paint: Paint()..color=Colors.blue)
            );
          break;
          case 15:
            add(Mexico(position: Vector2(RanPos.nextDouble()*(size.x-50),0), 
              size: Vector2(Tam*100,Tam*50), 
              paint: Paint()..color=Colors.green)
            );
          break;
        }
        TiempoFigura=0;
      }
      

      var pinguino=children.query<Pinguino>();
      moverPinguino(pinguino);

      var stickman=children.query<Stickman>();
      moverFigura(stickman);

      var mochila=children.query<Mochila>();
      moverFigura(mochila);

      var iguana=children.query<Iguana>();
      moverFigura(iguana);

      var caballo=children.query<Caballo>();
      moverFigura(caballo);

      var caballito=children.query<Caballito>();
      moverFigura(caballito);

      var ballena=children.query<Ballena>();
      moverFigura(ballena);

      var proyector=children.query<Proyector>();
      moverFigura(proyector);

      var tractor=children.query<Tractor>();
      moverFigura(tractor);

      var libreta=children.query<Libreta>();
      moverFigura(libreta);

      var grillo=children.query<Grillo>();
      moverFigura(grillo);

      var tree=children.query<Tree>();
      moverFigura(tree);

      var puerta=children.query<Puerta>();
      moverFigura(puerta);

      var mouse=children.query<Mouse>();
      moverFigura(mouse);

      var elefante=children.query<Elefante>();
      moverFigura(elefante);

      var mexico=children.query<Mexico>();
      moverFigura(mexico);


    }else if(play){
      if(Puntos>globals.pointers.points){
        children.add(TextComponent(
         priority: 100,
         text:"New Score",
         position: Vector2(10,size.y/2),
         size: Vector2(100, 50),
        ),);
      }
      db.insert(Score(id: globals.lastpoint.id+1, points: Puntos));
      play=false;
    }
    
    
    super.update(dt);
  }

  void moverIzquierda() {
    final Flower flower = children.query<Flower>().first;
    flower.position.x -= 5;
    if (flower.position.x + flower.width < 0) {
      flower.position.x = size.x;
    }
  }

  void moverDerecha() {
    final Flower flower = children.query<Flower>().first;
    flower.position.x += 5;
    if (flower.position.x > size.x) {
      flower.position.x = -flower.size.x;
    }
  }

  bool colFig(FlowerPlayer player, PositionComponent figura) {
      Rect rectPlayer = Rect.fromLTWH(
          player.position.x, player.position.y, player.size.x, player.size.y);

      Rect rectFigura = Rect.fromLTWH(
          figura.position.x, figura.position.y, figura.size.x, figura.size.y);

      return rectPlayer.overlaps(rectFigura);
    }

  void actualizarText(){
    var text = children.query<TextComponent>();
    text[0].text=Puntos.toString();
    text[1].text="Best: "+globals.pointers.points.toString();
    text[2].text="Lives: "+vidas.toString();
  }

  void aumentarDificultad(){
      vel+=.2;
      TiempoGenerarFigura*=.9;
  }

  void moverFigura(List<PositionComponent> figura){
    if(figura.isNotEmpty){
      for(int i=0;i<figura.length;i++){
        figura[i].y+=vel;

        if(colFig(player, figura[i])){
          children.remove(figura[i]);
        }else{
          if(figura[i].y>size.y){
            children.remove(figura[i]);
            vidas--;
          }
        }
        
      }
    }
  }

  void moverPinguino(List<PositionComponent> figura){
    if(figura.isNotEmpty){
      for(int i=0;i<figura.length;i++){
        figura[i].y+=vel;

        if(colFig(player, figura[i])){
          Puntos++;
          actualizarText();
          children.remove(figura[i]);
          aumentarDificultad();
        }else{
          if(figura[i].y>size.y){
            children.remove(figura[i]);
            vidas--;
          }
        }
        
      }
    }
  }
}