using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MouseInteractor : MonoBehaviour
{
    private DiceButton _hovering;

    // Start is called before the first frame update
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {
        RaycastHit hit;
        Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
        if (Physics.Raycast(ray, out hit, 100))
        {
            DiceButton db = hit.collider.GetComponent<DiceButton>();
            if (db != _hovering)
            {
                _hovering?.OnUnHover();
                _hovering = db;
                db.OnHover();
            }
        }
        else
        {
            _hovering?.OnUnHover();
            _hovering = default;
        }

        if (Input.GetMouseButtonDown(0))
        {
            _hovering?.Interact();
        }
    }
}
