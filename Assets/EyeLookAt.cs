using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EyeLookAt : MonoBehaviour
{
    private Transform _lookAt;
    private int shift180;

    // OnStateEnter is called when a transition starts and the state machine starts to evaluate this state
    public void Start()
    {
        _lookAt = Camera.main.transform;
        shift180 = 1;
        StartCoroutine(C180Shift());
    }

    // OnStateUpdate is called on each Update frame between OnStateEnter and OnStateExit callbacks
    public void Update()
    {
        Vector3 lookAtPos = _lookAt.transform.position - transform.position;
        lookAtPos *= shift180;
        Quaternion targetRotation = Quaternion.LookRotation(lookAtPos);
        transform.rotation = Quaternion.Slerp(transform.rotation, targetRotation, 5 * Time.deltaTime);
    }

    private IEnumerator C180Shift()
    {
        yield return new WaitForSeconds(Random.Range(3, 8));
        shift180 *= -1;

        StartCoroutine(C180Shift());
    }
}
