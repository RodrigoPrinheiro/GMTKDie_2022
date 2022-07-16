using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

public class DieFaces : MonoBehaviour
{
    public enum Direction
    {
        Zp = 0,
        Zm = 1,
        Yp = 2,
        Ym = 3,
        Xp = 4,
        Xm = 5
    }
    private Dictionary<Direction, Transform> diceSidesDic;
    private void Awake() 
    {
        diceSidesDic = new Dictionary<Direction, Transform>();
        
        foreach(Transform child in transform)
        {
            Direction d = Enum.Parse<Direction>(child.name);
            diceSidesDic.Add(d, child);
        }
    }

    public void SetFace(DiceGameEvent e, Direction dir)
    {
        // Generate face
    }

    public Transform GetTransform(Direction dir)
    {
        return diceSidesDic[dir];
    }

    private void OnDrawGizmos() {
        foreach(Transform c in transform)
        {
            Gizmos.DrawSphere(c.transform.position, 0.1f);
        }
    }
}