using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public enum PlayerState
{
    Default = 0,
    LeanLeft = 1,
    LeanRight = 2,
    LeanDown = 3,
    EyesClosed = 4
}

public class Player : MonoBehaviour
{
    [System.Serializable]
    public class StateChange
    {
        public Vector3 positionOffset;
        public Vector3 rotationOffset;
    }

    public static Player instance;
    [SerializeField, ReadOnly] private PlayerState state;
    [SerializeField] private float leanSpeed = 0.6f;
    [SerializeField] private Transform leanTransform;
    [SerializeField] private List<StateChange> changes;

    private Vector3 holderStartPosition;
    private Quaternion holderStartRotation;
    private Vector3 targetPosition;
    private Quaternion targetRotation;

    private void Awake()
    {
        instance = this;
        if (changes.Count < 5)
        {
            for (int i = 0; i < 5 - changes.Count; i++)
            {
                changes.Add(new StateChange());
            }
        }
    }

    private void Start()
    {
        holderStartPosition = leanTransform.localPosition;
        holderStartRotation = leanTransform.localRotation;
    }

    private void Update()
    {
        CheckState(KeyCode.A, PlayerState.LeanLeft);
        CheckState(KeyCode.D, PlayerState.LeanRight);
        CheckState(KeyCode.S, PlayerState.LeanDown);
        CheckState(KeyCode.Space, PlayerState.EyesClosed);

        leanTransform.localPosition = Vector3.Lerp(leanTransform.localPosition, targetPosition, Time.deltaTime * leanSpeed);
        leanTransform.localRotation = Quaternion.Slerp(leanTransform.localRotation, targetRotation, Time.deltaTime * leanSpeed);
    }

    private void CheckState(KeyCode key, PlayerState target)
    {
        if (Input.GetKeyDown(key))
        {
            state = target;
        }
        else if (state == target && Input.GetKeyUp(key))
        {
            state = PlayerState.Default;
        }
        UpdateState(state);

    }

    public void UpdateState(PlayerState newState)
    {
        switch (newState)
        {
            case PlayerState.EyesClosed:
                //! Send close eyes vfx event
                break;
            case PlayerState.Default:
            case PlayerState.LeanRight:
            case PlayerState.LeanLeft:
            case PlayerState.LeanDown:
                ActState(changes[(int)newState]);
                break;
        }
    }

    private void ActState(StateChange change)
    {
        targetPosition = change.positionOffset + holderStartPosition;
        targetRotation = Quaternion.Euler(change.rotationOffset);
    }
}
