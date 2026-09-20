using UnityEngine;

public class CameraFollow : MonoBehaviour
{
    public Transform Target { get; set; }

    [SerializeField] private Vector3 offset = new Vector3(2f, 1f, -10f);
    [SerializeField] private float smoothTime = 0.2f;

    private Vector3 velocity;

    private void LateUpdate()
    {
        if (Target == null) return;

        Vector3 desired = Target.position + offset;
        desired.x = Mathf.Max(0f, desired.x);
        desired.y = Mathf.Clamp(desired.y, 0f, 2.5f);
        transform.position = Vector3.SmoothDamp(transform.position, desired, ref velocity, smoothTime);
    }
}

