package  
{
	/**
	 * Classe utilisée par l'application elle-même
	 */
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	// Imports pour le jeu :
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	
	public class Keyboard_Hero extends MovieClip
	{
		// Différentes pages ecran du jeu.1 acceuil, 2 jeu, 3 Game Over
		private var _accueil:MovieClip;
		private var _jeu:MovieClip;
		private var _pointage:MovieClip;
		private var _zone:MovieClip;
		private var _recepteur:MovieClip;
		private var _up:MovieClip;
		private var _down:MovieClip;
		private var _left:MovieClip;
		private var _right:MovieClip;
		
		
		//Variables utilisés pour le fonctionnement du jeu
		private var _difficulte:String;
		private var _musicFacile:Sound;
		private var _musicMoyen:Sound;
		private var _musicDifficile:Sound;
		private var _channel:SoundChannel;
		private var _initialUp:int;
		private var _initialDown:int;
		private var _initialLeft:int;
		private var _initialRight:int;
		private var _score:int;
		private var _timer:Timer;
		
		
		
		public function Keyboard_Hero() :void
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
				
		
		private function init(e:Event = null):void 
		{
			//destruction de l'écouteur d'ajout à la scène
			removeEventListener(Event.ADDED_TO_STAGE, init);
			//ajouter a l'affichage
		
			_accueil = new AccueilMC();
			_accueil.btnFacile.addEventListener(MouseEvent.CLICK, jeuEnFacile);
			_accueil.btnMoyen.addEventListener(MouseEvent.CLICK, jeuEnMoyen);
			_accueil.btnDifficile.addEventListener(MouseEvent.CLICK,jeuEnDifficile );
			
			addChild(_accueil);
			
		}
		
		private function jeuEnFacile(e:MouseEvent){
			_difficulte ="facile";
			_accueil.btnFacile.removeEventListener(MouseEvent.CLICK, jeuEnFacile);
			onStartGame();
		}
		
		private function jeuEnMoyen(e:MouseEvent){
			_difficulte ="moyen";
			_accueil.btnMoyen.removeEventListener(MouseEvent.CLICK, jeuEnMoyen);
			onStartGame();
		}
		
		private function jeuEnDifficile(e:MouseEvent){
			_difficulte ="difficile";
			_accueil.btnDifficile.removeEventListener(MouseEvent.CLICK,jeuEnDifficile );
			onStartGame();
		}
		
		
		
		// Quand on clic sur jouer, cette fonction est appellé.
		// Elle appelle la fonction startGame, qui contient la mécanique de jeu.
		private function onStartGame():void 
		{
			//enlever l'accueil de l'affichage si elle est présente
			if (contains(_accueil)){
				removeChild(_accueil);
			}
			
			//creation de la page jeu si elle n'existe pas deja
			if (_jeu == null){
				_jeu = new JeuMC();
			}
			
			//ajout du jeu a l'affichage
			addChild(_jeu);
			startGame();
		}
		
		
		public function startGame():void 
		{	
			// Permet de ne pas devoir cliquer sur le jeu pour utiliser les touches
			stage.focus=stage;
			_score=0;
			
			if(_difficulte=="facile"){
				_musicFacile = new musicFacile();
				_channel = _musicFacile.play(1,0);
				_channel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
			}
			
			//if(_difficulte=="moyen"){
			//	_musicMoyen = new musicMoyen();
			//	_channel = _musicMoyen.play(1,0);
			//	_channel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
			//}
			
			if(_difficulte=="difficile"){
				_musicDifficile = new musicDifficile();
				_channel = _musicDifficile.play(1,0);
				_channel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
			}
			
			
			if (_zone == null){
				_zone = new zoneMC();
			}
			
			//ajout du jeu a l'affichage
			addChild(_zone);
			
			if (_recepteur == null){
				_recepteur = new RecepteurMC();
			}
			
			//ajout du jeu a l'affichage
			addChild(_recepteur);
			
			
			// Ecouteur de clavier et apelle de multiples fonction a chaque frame.
			stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDownListener);
			_jeu.addEventListener(Event.ENTER_FRAME,gameloop);
			
		}
		
		
		// Fonction apellé à chaque frame.
		// Elle crée une fleche à la première frame 
		// Le déplace ensuite vers le bas celon la difficulté facile.
		// Si la fleche disparait, elle se recrée en haut de l'écran.
		private function gameloop(e:Event){
			
				if (_up == null){
				_up = new UpMC();
				addChild(_up);
				_initialUp = 0;
				_up.y = _initialUp
				
				}
				
				if (_down == null){
				_down = new DownMC();
				addChild(_down);
				_initialDown = 0;
				_down.y = _initialDown
				}
				
				if (_left == null){
				_left = new LeftMC();
				addChild(_left);
				_initialLeft = 0;
				_left.y = _initialLeft
				}
				
				if (_right == null){
				_right = new RightMC();
				addChild(_right);
				_initialRight = 0;
				_right.y = _initialRight
				}
				
				if(_difficulte=="facile"){
					_up.y = _up.y + random(1,15);
					_down.y = _down.y + random(1,15);
					_left.y = _left.y + random(1,15);
					_right.y = _right.y + random(1,15);
				}
				
				
				if(_difficulte=="moyen"){
					_up.y = _up.y + random(1,20);
					_down.y = _down.y + random(1,30);
					_left.y = _left.y + random(1,30);
					_right.y = _right.y + random(1,30);
				}
				
				if(_difficulte=="difficile"){
					_up.y = _up.y + random(1,45);
					_down.y = _down.y + random(1,45);
					_left.y = _left.y + random(1,45);
					_right.y = _right.y + random(1,45);
				}
				
				detectcolision();
				_jeu.txtScore.text=_score;
			}
			
			function random(min:Number, max:Number):Number {
						return Math.random()*(max-min)+min;
			}
		
			private function detectcolision(){
				if(_up.hitTestObject(_recepteur)) {
						removeChild(_up);
						_up= null;
					}	
					
				if(_down.hitTestObject(_recepteur)) {
						removeChild(_down);
						_down= null;
					}
					
				if(_left.hitTestObject(_recepteur)) {
						removeChild(_left);
						_left= null;
					}
					
				if(_right.hitTestObject(_recepteur)) {
						removeChild(_right);
						_right= null;
					}
			}
		
			
			private function keyDownListener(e:KeyboardEvent):void{

					if (e.keyCode == Keyboard.DOWN) {
						if(_down.hitTestObject(_zone)) {
						removeChild(_down);
						_down= null;
						_score ++;
						} else {
							_score --;
						}
					}
					
					if (e.keyCode == Keyboard.UP) {
						if(_up.hitTestObject(_zone)) {
						removeChild(_up);
						_up= null;
						_score ++;
						} else {
							_score --;
						}
					}
					
					if (e.keyCode == Keyboard.LEFT) {
						if(_left.hitTestObject(_zone)) {
						removeChild(_left);
						_left= null;
						_score ++;
						} else {
							_score --;
						}
					}
					
					if (e.keyCode == Keyboard.RIGHT) {
						if(_right.hitTestObject(_zone)) {
						removeChild(_right);
						_right= null;
						_score ++;
						}else {
							_score --;
						}
					}

		}
		
		private function onSoundComplete(e:Event){
			if (_jeu != null){
				
				_jeu.removeEventListener(Event.ENTER_FRAME,gameloop);
				stage.removeEventListener(KeyboardEvent.KEY_DOWN,keyDownListener);
				_channel.removeEventListener(Event.SOUND_COMPLETE, onSoundComplete)
				
				if(_up !=null){
					removeChild(_up);
					_up = null;
				}
				
				if(_down !=null){
					removeChild(_down);
					_down = null;
				}
				
				if(_left !=null){
					removeChild(_left);
					_left = null;
					
				}
				
				if(_right !=null){
					removeChild(_right);
					_right = null;
					
				}
				
				if(_zone !=null){
					removeChild(_zone);
				}
				
				if(_recepteur !=null){
					removeChild(_recepteur);
				}
				
				removeChild(_jeu);
				
				_pointage = new PointageMC;
				addChild(_pointage);
			}
			
			_pointage.txtPointage.text=_score;
			gameOver();
		}
					
		// Fonction qui affiche le game over. Détruit des varibles et affiche le score.			
		public function gameOver():void  
		{
			_pointage.btnReJouer.addEventListener(MouseEvent.CLICK,restartGame);
		}
		
		public function restartGame(e:MouseEvent){
			_pointage.btnReJouer.removeEventListener(MouseEvent.CLICK,restartGame);
			removeChild(_pointage);
			init();
		}
	}
}