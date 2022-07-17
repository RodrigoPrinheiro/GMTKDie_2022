using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BloodshotSSEffect : BaseEffect, ISSEffect
{
    const float SHADER_BOT = 0f;
    const float SHADER_TOP = 5f;
  
    protected override void Awake() 
    {
        base.Awake();
        effectMaterial.SetFloat("_VignetteSize", SHADER_BOT);
    }

    public void Activate(float strength, float transitionTime, Action effectAction = null)
    {
        
    }
}
