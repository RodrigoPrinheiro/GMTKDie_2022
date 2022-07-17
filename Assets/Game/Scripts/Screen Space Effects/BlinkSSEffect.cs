using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BlinkSSEffect : BaseEffect, ISSEffect
{
    private const float SHADER_TOP = 4f;
    private const float SHADER_BOT = -0.02f;

    [SerializeField] private AnimationCurve blinkInCurve;
    [SerializeField] private AnimationCurve blinkOutCurve;
    private Coroutine fxCoroutine;

    private void Start()
    {
        effectMaterial.SetFloat("_VignettePower", SHADER_TOP);
    }
    public void Activate(float strength, float transitionTime, Action effectAction = null)
    {
        if (fxCoroutine != null) StopCoroutine(fxCoroutine);

        float start = strength > 0.5f ? SHADER_TOP : SHADER_BOT;
        float end = strength > 0.5f ? SHADER_BOT : SHADER_TOP;
        AnimationCurve curve = strength > 0.5f ? blinkInCurve : blinkOutCurve;
        Debug.Log($"Played Blink: {start} - {end}");
        fxCoroutine = StartCoroutine(SSEffects.LerpMaterialProp
        (
            "_VignettePower",
            (prop, t) =>
            {
                float value = Mathf.Lerp(start, end, curve.Evaluate(t));
                effectMaterial.SetFloat(prop, value);
                if (value >= SHADER_TOP - 0.02f) effectAction?.Invoke();
            },
            transitionTime
        ));
    }
}
