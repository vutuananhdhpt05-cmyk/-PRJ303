<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.ChatItem,model.ContactMessage,model.User" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>

<%
    User me = (User) session.getAttribute("user");
    if (me==null || (!"ADMIN".equalsIgnoreCase(me.getRole()) && !"STAFF".equalsIgnoreCase(me.getRole()))) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }
%>

<c:set var="convos"    value="${requestScope.conversations}"/>
<c:set var="items"     value="${requestScope.chatItems}"/>
<c:set var="messages"  value="${requestScope.messages}"/>
<c:set var="selEmail"  value="${requestScope.selectedEmail}"/>

<jsp:include page="/jsp/mgmt_header.jsp">
    <jsp:param name="activeMenu" value="messages" />
    <jsp:param name="pageTitle" value="Quản lý Chat" />
</jsp:include>
<link href="<c:url value='/css/staff-messages.css'/>" rel="stylesheet"/>

  <div class="inbox inbox-container">
    <!-- LEFT: danh sách conversations -->
    <div class="contacts">
      <c:forEach var="c" items="${convos}">
        <c:url var="u" value="/staff/messages">
          <c:param name="email" value="${c.email}"/>
        </c:url>
        <div class="item ${c.email==selEmail?'active':''}"
             onclick="location.href='${u}'">
          <strong>${c.name}</strong><br/>
          <small class="snippet">${c.message}</small><br/>
          <small class="text-muted">
            <fmt:formatDate value="${c.createdAt}" pattern="MM/dd HH:mm"/>
          </small>
        </div>
      </c:forEach>
    </div>

    <!-- RIGHT: chat window -->
    <div class="chat">
      <div class="chat-header">
        <strong>
          <c:forEach var="c" items="${convos}">
            <c:if test="${c.email==selEmail}">${c.name}</c:if>
          </c:forEach>
          <c:if test="${empty selEmail}">Chọn một cuộc trò chuyện</c:if>
        </strong>
      </div>

      <div class="chat-body" id="chatBody">
        <c:forEach var="it" items="${items}">
          <div class="message ${it.sender}">
            <div class="bubble ${it.sender}">
              ${it.text}
              <span class="ts">
                <fmt:formatDate value="${it.time}" pattern="HH:mm"/>
              </span>
            </div>
          </div>
        </c:forEach>
        <c:if test="${empty items && not empty selEmail}">
          <div class="text-center text-muted mt-5">
            Chưa có tin nhắn.
          </div>
        </c:if>
        <c:if test="${empty selEmail}">
            <div class="text-center text-muted mt-5">
              Vui lòng chọn một người dùng từ danh sách để xem tin nhắn.
            </div>
        </c:if>
      </div>

<div class="chat-footer p-2">
  <form action="<c:url value='/staff/reply'/>" method="post">
    <input type="hidden" name="email" value="${selectedEmail}"/>
    <div class="input-group">
      <input
        name="reply"
        type="text"
        class="form-control"
        placeholder="Nhập phản hồi…"
        required
        ${empty selEmail ? 'disabled' : ''}
      />
      <button class="btn btn-primary" type="submit" ${empty selEmail ? 'disabled' : ''}>
        Gửi
      </button>
    </div>
  </form>
</div>

    </div>
  </div>

<jsp:include page="/jsp/mgmt_footer.jsp" />

