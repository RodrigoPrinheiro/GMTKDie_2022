using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class bob : MonoBehaviour
{
    private bool isDisplaying;
    private Animator animator;
    private void Start()
    {
        animator = GetComponent<Animator>();
    }

    public void Toggle()
    {
        isDisplaying = !isDisplaying;

        if(isDisplaying)
        {
            animator.SetTrigger("SlideIn");
        }
        else
        {
            animator.SetTrigger("SlideOut");
        }
    }
}
