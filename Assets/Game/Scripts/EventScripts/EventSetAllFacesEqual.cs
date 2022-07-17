using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EventSetAllFacesEqual : MonoBehaviour
{
	private readonly List<DieFaces.Direction> _directions = new List<DieFaces.Direction>()
	{
		DieFaces.Direction.Xm,
		DieFaces.Direction.Xp,
		DieFaces.Direction.Ym,
		DieFaces.Direction.Yp,
		DieFaces.Direction.Zm,
		DieFaces.Direction.Zp
	};

	private TheDie _die;
	private DieFaces _dieFaces;
	[SerializeField] private bool _playOnEnable;

	private void OnEnable()
	{
		if (_playOnEnable)
		{
			SetAllFaces();
		}
	}

	private void SetAllFaces()
	{
		_die = FindObjectOfType<TheDie>();
		_dieFaces = _die.GetComponentInChildren<DieFaces>();
		_die.DestroyAllFaces();

		int rnd;

		// Hate it.
		do
		{
			rnd = Random.Range(0, 5);
		} 
		while (_dieFaces.GetTransform(_directions[rnd]) == _die.rollPick.faceTransform);

		var evnt = _die.GetDieFaceEvent(_directions[rnd]);

		foreach (var dir in _directions)
		{
			_dieFaces.SetFace(evnt, dir);
		}
	}
}
