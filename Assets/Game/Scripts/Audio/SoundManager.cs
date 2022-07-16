using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Audio;
using System;
using UnityEngine.SceneManagement;
using UnityEngine.Events;

public class SoundManager : Singleton<SoundManager>
{
    [Header("Sound")]
    [SerializeField] private AudioMixer mainMixer;
    [SerializeField] private SoundDatabase database;

    protected override void OnAwake()
    {
        
    }

    protected override void MyDestroy()
    {
        
    }
}