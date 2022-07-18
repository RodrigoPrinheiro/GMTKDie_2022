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
        //DeathFX();
    }

    public void DeathFX(bool playThomas = true)
    {
        SoundManager.Play(deathVA);
        StartCoroutine(DeathSequenceRoutine(playThomas));
    }
    private IEnumerator DeathSequenceRoutine(bool playThomas)
    {
        SSEffects.FxAnimator.SetTrigger("DeathEffect");
        animator.SetTrigger("Death");
        yield return new WaitForSeconds(5f);
        if (playThomas)
            SoundManager.Play(death);
        yield return new WaitForSeconds(20f);
        UnityEngine.SceneManagement.SceneManager.LoadScene(1);
        SSEffects.FxAnimator.SetTrigger("RemoveBloodshot");
    }
}
