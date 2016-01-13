package com.zombotron.core
{
    import com.antkarlov.managers.*;
    import com.antkarlov.math.*;
    import flash.events.*;
    import flash.media.*;
    import flash.net.*;

    public class SoundManager extends Object
    {
        private var _delay:int = 0;
        private var _enableSound:Boolean = true;
        private var _enableMusic:Boolean = true;
        private var _universe:Universe;
        private var _musicPlaying:Boolean = false;
        private var _musicPausePos:int = 0;
        private var _musicTrack:String = "none";
        private var _musicLoops:int = 0;
        private var _musicThread:Array;
        private var _isNetMode:Boolean = false;
        private var _sounds:Array;
        private var _musicTransform:SoundTransform;
        private var _tmMusic:TaskManager;
        private var _pausedSounds:Array;
        private var _musicPaused:Boolean = false;
        private var _musicChannel:SoundChannel;
        public static const WOOD_COLLISION:uint = 53;
        public static const MISFIRE:uint = 21;
        public static const WEAPON_PICKUP:uint = 96;
        public static const ACHIEVEMENT:uint = 127;
        public static const SHOTGUN_RELOAD:uint = 4;
        public static const BUTTON_CLICK:uint = 113;
        public static const HIT_TO_BARREL:uint = 31;
        public static const JOINT_DEAD:uint = 85;
        public static const TERMINAL_MESSAGE:uint = 111;
        public static const HIT_TO_BOX:uint = 32;
        public static const CHEST_COLLISION:uint = 54;
        public static const ACTION_PRESS_BUTTON:uint = 101;
        public static const GRENADEGUN_RELOAD:uint = 8;
        public static const DROP_ITEMS:uint = 86;
        public static const HERO_JUMP:uint = 62;
        public static const BOMB_ALARM:uint = 42;
        public static const ACTION_OPEN_CHEST:uint = 103;
        public static const BOSS_ATTACK:uint = 79;
        public static const COIN_COLLECT:uint = 91;
        public static const MOTI_SILENT_KILL:uint = 125;
        public static const PISTOL_RELOAD:uint = 2;
        public static const MOTI_MEGA_KILL:uint = 124;
        public static const MOTI_DOUBLE_KILL:uint = 121;
        public static const STONE_BREAK:uint = 56;
        public static const TURRET_EXPLOSION:uint = 74;
        public static const COIN_FALL:uint = 92;
        public static const MOTI_MULTI_KILL:uint = 123;
        public static const SKELETON_DIE:uint = 77;
        public static const ELECTRO_SHOCK:uint = 81;
        public static const SKELETON_ATTACK:uint = 78;
        public static const BAG_COLLISION:uint = 57;
        public static const BOX_COLLISION:uint = 51;
        public static const ZOMBIE_ATTACK:uint = 72;
        public static const ELEVATOR_MOVE:uint = 82;
        public static const HIT_TO_DEADBODY:uint = 35;
        public static const HERO_DEAD:uint = 61;
        public static const TURRET_DIE:uint = 75;
        public static const BACKDOOR2_OPEN:uint = 84;
        public static const BOSS_DIE:uint = 801;
        public static const BUY_ITEMS:uint = 115;
        public static const STONE_COLLISION:uint = 55;
        public static const AMMO_COLLECT:uint = 94;
        public static const BARREL_EXPLOSION:uint = 43;
        public static const HIT_TO_ZOMBIE:uint = 34;
        public static const GUN_RELOAD:uint = 6;
        public static const BOMB_EXPLOSION:uint = 41;
        public static const MISSION_COMPLETE:uint = 128;
        public static const TERMINAL_ALARM:uint = 112;
        public static const SHOTGUN_SHOT:uint = 3;
        public static const WEAPON_SWITCH:uint = 98;
        public static const BARREL_COLLISION:uint = 52;
        public static const BUTTON_DISABLE:uint = 114;
        public static const WEAPON_FALL:uint = 97;
        public static const GUN_SHOT:uint = 5;
        public static const ACTION_OPEN_DOOR:uint = 102;
        public static const PISTOL_SHOT:uint = 1;
        public static const HIT_TO_SKELETON:uint = 37;
        public static const ZOMBIE_DIE:uint = 71;
        public static const BOSS_FIRE:uint = 80;
        public static const BOSS_JUMP:uint = 802;
        public static const TRUCK_MOVE:uint = 87;
        public static const HIT_TO_ROBOT:uint = 36;
        public static const BOSS_FIREBALL:uint = 803;
        public static const BOSS_COLLISION:uint = 804;
        public static const ROBOT_ATTACK:uint = 76;
        public static const ITEM_COLLECT:uint = 93;
        public static const GRENADEGUN_SHOT:uint = 7;
        public static const TURRET_SHOT:uint = 73;
        public static const BACKDOOR1_OPEN:uint = 83;
        public static const USE_AIDKIT:uint = 95;
        public static const OBJECT_EXPLOSION:uint = 44;
        public static const MOTI_TRIPLE_KILL:uint = 122;
        private static var _instance:SoundManager;
        public static const HIT_TO_GROUND:uint = 33;

        public function SoundManager()
        {
            this._sounds = [];
            this._pausedSounds = [];
            this._tmMusic = new TaskManager();
            this._musicTransform = new SoundTransform();
            this._musicThread = [];
            if (_instance)
            {
                throw "SoundManager is a singleton. Use method SoundManager.getInstance().";
            }
            _instance = this;
            this._universe = Universe.getInstance();
            return;
        }// end function

        public function stop(param1:uint, param2:Boolean = true) : void
        {
            var _loc_3:* = this._sounds.length - 1;
            var _loc_4:* = _loc_3;
            while (_loc_4 >= 0)
            {
                
                if (this._sounds[_loc_4] != null && this._sounds[_loc_4].kind == param1)
                {
                    this._sounds[_loc_4].channel.stop();
                    this._sounds[_loc_4] = null;
                    if (param2)
                    {
                        this._sounds.splice(_loc_4, 1);
                    }
                }
                _loc_4 = _loc_4 - 1;
            }
            return;
        }// end function

        public function clearMusicThread() : void
        {
            this._musicThread.length = 0;
            return;
        }// end function

        public function sound(param1:uint, param2 = null, param3:Boolean = false) : void
        {
            var _loc_6:SoundChannel = null;
            var _loc_7:SoundTransform = null;
            var _loc_10:Number = NaN;
            if (!this._enableSound || param3 && this.isPlaying(param1))
            {
                return;
            }
            var _loc_4:Sound = null;
            var _loc_5:String = "";
            var _loc_8:int = 0;
            var _loc_9:Number = 1;
            if (param2 != null)
            {
                _loc_10 = Amath.distance(param2.x, param2.y, Math.abs(this._universe.x) + App.SCR_HALF_W, Math.abs(this._universe.y) + App.SCR_HALF_H);
                _loc_9 = 1 - _loc_10 / App.SCR_H;
                _loc_9 = _loc_9 < 0 ? (0) : (_loc_9 > 1 ? (1) : (_loc_9));
            }
            if (this._isNetMode)
            {
                _loc_5 = this.getSoundFileName(param1);
                _loc_4 = new Sound(new URLRequest("sound/" + _loc_5));
            }
            else
            {
                _loc_4 = this.getSound(param1);
            }
            switch(param1)
            {
                case ELEVATOR_MOVE:
                case TRUCK_MOVE:
                {
                    _loc_8 = 300;
                    break;
                }
                default:
                {
                    break;
                }
            }
            if (_loc_4 != null)
            {
                _loc_7 = new SoundTransform();
                _loc_7.volume = _loc_9;
                _loc_6 = _loc_4.play(0, _loc_8);
                _loc_6.soundTransform = _loc_7;
                _loc_6.addEventListener(Event.SOUND_COMPLETE, this.soundCompleteHandler);
                this._sounds[this._sounds.length] = {kind:param1, channel:_loc_6, transform:_loc_7, obj:param2};
            }
            return;
        }// end function

        public function set enableSound(param1:Boolean) : void
        {
            this._enableSound = param1;
            return;
        }// end function

        public function soundResume() : void
        {
            var _loc_1:Object = null;
            var _loc_2:* = this._pausedSounds.length;
            var _loc_3:int = 0;
            while (_loc_3 < _loc_2)
            {
                
                _loc_1 = this._pausedSounds[_loc_3];
                this.sound(_loc_1.kind, _loc_1.obj);
                _loc_3++;
            }
            this._pausedSounds.length = 0;
            return;
        }// end function

        public function soundPause() : void
        {
            var _loc_1:Object = null;
            var _loc_2:* = this._sounds.length;
            this._pausedSounds.length = 0;
            var _loc_3:int = 0;
            while (_loc_3 < _loc_2)
            {
                
                _loc_1 = this._sounds[_loc_3];
                if (_loc_1 != null && (_loc_1.kind == ELEVATOR_MOVE || _loc_1.kind == TRUCK_MOVE))
                {
                    this._pausedSounds[this._pausedSounds.length] = {kind:_loc_1.kind, obj:_loc_1.obj};
                    this.stop(_loc_1.kind, false);
                }
                _loc_3++;
            }
            return;
        }// end function

        public function musicReset() : void
        {
            this.stopMusic(false);
            this._musicPaused = false;
            return;
        }// end function

        private function getMusicTrack(param1:String) : Sound
        {
            var _loc_2:Sound = null;
            switch(param1)
            {
                case "track1":
                {
                    _loc_2 = new Track1_snd();
                    break;
                }
                case "track2":
                {
                    _loc_2 = new Track2_snd();
                    break;
                }
                case "track3":
                {
                    _loc_2 = new Track3_snd();
                    break;
                }
                case "track4":
                {
                    _loc_2 = new Track4_snd();
                    break;
                }
                case "track5":
                {
                    _loc_2 = new Track5_snd();
                    break;
                }
                case "track6":
                {
                    _loc_2 = new Track6_snd();
                    break;
                }
                case "track7":
                {
                    _loc_2 = new Track7_snd();
                    break;
                }
                default:
                {
                    break;
                }
            }
            return _loc_2;
        }// end function

        private function getSoundFileName(param1:uint) : String
        {
            var _loc_3:int = 0;
            var _loc_2:String = "";
            switch(param1)
            {
                case MOTI_DOUBLE_KILL:
                {
                    _loc_2 = "moti_doublekill.mp3";
                    break;
                }
                case MOTI_TRIPLE_KILL:
                {
                    _loc_2 = "moti_triplekill.mp3";
                    break;
                }
                case MOTI_MULTI_KILL:
                {
                    _loc_2 = "moti_multikill.mp3";
                    break;
                }
                case MOTI_MEGA_KILL:
                {
                    _loc_2 = "moti_megakill.mp3";
                    break;
                }
                case MOTI_SILENT_KILL:
                {
                    _loc_2 = "moti_silentkill.mp3";
                    break;
                }
                case ACHIEVEMENT:
                {
                    _loc_2 = "achievement.mp3";
                    break;
                }
                case MISSION_COMPLETE:
                {
                    _loc_2 = "mission_complete.mp3";
                    break;
                }
                case PISTOL_SHOT:
                {
                    _loc_2 = "pistol_shot.mp3";
                    break;
                }
                case PISTOL_RELOAD:
                {
                    _loc_2 = "pistol_reload.mp3";
                    break;
                }
                case GUN_SHOT:
                {
                    _loc_2 = "gun_shot.mp3";
                    break;
                }
                case GUN_RELOAD:
                {
                    _loc_2 = "gun_reload.mp3";
                    break;
                }
                case GRENADEGUN_SHOT:
                {
                    _loc_2 = "grenadegun_shot.mp3";
                    break;
                }
                case GRENADEGUN_RELOAD:
                {
                    _loc_2 = "grenadegun_reload.mp3";
                    break;
                }
                case MISFIRE:
                {
                    _loc_2 = "misfire.mp3";
                    break;
                }
                case HIT_TO_BARREL:
                {
                    _loc_2 = "hit_barrel.mp3";
                    break;
                }
                case HIT_TO_BOX:
                {
                    _loc_2 = "hit_box.mp3";
                    break;
                }
                case HIT_TO_GROUND:
                {
                    _loc_2 = "hit_ground.mp3";
                    break;
                }
                case HIT_TO_ZOMBIE:
                {
                    _loc_2 = "hit_to_zombie.mp3";
                    break;
                }
                case HIT_TO_DEADBODY:
                {
                    _loc_2 = "hit_deadbody.mp3";
                    break;
                }
                case HIT_TO_SKELETON:
                {
                    _loc_2 = "hit_to_skeleton.mp3";
                    break;
                }
                case BARREL_EXPLOSION:
                {
                    _loc_2 = "barrel_explosion.mp3";
                    break;
                }
                case OBJECT_EXPLOSION:
                {
                    _loc_2 = "box_destroy.mp3";
                    break;
                }
                case BOX_COLLISION:
                {
                    _loc_2 = "box_collision.mp3";
                    break;
                }
                case BARREL_COLLISION:
                {
                    _loc_2 = "barrel_collision.mp3";
                    break;
                }
                case ACTION_PRESS_BUTTON:
                {
                    _loc_2 = "action_press_button.mp3";
                    break;
                }
                case ACTION_OPEN_DOOR:
                {
                    _loc_2 = "action_open_door.mp3";
                    break;
                }
                case ZOMBIE_DIE:
                {
                    _loc_2 = "zombie_die.mp3";
                    break;
                }
                case ZOMBIE_ATTACK:
                {
                    _loc_2 = "zombie_attack.mp3";
                    break;
                }
                case SKELETON_DIE:
                {
                    _loc_2 = "skeleton_die.mp3";
                    break;
                }
                case SKELETON_ATTACK:
                {
                    _loc_2 = "skeleton_attack.mp3";
                    break;
                }
                case BOSS_ATTACK:
                {
                    _loc_2 = "boss_attack.mp3";
                    break;
                }
                case BOSS_FIRE:
                {
                    _loc_2 = "boss_fire.mp3";
                    break;
                }
                case BOSS_DIE:
                {
                    _loc_2 = "boss_die.mp3";
                    break;
                }
                case BOSS_JUMP:
                {
                    _loc_2 = "boss_jump.mp3";
                    break;
                }
                case BOSS_FIREBALL:
                {
                    _loc_2 = "boss_fireball.mp3";
                    break;
                }
                case BOSS_COLLISION:
                {
                    _loc_2 = "boss_collision.mp3";
                    break;
                }
                case BAG_COLLISION:
                {
                    _loc_2 = "bag_collision.mp3";
                    break;
                }
                case ELECTRO_SHOCK:
                {
                    _loc_3 = Amath.random(1, 4);
                    _loc_2 = "electro_shock" + _loc_3.toString() + ".mp3";
                    break;
                }
                case HERO_DEAD:
                {
                    _loc_2 = "hero_death.mp3";
                    break;
                }
                case TURRET_SHOT:
                {
                    _loc_2 = "turret_shoot.mp3";
                    break;
                }
                case TURRET_EXPLOSION:
                {
                    _loc_2 = "turret_explosion.mp3";
                    break;
                }
                case TURRET_DIE:
                {
                    _loc_2 = "turret_dead.mp3";
                    break;
                }
                case ELEVATOR_MOVE:
                {
                    _loc_2 = "elevator_move.mp3";
                    break;
                }
                case TRUCK_MOVE:
                {
                    _loc_2 = "truck_engine.mp3";
                    break;
                }
                case BACKDOOR1_OPEN:
                {
                    _loc_2 = "backdoor1_open.mp3";
                    break;
                }
                case BACKDOOR2_OPEN:
                {
                    _loc_2 = "backdoor2_open.mp3";
                    break;
                }
                case JOINT_DEAD:
                {
                    _loc_2 = "joint_dead.mp3";
                    break;
                }
                case WOOD_COLLISION:
                {
                    _loc_2 = "wood_collision.mp3";
                    break;
                }
                case COIN_COLLECT:
                {
                    _loc_2 = "coin_collect.mp3";
                    break;
                }
                case COIN_FALL:
                {
                    _loc_2 = "coin_fall.mp3";
                    break;
                }
                case HIT_TO_ROBOT:
                {
                    _loc_2 = "hit_to_robot.mp3";
                    break;
                }
                case ROBOT_ATTACK:
                {
                    _loc_2 = "robot_attack.mp3";
                    break;
                }
                case TERMINAL_MESSAGE:
                {
                    _loc_2 = "terminal_message.mp3";
                    break;
                }
                case TERMINAL_ALARM:
                {
                    _loc_2 = "terminal_alarm.mp3";
                    break;
                }
                case BUTTON_CLICK:
                {
                    _loc_2 = "button_click.mp3";
                    break;
                }
                case BUTTON_DISABLE:
                {
                    _loc_2 = "button_disable.mp3";
                    break;
                }
                case BUY_ITEMS:
                {
                    _loc_2 = "buy_items.mp3";
                    break;
                }
                case HERO_JUMP:
                {
                    _loc_2 = "hero_jump.mp3";
                    break;
                }
                case DROP_ITEMS:
                {
                    _loc_2 = "drop_items.mp3";
                    break;
                }
                case ITEM_COLLECT:
                {
                    _loc_2 = "item_collect.mp3";
                    break;
                }
                case AMMO_COLLECT:
                {
                    _loc_2 = "ammo_collect.mp3";
                    break;
                }
                case USE_AIDKIT:
                {
                    _loc_2 = "use_aidkit.mp3";
                    break;
                }
                case SHOTGUN_SHOT:
                {
                    _loc_2 = "shotgun_fire.mp3";
                    break;
                }
                case SHOTGUN_RELOAD:
                {
                    _loc_2 = "shotgun_reload.mp3";
                    break;
                }
                case WEAPON_PICKUP:
                {
                    _loc_2 = "weapon_pickup.mp3";
                    break;
                }
                case WEAPON_FALL:
                {
                    _loc_2 = "weapon_fall.mp3";
                    break;
                }
                case WEAPON_SWITCH:
                {
                    _loc_2 = "weapon_switch.mp3";
                    break;
                }
                case ACTION_OPEN_CHEST:
                {
                    _loc_2 = "action_open_chest.mp3";
                    break;
                }
                case CHEST_COLLISION:
                {
                    _loc_2 = "chest_collision.mp3";
                    break;
                }
                case BOMB_EXPLOSION:
                {
                    _loc_2 = "bomb_explosion.mp3";
                    break;
                }
                case BOMB_ALARM:
                {
                    _loc_2 = "bomb_alarm.mp3";
                    break;
                }
                case STONE_COLLISION:
                {
                    _loc_2 = "stone_collision.mp3";
                    break;
                }
                case STONE_BREAK:
                {
                    _loc_2 = "stone_break.mp3";
                    break;
                }
                default:
                {
                    break;
                }
            }
            return _loc_2;
        }// end function

        public function musicResume(param1:Boolean = true) : void
        {
            if (!this._enableMusic)
            {
                return;
            }
            if (param1)
            {
                this.playTrack(this._musicTrack, this._musicLoops, this._musicPausePos, 0);
                this._tmMusic.clear();
                this._tmMusic.addTask(this.doMusicFadeIn);
            }
            else
            {
                this.playTrack(this._musicTrack, this._musicLoops, this._musicPausePos);
            }
            this._musicPaused = false;
            return;
        }// end function

        public function addMusicTrack(param1:String, param2:Boolean, param3:int) : void
        {
            if (!this._enableMusic)
            {
                this._musicTrack = param1;
                return;
            }
            if (!param2 && this._musicPlaying)
            {
                this._musicThread[this._musicThread.length] = {trackName:param1, loops:param3};
            }
            else if (param2 || !this._musicPlaying)
            {
                this.playTrack(param1, param3);
            }
            return;
        }// end function

        private function doMusicFadeIn() : Boolean
        {
            if (this._musicTransform.volume + 0.05 <= 0.8)
            {
                this._musicTransform.volume = this._musicTransform.volume + 0.05;
                this._musicChannel.soundTransform = this._musicTransform;
            }
            else
            {
                this._musicTransform.volume = 0.8;
                this._musicChannel.soundTransform = this._musicTransform;
                return true;
            }
            return false;
        }// end function

        private function isPlaying(param1:uint) : Boolean
        {
            var _loc_2:* = this._sounds.length;
            var _loc_3:uint = 0;
            while (_loc_3 < _loc_2)
            {
                
                if (this._sounds[_loc_3] != null && this._sounds[_loc_3].kind == param1)
                {
                    return true;
                }
                _loc_3 = _loc_3 + 1;
            }
            return false;
        }// end function

        public function set netMode(param1:Boolean) : void
        {
            this._isNetMode = param1;
            return;
        }// end function

        private function soundCompleteHandler(event:Event) : void
        {
            (event.target as SoundChannel).removeEventListener(Event.SOUND_COMPLETE, this.soundCompleteHandler);
            var _loc_2:* = this._sounds.length;
            var _loc_3:* = _loc_2;
            while (_loc_3 >= 0)
            {
                
                if (this._sounds[_loc_3] == null)
                {
                    this._sounds.splice(_loc_3, 1);
                }
                else if (event.target == this._sounds[_loc_3].channel)
                {
                    this._sounds[_loc_3] = null;
                    this._sounds.splice(_loc_3, 1);
                    break;
                }
                _loc_3 = _loc_3 - 1;
            }
            return;
        }// end function

        public function stopMusic(param1:Boolean = true, param2:Boolean = true) : void
        {
            if (!this._musicPlaying && !this._enableMusic)
            {
                return;
            }
            if (this._musicPlaying)
            {
                if (param1)
                {
                    this._tmMusic.clear();
                    this._tmMusic.addTask(this.doMusicFadeOut);
                }
                else
                {
                    this._musicChannel.stop();
                    this._musicPlaying = false;
                }
            }
            if (param2)
            {
                this.clearMusicThread();
            }
            return;
        }// end function

        public function set enableMusic(param1:Boolean) : void
        {
            this._enableMusic = param1;
            if (!this._enableMusic)
            {
                this.stopMusic();
            }
            else if (this._enableMusic)
            {
                this.playTrack(this._musicTrack);
            }
            return;
        }// end function

        public function musicPause(param1:Boolean = true) : void
        {
            var fade:* = param1;
            if (!this._enableMusic)
            {
                return;
            }
            if (fade)
            {
                this._tmMusic.clear();
                this._tmMusic.addTask(this.doMusicFadeOut);
                this._tmMusic.addInstantTask(function () : void
            {
                _musicPausePos = _musicChannel.position;
                return;
            }// end function
            );
            }
            else
            {
                this._musicChannel.stop();
                this._musicPausePos = this._musicChannel.position;
            }
            this._musicPlaying = false;
            this._musicPaused = true;
            return;
        }// end function

        public function get enableSound() : Boolean
        {
            return this._enableSound;
        }// end function

        private function updateSound() : void
        {
            var _loc_1:Object = null;
            var _loc_2:Avector = null;
            var _loc_3:Number = NaN;
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            var _loc_6:Number = NaN;
            if (this._delay >= 2)
            {
                _loc_2 = new Avector();
                _loc_4 = this._sounds.length;
                _loc_5 = 0;
                while (_loc_5 < _loc_4)
                {
                    
                    _loc_1 = this._sounds[_loc_5];
                    if (_loc_1 == null || _loc_1.obj == null)
                    {
                    }
                    else
                    {
                        _loc_2.set(_loc_1.obj.x - Math.abs(this._universe.x), _loc_1.obj.y - Math.abs(this._universe.y));
                        if (_loc_2.x > App.SCR_HALF_W)
                        {
                            _loc_2.x = _loc_2.x - App.SCR_HALF_W;
                            _loc_1.transform.pan = _loc_2.x / App.SCR_HALF_W;
                        }
                        else
                        {
                            _loc_1.transform.pan = -1 + _loc_2.x / App.SCR_HALF_W;
                        }
                        _loc_6 = Amath.distance(_loc_1.obj.x, _loc_1.obj.y, Math.abs(this._universe.x) + App.SCR_HALF_W, Math.abs(this._universe.y) + App.SCR_HALF_H);
                        _loc_3 = 1 - _loc_6 / App.SCR_H;
                        _loc_1.transform.volume = _loc_3 < 0 ? (0) : (_loc_3 > 1 ? (1) : (_loc_3));
                        _loc_1.channel.soundTransform = _loc_1.transform;
                    }
                    _loc_5++;
                }
                this._delay = 0;
            }
            var _loc_7:String = this;
            var _loc_8:* = this._delay + 1;
            _loc_7._delay = _loc_8;
            return;
        }// end function

        private function getSound(param1) : Sound
        {
            var _loc_2:Sound = null;
            switch(param1)
            {
                case PISTOL_SHOT:
                {
                    _loc_2 = new PistolShot_snd();
                    break;
                }
                case PISTOL_RELOAD:
                {
                    _loc_2 = new PistolReload_snd();
                    break;
                }
                case SHOTGUN_SHOT:
                {
                    _loc_2 = new ShotgunShot_snd();
                    break;
                }
                case SHOTGUN_RELOAD:
                {
                    _loc_2 = new ShotgunReload_snd();
                    break;
                }
                case GUN_SHOT:
                {
                    _loc_2 = new GunShot_snd();
                    break;
                }
                case GUN_RELOAD:
                {
                    _loc_2 = new GunReload_snd();
                    break;
                }
                case GRENADEGUN_SHOT:
                {
                    _loc_2 = new GrenadegunShot_snd();
                    break;
                }
                case GRENADEGUN_RELOAD:
                {
                    _loc_2 = new GrenadegunReload_snd();
                    break;
                }
                case MISFIRE:
                {
                    _loc_2 = new Misfire_snd();
                    break;
                }
                case HIT_TO_BARREL:
                {
                    _loc_2 = new HitToBarrel_snd();
                }
                case HIT_TO_BOX:
                {
                    _loc_2 = new HitToBox_snd();
                }
                case HIT_TO_GROUND:
                {
                    _loc_2 = new HitToGround_snd();
                    break;
                }
                case HIT_TO_ZOMBIE:
                {
                    _loc_2 = new HitToZombie_snd();
                    break;
                }
                case HIT_TO_DEADBODY:
                {
                    _loc_2 = new HitToDeadbody_snd();
                    break;
                }
                case HIT_TO_ROBOT:
                {
                    _loc_2 = new HitToRobot_snd();
                    break;
                }
                case HIT_TO_SKELETON:
                {
                    _loc_2 = new HitToSkeleton_snd();
                    break;
                }
                case BOMB_EXPLOSION:
                {
                    _loc_2 = new BombExplosion_snd();
                    break;
                }
                case BOMB_ALARM:
                {
                    _loc_2 = new BombAlarm_snd();
                    break;
                }
                case BARREL_EXPLOSION:
                {
                    _loc_2 = new BarrelExplosion_snd();
                    break;
                }
                case OBJECT_EXPLOSION:
                {
                    _loc_2 = new ObjectExplosion_snd();
                    break;
                }
                case BOX_COLLISION:
                {
                    _loc_2 = new BoxCollision_snd();
                    break;
                }
                case BARREL_COLLISION:
                {
                    _loc_2 = new BarrelCollision_snd();
                    break;
                }
                case WOOD_COLLISION:
                {
                    _loc_2 = new WoodCollision_snd();
                    break;
                }
                case CHEST_COLLISION:
                {
                    _loc_2 = new ChestCollision_snd();
                    break;
                }
                case STONE_COLLISION:
                {
                    _loc_2 = new StoneCollision_snd();
                    break;
                }
                case STONE_BREAK:
                {
                    _loc_2 = new StoneBreak_snd();
                    break;
                }
                case BAG_COLLISION:
                {
                    _loc_2 = new BagCollision_snd();
                    break;
                }
                case HERO_DEAD:
                {
                    _loc_2 = new HeroDead_snd();
                    break;
                }
                case HERO_JUMP:
                {
                    _loc_2 = new HeroJump_snd();
                    break;
                }
                case ZOMBIE_DIE:
                {
                    _loc_2 = new ZombieDie_snd();
                    break;
                }
                case ZOMBIE_ATTACK:
                {
                    _loc_2 = new ZombieAttack_snd();
                    break;
                }
                case TURRET_SHOT:
                {
                    _loc_2 = new TurretShot_snd();
                    break;
                }
                case TURRET_EXPLOSION:
                {
                    _loc_2 = new TurretExplosion_snd();
                    break;
                }
                case TURRET_DIE:
                {
                    _loc_2 = new TurretDie_snd();
                    break;
                }
                case ROBOT_ATTACK:
                {
                    _loc_2 = new RobotAttack_snd();
                    break;
                }
                case SKELETON_DIE:
                {
                    _loc_2 = new SkeletonDie_snd();
                    break;
                }
                case SKELETON_ATTACK:
                {
                    _loc_2 = new SkeletonAttack_snd();
                    break;
                }
                case BOSS_ATTACK:
                {
                    _loc_2 = new BossAttack_snd();
                    break;
                }
                case BOSS_FIRE:
                {
                    _loc_2 = new BossFire_snd();
                    break;
                }
                case BOSS_DIE:
                {
                    _loc_2 = new BossDie_snd();
                    break;
                }
                case BOSS_JUMP:
                {
                    _loc_2 = new BossJump_snd();
                    break;
                }
                case BOSS_FIREBALL:
                {
                    _loc_2 = new BossFireball_snd();
                    break;
                }
                case BOSS_COLLISION:
                {
                    _loc_2 = new BossCollision_snd();
                    break;
                }
                case ELECTRO_SHOCK:
                {
                    switch(Amath.random(1, 4))
                    {
                        case 1:
                        {
                            _loc_2 = new ElectroShock1_snd();
                            break;
                        }
                        case 2:
                        {
                            _loc_2 = new ElectroShock2_snd();
                            break;
                        }
                        case 3:
                        {
                            _loc_2 = new ElectroShock3_snd();
                            break;
                        }
                        case 4:
                        {
                            _loc_2 = new ElectroShock4_snd();
                            break;
                        }
                        default:
                        {
                            break;
                        }
                    }
                    break;
                }
                case ELEVATOR_MOVE:
                {
                    _loc_2 = new ElevatorMove_snd();
                    break;
                }
                case BACKDOOR1_OPEN:
                {
                    _loc_2 = new Backdoor1Open_snd();
                    break;
                }
                case BACKDOOR2_OPEN:
                {
                    _loc_2 = new Backdoor2Open_snd();
                    break;
                }
                case JOINT_DEAD:
                {
                    _loc_2 = new JointDead_snd();
                    break;
                }
                case DROP_ITEMS:
                {
                    _loc_2 = new DropItems_snd();
                    break;
                }
                case TRUCK_MOVE:
                {
                    _loc_2 = new TruckMove_snd();
                    break;
                }
                case COIN_COLLECT:
                {
                    _loc_2 = new CoinCollect_snd();
                    break;
                }
                case COIN_FALL:
                {
                    _loc_2 = new CoinFall_snd();
                    break;
                }
                case ITEM_COLLECT:
                {
                    _loc_2 = new ItemCollect_snd();
                    break;
                }
                case AMMO_COLLECT:
                {
                    _loc_2 = new AmmoCollect_snd();
                    break;
                }
                case USE_AIDKIT:
                {
                    _loc_2 = new UseAidkit_snd();
                    break;
                }
                case WEAPON_PICKUP:
                {
                    _loc_2 = new WeaponPickup_snd();
                    break;
                }
                case WEAPON_FALL:
                {
                    _loc_2 = new WeaponFall_snd();
                    break;
                }
                case WEAPON_SWITCH:
                {
                    _loc_2 = new WeaponSwitch_snd();
                    break;
                }
                case ACTION_PRESS_BUTTON:
                {
                    _loc_2 = new ActionPressButton_snd();
                    break;
                }
                case ACTION_OPEN_DOOR:
                {
                    _loc_2 = new ActionOpenDoor_snd();
                    break;
                }
                case ACTION_OPEN_CHEST:
                {
                    _loc_2 = new ActionOpenChest_snd();
                    break;
                }
                case MOTI_DOUBLE_KILL:
                {
                    _loc_2 = new MotiDoubleKill_snd();
                    break;
                }
                case MOTI_TRIPLE_KILL:
                {
                    _loc_2 = new MotiTripleKill_snd();
                    break;
                }
                case MOTI_MULTI_KILL:
                {
                    _loc_2 = new MotiMultiKill_snd();
                    break;
                }
                case MOTI_MEGA_KILL:
                {
                    _loc_2 = new MotiMegaKill_snd();
                    break;
                }
                case MOTI_SILENT_KILL:
                {
                    _loc_2 = new MotiSilentKill_snd();
                    break;
                }
                case ACHIEVEMENT:
                {
                    _loc_2 = new Achievement_snd();
                    break;
                }
                case MISSION_COMPLETE:
                {
                    _loc_2 = new MissionComplete_snd();
                    break;
                }
                case TERMINAL_MESSAGE:
                {
                    _loc_2 = new TerminalMessage_snd();
                    break;
                }
                case TERMINAL_ALARM:
                {
                    _loc_2 = new TerminalAlarm_snd();
                    break;
                }
                case BUTTON_CLICK:
                {
                    _loc_2 = new ButtonClick_snd();
                    break;
                }
                case BUTTON_DISABLE:
                {
                    _loc_2 = new ButtonDisable_snd();
                    break;
                }
                case BUY_ITEMS:
                {
                    _loc_2 = new BuyItems_snd();
                    break;
                }
                default:
                {
                    break;
                }
            }
            return _loc_2;
        }// end function

        private function updateMusic() : void
        {
            return;
        }// end function

        public function get enableMusic() : Boolean
        {
            return this._enableMusic;
        }// end function

        private function musicCompleteHandler(event:Event) : void
        {
            var _loc_2:Object = null;
            (event.target as SoundChannel).removeEventListener(Event.SOUND_COMPLETE, this.musicCompleteHandler);
            this._musicPlaying = false;
            if (this._musicThread.length > 0)
            {
                _loc_2 = this._musicThread.shift();
                this.playTrack(_loc_2.trackName, _loc_2.loops);
            }
            else if ((this._musicLoops - 1) > 0)
            {
                this.playTrack(this._musicTrack, (this._musicLoops - 1));
            }
            return;
        }// end function

        public function process() : void
        {
            this.updateSound();
            return;
        }// end function

        public function playTrack(param1:String, param2:int = 90, param3:int = 0, param4:Number = 0.8) : void
        {
            var _loc_5:Sound = null;
            if (this._musicPlaying && !this._musicPaused)
            {
                this._tmMusic.clear();
                this._tmMusic.addTask(this.doMusicFadeOut);
                this._tmMusic.addInstantTask(this.playTrack, [param1, param2]);
                return;
            }
            if (param1 == "none" || !this._enableMusic)
            {
                this._musicTrack = param1;
                return;
            }
            if (this._isNetMode)
            {
                _loc_5 = new Sound(new URLRequest("music/" + param1 + ".mp3"));
            }
            else
            {
                _loc_5 = this.getMusicTrack(param1);
            }
            if (_loc_5 != null)
            {
                this._musicTransform.volume = param4;
                this._musicLoops = param2;
                this._musicTrack = param1;
                this._musicChannel = _loc_5.play(param3, 0, this._musicTransform);
                this._musicChannel.addEventListener(Event.SOUND_COMPLETE, this.musicCompleteHandler);
                this._musicPlaying = true;
            }
            return;
        }// end function

        private function doMusicFadeOut() : Boolean
        {
            if (this._musicChannel == null)
            {
                return true;
            }
            if (this._musicTransform.volume - 0.05 > 0)
            {
                this._musicTransform.volume = this._musicTransform.volume - 0.05;
                this._musicChannel.soundTransform = this._musicTransform;
            }
            else
            {
                this._musicTransform.volume = 0;
                this._musicChannel.soundTransform = this._musicTransform;
                this._musicChannel.stop();
                this._musicPlaying = false;
                return true;
            }
            return false;
        }// end function

        public static function getInstance() : SoundManager
        {
            return _instance ? (_instance) : (new SoundManager);
        }// end function

    }
}
