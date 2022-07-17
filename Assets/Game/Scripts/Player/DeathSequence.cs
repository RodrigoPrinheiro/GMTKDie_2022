using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DeathSequence : MonoBehaviour
{
    [SerializeField] SoundDef deathVA;
    [SerializeField] SoundDef death;
    private Animator animator;

    private void Awake() {
        animator = GetComponent<Animator>();
    }

    private void Start() 
    {

    }

    public void DeathFX()
    {
        SoundManager.Play(deathVA);
        StartCoroutine(DeathSequenceRoutine());
    }
    private IEnumerator DeathSequenceRoutine()
    {
        SSEffects.FxAnimator.SetTrigger("DeathEffect");
        animator.SetTrigger("Death");
        yield return new WaitForSeconds(5f);
        SoundManager.Play(death);
        yield return new WaitForSeconds(20f);
        UnityEngine.SceneManagement.SceneManager.LoadScene(1);
    }
}
