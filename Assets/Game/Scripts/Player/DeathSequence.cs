using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DeathSequence : MonoBehaviour
{
    private Animator animator;

    private void Awake() {
        animator = GetComponent<Animator>();
    }

    private void Start() 
    {
        StartCoroutine(DeathSequenceRoutine());
    }
    private IEnumerator DeathSequenceRoutine()
    {
        SSEffects.FxAnimator.SetTrigger("DeathEffect");
        animator.SetTrigger("Death");
        yield return null;
    }
}
