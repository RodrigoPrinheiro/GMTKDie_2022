using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

public interface ISSEffect
{
    Animator FxAnimator {get;}
    void Activate(float strength, float transitionTime, Action effectAction = null);
}

public class SSEffects : Singleton<SSEffects>
{
    public static Animator FxAnimator {get; private set;}
    public void _ActivateEffect(string fxName, float strength, float time, Action effectAction = null)
    {
        ISSEffect effect =  (ISSEffect)transform.Find(fxName).GetComponent(typeof(ISSEffect));
        effect.Activate(strength, time, effectAction);
    }

    public static void ActivateEffect(string fxName, float strength, float time, Action effectAction = null)
    {
        if (instance != null)
            instance._ActivateEffect(fxName, strength, time, effectAction);
    }

    private ISSEffect _GetEffect(string fxName)
    {
        return (ISSEffect)transform.Find(fxName).GetComponent(typeof(ISSEffect));
    }

    public static ISSEffect GetEffect(string fxName)
    {
        if (instance != null)
            return instance._GetEffect(fxName);
        else
            return null;
    }

    public static IEnumerator LerpMaterialProp(string prop, Action<int, float> parameterAction, float time)
    {
        int id = Shader.PropertyToID(prop);
        float elapsed = 0f;
        while(elapsed < time)
        {
            float t = elapsed / time;
            parameterAction(id, t);
            elapsed += Time.deltaTime;
            yield return null;
        }
    }

    protected override void OnAwake()
    {
        FxAnimator = GetComponent<Animator>();
    }

    protected override void MyDestroy()
    {
        
    }
}
