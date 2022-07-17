using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Unparent : MonoBehaviour
{
    private void OnEnable() {
        transform.SetParent(null);
    }
}
