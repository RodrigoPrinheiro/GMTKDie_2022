using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BoneShake : MonoBehaviour
{
    [SerializeField] private float _speed = 20;
    [SerializeField] private float _intensity = 10;
    [SerializeField] private float _shakeDuration = .8f;
    [SerializeField] private bool _looping = false;

    [SerializeField] private AnimationCurve _shakeCurve;
    [SerializeField] private Transform _targetBone;

    private Vector3 _finalShakeRotation;
    private Quaternion _initialRot;
    private Vector3 _randomSeed;

    private Coroutine _shakeCor;

    float _startTime = 0;
    float _elapsed = 100;
    float _elapsedPercent = 0;

    public bool doItDebugStyle;

    // Start is called before the first frame update
    void Start()
    {
        _randomSeed = new Vector3(Random.Range(-100f, 100f), Random.Range(-100f, 100f), Random.Range(-100f, 100f));
        _initialRot = _targetBone.localRotation;
    }

    // Update is called once per frame
    void LateUpdate()
    {
        if (doItDebugStyle)
        {
            doItDebugStyle = false;
            DoShake();
        }

        if (_elapsed < _shakeDuration)
        {
            Vector3 perlinNoise;
            float time = _speed * Time.time;
            float finalStrength = 2 * _intensity * _shakeCurve.Evaluate(_elapsedPercent);
            _finalShakeRotation = _targetBone.localRotation.eulerAngles;

            perlinNoise = new Vector3(
                Mathf.PerlinNoise(time + _randomSeed.x, time - _randomSeed.x),
                Mathf.PerlinNoise(time - _randomSeed.y, time + _randomSeed.y),
                Mathf.PerlinNoise(time + _randomSeed.z, time - _randomSeed.z));

            perlinNoise -= (Vector3.one * 0.5f); // make it also go to the negative side of the spectrum
            perlinNoise *= finalStrength;

            _finalShakeRotation += perlinNoise;

            _targetBone.localRotation = Quaternion.Euler(_finalShakeRotation);

            _elapsed = Time.time - _startTime;
            _elapsedPercent = _elapsed / _shakeDuration;
        }
        else if (_looping) DoShake();
    }

    public void DoShake()
    {
        _startTime = Time.time;
        _elapsed = 0;
        _elapsedPercent = 0;
    }
}