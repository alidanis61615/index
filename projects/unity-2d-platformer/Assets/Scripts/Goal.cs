using UnityEngine;

public class Goal : MonoBehaviour
{
    private void OnTriggerEnter2D(Collider2D other)
    {
        if (!other.TryGetComponent<PlayerController>(out PlayerController player)) return;
        player.CanMove = false;
        GameManager.Instance?.CompleteLevel();
    }
}

