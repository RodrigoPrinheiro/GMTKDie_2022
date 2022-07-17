using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EventCheck : MonoBehaviour
{
    // Full duration the player can be ignoring the state before dying;
    [SerializeField] private float buildUpTime; 
    [SerializeField] private PlayerState checkState;
    [SerializeField, ReadOnly] private float buildUpToDeath;

    private void OnEnable() 
    {
        buildUpToDeath = 0;
    }

    private void Update() 
    {
        if (Player.instance.state != checkState)
        {
            if (buildUpToDeath > buildUpTime)
            {
                if (Player.instance.Enabled)
                    Player.instance.Die();
            }

            buildUpToDeath += Time.deltaTime;

        }
    }
}
