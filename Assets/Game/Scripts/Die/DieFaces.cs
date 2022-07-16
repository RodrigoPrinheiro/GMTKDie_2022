using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DieFaces : MonoBehaviour
{
    private void OnDrawGizmos() {
        foreach(Transform c in transform)
        {
            Gizmos.DrawSphere(c.transform.position, 0.1f);
        }
    }
}
