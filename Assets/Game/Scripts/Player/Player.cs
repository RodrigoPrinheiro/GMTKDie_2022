using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public enum PlayerState
{
    LeanLeft,
    LeanRight,
    LeanDown,
    EyesClosed
}

public class Player : MonoBehaviour
{
    public static Player instance;
    [SerializeField, ReadOnly] private PlayerState state;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
