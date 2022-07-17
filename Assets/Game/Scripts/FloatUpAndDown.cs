using UnityEngine;

public class FloatUpAndDown : MonoBehaviour
{
    public float speed = 1;
    public float distance = 1;

    [SerializeField ]private Vector3 _initPos;

    private void Start()
    {
        _initPos = transform.localPosition;
    }

    private void Update()
    {
        Vector3 finalBobPos = _initPos + Vector3.up * Mathf.Sin(Time.fixedTime * Mathf.PI * speed) * distance;
        
        transform.localPosition = finalBobPos;
    }
}
