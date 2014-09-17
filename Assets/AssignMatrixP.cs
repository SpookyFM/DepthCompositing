using UnityEngine;
using System.Collections;

public class AssignMatrixP : MonoBehaviour {

    /// <summary>
    /// The perspective camera that renders the realtime objects.
    /// </summary>
    public Camera camera;

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {

        // Feed the perspective transform matrix into the shader
        renderer.material.SetMatrix("_Perspective", camera.projectionMatrix);
	}
}
