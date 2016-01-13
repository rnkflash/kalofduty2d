package com.zombotron.helpers
{
    import com.antkarlov.math.*;
    import com.zombotron.core.*;
    import com.zombotron.effects.*;
    import com.zombotron.objects.*;

    public class Weapon extends Object
    {
        public var ammoKind:uint;
        public var shootInterval:int;
        public var charger:int;
        public var upperDispersion:int;
        public var ammoPack:uint;
        public var shootAnim:String;
        public var reloadAnim:String;
        public var bulletCase:uint;
        public var bulletsNum:uint;
        public var shootEffect:uint;
        public var chargerCapacity:int;
        public var shootSnd:uint;
        public var reloadSnd:uint;
        public var lowerDispersion:int;
        public var bulletVariety:uint;
        public var damage:Number;
        public var bulletPos:Avector;
        private var _kind:uint = 0;
        public var chargerPos:Avector;
        public var supply:int;

        public function Weapon()
        {
            this.bulletPos = new Avector();
            this.chargerPos = new Avector();
            this.supply = 0;
            this.charger = 0;
            this.bulletsNum = 1;
            return;
        }// end function

        public function get dispersion() : int
        {
            return Amath.random(this.lowerDispersion, this.upperDispersion);
        }// end function

        public function get kind() : uint
        {
            return this._kind;
        }// end function

        public function set kind(param1:uint) : void
        {
            if (this._kind != param1)
            {
                this._kind = param1;
                this.setData();
            }
            return;
        }// end function

        private function setData() : void
        {
            switch(this._kind)
            {
                case ShopBox.ITEM_PISTOL:
                {
                    this.shootInterval = 15;
                    this.chargerCapacity = 8;
                    this.damage = 0.4;
                    this.lowerDispersion = -6;
                    this.upperDispersion = 6;
                    this.bulletPos.set(50, 1);
                    this.bulletVariety = Bullet.PISTOL;
                    this.bulletCase = EffectBulletCase.BASIC;
                    this.bulletsNum = 1;
                    this.shootAnim = Art.HERO_WEAPON1;
                    this.reloadAnim = Art.HERO_WEAPON1_RELOAD;
                    this.shootEffect = EffectShoot.PISTOL_SHOT;
                    this.shootSnd = SoundManager.PISTOL_SHOT;
                    this.reloadSnd = SoundManager.PISTOL_RELOAD;
                    this.ammoKind = ShopBox.ITEM_AMMO_PISTOL;
                    this.ammoPack = 8;
                    break;
                }
                case ShopBox.ITEM_SHOTGUN:
                {
                    this.shootInterval = 15;
                    this.chargerCapacity = 2;
                    this.damage = 0.25;
                    this.lowerDispersion = -8;
                    this.upperDispersion = 8;
                    this.bulletPos.set(60, 1);
                    this.bulletVariety = Bullet.SHOTGUN;
                    this.bulletCase = EffectBulletCase.SHOTGUN;
                    this.bulletsNum = 5;
                    this.shootAnim = Art.HERO_WEAPON2;
                    this.reloadAnim = Art.HERO_WEAPON2_RELOAD;
                    this.shootEffect = EffectShoot.SHOTGUN_SHOT;
                    this.shootSnd = SoundManager.SHOTGUN_SHOT;
                    this.reloadSnd = SoundManager.SHOTGUN_RELOAD;
                    this.ammoKind = ShopBox.ITEM_AMMO_SHOTGUN;
                    this.ammoPack = 3;
                    break;
                }
                case ShopBox.ITEM_GUN:
                {
                    this.shootInterval = 6;
                    this.chargerCapacity = 16;
                    this.damage = 0.4;
                    this.lowerDispersion = -7;
                    this.upperDispersion = 7;
                    this.bulletPos.set(50, 1);
                    this.bulletVariety = Bullet.GUN;
                    this.bulletCase = EffectBulletCase.BASIC;
                    this.bulletsNum = 1;
                    this.shootAnim = Art.HERO_WEAPON3;
                    this.reloadAnim = Art.HERO_WEAPON3_RELOAD;
                    this.shootEffect = EffectShoot.GUN_SHOT;
                    this.shootSnd = SoundManager.GUN_SHOT;
                    this.reloadSnd = SoundManager.GUN_RELOAD;
                    this.ammoKind = ShopBox.ITEM_AMMO_GUN;
                    this.ammoPack = 16;
                    break;
                }
                case ShopBox.ITEM_GRENADEGUN:
                {
                    this.shootInterval = 16;
                    this.chargerCapacity = 3;
                    this.damage = 1.8;
                    this.lowerDispersion = 0;
                    this.upperDispersion = 0;
                    this.bulletPos.set(50, 1);
                    this.bulletVariety = Bullet.GRENADEGUN;
                    this.bulletCase = EffectBulletCase.BASIC;
                    this.bulletsNum = 1;
                    this.shootAnim = Art.HERO_WEAPON4;
                    this.reloadAnim = Art.HERO_WEAPON4_RELOAD;
                    this.shootEffect = EffectShoot.GRENADEGUN_SHOT;
                    this.shootSnd = SoundManager.GRENADEGUN_SHOT;
                    this.reloadSnd = SoundManager.GRENADEGUN_RELOAD;
                    this.ammoKind = ShopBox.ITEM_AMMO_GRENADEGUN;
                    this.ammoPack = 2;
                    break;
                }
                case ShopBox.ITEM_MACHINEGUN:
                {
                    this.shootInterval = 5;
                    this.chargerCapacity = 40;
                    this.damage = 0.4;
                    this.lowerDispersion = -8;
                    this.upperDispersion = 8;
                    this.bulletPos.set(50, 12);
                    this.bulletVariety = Bullet.MACHINEGUN;
                    this.bulletCase = EffectBulletCase.BASIC;
                    this.bulletsNum = 1;
                    this.shootAnim = Art.HERO_WEAPON5;
                    this.reloadAnim = Art.HERO_WEAPON5_RELOAD;
                    this.shootEffect = EffectShoot.MACHINEGUN_SHOT;
                    this.shootSnd = SoundManager.TURRET_SHOT;
                    this.reloadSnd = SoundManager.SHOTGUN_RELOAD;
                    this.ammoKind = ShopBox.ITEM_AMMO_MACHINEGUN;
                    this.ammoPack = 40;
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

    }
}
