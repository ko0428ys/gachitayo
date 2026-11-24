.class public Lkr/semyung/gachitayo/ExtClient;
.super Landroid/webkit/WebViewClient;
.source "ExtClient.java"

.field private act:Landroid/app/Activity;

.method public constructor <init>(Landroid/app/Activity;)V
    .registers 2
    invoke-direct {p0}, Landroid/webkit/WebViewClient;-><init>()V
    iput-object p1, p0, Lkr/semyung/gachitayo/ExtClient;->act:Landroid/app/Activity;
    return-void
.end method

.method private open(Landroid/net/Uri;)Z
    .registers 5
    invoke-virtual {p1}, Landroid/net/Uri;->getScheme()Ljava/lang/String;
    move-result-object v0
    const-string v1, "file"
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-eqz v0, :external
    const/4 v0, 0x0
    return v0
    :external
    :try_start_0
    new-instance v0, Landroid/content/Intent;
    const-string v1, "android.intent.action.VIEW"
    invoke-direct {v0, v1, p1}, Landroid/content/Intent;-><init>(Ljava/lang/String;Landroid/net/Uri;)V
    iget-object v1, p0, Lkr/semyung/gachitayo/ExtClient;->act:Landroid/app/Activity;
    invoke-virtual {v1, v0}, Landroid/app/Activity;->startActivity(Landroid/content/Intent;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    const/4 v0, 0x1
    return v0
    :catch_0
    move-exception v0
    const/4 v0, 0x1
    return v0
.end method

.method public shouldOverrideUrlLoading(Landroid/webkit/WebView;Landroid/webkit/WebResourceRequest;)Z
    .registers 4
    invoke-interface {p2}, Landroid/webkit/WebResourceRequest;->getUrl()Landroid/net/Uri;
    move-result-object v0
    invoke-direct {p0, v0}, Lkr/semyung/gachitayo/ExtClient;->open(Landroid/net/Uri;)Z
    move-result v0
    return v0
.end method

.method public shouldOverrideUrlLoading(Landroid/webkit/WebView;Ljava/lang/String;)Z
    .registers 4
    invoke-static {p2}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;
    move-result-object v0
    invoke-direct {p0, v0}, Lkr/semyung/gachitayo/ExtClient;->open(Landroid/net/Uri;)Z
    move-result v0
    return v0
.end method
