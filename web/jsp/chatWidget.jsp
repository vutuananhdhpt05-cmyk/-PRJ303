<%@ page contentType="text/html; charset=UTF-8" language="java" session="true"%>
<%@ page import="model.User"%>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        // chưa login thì không hiển thị
        return;
    }
%>
<!-- Chat Widget Styles -->
<style>
#chatFab {
  position: fixed;
  bottom: 20px;
  right: 20px;
  width: 60px;
  height: 60px;
  background-color: #0ea5e9;
  color: white;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 28px;
  cursor: pointer;
  box-shadow: 0 4px 15px rgba(0,0,0,0.2);
  z-index: 1000;
  transition: transform 0.2s;
}
#chatFab:hover {
  transform: scale(1.1);
}

#chatWidget {
  display: none;
  position: fixed;
  bottom: 20px;
  right: 20px;
  width: 340px;
  background: #fff;
  box-shadow: 0 5px 25px rgba(0,0,0,0.2);
  border-radius: 12px;
  overflow: hidden;
  z-index: 1000;
  font-family: 'Inter', sans-serif;
}

#chatHeader {
  background: linear-gradient(135deg, #0ea5e9, #3b82f6);
  color: #fff;
  padding: 15px;
  cursor: pointer;
  user-select: none;
  font-weight: 600;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

#chatBody {
  height: 350px;
  overflow-y: auto;
  padding: 15px;
  background: #f8fafc;
  display: flex;
  flex-direction: column;
}

#chatInput {
  border-top: 1px solid #e2e8f0;
  padding: 12px;
  background: #fff;
}

#chatInput .input-group {
  display: flex;
  width: 100%;
}

#chatText {
  flex: 1;
  border-radius: 20px 0 0 20px !important;
  border: 1px solid #ced4da;
  padding: 8px 15px;
  outline: none;
}

#sendBtn {
  border-radius: 0 20px 20px 0 !important;
  padding: 8px 20px;
  background-color: #0ea5e9;
  border-color: #0ea5e9;
}

.chat-msg { margin-bottom:8px; clear:both; }
.bubble { padding:6px 10px; max-width:75%; border-radius:12px; position:relative; display:inline-block; word-wrap:break-word; }
.bubble .ts { display:block; font-size:.7em; color:#666; margin-top:4px; text-align:right; }

/* User = xanh, phải */
.chat-msg.user { align-self: flex-end; }
.chat-msg.user .bubble { background:#dcf8c6; float:right; border-radius:12px 12px 0 12px; margin-left:20%; }

/* Admin = trắng, trái */
.chat-msg.admin { align-self: flex-start; }
.chat-msg.admin .bubble { background:#fff; float:left; border:1px solid #ddd; border-radius:12px 12px 12px 0; margin-right:20%; }
</style>
  <!-- Floating Action Button -->
  <div id="chatFab">
    <i class="fa-solid fa-comments"></i>
  </div>

  <!-- Chat Panel -->
  <div id="chatWidget">
    <div id="chatHeader">
        <span><i class="fa-solid fa-comments"></i> Chat với Staff</span>
        <i class="fa-solid fa-chevron-down"></i>
    </div>
    <div id="chatBody"></div>
    <div id="chatInput">
      <div class="input-group">
        <input id="chatText" class="form-control" type="text"
               placeholder="Gõ tin nhắn và Enter..."/>
        <div class="input-group-append">
            <button id="sendBtn" class="btn btn-primary">Gửi</button>
        </div>
      </div>
    </div>
  </div>

  <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
  <script>
  $(function(){
    const $fab = $('#chatFab'),
          $widget = $('#chatWidget'),
          $h = $('#chatHeader'),
          $b = $('#chatBody'),
          $i = $('#chatInput'),
          $t = $('#chatText');

    function loadChat() {
      $b.load('${pageContext.request.contextPath}/simpleChat', function(){
        $b.scrollTop($b.prop('scrollHeight'));
      });
    }

    $fab.click(function(){
      $fab.hide();
      $widget.fadeIn(200);
      loadChat();
    });

    $h.click(function(){
      $widget.fadeOut(200, function() {
          $fab.show();
      });
    });

    function sendMsg() {
      const m = $t.val().trim();
      if (!m) return;
      $.post('${pageContext.request.contextPath}/simpleChat',
             { message: m },
             function(){
               $t.val('');
               loadChat();
             });
    }

    $t.on('keypress', e => { if (e.which === 13) sendMsg(); });
    $('#sendBtn').click(sendMsg);

    setInterval(function(){
      if ($b.is(':visible')) loadChat();
    }, 3000);
  });
  </script>