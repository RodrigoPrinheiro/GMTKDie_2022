using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayAudio : MonoBehaviour
{
    [SerializeField] private SoundDef soundToPlay;
    [SerializeField] private bool playOnEnable;
    public SoundDef SoundToPlay => soundToPlay;
    private void OnEnable() 
    {
        if (playOnEnable)
        {
            PlayAudioObject(soundToPlay);
        }
    }

    public void PlayAudioObject(SoundDef sound)
    {
        Debug.Log("Play Audio");
        AudioSource s = SoundManager.Play(sound);
        s.transform.position = transform.position;
    }
}
