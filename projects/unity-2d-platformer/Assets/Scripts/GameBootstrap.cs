using UnityEngine;

public static class GameBootstrap
{
    private static Sprite whiteSprite;

    [RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.AfterSceneLoad)]
    private static void BuildLevel()
    {
        if (Object.FindObjectOfType<PlayerController>() != null) return;

        CreateBackground();
        CreatePlatform("Ana Zemin", new Vector2(0f, -4f), new Vector2(26f, 1f), new Color(0.20f, 0.30f, 0.25f));
        CreatePlatform("Platform 1", new Vector2(-5.5f, -1.8f), new Vector2(3.5f, 0.55f), new Color(0.34f, 0.44f, 0.35f));
        CreatePlatform("Platform 2", new Vector2(-1f, 0.1f), new Vector2(3f, 0.55f), new Color(0.34f, 0.44f, 0.35f));
        CreatePlatform("Platform 3", new Vector2(4f, -1.2f), new Vector2(3.5f, 0.55f), new Color(0.34f, 0.44f, 0.35f));
        CreatePlatform("Platform 4", new Vector2(7.2f, 0.6f), new Vector2(2.5f, 0.55f), new Color(0.34f, 0.44f, 0.35f));

        PlayerController player = CreatePlayer(new Vector2(-9.5f, -2.8f));
        CreateCoin(new Vector2(-5.5f, -0.8f));
        CreateCoin(new Vector2(-1f, 1.1f));
        CreateCoin(new Vector2(4f, -0.2f));
        CreateCoin(new Vector2(7.2f, 1.6f));
        CreateHazard(new Vector2(1.6f, -3.25f), new Vector2(2f, 0.45f));
        CreateHazard(new Vector2(6f, -3.25f), new Vector2(1.5f, 0.45f));
        CreateGoal(new Vector2(10.5f, -2.75f));

        ConfigureCamera(player.transform);
        GameManager manager = new GameObject("Game Manager").AddComponent<GameManager>();
        manager.RefreshCoinCount();
    }

    private static PlayerController CreatePlayer(Vector2 position)
    {
        GameObject player = CreateBlock("Oyuncu", position, new Vector2(0.85f, 1.25f), new Color(0.20f, 0.65f, 1f));
        player.tag = "Player";
        Rigidbody2D body = player.AddComponent<Rigidbody2D>();
        body.freezeRotation = true;
        body.gravityScale = 3f;
        BoxCollider2D collider = player.AddComponent<BoxCollider2D>();
        collider.size = Vector2.one;
        return player.AddComponent<PlayerController>();
    }

    private static void CreatePlatform(string name, Vector2 position, Vector2 size, Color color)
    {
        GameObject platform = CreateBlock(name, position, size, color);
        platform.AddComponent<BoxCollider2D>();
    }

    private static void CreateCoin(Vector2 position)
    {
        GameObject coin = CreateBlock("Yıldız", position, Vector2.one * 0.55f, new Color(1f, 0.82f, 0.12f));
        coin.transform.rotation = Quaternion.Euler(0f, 0f, 45f);
        BoxCollider2D collider = coin.AddComponent<BoxCollider2D>();
        collider.isTrigger = true;
        coin.AddComponent<Coin>();
    }

    private static void CreateHazard(Vector2 position, Vector2 size)
    {
        GameObject hazard = CreateBlock("Tehlike", position, size, new Color(0.95f, 0.25f, 0.28f));
        BoxCollider2D collider = hazard.AddComponent<BoxCollider2D>();
        collider.isTrigger = true;
        hazard.AddComponent<Hazard>();
    }

    private static void CreateGoal(Vector2 position)
    {
        GameObject goal = CreateBlock("Bitiş", position, new Vector2(0.35f, 2.5f), new Color(0.32f, 0.84f, 0.48f));
        BoxCollider2D collider = goal.AddComponent<BoxCollider2D>();
        collider.isTrigger = true;
        goal.AddComponent<Goal>();
        CreateBlock("Bayrak", position + new Vector2(0.7f, 0.9f), new Vector2(1.2f, 0.65f), new Color(0.32f, 0.84f, 0.48f));
    }

    private static void ConfigureCamera(Transform target)
    {
        Camera camera = Camera.main;
        if (camera == null)
        {
            GameObject cameraObject = new GameObject("Main Camera");
            cameraObject.tag = "MainCamera";
            camera = cameraObject.AddComponent<Camera>();
        }

        camera.orthographic = true;
        camera.orthographicSize = 5.2f;
        camera.backgroundColor = new Color(0.35f, 0.72f, 0.95f);
        camera.transform.position = new Vector3(0f, 0f, -10f);
        camera.gameObject.AddComponent<CameraFollow>().Target = target;
    }

    private static void CreateBackground()
    {
        CreateDecoration("Güneş", new Vector2(-7f, 3.5f), Vector2.one * 1.4f, new Color(1f, 0.88f, 0.25f));
        CreateDecoration("Bulut 1", new Vector2(-2f, 3f), new Vector2(2.8f, 0.65f), Color.white);
        CreateDecoration("Bulut 2", new Vector2(5f, 3.4f), new Vector2(2.2f, 0.55f), Color.white);
    }

    private static void CreateDecoration(string name, Vector2 position, Vector2 size, Color color)
    {
        GameObject decoration = CreateBlock(name, position, size, color);
        decoration.GetComponent<SpriteRenderer>().sortingOrder = -5;
    }

    private static GameObject CreateBlock(string name, Vector2 position, Vector2 size, Color color)
    {
        GameObject gameObject = new GameObject(name);
        gameObject.transform.position = position;
        gameObject.transform.localScale = new Vector3(size.x, size.y, 1f);
        SpriteRenderer renderer = gameObject.AddComponent<SpriteRenderer>();
        renderer.sprite = GetWhiteSprite();
        renderer.color = color;
        return gameObject;
    }

    private static Sprite GetWhiteSprite()
    {
        if (whiteSprite != null) return whiteSprite;
        Texture2D texture = new Texture2D(1, 1);
        texture.name = "Runtime White Pixel";
        texture.SetPixel(0, 0, Color.white);
        texture.Apply();
        whiteSprite = Sprite.Create(texture, new Rect(0, 0, 1, 1), new Vector2(0.5f, 0.5f), 1f);
        return whiteSprite;
    }
}

