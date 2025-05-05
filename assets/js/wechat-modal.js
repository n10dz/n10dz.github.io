// 定义全局函数
window.showWechatQR = function() {
    console.log('Showing QR code');
    var modal = document.getElementById('wechatModal');
    if (modal) {
        modal.style.display = 'block';
    } else {
        console.error('Modal element not found');
    }
}

window.closeWechatQR = function() {
    console.log('Closing QR code');
    var modal = document.getElementById('wechatModal');
    if (modal) {
        modal.style.display = 'none';
    }
}

// 点击模态框外部时关闭
window.onclick = function(event) {
    var modal = document.getElementById('wechatModal');
    if (event.target == modal) {
        modal.style.display = 'none';
    }
} 