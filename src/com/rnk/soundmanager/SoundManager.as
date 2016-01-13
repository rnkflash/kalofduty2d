
package com.rnk.soundmanager 
{
        import flash.events.Event;
        import flash.media.Sound;
        import flash.media.SoundChannel;
        import flash.media.SoundTransform;
        
        /**
         * @author Alexander Porechnov aka scmorr
         */
        public class SoundManager 
		{

				//для расчета стереобазы
				public static var SCREEN_WIDTH:int = 640;
                // Из всего количества каналов выделяем сколько-то под взрывы
                private static const BOOM_CHANNEL_MAX : int = 10;
				
                // Для замещения или объединения звуков взрывов вводим группы/приоритеты
                // Взрывы многоразовых мин, их много, манипуляции будут малозаметны
                public static const BOOM_PRI_0_LOW : int = 0;
                // Взрывы мобильной техники
                public static const BOOM_PRI_1_MODERATE : int = 1;
                // Большие, редкие, хорошо выделяющиеся взрывы спец. юнитов или зданий,
                // замещать их плохо - будет заметно
                public static const BOOM_PRI_2_HIGH : int = 2;
                // Ядерный взрыв, замещать нельзя
                public static const BOOM_PRI_3_HIGHEST : int = 3;

                // Регулятор громкости взрыва юнитов для подстройки
                public static const UNIT_BOOM_VOLUME : Number = 0.75;

                // Библиотека Sound для незацикленных звуков, лежат по индексам SINGLE_SOUND_*
                // Дополнительно здесь хранятся настройки для каждого звука, ибо в библиотеке
                // все звуки нормализованы, подстройку по громкости и стереобазе проводим
                // прямо тут
                protected static var singleSoundBase : Array;
                // Булеан пометка для скорости кода. Пометка о том, является ли звук в библиотеке
                // выше - набором. В случае часто повторяющего звука игрок хорошо слышит искуственность
                // ситуации, необходимо набрать несколько разных и выбирать из них случайным образом
                protected static var singleSoundBaseGroupMark : Array;

                // Каналы сейчас звучащих звуков
                protected static var singleSoundChannels : Array;
                // Соотв. Sound-ы для этих каналов. Их надо помнить, чтобы при unpause восстанавливать
                protected static var singleSounds : Array;

                // Так как на взрывчики выделено только 10 каналов - необходим механизм, который
                // объединяет или незаметно вытесняет звуки по приоритетам и группам
                protected static var boomChannels : Array;
                protected static var boomSounds : Array;
                protected static var boomPositions : Array;
                protected static var boomPriorities : Array;
                protected static var boomExecutes : Array;
                
                // Временный SoundTransform, чтобы не пересоздавать постоянно
                protected static var tempST : SoundTransform;

                protected static var paused : Boolean;
				protected static var muteSounds : Boolean;
				protected static var muteMusic: Boolean;
				protected static var musicBank:Array;
				protected static var musicChannel:SoundChannel;
				static private var currentMusicId:int;

                public static function getUsedChannelsCount() : int {
                        var res : int = singleSoundChannels.length;
                        for (var i:int = 0; i < BOOM_CHANNEL_MAX; i++) {
                                if (boomChannels[i] != null) {
                                        res++;
                                }
                        }
                        return res;
                }

                public static function init(initSoundsFunc:Function) : void {
                        tempST = new SoundTransform();
                        paused = false;
						muteSounds = false;
						muteMusic = false;
						
						//music
						musicBank = [];
						musicChannel = null;

                        // single sounds                        
                        singleSoundBase = new Array(); 
                        singleSoundBaseGroupMark = new Array(); 
						
						initSoundsFunc(singleSoundBase,singleSoundBaseGroupMark,musicBank);
						//Sounds.init(singleSoundBase,singleSoundBaseGroupMark,musicBank);
                        
                        // Библиотека незацикленных звуков, первым идет Sound, затем настроенный SoundTransform
                        // и потом стартовое время (некоторые звуки можно реюзать, скажем есть взрыв с эхо, в другом месте используем только эхо)
                        /*singleSoundBase[SINGLE_SOUND_SHOT] = [new VulcanSound(), new SoundTransform(1, 0), 0];
                        singleSoundBaseGroupMark[SINGLE_SOUND_SHOT] = false;*/
                        
                        // Пример звука с вариантами и пометкой об этом
//                      singleSoundBase[SINGLE_SOUND_TEST] = [
//                              [new UnitBoom9Sound(),          new SoundTransform(1, 0),       0],     
//                              [new UnitBoom8Sound(),          new SoundTransform(1, 0),       0],     
//                      ];
//                      singleSoundBaseGroupMark[SINGLE_SOUND_TEST] = true;

                        singleSoundChannels = new Array();
                        singleSounds = new Array();
                        
                        
						//boom shakalaka
                        boomChannels = new Array(BOOM_CHANNEL_MAX);
                        boomSounds = new Array(BOOM_CHANNEL_MAX);
                        boomPositions = new Array(BOOM_CHANNEL_MAX);
                        boomPriorities = new Array(BOOM_CHANNEL_MAX);
                        boomExecutes = new Array(BOOM_CHANNEL_MAX);
                        for (var j:int = 0; j < BOOM_CHANNEL_MAX; j++) {
                                boomChannels[j] = null;
                                boomSounds[j] = null;
                                boomPositions[j] = 0;
                                boomPriorities[j] = 0;
                                boomExecutes[j] = 0;
                        }

                }
				
				
				//mute
				public static function IsSoundMute():Boolean
				{
					return muteSounds;
				}
				
				public static function MuteSound(orly:Boolean,save:Boolean=true):void
				{
					if (orly)
					{
						muteSounds = true;
						stopMissionSounds();
						
					} else
					{
						muteSounds = false;
					}
					
					if (save)
					{
						//Player.SaveSoundSettings(muteSounds,muteMusic);
					}
				}
				
				public static function IsMusicMute():Boolean
				{
					return muteMusic;
				}
				
				public static function MuteMusic(orly:Boolean,save:Boolean=true):void
				{
					if (orly)
					{
						muteMusic = true;
						if (musicChannel)
						{
							
							var musicTransform:SoundTransform = musicChannel.soundTransform;
							musicTransform.volume = 0.0;
							musicChannel.soundTransform = musicTransform;
						}
						
						
					} else
					{
						muteMusic = false;
						
						if (musicChannel)
						{
							musicTransform = musicBank[currentMusicId][1];
							musicChannel.soundTransform = musicTransform;
						}
					}
					
					if (save)
					{
						//Player.SaveSoundSettings(muteSounds,muteMusic);
					}
				}
				
				public static function PlayMusic(musicId:int):void
				{
					
					StopMusic();
					currentMusicId = musicId;
					var music:Sound = musicBank[musicId][0];
					var musicTransform:SoundTransform = musicBank[musicId][1];
					
					musicChannel = music.play(0, 999, musicTransform);
					
					if (muteMusic)
					{
						musicTransform = musicChannel.soundTransform;
						musicTransform.volume = 0.0;
						musicChannel.soundTransform = musicTransform;
					}
					
					
					
				}
				
				public static function StopMusic():void
				{
					if (musicChannel)
					{
						musicChannel.stop();
						musicChannel = null;
					}
					
				}
				
				


                // Boom section
                
                // При появлении нового взрыва, он сразу не играется, а информация накапливается в течении
                // логического кванта
                public static function addBoomSoundByPos(soundID : int, pos : Number, pri : int) : void {
					
						if (muteSounds) return;
					
                        var freeIdx : int = getFreeIdxBoom();
                        if (freeIdx >= 0) {
                                // Если из 10 каналов под взрывы есть свободный - запоминаем
                                boomSounds[freeIdx] = getSingleSoundBaseBySoundID(soundID);
                                boomPositions[freeIdx] = pos;
                                boomPriorities[freeIdx] = pri;
                        } else {
                                // Если нет свободного канала, выискиваем ближайший по приоритету
                                // и ближайший по расстоянию
                                var nearestIdx : int = -1;
                                switch (pri) {
                                        case BOOM_PRI_3_HIGHEST:
                                                {
                                                        nearestIdx = getNearestIdxBoomByPri(pos, BOOM_PRI_3_HIGHEST);
                                                }
                                                break;
                                        case BOOM_PRI_2_HIGH:
                                                {
                                                        nearestIdx = getNearestIdxBoomByPri(pos, BOOM_PRI_1_MODERATE);
                                                        if (nearestIdx < 0) {
                                                                nearestIdx = getNearestIdxBoomByPri(pos, BOOM_PRI_2_HIGH);
                                                        }
                                                }
                                                break;
                                        case BOOM_PRI_1_MODERATE:
                                                {
                                                        nearestIdx = getNearestIdxBoomByPri(pos, BOOM_PRI_1_MODERATE);
                                                }
                                                break;
                                        case BOOM_PRI_0_LOW:
                                                {
                                                        nearestIdx = getNearestIdxBoomByPri(pos, BOOM_PRI_0_LOW);
                                                }
                                                break;
                                }
                                // Если ближайший найден, то производим замещение (останавливаем старый, запоминаем новый)
                                if (nearestIdx >= 0) {
                                        //stop old channel
                                        var channelToStop : SoundChannel = boomChannels[nearestIdx];
                                        if (channelToStop != null) {
                                                channelToStop.stop();
                                                channelToStop.removeEventListener(Event.SOUND_COMPLETE, boomSoundCompleteListener);
                                        }
                                        
                                        boomChannels[nearestIdx] = null;
                                        boomSounds[nearestIdx] = getSingleSoundBaseBySoundID(soundID);
                                        boomPositions[nearestIdx] = pos;
                                        boomPriorities[nearestIdx] = pri;
                                }
                                // Если ближайшего так и не нашли, значит по приоритету ему не звучать,
                                // сейчас уже звучат более приоритетные (то-есть заметные немассовые звуки)
                        }
                }

                // В конце логического кванта Сессия вызовет этот метод, чтобы
                // разобраться с запомненными звуками взрывов и проанализировав запустить
                public static function update() : void {
                        var soundBase : Array = null;

                        // Для взрывов юнитов алгоритм похитрее, взрываться юниты могут в большом
                        // количестве и в разных частях экрана одновременно. Поэтому для экономии каналов
                        // и предотвращения какофонии приходится эти звуки сливать подрегулируя громкость
                        // и стереобазу
                        var newUnitBoomCount : int = 0;
                        
                        for (var j : int = 0; j < BOOM_CHANNEL_MAX; j++) {
                                if (
                                
                                                boomSounds[j] != null
                                                && boomPriorities[j] == BOOM_PRI_1_MODERATE
                                                && (boomChannels[j] == null || boomExecutes[j] < 2)
                                                
                                        ) {
                                                
                                        newUnitBoomCount++;
                                        
                                }
                        }
                        
                        var newUnitBoomVolume : Number = 1.0 * UNIT_BOOM_VOLUME;
                        
                        if (newUnitBoomCount > 2) { 
                                newUnitBoomVolume = 2.0 / newUnitBoomCount * UNIT_BOOM_VOLUME;
                        }
                                
                        for (var i : int = 0; i < BOOM_CHANNEL_MAX; i++) {
                                soundBase = boomSounds[i];
                                if (soundBase != null) {
                                        if (boomChannels[i] == null) {
                                                var startTime : Number = soundBase[2];
                                                var sound : Sound = soundBase[0];
                                                
                                                var soundTrans : SoundTransform = soundBase[1];
                                                prepareSTPan(soundTrans, boomPositions[i]);
                                                
                                                if (boomPriorities[i] == BOOM_PRI_1_MODERATE) {
                                                        soundTrans.volume = newUnitBoomVolume; 
                                                }
        
                                                var soundChannel : SoundChannel = sound.play(startTime, 0, soundTrans);
        
                                                if (soundChannel != null) {
                                                        soundChannel.addEventListener(Event.SOUND_COMPLETE, boomSoundCompleteListener);
                                                        boomChannels[i] = soundChannel;                 
                                                        boomExecutes[i] = 1;
                                                }
                                                
                                        } else if (boomPriorities[i] == BOOM_PRI_1_MODERATE) {
                                                if (boomExecutes[i] < 2) {
                                                        tempST = boomChannels[i].soundTransform;
                                                        tempST.volume = newUnitBoomVolume;
                                                        boomChannels[i].soundTransform = tempST;
                                                }
                                                boomExecutes[i] += 1;
                                        }
                        

                                }
                        }
                }
                
                // Листенер по окончанию звука - когда взрыв отгремел - убирает его
                protected static function boomSoundCompleteListener(event : Event) : void {
                        if (!paused) {
                                for (var i : int = 0; i < BOOM_CHANNEL_MAX; i++) {
                                        if (boomChannels[i] == event.target) {
                                                event.target.removeEventListener(Event.SOUND_COMPLETE, boomSoundCompleteListener);
                                                boomChannels[i] = null;         
                                                boomSounds[i] = null;
                                                break;                          
                                        }
                                }
                        }
                        
                }

                // Выдача звука из библиотеки по индексу, или случайного звука из набора, если есть пометка
                protected static function getSingleSoundBaseBySoundID(soundID : int) : Array {
                        var soundBase : Array = null;
                        if (singleSoundBaseGroupMark[soundID]) {
                                var idx : int = Math.floor(Math.random() * singleSoundBase[soundID].length);
                                return singleSoundBase[soundID][idx];
                        } else {
                                return singleSoundBase[soundID];
                        }
                }

                // Получение индекса свободного канала для взрывов, количество которых ограничено
                protected static function getFreeIdxBoom() : int {
                        for (var i : int = 0; i < BOOM_CHANNEL_MAX; i++) {
                                if (boomSounds[i] == null) {
                                        return i;
                                }
                        }
                        return -1;
                }

                // Поиск ближаешего по расстоянию взрыва
                protected static function getNearestIdxBoomByPri(pos : Number, pri : int) : int {
                        var currDist : Number = -1;
                        
                        var nearestIdx : int = -1;
                        var dist : Number = 1000000;
                        
                        for (var i : int = 0; i < BOOM_CHANNEL_MAX; i++) {
                                if (boomPriorities[i] <= pri) {
                                        currDist = Math.abs(boomPositions[i] - pos);
                                        if (currDist < dist) {
                                                dist = currDist;
                                                nearestIdx = i;
                                        }
                                }
                        }
                        return nearestIdx;
                }


                // Запуск незацикленного звука, имеющего позицию на экране: выстрелы, промахи, посадка шаттла, открытие шахты итд, взрывы шаттла, сирена при въезде юнита в шахту
                public static function playSingleSoundByPos(soundID : int, pos : Number) : void {
					
						if (muteSounds) return;
						
                        var soundBase : Array = getSingleSoundBaseBySoundID(soundID);
                        
                        var startTime : Number = soundBase[2];
                        var sound : Sound = soundBase[0];
                        
                        var soundTrans : SoundTransform = soundBase[1];
                        // Рассчет стереобазы в зависимости от положения звука на экране
                        prepareSTPan(soundTrans, pos);
                        
                        var soundChannel : SoundChannel = sound.play(startTime, 0, soundTrans);
                        if (soundChannel != null) {
                                soundChannel.addEventListener(Event.SOUND_COMPLETE, singleSoundCompleteListener);               
                                singleSoundChannels.push(soundChannel);
                                singleSounds.push(sound);
                        }
                }
                
                // Рассчет стереобазы в зависимости от положения звука на экране
                protected static function prepareSTPan(st : SoundTransform, pos : Number) : void {
                        st.pan = (pos / (SCREEN_WIDTH *0.5) - 1.0) * 0.5;
                }


                //  Запуск незацикленных звуков без конкретной позиции на экране: интерфейсные звуки, попадание в станцию
                public static function playSingleSound(soundID : int) : void {
					
						if (muteSounds) return;
					
                        var soundBase : Array = getSingleSoundBaseBySoundID(soundID);
                        
                        var startTime : Number = soundBase[2];
                        var sound : Sound = soundBase[0];
                        
                        var soundTrans : SoundTransform = soundBase[1];
                        soundTrans.pan = 0;
                        
                        var soundChannel : SoundChannel = sound.play(startTime, 0, soundTrans);
                        if (soundChannel != null) {
                                soundChannel.addEventListener(Event.SOUND_COMPLETE, singleSoundCompleteListener);               
                                singleSoundChannels.push(soundChannel);
                                singleSounds.push(sound);
                        }
                        
                }
                
                // Листенер для зачистки звука который отрыграл
                protected static function singleSoundCompleteListener(event : Event) : void {
                        if (!paused) {
                                var singleSoundChannelsLength : int = singleSoundChannels.length;
                                for (var i : int = 0; i < singleSoundChannelsLength; i++) {
                                        if (singleSoundChannels[i] == event.target) {
                                                event.target.removeEventListener(Event.SOUND_COMPLETE, singleSoundCompleteListener);            
                                                singleSoundChannels.splice(i, 1);
                                                singleSounds.splice(i, 1);
                                                break;                          
                                        }
                                }
                        }
                }

                

                // Секция паузы, остановки и зачистки

                // Пауза требует временного срезания листенеров окончания, иначе звуки вместо паузы завершатся
                // Кроме того, приходится для незацикленных звуков спрашивать из позицию, не запоминая ее
                // чтобы она не обнулилась при stop и тогда можно при снятии с паузы запустить новый канал
                // с позиции останова
                public static function setPaused(pausedMode : Boolean) : void {
                        paused = pausedMode;
                        var singleSoundChannelsLength : int = singleSoundChannels.length;
                        var channelToStop : SoundChannel = null;
                        var stopPos : Number = 0.0;
                        if (paused) {
                                for (var j : int = 0; j < singleSoundChannelsLength; j++) {
                                        channelToStop = singleSoundChannels[j];
                                        if (channelToStop != null) {
                                                stopPos = channelToStop.position;
                                                channelToStop.stop();
                                                channelToStop.removeEventListener(Event.SOUND_COMPLETE, singleSoundCompleteListener);
                                        }               
                                }
                                for (j = 0; j < BOOM_CHANNEL_MAX; j++) {
                                        channelToStop = boomChannels[j];
                                        if (channelToStop != null) {
                                                stopPos = channelToStop.position;
                                                channelToStop.stop();
                                                channelToStop.removeEventListener(Event.SOUND_COMPLETE, boomSoundCompleteListener);
                                        }               
                                }
                        } else {
                                var oldChannel : SoundChannel = null;
                                var newChannel : SoundChannel = null;
                                for (var i:int = 0; i < singleSoundChannelsLength; i++) {
                                        oldChannel = singleSoundChannels[i];
                                        newChannel = singleSounds[i].play(oldChannel.position, 0, oldChannel.soundTransform);
                                        if (newChannel != null) { 
                                                singleSoundChannels[i] = newChannel;
                                                newChannel.addEventListener(Event.SOUND_COMPLETE, singleSoundCompleteListener);
                                        } else {
                                                singleSoundChannels[i] = null;
                                        }               
                                }
                                for (i = 0; i < BOOM_CHANNEL_MAX; i++) {
                                        oldChannel = boomChannels[i];
                                        if (oldChannel != null) {
                                                newChannel = boomSounds[i][0].play(oldChannel.position, 0, oldChannel.soundTransform);
                                                if (newChannel != null) { 
                                                        boomChannels[i] = newChannel;
                                                        newChannel.addEventListener(Event.SOUND_COMPLETE, boomSoundCompleteListener);
                                                } else {
                                                        boomChannels[i] = null;         
                                                        boomSounds[i] = null;
                                                }
                                        }               
                                }
                        }
                }

                // Зачистка всего, ибо миссия закончена или прервана
                // Зачистка отличается для ситуаций "были на паузе" или нет
                public static function stopMissionSounds() : void {
                        var singleSoundChannelsLength : int = singleSoundChannels.length;
                        if (!paused) {
                                paused = true;
                                var channelToStop : SoundChannel = null;
                                for (var j : int = 0; j < singleSoundChannelsLength; j++) {
                                        channelToStop = singleSoundChannels[j];
                                        channelToStop.stop();
                                        channelToStop.removeEventListener(Event.SOUND_COMPLETE, singleSoundCompleteListener);           
                                }
                                singleSoundChannels = new Array();
                                singleSounds = new Array();
                                
                                for (j = 0; j < BOOM_CHANNEL_MAX; j++) {
                                        channelToStop = boomChannels[j];
                                        if (channelToStop != null) {
                                                channelToStop.stop();
                                                channelToStop.removeEventListener(Event.SOUND_COMPLETE, boomSoundCompleteListener);             
                                        }
                                        boomChannels[j] = null;         
                                        boomSounds[j] = null;
                                }
                        } else {
                                for (var i:int = 0; i < singleSoundChannelsLength; i++) {
                                        singleSoundChannels[i].removeEventListener(Event.SOUND_COMPLETE, singleSoundCompleteListener);          
                                }
                                singleSoundChannels = new Array();
                                singleSounds = new Array();
                                
                                for (j = 0; j < BOOM_CHANNEL_MAX; j++) {
                                        boomChannels[j] = null;         
                                        boomSounds[j] = null;
                                }
                        }
                        
                        paused = false;
                }
                
                
        }
        
}
