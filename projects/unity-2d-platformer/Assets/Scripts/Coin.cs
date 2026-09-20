using UnityEngine;

public class Coin : MonoBehaviour
{
    private Vector3 startPosition;

    private void Start()
    {
        startPosition = transform.position;
    }

    private void Update()
    {
        transform.Rotate(0f, 0f, 90f * Time.deltaTime);
        transform.position = startPosition + Vector3.up * (Mathf.Sin(Time.time * 3f) * 0.12f);
    }

    private void OnTriggerEnter2D(Collider2D other)
    {
        if (!other.TryGetComponent<PlayerController>(out _)) return;
        GameManager.Instance?.CollectCoin();
        Destroy(gameObject);
    }
}

