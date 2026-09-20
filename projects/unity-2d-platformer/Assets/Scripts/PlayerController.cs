using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Rigidbody2D), typeof(BoxCollider2D))]
public class PlayerController : MonoBehaviour
{
    [SerializeField] private float moveSpeed = 7f;
    [SerializeField] private float jumpForce = 12f;

    private readonly HashSet<Collider2D> groundContacts = new HashSet<Collider2D>();
    private Rigidbody2D body;
    private Vector3 spawnPoint;
    private float horizontalInput;
    private bool jumpRequested;

    public bool CanMove { get; set; } = true;

    private void Awake()
    {
        body = GetComponent<Rigidbody2D>();
        spawnPoint = transform.position;
    }

    private void Update()
    {
        if (!CanMove || (GameManager.Instance != null && GameManager.Instance.IsCompleted))
        {
            horizontalInput = 0f;
            return;
        }

        horizontalInput = Input.GetAxisRaw("Horizontal");
        jumpRequested |= Input.GetButtonDown("Jump") || Input.GetKeyDown(KeyCode.W) || Input.GetKeyDown(KeyCode.UpArrow);

        if (transform.position.y < -7f)
        {
            Respawn();
        }
    }

    private void FixedUpdate()
    {
        body.velocity = new Vector2(horizontalInput * moveSpeed, body.velocity.y);

        if (jumpRequested && groundContacts.Count > 0)
        {
            body.velocity = new Vector2(body.velocity.x, jumpForce);
            groundContacts.Clear();
        }

        jumpRequested = false;
    }

    private void OnCollisionStay2D(Collision2D collision)
    {
        for (int i = 0; i < collision.contactCount; i++)
        {
            if (collision.GetContact(i).normal.y > 0.55f)
            {
                groundContacts.Add(collision.collider);
                return;
            }
        }
    }

    private void OnCollisionExit2D(Collision2D collision)
    {
        groundContacts.Remove(collision.collider);
    }

    public void Respawn()
    {
        transform.position = spawnPoint;
        body.velocity = Vector2.zero;
        groundContacts.Clear();
    }
}

