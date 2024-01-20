//
//  SpeechEngineDefines.h
//  SpeechEngine
//
//  Created by fangweiwei on 2020/2/8.
//  Copyright © 2020 fangweiwei. All rights reserved.
//

#ifndef SpeechEngineDefines_h
#define SpeechEngineDefines_h

#import <Foundation/Foundation.h>

#pragma mark - Engine Name

extern NSString* SE_ASR_ENGINE;
extern NSString* SE_CAPT_ENGINE;
extern NSString* SE_TTS_ENGINE;
extern NSString* SE_FULLLINK_ENGINE;
extern NSString* SE_FULLLINK_LITE_ENGINE;
extern NSString* SE_VOICECLONE_ENGINE;
extern NSString* SE_VOICECONV_ENGINE;
extern NSString* SE_RECORDER_ENGINE;
extern NSString* SE_DIALOG_ENGINE;
extern NSString* SE_VAD_ENGINE;
extern NSString* SE_AFP_ENGINE;
extern NSString* SE_AU_ENGINE;
extern NSString* SE_COVERSONG_ENGINE;
extern NSString* SE_HUMMING_ENGINE;

#pragma mark - Log Level

extern NSString* SE_LOG_LEVEL_TRACE;
extern NSString* SE_LOG_LEVEL_DEBUG;
extern NSString* SE_LOG_LEVEL_INFO;
extern NSString* SE_LOG_LEVEL_WARN;
extern NSString* SE_LOG_LEVEL_ERROR;
extern NSString* SE_LOG_LEVEL_FATAL;

#pragma mark - Recorder Type

extern NSString* SE_RECORDER_TYPE_RECORDER;
extern NSString* SE_RECORDER_TYPE_FILE;
extern NSString* SE_RECORDER_TYPE_STREAM;

#pragma mark - Recorder: File Type
typedef enum SERecFileType {
    SERecFileTypeWav = 0,
    SERecFileTypeAac = 1,
} SERecFileType;

#pragma mark - ASR Result Type
extern NSString* SE_ASR_RESULT_TYPE_FULL;
extern NSString* SE_ASR_RESULT_TYPE_SINGLE;

#pragma mark - CAPT: Core Type

extern NSString* SE_CAPT_CORE_TYPE_EN_SENT_SCORE;
extern NSString* SE_CAPT_CORE_TYPE_EN_WORD_SCORE;
extern NSString* SE_CAPT_CORE_TYPE_EN_WORD_PRON;
extern NSString* SE_CAPT_CORE_TYPE_CN_SENT_RAW;

#pragma mark - CAPT: Response Mode

extern NSString* SE_CAPT_RESPONSE_MODE_ONCE;
extern NSString* SE_CAPT_RESPONSE_MODE_STREAMING;

#pragma mark - Asr Work Mode
typedef enum SEAsrWorkMode {
    // Online mode.
    SEAsrWorkModeOnline = 0x01 << 10,
    // Offline mode.
    SEAsrWorkModeOffline = 0x01 << 11,
} SEAsrWorkMode;

#pragma mark - TTS: Text Type

extern NSString* SE_TTS_TEXT_TYPE_PLAIN;
extern NSString* SE_TTS_TEXT_TYPE_SSML;
extern NSString* SE_TTS_TEXT_TYPE_JSON;

#pragma mark - TTS: Scenario Type
extern NSString* SE_TTS_SCENARIO_TYPE_NORMAL;
extern NSString* SE_TTS_SCENARIO_TYPE_NOVEL;

#pragma mark - TTS: Authentication Type
extern NSString* SE_AUTHENTICATE_TYPE_PRE_BIND;
extern NSString* SE_AUTHENTICATE_TYPE_LATE_BIND;

#pragma mark - TTS: Data Callback Mode
/// @abstract Tts data callback mode
/// @discussion Error message will be returned with error code in message, no more explanation here.
typedef enum SETtsDataCallbackMode {
  // no data callback
  SETtsDataCallbackModeNone = 0,
  // only callback in offline tts (current is unsupported)
  SETtsDataCallbackModeOfflineOnly = 1,
  // callback tts data all the time
  SETtsDataCallbackModeAll = 2,
} SETtsDataCallbackMode;

#pragma mark - TTS: Concurrency Mode
/// @abstract Tts concurrency mode
/// @discussion Error message will be returned with error code in message, no more explanation here.
typedef enum SETtsConcurrencyMode {
  // Don't use any concurrency strategy.
  SETtsConcurrencyModeNone = 0,
  // Tts text will be separated by pipe "|".
  SETtsConcurrencyModeSeparateByPipe = 1,
} SETtsConcurrencyMode;

#pragma mark - TTS: Link Type

typedef enum SETtsLinkType {
  kTtsLinkTypeBinary = 0,
  kTtsLinkTypeFulllink = 1,
} SETtsLinkType;

#pragma mark - TTS: Work Mode

typedef enum SETtsWorkMode {
  SETtsWorkModeOnline = 0x01 << 10,
  SETtsWorkModeOffline = 0x01 << 11,
  SETtsWorkModeBoth = 0x01 << 12,
  SETtsWorkModeAlternate = 0x01 << 13,
  SETtsWorkModeFile = 0x01 << 14,
} SETtsWorkMode;

#pragma mark - Kws: Wakeup Mode

extern NSString* SE_WAKEUP_MODE_NORMAL;
extern NSString* SE_WAKEUP_MODE_DISABLED;
extern NSString* SE_WAKEUP_MODE_NIGHT;

#pragma mark - Player: Player Params

extern NSString* SE_PLAYER_SPEED;

#pragma mark - ASR: Scenario
typedef enum SEAsrScenario {
  SEAsrScenarioOneSentence = 0,
  SEAsrScenarioStreaming = 1,
} SEAsrScenario;

#pragma mark - Au abilities.
typedef enum SEAuAbility {
    // Asr ability.
    SEAuAbilityAsr = 0x01 << 0,
    // Music ability.
    SEAuAbilityMusic = 0x01 << 1,
} SEAuAbility;

#pragma mark - Params key: Common

/// @const SE_PARAMS_KEY_ENGINE_NAME_STRING.
/// @abstract Tell the SDK to create a special engine.
/// @discussion Required, choose value from SE_XXX_ENGINE.
extern const NSString* SE_PARAMS_KEY_ENGINE_NAME_STRING;

/// @const SE_PARAMS_KEY_LOG_LEVEL_STRING.
/// @abstract Config the log level of SDK.
/// @discussion Optional, choose value from SE_LOG_LEVEL_XXX.
extern const NSString* SE_PARAMS_KEY_LOG_LEVEL_STRING;

/// @const SE_PARAMS_KEY_DEBUG_PATH_STRING.
/// @abstract Debug path, SDK will save debug info (log file) into this dir if not empty.
/// @discussion Optional, if use it, make sure config info.plist: Application supports iTunes file sharing.
extern const NSString* SE_PARAMS_KEY_DEBUG_PATH_STRING;

/// @const Tracking data path.
/// @abstract Path used to store tracking data, set automatically by platform layer.
/// @discussion Optional, default is empty, configure it before init engine.
extern const NSString* SE_PARAMS_KEY_TRACKING_DATA_PATH_STRING;

/// @const SE_PARAMS_KEY_DEVICE_ID_STRING.
/// @abstract Device id, Used as a unique id to distinguish the device when uploading the user action info.
/// @discussion Optional, default is empty, configure it before init engine.
extern const NSString* SE_PARAMS_KEY_DEVICE_ID_STRING;

/// @const SE_PARAMS_KEY_SAMPLE_RATE_INT.
/// @abstract Audio record sample rate.
/// @discussion Optional, default 16000.
extern const NSString* SE_PARAMS_KEY_SAMPLE_RATE_INT;

/// @const SE_PARAMS_KEY_RECORDER_TYPE_STRING.
/// @abstract This one determines SDK will read data from recorder or file.
/// @discussion Optional, default is: RECORDER_TYPE_RECORDER, configure it before init engine.
extern const NSString* SE_PARAMS_KEY_RECORDER_TYPE_STRING;

/// @const SE_PARAMS_KEY_RECORDER_FILE_STRING.
/// @abstract If the recorder type is RECORDER_TYPE_FILE, will use this file as data source.
/// @discussion Optional, configure it before start engine.
extern const NSString* SE_PARAMS_KEY_RECORDER_FILE_STRING;

/// @const SE_PARAMS_KEY_APP_ID_STRING.
/// @abstract Unique Id for application, apply it to AILab Speech.
/// @discussion Required.
extern const NSString* SE_PARAMS_KEY_APP_ID_STRING;

/// @const SE_PARAMS_KEY_APP_TOKEN_STRING.
/// @abstract Authorization for application, apply it to AILab Speech.
/// @discussion Optional for now.
extern const NSString* SE_PARAMS_KEY_APP_TOKEN_STRING;

/// @const SE_PARAMS_KEY_UID_STRING.
/// @abstract Unique Id for user.
/// @discussion Optional, use this to trace a special user's log.
extern const NSString* SE_PARAMS_KEY_UID_STRING;

/// @const SE_PARAMS_KEY_CHANNEL_NUM_INT.
/// @abstract Number of recorder channel.
/// @discussion Required, 1: mono, 2: stereo.
extern const NSString* SE_PARAMS_KEY_CHANNEL_NUM_INT;

/// @const SE_PARAMS_KEY_UP_CHANNEL_NUM_INT.
/// @abstract Number of recorder channel.
/// @discussion Required, 1: mono, 2: stereo.
extern const NSString* SE_PARAMS_KEY_UP_CHANNEL_NUM_INT;

/// @const SE_PARAMS_KEY_CUSTOM_SAMPLE_RATE_INT.
/// @abstract Sample rate of feed audio.
/// @discussion Required, default is 16000.
extern const NSString* SE_PARAMS_KEY_CUSTOM_SAMPLE_RATE_INT;

/// @const Custom audio channel.
/// @abstract Channel of feed audio.
/// @discussion Default is 1.
extern const NSString* SE_PARAMS_KEY_CUSTOM_CHANNEL_INT;

/// @const SE_PARAMS_KEY_ENABLE_GET_VOLUME_BOOL.
/// @abstract Enable get recoder volume level.
/// @discussion Optional, default is FALSE, config it before start engine.
extern const NSString* SE_PARAMS_KEY_ENABLE_GET_VOLUME_BOOL;

/// @const SE_PARAMS_KEY_ENABLE_AEC_BOOL.
/// @abstract Enable aec.
/// @discussion Optional, default is FALSE, config it before init engine.
extern const NSString* SE_PARAMS_KEY_ENABLE_AEC_BOOL;

/// @const SE_PARAMS_KEY_ENABLE_RESAMPLER_BOOL.
/// @abstract Enable resampler.
/// @discussion Optional, default is FALSE, config it before init engine.
extern const NSString* SE_PARAMS_KEY_ENABLE_RESAMPLER_BOOL;

/// @const SE_PARAMS_KEY_VAD_MAX_SPEECH_DURATION_INT.
/// @abstract If need to limit the max speech duration for recorder, set it.
/// @discussion Optional, default is 150000ms, configure it before start engine.
extern const NSString* SE_PARAMS_KEY_VAD_MAX_SPEECH_DURATION_INT;

/// @const Vad max music duration.
/// @abstract If need to limit the max music duration for recorder, set it.
/// @discussion Optional, default is 12000ms, configure it before start engine.
extern const NSString* SE_PARAMS_KEY_VAD_MAX_MUSIC_DURATION_INT;

/// @const SE_PARAMS_KEY_RESET_AUDIOSESSION_BOOL.
/// @abstract Enable reset audiosession when engine stopped.
/// @discussion Optional, default is FALSE, config it before start engine, only for IOS.
extern const NSString* SE_PARAMS_KEY_RESET_AUDIOSESSION_BOOL;

/// @const SE_PARAMS_KEY_RESTART_AUDIOSESSION_BOOL.
/// @abstract Enable restart audiosession when check record environment.
/// @discussion Optional, default is FALSE, config it before start engine, only for IOS.
extern const NSString* SE_PARAMS_KEY_RESTART_AUDIOSESSION_BOOL;

/// @const SE_PARAMS_KEY_RESUME_OTHERS_INTERRUPTED_PLAYBACK_BOOL.
/// @abstract Enable resume others interrupted playback when stopped.
/// @discussion Optional, default is FALSE, config it before start engine, only for IOS.
extern const NSString* SE_PARAMS_KEY_RESUME_OTHERS_INTERRUPTED_PLAYBACK_BOOL;

/// @const SE_PARAMS_KEY_ENABLE_RECORDER_AUDIO_CALLBACK_BOOL.
/// @abstract If enabled, audio data will be popped through MESSAGE_TYPE_ASR_AUDIO_DATA.
/// @discussion Optional, default is FALSE, configure it before start engine.
extern const NSString* SE_PARAMS_KEY_ENABLE_RECORDER_AUDIO_CALLBACK_BOOL;

/// @const SE_PARAMS_KEY_REC_PATH_STRING.
/// @abstract Recorder path, save wav audio file if not empty.
/// @discussion Optional for RECORDER.
extern const NSString* SE_PARAMS_KEY_REC_PATH_STRING;

/// @const SE_PARAMS_KEY_REC_FILE_TYPE_INT.
/// @abstract Recorder file type, SERecFileTypeWav (default) or SERecFileTypeAac.
/// @discussion Optional for recorder.
extern const NSString* SE_PARAMS_KEY_REC_FILE_TYPE_INT;

/// @const SE_PARAMS_KEY_STOP_RECORD_WHEN_BACKGROUND_BOOL.
/// @abstract Stop recording when enter background
/// @discussion Optional for engines which use recorder, default true, config it before init engine.
extern const NSString* SE_PARAMS_KEY_STOP_RECORD_WHEN_BACKGROUND_BOOL;

/// @const SE_PARAMS_KEY_STOP_RECORD_WHEN_INTERRUPTION_BOOL.
/// @abstract Stop recording when interrupted by another app.
/// @discussion Optional for engines which use recorder, default true, config it before init engine.
extern const NSString* SE_PARAMS_KEY_STOP_RECORD_WHEN_INTERRUPTION_BOOL;

#pragma mark - Params key: Asr

/// @const Asr work mode.
/// @abstract Asr work mode, online or offline.
/// @discussion Optional, default is ONLINE, config it before init engine.
extern const NSString* SE_PARAMS_KEY_ASR_WORK_MODE_INT;

/// @const Asr off resource path.
/// @abstract Asr off resource path, input should be a directory.
/// @discussion Required for ASR in offline mode, config it before init engine.
extern const NSString* SE_PARAMS_KEY_ASR_OFF_RESOURCE_PATH_STRING;

/// @const SE_PARAMS_KEY_ASR_CLUSTER_STRING.
/// @abstract Service cluster for asr egnine.
/// @discussion Required for ASR, apply to AILab Speech.
extern const NSString* SE_PARAMS_KEY_ASR_CLUSTER_STRING;

/// @const SE_PARAMS_KEY_ASR_ADDRESS_STRING.
/// @abstract Service address for asr egnine.
/// @discussion Required for ASR, apply to AILab Speech.
extern const NSString* SE_PARAMS_KEY_ASR_ADDRESS_STRING;

/// @const SE_PARAMS_KEY_ASR_URI_STRING.
/// @abstract Service uri for asr egnine.
/// @discussion Required for ASR, apply to AILab Speech.
extern const NSString* SE_PARAMS_KEY_ASR_URI_STRING;

/// @const Asr language.
/// @abstract Asr audio language.
/// @discussion Optional, default is "", config it before start engine.
extern const NSString* SE_PARAMS_KEY_ASR_LANGUAGE_STRING;

/// vad resource path.
/// Resource path for petrel vad.
/// Required for ASR when in streaming scenario.
extern const NSString* SE_PARAMS_KEY_AED_RESOURCE_PATH_STRING;

/// Asr package size.
/// The size of each packet sent to ASR service.
/// Optional for ASR, default is 80ms.
extern const NSString* SE_PARAMS_KEY_ASR_PACKAGE_SIZE_INT;

/// Asr scenario.
/// Scenario for asr working mode.
/// Optional for ASR, default is 0.
extern const NSString* SE_PARAMS_KEY_ASR_SCENARIO_INT;

/// @const SE_PARAMS_KEY_ASR_CONN_TIMEOUT_INT.
/// @abstract Timeout for creating conntions, milliseconds.
/// @discussion Optional for ASR, default is 12000 ms.
extern const NSString* SE_PARAMS_KEY_ASR_CONN_TIMEOUT_INT;

/// @const SE_PARAMS_KEY_ASR_RECV_TIMEOUT_INT.
/// @abstract Timeout for receiving next data package, milliseconds.
/// @discussion Optional for ASR, default is 8000 ms.
extern const NSString* SE_PARAMS_KEY_ASR_RECV_TIMEOUT_INT;

/// @const SE_PARAMS_KEY_ASR_AUTO_STOP_BOOL.
/// @abstract Enable detecting for speech endpoint.
/// @discussion Optional, default is FALSE, should be enabled for long press asr, config it before start engine.
extern const NSString* SE_PARAMS_KEY_ASR_AUTO_STOP_BOOL;

/// @const SE_PARAMS_KEY_ASR_ENABLE_ITN_BOOL
/// @abstract Enable inverse text normalization.
/// @discussion Optional, default is FALSE, config it before start engine.
extern const NSString* SE_PARAMS_KEY_ASR_ENABLE_ITN_BOOL;

/// @const SE_PARAMS_KEY_ASR_ENABLE_DDC_BOOL
/// @abstract Enable disfluency detection.
/// @discussion Optional, default is FALSE, config it before start engine.
extern const NSString* SE_PARAMS_KEY_ASR_ENABLE_DDC_BOOL;

/// @const SE_PARAMS_KEY_ASR_SHOW_PUNC_BOOL.
/// @abstract Enable showing punctuation in asr results.
/// @discussion Optional, default is FALSE.
extern const NSString* SE_PARAMS_KEY_ASR_SHOW_PUNC_BOOL;

/// @const SE_PARAMS_KEY_ASR_SHOW_NLU_PUNC_BOOL
/// @abstract Asr show punctuation in results.
/// @discussion Optional, default is FALSE. Its priority is higher than OPTIONS_KEY_ASR_SHOW_PUNC_BOOL.
extern const NSString* SE_PARAMS_KEY_ASR_SHOW_NLU_PUNC_BOOL;

/// @const SE_PARAMS_KEY_ASR_SHOW_UTTER_BOOL.
/// @abstract Enable showing utterances in asr results.
/// @discussion Optional, default is FALSE, config it before start engine.
extern const NSString* SE_PARAMS_KEY_ASR_SHOW_UTTER_BOOL;

/// @const Asr show language.
/// @abstract Enable showing language details in asr results.
/// @discussion Optional, default is FALSE.
extern const NSString* SE_PARAMS_KEY_ASR_SHOW_LANG_BOOL;

/// @const Asr show volume.
/// @abstract Enable showing volume value in asr results.
/// @discussion Optional, default is FALSE.
extern const NSString* SE_PARAMS_KEY_ASR_SHOW_VOLUME_BOOL;

/// @const SE_PARAMS_KEY_ASR_KEEP_RECORDING_BOOL.
/// @abstract If enabled, the recorder will continue work even encounter error.
/// @discussion Optional, default is FALSE.
extern const NSString* SE_PARAMS_KEY_ASR_KEEP_RECORDING_BOOL;

/// @const SE_PARAMS_KEY_ASR_REC_PATH_STRING.
/// @abstract Recorder path, save wav audio file if not empty.
/// @discussion Optional for ASR.
extern const NSString* SE_PARAMS_KEY_ASR_REC_PATH_STRING;

/// @const Asr vad start silence time.
/// @abstract Asr vad empty audio time limit, Unit: ms.
/// @discussion Optional for ASR, default is 0.
extern const NSString* SE_PARAMS_KEY_ASR_VAD_START_SILENCE_TIME_INT;

/// @const Asr vad end silence time.
/// @abstract Asr vad end time limit, Unit: ms.
/// @discussion Optional for ASR, default is 0.
extern const NSString* SE_PARAMS_KEY_ASR_VAD_END_SILENCE_TIME_INT;

/// @const Asr vad mode.
/// @abstract Vad mode for asr engine.
/// @discussion Optional for ASR, default is "", apply to AILab Speech.
extern const NSString* SE_PARAMS_KEY_ASR_VAD_MODE_STRING;

/// Asr Result Type.
/// Asr result type in response, <single|full>.
/// Optional for ASR, default is full, configure it before start engine.
extern const NSString* SE_PARAMS_KEY_ASR_RESULT_TYPE_STRING;

/// Asr correct words.
/// Optional for ASR, for example:@"{\"星球崛起\":\"猩球崛起\"}" , configure it before start engine.
extern const NSString* SE_PARAMS_KEY_ASR_CORRECT_WORDS_STRING;

/// Asr max retry times.
/// Optional for ASR, default is 0, configure it before start engine.
extern const NSString* SE_PARAMS_KEY_ASR_MAX_RETRY_TIMES_INT;

/// Vad rec path.
/// Recorder path, save wav audio file if not empty.
/// Optional for Vad.
extern const NSString* SE_PARAMS_KEY_VAD_REC_PATH_STRING;

/// Vad head silence threshold.
/// Head silence threshold of vad, units: ms.
/// Optional for Vad, default is: 4000, configure it before init engine.
extern const NSString* SE_PARAMS_KEY_VAD_HEAD_SILENCE_THRESHOLD_INT;

/// Vad tail silence threshold.
/// Tail silence threshold of vad, units: ms.
/// Optional for Vad, default is: 2000, configure it before init engine.
extern const NSString* SE_PARAMS_KEY_VAD_TAIL_SILENCE_THRESHOLD_INT;

#pragma mark - Params key: Capt

/// @const SE_PARAMS_KEY_CAPT_CLUSTER_STRING.
/// @abstract Service cluster for capt egnine.
/// @discussion Required for CAPT, apply to AILab Speech, can be configured before start engine.
extern const NSString* SE_PARAMS_KEY_CAPT_CLUSTER_STRING;

/// @const SE_PARAMS_KEY_CAPT_ADDRESS_STRING.
/// @abstract Service address for capt egnine.
/// @discussion Required for CAPT, apply to AILab Speech.
extern const NSString* SE_PARAMS_KEY_CAPT_ADDRESS_STRING;

/// @const SE_PARAMS_KEY_CAPT_URI_STRING.
/// @abstract Service uri for capt egnine.
/// @discussion Required for CAPT, apply to AILab Speech.
extern const NSString* SE_PARAMS_KEY_CAPT_URI_STRING;

/// @const SE_PARAMS_KEY_CAPT_SCENE_STRING.
/// @abstract The scene for capt egnine.
/// @discussion Optional for CAPT, negotiate with AILab Speech.
extern const NSString* SE_PARAMS_KEY_CAPT_SCENE_STRING;

/// @const SE_PARAMS_KEY_CAPT_CONN_TIMEOUT_INT.
/// @abstract Timeout for creating conntions, milliseconds.
/// @discussion Optional for CAPT, default is 12000 ms.
extern const NSString* SE_PARAMS_KEY_CAPT_CONN_TIMEOUT_INT;

/// @const SE_PARAMS_KEY_CAPT_RECV_TIMEOUT_INT.
/// @abstract Timeout for receiving next data package, milliseconds.
/// @discussion Optional for CAPT, default is 8000 ms.
extern const NSString* SE_PARAMS_KEY_CAPT_RECV_TIMEOUT_INT;

/// @const SE_PARAMS_KEY_CAPT_REFER_TEXT_STRING.
/// @abstract Reference text for a capt request.
/// @discussion Required for CAPT, configure it before start engine.
extern const NSString* SE_PARAMS_KEY_CAPT_REFER_TEXT_STRING;

/// @const SE_PARAMS_KEY_CAPT_REC_PATH_STRING.
/// @abstract Recorder path, save wav audio file if not empty.
/// @discussion Optional for CAPT.
extern const NSString* SE_PARAMS_KEY_CAPT_REC_PATH_STRING;

/// @const SE_PARAMS_KEY_CAPT_CORE_TYPE_STRING.
/// @abstract Core type for a capt request.
/// @discussion Optional for CAPT, default is SE_CAPT_CORE_TYPE_EN_SENT_SCORE.
extern const NSString* SE_PARAMS_KEY_CAPT_CORE_TYPE_STRING;

/// @const SE_PARAMS_KEY_CAPT_DIFFICULTY_INT.
/// @abstract Difficulty for a capt request.
/// @discussion Optional for CAPT, default is 2.
extern const NSString* SE_PARAMS_KEY_CAPT_DIFFICULTY_INT;

/// @const SE_PARAMS_KEY_CAPT_RESPONSE_MODE_STRING.
/// @abstract Response mode, SE_CAPT_RESPONSE_MODE_ONCE: only final result; SE_CAPT_RESPONSE_MODE_STREAMING: partial and final.
/// @discussion Optional for CAPT, default is SE_CAPT_RESPONSE_MODE_ONCE.
extern const NSString* SE_PARAMS_KEY_CAPT_RESPONSE_MODE_STRING;

/// @const SE_PARAMS_KEY_CAPT_AUTO_STOP_BOOL.
/// @abstract Enable detecting for speech endpoint.
/// @discussion Optional, default is FALSE, config it before start engine.
extern const NSString* SE_PARAMS_KEY_CAPT_AUTO_STOP_BOOL;

#pragma mark - Params key: Fulllink

/// @const SE_PARAMS_KEY_FULLLINK_ADDRESS_STRING.
/// @abstract Service address for fulllink egnine.
/// @discussion Required for FULLLINK, apply to AILab Speech.
extern const NSString* SE_PARAMS_KEY_FULLLINK_ADDRESS_STRING;

/// @const SE_PARAMS_KEY_FULLLINK_URI_STRING.
/// @abstract Service uri for fulllink egnine.
/// @discussion Required for FULLLINK, apply to AILab Speech.
extern const NSString* SE_PARAMS_KEY_FULLLINK_URI_STRING;

/// @const SE_PARAMS_KEY_FULLLINK_QUERY_STRING_STRING.
/// @abstract Query string added to url.
/// @discussion Optional for FULLLINK, configure it before start engine.
extern const NSString* SE_PARAMS_KEY_FULLLINK_QUERY_STRING_STRING;

/// @const SE_PARAMS_KEY_FULLLINK_CLUSTER_STRING.
/// @abstract Cluster for fulllink egnine boe environment.
/// @discussion Optional for FULLLINK, apply to AILab Speech.
extern const NSString* SE_PARAMS_KEY_FULLLINK_CLUSTER_STRING;

/// @const SE_PARAMS_KEY_FULLLINK_CONN_TIMEOUT_INT.
/// @abstract Timeout for creating conntions, milliseconds.
/// @discussion Optional for FULLLINK, default is 3000 ms.
extern const NSString* SE_PARAMS_KEY_FULLLINK_CONN_TIMEOUT_INT;

/// @const SE_PARAMS_KEY_FULLLINK_RECV_TIMEOUT_INT.
/// @abstract Timeout for receiving next data package, milliseconds.
/// @discussion Optional for FULLLINK, default is 5000 ms.
extern const NSString* SE_PARAMS_KEY_FULLLINK_RECV_TIMEOUT_INT;

/// @const SE_PARAMS_KEY_FULLLINK_USER_PARAM_STRING.
/// @abstract User param used for NLU.
/// @discussion Required for FULLLINK.
extern const NSString* SE_PARAMS_KEY_FULLLINK_USER_PARAM_STRING;

/// @const SE_PARAMS_KEY_FULLLINK_VAD_HEAD_WAIT_TIME_INT.
/// @abstract Vad wait for head silence.
/// @discussion Optional for FULLLINK, default is 8000 ms.
extern const NSString* SE_PARAMS_KEY_FULLLINK_VAD_HEAD_WAIT_TIME_INT;

/// @const SE_PARAMS_KEY_FULLLINK_FILTER_WAKEUP_WORD_STRING.
/// @abstract Set is false to Y6, other is true.
/// @discussion Optional for FULLLINK, default is true.
extern const NSString* SE_PARAMS_KEY_FULLLINK_FILTER_WAKEUP_WORD_STRING;

/// @const SE_PARAMS_KEY_FULLLINK_SCENE_ID_STRING.
/// @abstract Change asr scene.
/// @discussion Optional for FULLLINK, default is general.
extern const NSString* SE_PARAMS_KEY_FULLLINK_SCENE_ID_STRING;

/// @const SE_PARAMS_KEY_FULLLINK_ASR_ONLY_BOOL.
/// @abstract Only asr, without nlp and tts.
/// @discussion Optional for FULLLINK, default is false.
extern const NSString* SE_PARAMS_KEY_FULLLINK_ASR_ONLY_BOOL;

/// @const SE_PARAMS_KEY_FULLLINK_ASR_AUTO_STOP_BOOL.
/// @abstract Only asr, auto stop enable or not.
/// @discussion Optional for FULLLINK, default is false.
extern const NSString* SE_PARAMS_KEY_FULLLINK_ASR_AUTO_STOP_BOOL;

/// @const SE_PARAMS_KEY_FULLLINK_DISABLE_TTS_BOOL.
/// @abstract Disable tts, keep asr and nlp.
/// @discussion Optional for FULLLINK, default is false.
extern const NSString* SE_PARAMS_KEY_FULLLINK_DISABLE_TTS_BOOL;

#pragma mark - Params key: Tts

/// @const SE_PARAMS_KEY_TTS_CLUSTER_STRING.
/// @abstract Service cluster for tts egnine.
/// @discussion Required for TTS, apply to AILab Speech.
extern const NSString* SE_PARAMS_KEY_TTS_CLUSTER_STRING;

/// @const SE_PARAMS_KEY_TTS_BACKEND_CLUSTER_STRING.
/// @abstract Service cluster for tts backend. When SE_PARAMS_KEY_TTS_CLUSTER_STRING is just a proxy, use backend-cluster to tell proxy which cluster to find.
/// @discussion Optional for TTS, apply to AILab Speech.
extern const NSString* SE_PARAMS_KEY_TTS_BACKEND_CLUSTER_STRING;

/// @const SE_PARAMS_KEY_TTS_ADDRESS_STRING.
/// @abstract Service address for tts egnine.
/// @discussion Required for TTS, apply to AILab Speech.
extern const NSString* SE_PARAMS_KEY_TTS_ADDRESS_STRING;

/// @const SE_PARAMS_KEY_TTS_URI_STRING.
/// @abstract Service uri for uri egnine.
/// @discussion Required for TTS, apply to AILab Speech.
extern const NSString* SE_PARAMS_KEY_TTS_URI_STRING;

/// @const Tts connection timeout.
/// @abstract Timeout for creating conntions, milliseconds.
/// @discussion Optional for TTS, default is 12000 ms, configure it before init engine.
extern const NSString* SE_PARAMS_KEY_TTS_CONN_TIMEOUT_INT;

/// @const Tts receive timeout.
/// @abstract Timeout for receiving next data package, milliseconds.
/// @discussion Optional for TTS, default is 8000 ms, configure it before init engine.
extern const NSString* SE_PARAMS_KEY_TTS_RECV_TIMEOUT_INT;

/// @const SE_PARAMS_KEY_TTS_VOICE_ONLINE_STRING.
/// @abstract The voice of synthesised audio used in online.
/// @discussion Required for TTS, default is other, configure it before start engine.
extern const NSString* SE_PARAMS_KEY_TTS_VOICE_ONLINE_STRING;

/// @const SE_PARAMS_KEY_TTS_VOICE_TYPE_ONLINE_STRING.
/// @abstract The voice type of synthesised audio used in online.
/// @discussion Required for TTS, default is BHV002_streaming_fast, configure it before start engine.
extern const NSString* SE_PARAMS_KEY_TTS_VOICE_TYPE_ONLINE_STRING;

/// @const SE_PARAMS_KEY_TTS_VOICE_OFFLINE_STRING.
/// @abstract The voice of synthesised audio used in offline.
/// @discussion Required for TTS, default is other, configure it before start engine.
extern const NSString* SE_PARAMS_KEY_TTS_VOICE_OFFLINE_STRING;

/// @const SE_PARAMS_KEY_TTS_VOICE_TYPE_OFFLINE_STRING.
/// @abstract The voice type of synthesised audio used in offline.
/// @discussion Required for TTS, default is BHV002_streaming_fast, configure it before start engine.
extern const NSString* SE_PARAMS_KEY_TTS_VOICE_TYPE_OFFLINE_STRING;

/// @const SE_PARAMS_KEY_TTS_LANGUAGE_ONLINE_STRING.
/// @abstract The language of synthesised audio used in online.
/// @discussion Optional for TTS, configure it before start engine.
extern const NSString* SE_PARAMS_KEY_TTS_LANGUAGE_ONLINE_STRING;

/// @const Tts emotion.
/// @abstract Emotion used by tts online, substitute tts_style.
/// @discussion Optional for TTS, default is empty, configure it before start engine.
extern const NSString* SE_PARAMS_KEY_TTS_EMOTION_STRING;

/// @const SE_PARAMS_KEY_TTS_SPEED_INT.
/// @abstract The speed of synthesised audio.
/// @discussion Required for TTS, default is 10, configure it before start engine.
extern const NSString* SE_PARAMS_KEY_TTS_SPEED_INT;

/// @const SE_PARAMS_KEY_TTS_VOLUME_INT.
/// @abstract The volume of synthesised audio.
/// @discussion Required for TTS, default is 10, configure it before start engine.
extern const NSString* SE_PARAMS_KEY_TTS_VOLUME_INT;

/// @const SE_PARAMS_KEY_TTS_PITCH_INT.
/// @abstract The pitch of synthesised audio.
/// @discussion Required for TTS, default is 10, configure it before start engine.
extern const NSString* SE_PARAMS_KEY_TTS_PITCH_INT;

/// @const SE_PARAMS_KEY_TTS_SAMPLE_RATE_INT.
/// @abstract The sample rate for player.
/// @discussion Optionnal for TTS, default is 24000.
extern const NSString* SE_PARAMS_KEY_TTS_SAMPLE_RATE_INT;

/// @const SE_PARAMS_KEY_TTS_COMPRESSION_RATE_INT.
/// @abstract The compression rate for tts audio data.
/// @discussion Required for TTS, default is 1.
extern const NSString* SE_PARAMS_KEY_TTS_COMPRESSION_RATE_INT;

/// @const SE_PARAMS_KEY_TTS_TEXT_STRING.
/// @abstract Text to do synthesis.
/// @discussion Required for TTS, configure it before start engine.
extern const NSString* SE_PARAMS_KEY_TTS_TEXT_STRING;

/// @const SE_PARAMS_KEY_TTS_TEXT_TYPE_STRING.
/// @abstract Text type, support plain/ssml/json.
/// @discussion Required for TTS, default is plain, configure it before start engine.
extern const NSString* SE_PARAMS_KEY_TTS_TEXT_TYPE_STRING;

/// @const SE_PARAMS_KEY_TTS_STYLE_NAME_STRING.
/// @abstract TTts style name, example: neutral, happy, sad.
/// @discussion Required for TTS, default is empty, configure it before start engine.
extern const NSString *SE_PARAMS_KEY_TTS_STYLE_NAME_STRING
    __attribute__((deprecated("This parameter is deprecated.")));

/// @const SE_PARAMS_KEY_TTS_REQUEST_ID_STRING.
/// @abstract Unique id to identify a single request.
/// @discussion Optional for TTS, if empty, engine will generate one for you.
extern const NSString* SE_PARAMS_KEY_TTS_REQUEST_ID_STRING;

/// @const SE_PARAMS_KEY_TTS_WITH_FRONTEND_INT.
/// @abstract Parameter when use TTS online, default is 0, use 1 when you want receive playing
/// progress callback.
/// @discussion Optional for online TTS, config it before init engine.
extern const NSString* SE_PARAMS_KEY_TTS_WITH_FRONTEND_INT;

/// @const Parameter when use TTS online.
/// @abstract Default is 0, use 1 when you want resume tts playback from breakpoint.
/// @discussion Optional for TTS alternate mode, config it before init engine.
extern const NSString *SE_PARAMS_KEY_TTS_WITH_TIMESTAMP_INT;

/// @const SE_PARAMS_KEY_TTS_FRONTEND_TYPE_STRING
/// Parameter when use TTS online
/// Default is empty string, need to set tts_with_frontend to 1 before.
/// Optional for online TTS, config it before init engine.
extern const NSString* SE_PARAMS_KEY_TTS_FRONTEND_TYPE_STRING;

/// @const SE_PARAMS_KEY_TTS_WITH_INTENT_BOOL.
/// @abstract Parameter means if enable intent prediction from server.
/// @discussion Optional for online TTS, default is false, config it before start engine.
extern const NSString* SE_PARAMS_KEY_TTS_WITH_INTENT_BOOL;

/// @const Parameter used by both TTS online and offline.
/// @abstract Default is 1, use 1 when you want disable the automatic split sentence.
/// @discussion Optional for TTS, config it before start.
extern const NSString* SE_PARAMS_KEY_TTS_SPLIT_SENTENCE_INT;

/// @const SE_PARAMS_KEY_TTS_FADEOUT_DURATION_INT
/// Tts fadeout duration
/// The duration of the online tts audio fade-out when resuming from breakpoint.
/// Optional for online TTS, default is 30ms, config it before init engine.
extern const NSString* SE_PARAMS_KEY_TTS_FADEOUT_DURATION_INT;

/// @const SE_PARAMS_KEY_TTS_FADEIN_DURATION_INT
/// Tts fadein duration
/// The duration of offline tts fade-in audio when resuming from a breakpoint.
/// Optional for online TTS, default is 30ms, config it before init engine.
extern const NSString* SE_PARAMS_KEY_TTS_FADEIN_DURATION_INT;

/// @const SE_PARAMS_KEY_TTS_LIMIT_CPU_USAGE_BOOL.
/// @abstract Parameter means whether to limit offline synethesising CPU usage.
/// @discussion Optional for online TTS, default is false, config it before start engine.
extern const NSString* SE_PARAMS_KEY_TTS_LIMIT_CPU_USAGE_BOOL;

/// @const SE_PARAMS_KEY_TTS_ENABLE_PLAYER_BOOL.
/// @abstract Enable player, will start playing automatically..
/// @discussion Required for TTS, default is false.
extern const NSString* SE_PARAMS_KEY_TTS_ENABLE_PLAYER_BOOL;

/// @const SE_PARAMS_KEY_TTS_AUDIO_PATH_STRING.
/// @abstract Synthesis audio path, save wav audio file if not empty.
/// @discussion Optional for TTS, default is empty.
extern const NSString* SE_PARAMS_KEY_TTS_AUDIO_PATH_STRING;

/// @const SE_PARAMS_KEY_TTS_AUDIO_FILE_STRING.
/// @abstract Synthesis will use this file to play in SETtsWorkModeFile.
/// @discussion Optional for TTS.
extern const NSString *SE_PARAMS_KEY_TTS_AUDIO_FILE_STRING;

/// @const SE_PARAMS_KEY_TTS_SILENCE_DURATION_INT.
/// @abstract Tts silence dutation, The length of silence data.
/// @discussion Optional for TTS, default is -1.
extern const NSString* SE_PARAMS_KEY_TTS_SILENCE_DURATION_INT;

/// @const SE_PARAMS_KEY_TTS_WORK_MODE_INT.
/// @abstract Tts work mode, default is online, <online, offline, both, alternate>
/// @discussion Optional for TTS, confit it before init engine.
extern const NSString* SE_PARAMS_KEY_TTS_WORK_MODE_INT;

/// @const SE_PARAMS_KEY_TTS_OFF_RESOURCE_PATH_STRING.
/// @abstract Tts offline resource path
/// @discussion Required for TTS when work mode isn't online, confit it before init engine.
extern const NSString* SE_PARAMS_KEY_TTS_OFF_RESOURCE_PATH_STRING;

/// @const SE_PARAMS_KEY_TTS_ENABLE_DUMP_BOOL.
/// @abstract Enable dump, save audio as a wav file named "tts_reqid.wav".
/// @discussion Required for TTS, required audio path, default is false, config it before start engine.
extern const NSString* SE_PARAMS_KEY_TTS_ENABLE_DUMP_BOOL;

/// @const SE_PARAMS_KEY_TTS_SCENARIO_STRING.
/// @abstract Scenario for TTS, continuous synthesis or single synthesis.
/// @discussion Optional for TTS, default is normal, config it before start engine.
extern const NSString* SE_PARAMS_KEY_TTS_SCENARIO_STRING;

/// @const SE_PARAMS_KEY_TTS_CONCURRENCY_MODE_INT.
/// @abstract Value 1 means enable concurrency processor, text should divided by "|". Temporarily only available for tts engine.
/// @discussion Optional for TTS, default is 0, means disabled concurrency, config it before start engine.
extern const NSString* SE_PARAMS_KEY_TTS_CONCURRENCY_MODE_INT;

/// @const SE_PARAMS_KEY_TTS_BUSINESS_STRING.
/// @abstract Tts business param, means which kind of strategy will be used for specific business.
/// @discussion Optional for TTS, default is "", config it before start engine.
extern const NSString* SE_PARAMS_KEY_TTS_BUSINESS_STRING;

/// @const SE_PARAMS_KEY_TTS_ENABLE_CACHE_BOOL.
/// @abstract Tts enable cache, if use cache for tts process.
/// @discussion Optional for TTS, default is false, config it before start engine.
extern const NSString* SE_PARAMS_KEY_TTS_ENABLE_CACHE_BOOL;

#pragma mark - Params key: Kws

/// @const SE_PARAMS_KEY_KWS_ROOT_PATH_STRING
/// @abstract The path for kws modules.
/// @discussion Required for FULLLINK.
extern const NSString* SE_PARAMS_KEY_KWS_ROOT_PATH_STRING;

/// @const SE_PARAMS_KEY_SIGNAL_ROOT_PATH_STRING
/// @abstract The path for signal models.
/// @discussion Required for FULLLINK.
extern const NSString* SE_PARAMS_KEY_SIGNAL_ROOT_PATH_STRING;

/// @const Tts audio data callback mode.
/// @abstract If callback tts audio data.
/// @discussion Optional for TTS, default is SETtsDataCallbackModeNone, config it before start engine.
extern const NSString* SE_PARAMS_KEY_TTS_DATA_CALLBACK_MODE_INT;

/// Audio cache path.
/// Audio cache folder which store database file.
/// Optional for only TTS engine, default is "", config it before init engine.
extern const NSString* SE_PARAMS_KEY_TTS_AUDIO_CACHE_PATH_STRING;

/// Enable resume from breakpoint.
/// If enable resume playback from previous progress when use audio cache.
/// Optional for only TTS engine, default is false, config it before init engine.
extern const NSString *SE_PARAMS_KEY_ENABLE_RESUME_FROM_LAST_PROGRESS_BOOL;

/// Max cached audio num.
/// Maximum number of cached audio item.
/// Optional for only TTS engine, default is 100, config it before init engine.
extern const NSString* SE_PARAMS_KEY_TTS_MAX_CACHED_AUDIO_NUM_INT;

/// Cache renewal duration.
/// The renewal duration of each use of the cache, unit:seconds.
/// Optional for only TTS engine, default is 24*3600, config it before init engine.
extern const NSString* SE_PARAMS_KEY_TTS_CACHE_RENEWAL_DURATION_INT;

/// @const SE_PARAMS_KEY_AUTHENTICATE_TYPE_STRING.
/// @abstract type for authenticate, default is \"pre_bind\", also can be \"late_bind\"
/// @discussion Required in ToB project, configure it before init engine
extern const NSString* SE_PARAMS_KEY_AUTHENTICATE_TYPE_STRING;

/// @const SE_PARAMS_KEY_BUSINESS_KEY_STRING.
/// @abstract key for authentication
/// @discussion Required in ToB project, configure it before init engine
extern const NSString* SE_PARAMS_KEY_BUSINESS_KEY_STRING;

/// @const SE_PARAMS_KEY_AUTHENTICATE_SECRET_STRING.
/// @abstract Secret code for authentication
/// @discussion Required in ToB project, configure it before init engine
extern const NSString* SE_PARAMS_KEY_AUTHENTICATE_SECRET_STRING;

/// @const SE_PARAMS_KEY_AUTHENTICATE_CREDENTIAL_STRING.
/// @abstract Key used in late_bind authentication.
/// After setting, it will be used as the unique ID of the device during the
/// authentication process.
/// @discussion Optional in ToB project when authenticate_type equals late_bind,
/// configure it before init engine.
extern const NSString *SE_PARAMS_KEY_AUTHENTICATE_CREDENTIAL_STRING;

/// @const SE_PARAMS_KEY_LICENSE_DIRECTORY_STRING.
/// @abstract License file directory
/// @discussion Required in ToB project, configure it before init engine
extern const NSString* SE_PARAMS_KEY_LICENSE_DIRECTORY_STRING;

/// @const SE_PARAMS_KEY_LICENSE_BUSI_ID_STRING.
/// @abstract The scenario id acquired after applying
/// @discussion Required in ToB project, configure it before init engine
extern const NSString* SE_PARAMS_KEY_LICENSE_BUSI_ID_STRING;

/// @const SE_PARAMS_KEY_LICENSE_NAME_STRING.
/// @abstract The name displayed in license server
/// @discussion Required in ToB project, configure it before init engine
extern const NSString* SE_PARAMS_KEY_LICENSE_NAME_STRING;

/// @const SE_PARAMS_KEY_AUTHENTICATE_ADDRESS_STRING.
/// @abstract Authentication server address
/// @discussion Required in ToB project, configure it before init engine
extern const NSString* SE_PARAMS_KEY_AUTHENTICATE_ADDRESS_STRING;

/// @const SE_PARAMS_KEY_AUTHENTICATE_URI_STRING.
/// @abstract uri for download license file
/// @discussion Required in ToB project, configure it before init engine
extern const NSString* SE_PARAMS_KEY_AUTHENTICATE_URI_STRING;

/// @const SE_PARAMS_KEY_TTS_USE_VOICECLONE_BOOL.
/// @abstract If tts use voiceclone-trained voice type or not.
/// @discussion Optional for TTS, default is false, config it before start engine.
extern const NSString* SE_PARAMS_KEY_TTS_USE_VOICECLONE_BOOL;

/// @const SE_PARAMS_KEY_TTS_CONN_TIMEOUT_INT.
/// @abstract Tts connection timeout.
/// @discussion Optional for TTS, default is 12000ms, config it before init engine.
extern const NSString* SE_PARAMS_KEY_TTS_CONN_TIMEOUT_INT;

/// @const SE_PARAMS_KEY_TTS_RECV_TIMEOUT_INT.
/// @abstract Tts receive timeout.
/// @discussion Optional for TTS, default is 8000ms, config it before init engine.
extern const NSString* SE_PARAMS_KEY_TTS_RECV_TIMEOUT_INT;

/// @const SE_PARAMS_KEY_VOICECLONE_ADDRESS_STRING.
/// @abstract Service address for VoiceClone engine. Used for http/https request.
/// @discussion Required for VoiceClone, config it before init engine.
extern const NSString* SE_PARAMS_KEY_VOICECLONE_ADDRESS_STRING;

/// @const SE_PARAMS_KEY_VOICECLONE_STREAM_ADDRESS_STRING.
/// @abstract Stream address for VoiceClone engine. Used for record analysis.
/// @discussion Required for VoiceClone, config it before init engine.
extern const NSString* SE_PARAMS_KEY_VOICECLONE_STREAM_ADDRESS_STRING;

/// @const SE_PARAMS_KEY_VOICECLONE_ENABLE_DUMP_BOOL.
/// @abstract Enable record dump file.
/// @discussion Optional for VoiceClone, config it before init engine.
extern const NSString* SE_PARAMS_KEY_VOICECLONE_ENABLE_DUMP_BOOL;

/// @const SE_PARAMS_KEY_VOICECLONE_CONN_TIMEOUT_INT.
/// @abstract Timeout for creating conntions, milliseconds.
/// @discussion Optional for VOICECLONE, default is 12000 ms.
extern const NSString* SE_PARAMS_KEY_VOICECLONE_CONN_TIMEOUT_INT;

/// @const SE_PARAMS_KEY_VOICECLONE_RECV_TIMEOUT_INT.
/// @abstract Timeout for receiving next data package, milliseconds.
/// @discussion Optional for VOICECLONE, default is 8000 ms.
extern const NSString* SE_PARAMS_KEY_VOICECLONE_RECV_TIMEOUT_INT;

/// @const SE_PARAMS_KEY_VOICECLONE_REC_PATH_STRING.
/// @abstract The directory path for dump file.
/// @discussion Optional for VoiceClone, config it before init engine.
extern const NSString* SE_PARAMS_KEY_VOICECLONE_REC_PATH_STRING;

/// @const SE_PARAMS_KEY_VOICECLONE_GENDER_BOOL.
/// @abstract Marker the user gender, false for male, true for female.
/// @discussion Required for VoiceClone GetTask, config it before start engine.
extern const NSString* SE_PARAMS_KEY_VOICECLONE_GENDER_BOOL;

/// @const SE_PARAMS_KEY_VOICECLONE_QUERY_UIDS_STRING.
/// @abstract VoiceClone uids, multi uids joined by ';'.
/// @discussion Required for VoiceClone GetTrainStatus, config it before start engine.
extern const NSString* SE_PARAMS_KEY_VOICECLONE_QUERY_UIDS_STRING;

/// @const SE_PARAMS_KEY_VOICECLONE_TEXT_STRING.
/// @abstract VoiceClone reading text, read the text during voiceclone task.
/// @discussion Required for VoiceClone, config it before start engine.
extern const NSString* SE_PARAMS_KEY_VOICECLONE_TEXT_STRING;

/// @const SE_PARAMS_KEY_VOICECLONE_TEXT_SEQ_INT.
/// @abstract VoiceClone text sequence number in voiceclone task. Same as the index in text array.
/// @discussion Required for VoiceClone, config it before start engine.
extern const NSString* SE_PARAMS_KEY_VOICECLONE_TEXT_SEQ_INT;

/// @const SE_PARAMS_KEY_VOICECLONE_TASKID_INT.
/// @abstract VoiceClone task_id, mark one kind of voiceclone train task.
/// @discussion Required for VoiceClone, config it before start engine.
extern const NSString* SE_PARAMS_KEY_VOICECLONE_TASKID_INT;

/// @const SE_PARAMS_KEY_VOICECLONE_VOICE_TYPE_STRING.
/// @abstract When submit task, use VOICECLONE_VOICE_TYPE to custom the name of voice,
///           which will be used for tts_engine as tts_voice_type param. If empty, service
///           will generate uuid randomly as voice_type
/// @discussion Optional for VoiceClone Task Submit, config it before start engine.
extern const NSString* SE_PARAMS_KEY_VOICECLONE_VOICE_TYPE_STRING;

/// @const SE_PARAMS_KEY_VOICECONV_ADDRESS_STRING.
/// @abstract Service address for VoiceConv engine.
/// @discussion Required for VoiceConv, apply to AILab Speech.
extern const NSString* SE_PARAMS_KEY_VOICECONV_ADDRESS_STRING;

/// @const SE_PARAMS_KEY_VOICECONV_URI_STRING.
/// @abstract Service uri for VoiceConv engine.
/// @discussion Required for VoiceConv, apply to AILab Speech.
extern const NSString* SE_PARAMS_KEY_VOICECONV_URI_STRING;

/// @const SE_PARAMS_KEY_VOICECONV_CLUSTER_STRING.
/// @abstract Service cluster for VoiceConv engine.
/// @discussion Required for VoiceConv, apply to AILab Speech.
extern const NSString* SE_PARAMS_KEY_VOICECONV_CLUSTER_STRING;

/// @const SE_PARAMS_KEY_VOICECONV_VOICE_STRING.
/// @abstract Service voice for VoiceConv engine.
/// @discussion Required for VoiceConv, apply to AILab Speech.
extern const NSString* SE_PARAMS_KEY_VOICECONV_VOICE_STRING;

/// @const SE_PARAMS_KEY_VOICECONV_VOICE_TYPE_STRING.
/// @abstract Service voice type for VoiceConv engine.
/// @discussion Required for VoiceConv, apply to AILab Speech.
extern const NSString* SE_PARAMS_KEY_VOICECONV_VOICE_TYPE_STRING;

/// @const SE_PARAMS_KEY_VOICECONV_RESULT_SAMPLE_RATE_INT.
/// @abstract VoiceConv result audio sample rate.
/// @discussion Optional for VoiceConv, default 24000, apply to AILab Speech.
extern const NSString* SE_PARAMS_KEY_VOICECONV_RESULT_SAMPLE_RATE_INT;

/// @const SE_PARAMS_KEY_AUDIO_FADEOUT_DURATION_INT.
/// @abstract Player fade-out effect duration in ms, use 0 for disable fade-out.
/// @discussion Default is 0, configure it before init engine.
extern const NSString *SE_PARAMS_KEY_AUDIO_FADEOUT_DURATION_INT;

/// @const SE_PARAMS_KEY_VOICECONV_ENABLE_RECORD_DUMP_BOOL.
/// @abstract Enable record dump for VoiceConv engine. If true, VoiceConv will dump record
///           audio data to file at OPTIONS_KEY_VOICECONV_AUDIO_PATH_STRING.
/// @discussion Optional for VoiceConv, default false, apply to AILab Speech.
extern const NSString* SE_PARAMS_KEY_VOICECONV_ENABLE_RECORD_DUMP_BOOL;

/// @const SE_PARAMS_KEY_VOICECONV_ENABLE_RESULT_DUMP_BOOL.
/// @abstract Enable result dump for VoiceConv engine. If true, VoiceConv will dump result
///           audio data to file at OPTIONS_KEY_VOICECONV_AUDIO_PATH_STRING.
/// @discussion Optional for VoiceConv, default false, apply to AILab Speech.
extern const NSString* SE_PARAMS_KEY_VOICECONV_ENABLE_RESULT_DUMP_BOOL;

/// @const SE_PARAMS_KEY_VOICECONV_AUDIO_PATH_STRING.
/// @abstract Audio path for VoiceConv engine. Record audio file and VoiceConv result audio file will be stored at this path.
/// @discussion Required for VoiceConv if ENABLE_DUMP is true, apply to AILab Speech.
extern const NSString* SE_PARAMS_KEY_VOICECONV_AUDIO_PATH_STRING;

/// @const SE_PARAMS_KEY_VOICECONV_REQUEST_INTERVAL_INT.
/// @abstract VoiceConv Interval Time
/// @discussion TODO(chengzihao.ds) this param only used for test, delete this after test
extern const NSString* SE_PARAMS_KEY_VOICECONV_REQUEST_INTERVAL_INT;

#pragma mark - Params key: Dialog

/// @const SE_PARAMS_KEY_DIALOG_ADDRESS_STRING.
/// @abstract Service address for dialog egnine.
/// @discussion Required for Dialog, apply to AILab Speech.
extern const NSString* SE_PARAMS_KEY_DIALOG_ADDRESS_STRING;

/// @const SE_PARAMS_KEY_DIALOG_URI_STRING.
/// @abstract Service uri for dialog egnine.
/// @discussion Required for Dialog, apply to AILab Speech.
extern const NSString* SE_PARAMS_KEY_DIALOG_URI_STRING;

/// @const SE_PARAMS_KEY_DIALOG_APP_ID_STRING.
/// @abstract Unique Id for RTC, apply it to RTC.
/// @discussion Required for dialog with avatar.
extern const NSString* SE_PARAMS_KEY_DIALOG_APP_ID_STRING;

/// @const SE_PARAMS_KEY_DIALOG_ID_STRING.
/// @abstract Unique Id to choose dialog script.
/// @discussion Required for dialog.
extern const NSString* SE_PARAMS_KEY_DIALOG_ID_STRING;

/// @const SE_PARAMS_KEY_DIALOG_ROLE_STRING.
/// @abstract Param to choose dialog role.
/// @discussion Required for dialog.
extern const NSString* SE_PARAMS_KEY_DIALOG_ROLE_STRING;

/// @const SE_PARAMS_KEY_DIALOG_CLOTHES_TYPE_STRING.
/// @abstract Param to choose dialog clothes type.
/// @discussion Optional for Dialog.
extern const NSString* SE_PARAMS_KEY_DIALOG_CLOTHES_TYPE_STRING;

/// @const SE_PARAMS_KEY_DIALOG_TTA_VOICE_TYPE_STRING.
/// @abstract Param to choose dialog tta voice type.
/// @discussion Optional for Dialog.
extern const NSString* SE_PARAMS_KEY_DIALOG_TTA_VOICE_TYPE_STRING;

/// @const SE_PARAMS_KEY_DIALOG_USER_PARAM_STRING.
/// @abstract User param used for other services.
/// @discussion Optional for Dialog.
extern const NSString* SE_PARAMS_KEY_DIALOG_USER_PARAM_STRING;

/// @const SE_PARAMS_KEY_DIALOG_ENABLE_DUPLEX_BOOL.
/// @abstract In default mode, user needs calling 'StartTalking' to send voice to server;
///           In duplex mode, sdk will keep sending the voice to server during the dialog.
/// @discussion Optional for Dialog, default is false.
extern const NSString* SE_PARAMS_KEY_DIALOG_ENABLE_DUPLEX_BOOL;

/// @const SE_PARAMS_KEY_DIALOG_ENABLE_AVATAR_BOOL.
/// @abstract If open, will show avatar steam by RTC SDK.
/// @discussion Optional for Dialog, default is true.
extern const NSString* SE_PARAMS_KEY_DIALOG_ENABLE_AVATAR_BOOL;

#pragma mark - Params key: Au

/// @const Au abilities
/// @abstract Au abilities. Can be any combinations.
/// @discussion Optional for AU , default only contains Asr.
extern const NSString* SE_PARAMS_KEY_AU_ABILITY_INT;

/// @const Au cluster.
/// @abstract Service cluster for au engine.
/// @discussion Required for AU, apply to AILab Speech.
extern const NSString* SE_PARAMS_KEY_AU_CLUSTER_STRING;

/// @const Au address.
/// @abstract Service address for au engine.
/// @discussion Required for AU, apply to AILab Speech.
extern const NSString* SE_PARAMS_KEY_AU_ADDRESS_STRING;

/// @const Au uri.
/// @abstract Service uri for au engine.
/// @discussion Required for AU, apply to AILab Speech.
extern const NSString* SE_PARAMS_KEY_AU_URI_STRING;

/// @const Au connection timeout.
/// @abstract Timeout for creating conntions, milliseconds.
/// @discussion Optional for AU, default is 12000 ms.
extern const NSString* SE_PARAMS_KEY_AU_CONN_TIMEOUT_INT;

/// @const Au receive timeout.
/// @abstract Timeout for receiving next data package, milliseconds.
/// @discussion Optional for AU, default is 8000 ms.
extern const NSString* SE_PARAMS_KEY_AU_RECV_TIMEOUT_INT;

/// @const Au auto stop.
/// @abstract Enable detecting for speech endpoint.
/// @discussion Optional, default is FALSE, should be enabled for long press au, config it before start engine.
extern const NSString* SE_PARAMS_KEY_AU_AUTO_STOP_BOOL;

/// @const Au rec path.
/// @abstract Recorder path, save wav audio file if not empty.
/// @discussion Optional for Au.
extern const NSString* SE_PARAMS_KEY_AU_REC_PATH_STRING;

/// @const Au process timeout.
/// @abstract Timeout for waiting au process, milliseconds.
/// @discussion Optional for AU, default is 3000 ms.
extern const NSString* SE_PARAMS_KEY_AU_PROCESS_TIMEOUT_INT;

/// @const Au audio packet duration.
/// @abstract Duration for each audio packet, milliseconds.
/// @discussion Optional for AU, default is 80 ms.
extern const NSString* SE_PARAMS_KEY_AU_AUDIO_PACKET_DURATION_INT;

/// @const Au empty packet interval.
/// @abstract Interval for each empty packet, milliseconds.
/// @discussion Optional for AU, default is 500 ms.
extern const NSString* SE_PARAMS_KEY_AU_EMPTY_PACKET_INTERVAL_INT;

#pragma mark - Directive

/// @typedef SEDirective.
/// @abstract Directive for speech engine, each one means a function.
/// @discussion The meaning of directive maybe different for engines, be careful.
typedef enum SEDirective {
    /// @abstract Get engine state, SEEngineState.
    SEDirectiveGetEngineState = 900,
    /// @abstract Start a new request.
    SEDirectiveStartEngine = 1000,
    /// @abstract Cancel a request (async mode).
    SEDirectiveStopEngine = 1001,
    /// @abstract Cancel a request (sync mode, call it before destroy engine instance).
    SEDirectiveSyncStopEngine = 2001,
    /// @abstract Start sending recording data to cloud.
    SEDirectiveStartTalking = 1099,
    /// @abstract Stop recorder, waiting for results.
    SEDirectiveFinishTalking = 1100,
    /// @abstract Pause talking.
    SEDirectivePauseTalking = 1101,
    /// @abstract Resume talking.
    SEDirectiveResumeTalking = 1102,
    /// @abstract Trigger wakeup.
    SEDirectiveTriggerWakeup = 1200,
    /// @abstract Trigger wakeup for query text.
    SEDirectiveTriggerWakeupForQueryText = 1202,
    /// @abstract Change wakeup mode.
    SEDirectiveChangeWakeupMode = 1203,
    /// @abstract Cancel current dialog.
    SEDirectiveCancelCurrentDialog = 1204,
    /// @abstract Update wakeup words.
    SEDirectiveUpdateWakeupWordsParams = 1205,
    /// @abstract Trigger wakeup for raw data.
    SEDirectiveTriggerWakeupForRawData = 1206,
    /// @abstract Start dialog.
    SEDirectiveStartDialog = 1207,
    /// @abstract Interrupt dialog.
    SEDirectiveInterruptDialog = 1209,
    /// @abstract Decide start or mute tts playing.
    SEDirectivePlayingDecision = 1300,
    /// @abstract Change player params.
    SEDirectiveChangePlayerParams = 1301,
    /// @abstract Start synthesis text in novel mode
    SEDirectiveSynthesis = 1400,
    /// @abstract Pause player.
    SEDirectivePausePlayer = 1500,
    /// @abstract Resume player.
    SEDirectiveResumePlayer = 1501,
    /// @abstract Update hotwords.
    SEDirectiveUpdateAsrHotWords = 1610,
    /// @abstract Create connection.
    SEDirectiveCreateConnection = 1700,
    /// @abstract Get Audio cache size.
    SEDirectiveGetCacheSize = 1800,
    /// @abstract VoiceClone get task info
    SEDirectiveVoiceCloneGetTask = 2010,
    /// @abstract VoiceClone check environment sound
    SEDirectiveVoiceCloneCheckEnv = 2011,
    /// @abstract VoiceClone start record voice
    SEDirectiveVoiceCloneRecordVoice = 2012,
    /// @abstract VoiceClone query train status
    SEDirectiveVoiceCloneQueryStatus = 2013,
    /// @abstract VoiceClone submit train task
    SEDirectiveVoiceCloneSubmitTask = 2014,
    /// @abstract VoiceClone delete train data result
    SEDirectiveVoiceCloneDeleteData = 2015,
} SEDirective;

#pragma mark - Engine Status

/// @typedef SEEngineState.
/// @abstract Speech engine state.
typedef enum SEEngineState {
    /// @abstract ready to work.
    SEEngineStateIdle = 0,
    /// @abstract Starting, will transfer to SEEngineStateWorking when finished.
    SEEngineStateStarting = 1,
    /// @abstract Working, work for task.
    SEEngineStateWorking = 2,
    /// @abstract Stopping, will transfer to SEEngineStateIdle when finished.
    SEEngineStateStopping = 3,
} SEEngineState;

#pragma mark - Message Type

/// @typedef SEMessageType.
/// @abstract Type of message returned by speech engine listener.
/// @discussion Process the data of message according to the type.
typedef enum SEMessageType {
    /// @abstract Engine started.
    SEEngineStart = 1001,
    /// @abstract Engine stopped.
    SEEngineStop = 1002,
    /// @abstract Error occurred.
    SEEngineError = 1003,
    /// @abstract Wakeup result, unsupported for iOS.
    SEWakeupResult = 1100,
    /// @abstract Asr recording audio data.
    SEAsrAudioData = 1200,
    /// @abstract Partial result.
    SEPartialResult = 1201,
    /// @abstract Asr partial result.
    SEAsrPartialResult = 1201,
    /// @abstract Final result,.
    SEFinalResult = 1204,
    /// @abstract Asr statistics message.
    SEAsrStatistics = 1206,
    /// @abstract A collection of all uploaded audio data, including audio length and local timestamp,
    ///           for the purpose of time-consuming statistics, now is for asr/capt/fulllink.
    SEAsrAllAudioData = 1210,
    /// @abstract A collection of all uploaded partial results, including audio length and local timestamp,
    ///           for the purpose of time-consuming statistics, now is for asr/capt/fulllink.
    SEAllPartialResult = 1211,
    /// @abstract Unsupported for iOS.
    SENluResult = 1300,
    /// @abstract Tts synthesised audio data.
    SETtsAudioData = 1400,
    /// @abstract Tts engine start to play.
    SETtsStartPlaying = 1401,
    /// @abstract Tts engine finished playing.
    SETtsFinishPlaying = 1402,
    /// @abstract Tts synthesis begin.
    SETtsSynthesisBegin = 1403,
    /// @abstract Tts synthesis end.
    SETtsSynthesisEnd = 1404,
    /// @abstract Tts finish dump audio.
    SETtsFinishAudioDump = 1405,
    /// @abstract Tts toggle mode occur.
    SETtsSynthesisModeToggle = 1406,
    /// @abstract Tts toggle mode occur.
    SETtsPlaybackProgress = 1407,
    /// @abstract Predicate total duration of tts audio.
    SETtsLengthPredicated = 1408,
    /// @abstract Tts audio data end.
    SETtsAudioDataEnd = 1409,
    /// @abstract The beginning of dialog.
    SEDialogBegin = 1500,
    /// @abstract The end of dialog.
    SEDialogEnd = 1501,
    /// @abstract The current dialog cancelled.
    SECurDialogCancelled = 1502,
    /// @abstract volume level
    SEVolumeLevel = 1600,
    /// @abstract begin recording
    SERecorderBegin = 1700,
    /// @abstract eng recording
    SERecorderEnd = 1701,
    /// @abstract vad begin.
    SEVadBegin = 1800,
    /// @abstract vad end.
    SEVadEnd = 1801,
    /// vad silence.
    SEVadSilence = 1802,
    /// vad silence to speech.
    SEVadSil2Speech = 1803,
    /// vad speech.
    SEVadSpeech = 1804,
    /// vad speech to silence.
    SEVadSpeech2Sil = 1807,
    /// vad audio data.
    SEVadAudioData = 1808,
    /// @abstract speech silence.
    SESpeechSilence = 1998,
    /// @abstract mic detect info.
    SEMicDetectInfo = 1999,
    /// @abstract engine log
    SEEngineLog = 2000,
    /// @abstract VoiceClone get task info
    SEVoiceCloneGetTaskResult = 2010,
    /// @abstract VoiceClone result of checking environment sound
    SEVoiceCloneCheckEnvResult = 2011,
    /// @abstract VoiceClone result of voice record
    SEVoiceCloneRecordVoiceResult = 2012,
    /// @abstract VoiceClone training status
    SEVoiceCloneQueryStatusResult = 2013,
    /// @abstract VoiceClone submit task succ
    SEVoiceCloneSubmitTaskResult = 2014,
    /// @abstract VoiceClone del training data succ
    SEVoiceCloneDeleteDataResult = 2015,
    /// @abstract VoiceClone record audio process end
    SEVoiceCloneRecordProcessEnd = 2016,
    /// @abstract VoiceClone record audio time limit exceeded
    SEVoiceCloneAudioTimeLimitExceeded = 2017,
    /// @abstract VoiceConv result audio data
    SEVoiceConvResultAudio = 2020,
    /// @abstract Dialog init info.
    SEDialogInitInfo = 2200,
    /// @abstract Dialog channel joined.
    SEDialogChannelJoined = 2201,
    /// @abstract Dialog subtitle on.
    SEDialogSubtitleOn = 2210,
    /// @abstract Dialog subtitle off.
    SEDialogSubtitleOff = 2211,
    /// @abstract Dialog voice begin.
    SEDialogVoiceBegin = 2220,
    /// @abstract Dialog voice end.
    SEDialogVoiceEnd = 2221,
    /// @abstract Dialog scrip trans.
    SEDialogScriptTrans = 2230,
    /// @abstract Start build connection.
    SEConnectionStart = 2300,
    /// @abstract Connection is connected.
    SEConnectionConnected = 2301,
    /// @abstract Connection is disconnected.
    SEConnectionEnd = 2302,
    /// @abstract Au statistics message.
    SEAuStatistics = 2406,
} SEMessageType;

#pragma mark - Result Type

typedef enum SEResultType {
  SEVadResult = 1100,
  SEAfpResult = 1200,
  SECoversongResult = 1300,
  SEHummingResult = 1500,
} SEResultType;

#pragma mark - Engine Error Code

/// @typedef SEEngineErrorCode.
/// @abstract Error code for initEngine & sendDirective.
typedef enum SEEngineErrorCode {
  SENoError = 0,
  SEGetOptionFailed = -1,
  SECreateObjInstanceFailed = -2,
  SEStartWithoutInit = -3,
  SECronetCreateExecutorFailed = -100,
  SECronetCreateWsClientFailed = -101,
  SECronetCreateWsParamsFailed = -102,
  SEUnsupportedDecodec = -200,
  SEUnsupportedCodec = -201,
  SEAddressInvalid = -202,
  SEKwsCreateRecFailed = -300,
  SEKwsCreateGrammarFailed = -301,
  SEKwsCompileGrammarFailed = -302,
  SEKwsLoadGrammarFailed = -303,
  SEKwsUpdateWakeupWordsParamsInvalidFormat = -304,
  SEKwsUpdateWakeupWordsParamsFailed = -305,
  SEOpenFileFailed = -400,
  SESlesCreateEngineFailed = -401,
  SESlesRealiseFailed = -402,
  SESlesGetInterfaceFailed = -403,
  SESlesAllocBuffersFailed = -404,
  SESlesCreateRecorderFailed = -405,
  SESlesRegisteCbFailed = -406,
  SESlesGetStateFailed = -407,
  SESlesSetStateFailed = -408,
  SESlesClearFailed = -409,
  SESlesOutOfFreeBuffers = -410,
  SECreateAudioQueueFailed = -500,
  SEAudioQueueAllocBufferFailed = -501,
  SEAudioQueueEnqueueBufferFailed = -502,
  SEAudioQueueStartFailed = -503,
  SEAudioQueueStopFailed = -504,
  SESignalInitFailed = -600,
  SERecCheckEnvironmentFailed = -700,
  SEBpeaCheckFailed = -710,
  SESynthesisPlayerWithoutStart = -900,
  SESynthesisIsBusy = -901,
  SESynthesisPlayerIsBusy = -902,
  SESendDirectiveInWrongState = -1000,
  SEVerifyDigestFailed = -1100,
  SEAuthenticationFailed = -1101,
  SEPetrelAedDetectFailed = -1202,
  SEUnknownResultType = -2000,
  SERtcUnprepared = -5000,
} SEEngineErrorCode;

#pragma mark - Error Code

/// @typedef SEErrorCode.
/// @abstract Error code of engine, included in message.
/// @discussion Error message will be returned with error code in message, no more explanation here.
typedef enum SEErrorCode {
  // Server-side
  SESuccess = 1000,

  // request related
  SEInvalidRequest = 1001,
  SEPermissionDenied = 1002,
  SELimitQps = 1003,
  SELimitCount = 1004,
  SEServerBusy = 1005,
  SEInterrupted = 1006,

  // audio related
  SELongAudio = 1010,
  SELargePacket = 1011,
  SEInvalidFormat = 1012,
  SESilentAudio = 1013,
  SEVadStartTimeout = 1014,

  // recognition related
  SETimeoutWaiting = 1020,
  SETimeoutProcessing = 1021,
  SEErrorProcessing = 1022,

  // others
  SEErrorUnknown = 1099,

  // TTS Server-side
  SETTSSucess = 3000,

  // request related
  SETTSInvalidRequest = 3001,
  SETTSPermissionDenied = 3002,
  SETTSLimitQps = 3003,
  SETTSLimitCount = 3004,
  SETTSServerBusy = 3005,
  SETTSInterrupted = 3006,

  // input related
  SETTSLongText = 3010,
  SETTSInvalidText = 3011,

  // output related
  SETTSInvalidAudioFormat = 3020,
  SETTSInvalidEncodeParams = 3021,
  SETTSEncodeError = 3022,

  // processing related
  SETTSSynthesisTimeout = 3030,
  SETTSSynthesisError = 3031,
  SETTSSynthesisWaitingTimeout = 3032,

  // others
  SETTSErrorUnknown = 3099,

  // Client-side
  // request related
  SEConnectTimeout = 4000,
  SEReceiveTimeout = 4001,
  SEInvalidResponse = 4002,
  SENetLibError = 4003,
  SENetConnectFailed = 4004,

  SEEncodingAudioError = 4010,
  SECreateConnectionError = 4011,

  // file recorder
  SEFRReadDataFailed = 4030,
  SEFRWriteDataFailed = 4031,

  // recorder
  SERecWrongBufQueue = 4040,
  SERecWriteDataFailed = 4041,
  SERecEnqueueFailed = 4042,
  SERecAudioUnitSetPropertyFormatFailed = 4043,
  SERecAudioUnitSetPropertyCallbackFailed = 4044,
  SERecAudioUnitSetPropertyEnableFailed = 4045,
  SERecAudioUnitStartFailed = 4046,
  SERecAudioUnitRenderFailed = 4047,
  SERecAudioUnitInitFailed = 4048,

  SEOutOfMemory = 4070,

  SEAudioDataDecodeError = 4090,

  SEExternalError = 5000,

  kRtcError = 10000,
} SEErrorCode;

#endif /* SpeechEngineDefines_h */
