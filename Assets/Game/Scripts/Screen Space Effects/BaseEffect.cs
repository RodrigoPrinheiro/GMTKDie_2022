using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public abstract class BaseEffect : MonoBehaviour
{
    [SerializeField] protected Material effectMaterial;
    [SerializeField] private float vignetteSize = 0f;
    [SerializeField] private float vignettePower = 1.2f;
    public Animator FxAnimator { get; private set; }
    private int sizeProp;
    private int powerProp;
    protected virtual void Awake()
    {
        sizeProp = Shader.PropertyToID("_VignetteSize");
        powerProp = Shader.PropertyToID("_VignettePower");
        FxAnimator = GetComponentInParent<Animator>();
    }
    private bool isPlaying => !FxAnimator.GetCurrentAnimatorStateInfo(0).IsName("Idle") &&
        FxAnimator.GetCurrentAnimatorStateInfo(0).normalizedTime < 1.0f;
    private void Update()
    {
        if (isPlaying)
            effectMaterial.SetFloat(sizeProp, vignetteSize);
        effectMaterial.SetFloat(powerProp, vignettePower);
    }
}
