using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class DiceButton : MonoBehaviour
{
    [SerializeField] private UnityEvent onInteracted;
    [SerializeField] private bool _disableInteractionAfterInteracted;
    [SerializeField] private float _interactionDelay = .3f;

    bool CanInteract => !_delayLock && !_interactionLockedAfterInteraction;

    bool _delayLock;
    bool _interactionLockedAfterInteraction;

    private Animator _anim;
    // Start is called before the first frame update
    void Start()
    {
        _anim = GetComponent<Animator>();
    }

    public void Interact()
    {
        if (!CanInteract) return;

        if(_disableInteractionAfterInteracted) _interactionLockedAfterInteraction = true;
        _anim.SetTrigger("OnInteracted");
        onInteracted.Invoke();
        StartCoroutine(CInteractionDelay());
    }

    IEnumerator CInteractionDelay()
    {
        _delayLock = true;
        yield return new WaitForSeconds(_interactionDelay);
        _delayLock = false;

    }

    public void OnHover()
    {
        _anim.SetTrigger("OnHover");
    }

    public void OnUnHover()
    {
        _anim.SetTrigger("OnUnhover");
    }
}
