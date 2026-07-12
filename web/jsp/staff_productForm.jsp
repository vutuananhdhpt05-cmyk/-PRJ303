<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/jsp/mgmt_header.jsp">
    <jsp:param name="activeMenu" value="products" />
    <jsp:param name="pageTitle" value="${product.productID > 0 ? 'Sửa' : 'Thêm'} sản phẩm" />
</jsp:include>

    <div class="row justify-content-center">
      <div class="col-lg-8 col-md-10">
        <div class="form-container shadow-sm">
            <h4 class="mb-4">
              <c:choose>
                <c:when test="${product.productID > 0}">Sửa</c:when>
                <c:otherwise>Thêm</c:otherwise>
              </c:choose>
              sản phẩm
            </h4>
            
            <c:if test="${not empty error}">
                <div class="alert alert-danger" role="alert">
                    ${error}
                </div>
            </c:if>

            <form action="<c:url value='/staff/products'/>"
                  method="post"
                  enctype="multipart/form-data">
              
              <input type="hidden" name="productID" value="${product.productID}"/>

              <div class="mb-3">
                <label for="productName" class="form-label">Tên sản phẩm</label>
                <input
                  type="text"
                  id="productName"
                  name="productName"
                  class="form-control"
                  required
                  value="${product.productName}"/>
              </div>

              <div class="mb-3">
                <label for="description" class="form-label">Mô tả</label>
                <textarea
                  id="description"
                  name="description"
                  class="form-control"
                  rows="4"
                >${product.description}</textarea>
              </div>

              <div class="row">
                <div class="col-md-4 mb-3">
                  <label for="price" class="form-label">Giá</label>
                  <div class="input-group">
                    <span class="input-group-text">$</span>
                    <input
                      type="number"
                      step="0.01"
                      min="0.01"
                      id="price"
                      name="price"
                      class="form-control"
                      required
                      value="${product.price}"/>
                  </div>
                </div>
                <div class="col-md-4 mb-3">
                  <label for="stock" class="form-label">Số lượng</label>
                  <input
                    type="number"
                    min="1"
                    id="stock"
                    name="stock"
                    class="form-control"
                    required
                    value="${product.stock}"/>
                </div>
                <div class="col-md-4 mb-3">
                  <label for="brand" class="form-label">Hãng</label>
                  <input
                    type="text"
                    id="brand"
                    name="brand"
                    class="form-control"
                    required
                    value="${product.brand}"/>
                </div>
              </div>

              <div class="mb-3">
                <label for="imageFile" class="form-label">Ảnh sản phẩm</label>
                <input
                  type="file"
                  id="imageFile"
                  name="imageFile"
                  class="form-control"
                  accept="image/*"
                  ${product.productID > 0 ? '' : 'required'}/>
                <c:if test="${not empty product.imageUrl}">
                  <div class="mt-2">
                    <small>Ảnh hiện tại:</small><br>
                    <img src="${pageContext.request.contextPath}/${product.imageUrl}"
                         alt="Current Image"
                         class="img-thumbnail mt-2 img-preview"/>
                  </div>
                </c:if>
              </div>

              <div class="d-flex justify-content-between mt-4">
                <a href="<c:url value='/staff/products'/>" class="btn btn-secondary">
                  Hủy
                </a>
                <button type="submit" class="btn btn-primary px-4">
                  Lưu lại
                </button>
              </div>
            </form>
        </div>

      </div>
    </div>

<jsp:include page="/jsp/mgmt_footer.jsp" />

