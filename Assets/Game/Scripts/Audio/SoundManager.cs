using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Audio;
using System;
using UnityEngine.SceneManagement;
using UnityEngine.Events;

public class SoundManager : Singleton<SoundManager>
{
    public enum SoundType { Main, Music, Sfx, Sfx2, Voice, Ambient };
    class Sound
    {
        public AudioSource audioSource;
        public bool sceneSound;
        public Coroutine fxThread;
        public SoundDef currentSound;
    }

    Dictionary<AudioSource, Sound> audioSources;

    protected override void MyDestroy()
    {

    }
    
    protected override void OnAwake()
    {
        audioSources = new Dictionary<AudioSource, Sound>();
    }

    AudioSource _Play
		(SoundDef soundDef, float volume = 1.0f, float pitch = 1.0f)
    {
        AudioMixerGroup mixer = soundDef.group;
        if (mixer == null)
        {
            Debug.LogError($"No mixer found in {soundDef.name} Definition");
            return null;
        }
        AudioSource audioSource = GetSound(mixer, soundDef.is3D, soundDef.isScene);
        if (audioSource == null)
        {
            Debug.LogWarning("No sound channel available for sounds " + name);
            return null;
        }

        audioSource.clip = soundDef.GetRandomClip();
        audioSource.pitch = Mathf.Clamp(pitch + UnityEngine.Random.Range(-soundDef.pitchRange, soundDef.pitchRange), 0.0f, 2.0f);
        audioSource.volume = Mathf.Clamp(volume + UnityEngine.Random.Range(-soundDef.volumeRange, soundDef.volumeRange), 0.0f, 2.0f);
        audioSource.loop = soundDef.isLoop;
        audioSource.Play();

        Sound snd;
        if (audioSources.TryGetValue(audioSource, out snd))
        {
            if (snd.fxThread != null)
            {
                StopCoroutine(snd.fxThread);
                snd.fxThread = null;
            }
            snd.currentSound = soundDef;
        }

        return audioSource;
    }

    AudioSource GetSound(AudioMixerGroup grp, bool is3d, bool isScene)
    {
        foreach (var s in audioSources.Values)
        {
            if (!s.audioSource.isPlaying)
            {
                if (s.audioSource.outputAudioMixerGroup == grp)
                {
                    if ((is3d) && (s.audioSource.spatialBlend == 0.0f)) continue;
                    if ((!is3d) && (s.audioSource.spatialBlend == 1.0f)) continue;
                    return s.audioSource;
                }
            }
        }

        GameObject go = new GameObject();
        go.transform.parent = transform;
        go.name = grp.name;
        AudioSource src = go.AddComponent<AudioSource>();
        src.outputAudioMixerGroup = grp;
        src.spatialBlend = (is3d) ? (1.0f) : (0.0f);
        src.playOnAwake = false;

        Sound snd = new Sound();
        snd.audioSource = src;
        snd.sceneSound = isScene;
        snd.fxThread = null;

        audioSources.Add(src, snd);

        return src;
    }

    public static AudioSource Play(SoundDef snd, float volume = 1.0f, float pitch = 1.0f)
    {
        if (instance == null) return null;

        return instance._Play(snd, volume, pitch);
    }

    public static bool IsPlaying(AudioSource audioSource, SoundDef sound)
    {
        if (audioSource == null) return false;
        if (!audioSource.isPlaying) return false;

        if (sound.HasAudioClip(audioSource.clip))
        {
            return true;
        }

        return false;
    }
}