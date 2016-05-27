$(function(){
    var canvas = document.getElementById('parent');
    var canvas2 = document.getElementById('child');
    if(!canvas || !canvas.getContext) return false;
    if(!canvas2 || !canvas2.getContext) return false;
    var ctx = canvas.getContext('2d');
    var ctx2 = canvas2.getContext('2d');

    var startX,
        startY,
        x,
        y,
        lot,
        borderWidth = 10,
        isDrawing = false;

    // 背面レイヤ
    // 文字の描画
    ctx.font = 'bold 50px Verdana';
    ctx.textAlign = 'center';
    ctx.fillStyle = 'red';
    
    // 前面レイヤ
    // 四角形の描画
    ctx2.fillStyle = "#999";
    ctx2.fillRect(0,0, canvas.width, canvas.height); // 塗りつぶし
    
    $('#child').mousedown(function(e) {
        isDrawing = true;
        startX = e.pageX - $(this).offset().left - borderWidth;
        startY = e.pageY - $(this).offset().top - borderWidth;
        })
        .mousemove(function(e) {
            if(!isDrawing) return;
            x = e.pageX - $(this).offset().left - borderWidth;
            y = e.pageY - $(this).offset().top - borderWidth;
            ctx2.beginPath();
            ctx2.moveTo(x, y);
            ctx2.clearRect(x,y,150,150); // 切り抜き
            startX = x;
            startY = y;
        })
        .mouseup(function(e){
            isDrawing = false;
        });
});