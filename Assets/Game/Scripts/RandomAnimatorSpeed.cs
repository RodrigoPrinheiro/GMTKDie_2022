using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Animator))]
public class RandomAnimatorSpeed : MonoBehaviour
{
    [SerializeField] private Vector2 _speed = new Vector2(.85f, 1.15f);
    // Start is called before the first frame update
    void Start()
    {
        GetComponent<Animator>().speed = Random.Range(_speed.x, _speed.y);
    }
}
