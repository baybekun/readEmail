<?xml version='1.0' encoding='UTF-8' ?>
<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:inv="http://laphoadon.gdt.gov.vn/2014/09/invoicexml/v1" xmlns:ds="http://www.w3.org/2000/09/xmldsig#">
  <xsl:strip-space elements="*"/>
  <xsl:decimal-format decimal-separator="," grouping-separator="."/>
  <xsl:template name="tokenize">
    <xsl:param name="pText"/>
    <xsl:if test="string-length($pText)">
      <xsl:choose>
        <xsl:when test="contains($pText,',')">
          <xsl:variable name="text">
            <xsl:value-of select="substring-before($pText, ',')"/>
          </xsl:variable>
          <xsl:choose>
            <xsl:when test="substring($text,1,3) = 'CN='">
              <xsl:value-of select="substring-after($text, 'CN=')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="tokenize">
                <xsl:with-param name="pText" select=
       "substring-after($pText, ',')"/>
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:if test="substring($pText,1,3) = 'CN='">
            <xsl:value-of select="substring-after($pText, 'CN=')"/>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>
  <xsl:template name="string-replace-all">
    <xsl:param name="text"/>
    <xsl:param name="replace"/>
    <xsl:param name="by"/>
    <xsl:param name="spl"/>
    <xsl:choose>
      <xsl:when test="contains($text,$replace)">
        <xsl:value-of select="substring-before($text,$replace)"/>
        <xsl:value-of select="$by"/>
        <br/>
        <xsl:value-of select="$spl"/>
        <xsl:call-template name="string-replace-all">
          <xsl:with-param name="text" select="substring-after($text,$replace)"/>
          <xsl:with-param name="replace" select="$replace"/>
          <xsl:with-param name="by" select="$by"/>
          <xsl:with-param name="spl" select="$spl"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="loop">
    <xsl:param name="var"></xsl:param>
    <xsl:choose>
      <xsl:when test="$var &lt; 7 and $var &gt; 0">
        <tr>
          <td align="center" class= "boxSmall itemNormal">
            <font class="labelNormal"></font>
          </td>
          <td align="left" class= "boxSmall itemNormal">
          </td>
          <td align="center" class= "boxSmall itemNormal">
          </td>
          <td align="right" class= "boxSmall itemNormal">
          </td>
          <td align="right" class= "boxSmall itemNormal">
          </td>
          <td align="right" class= "boxSmall itemNormal">
          </td>
          <td align="right" class= "boxSmall itemNormal">
          </td>
          <td align="right" class= "boxSmall itemNormal">
          </td>
          <td align="right" class= "boxSmall itemNormal">
          </td>
        </tr>
        <xsl:call-template name="loop">
          <xsl:with-param name="var">
            <xsl:number value="number($var)+1" />
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="/HDon">
    <html>
      <head>
        <style>
          tbody{
          }
          .header{
          vertical-align:top
          }
          .invoiceName{
          font-weight:bold;
          font-size:18px;
          }
          .titleInvoice{
          font-weight:bold;
          font-style: normal;
          font-size:16px;
          }
          .serif {
          font-family: "Times New Roman", Times, serif;
          }

          .sansserif {
          font-family: Arial, Helvetica, sans-serif;
          }
          .image-box {
          text-align:center;
          }
          .image-box img {
          opacity: 0.3;
          width: 350px;
          background-image: none;
          background-repeat: no-repeat;
          background-position: center center;
          background-size: cover;
          margin-top:300px;
          margin-bottom: 100px;
          }

          img[src=""] {
          display: none;
          }

          .watermark {
          top: 0;
          left: 0;
          bottom: 0;
          right: 0;
          position: absolute;
          z-index: -2;
          margin-left:auto;
          margin-right:auto;
          width:400px;
          margin-top: 0px;
          }

          .itemNormal{
          font-weight: normal;
          padding : 2px 2px 2px 2px
          }

          .itemBold{
          font-weight:bold;
          /*vertical-align:top;*/
          padding : 2px 2px 2px 2px
          }
          .labelNormal{
          padding : 2px 2px 2px 2px
          }

          .labelItalic{
          padding : 2px 2px 2px 2px;
          font-style: italic;
          color: #000000;
          }

          .labelItalicNormal{
          padding : 2px 2px 2px 2px;
          font-style: italic;
          font-weight: normal;
          color: #000000;
          }

          .labelBold{
          font-weight:bold;
          /*vertical-align:top;*/
          padding : 2px 2px 2px 2px
          }



          .boxLarge{
          margin-left:auto;
          margin-right:auto;
          border-collapse: collapse;
          padding : 5px 5px 5px 5px;
          border: 3px solid;
          width:838.267px;
          }
          .boxSmall{
          border-collapse: collapse;
          padding : 5px 5px 5px 5px;
          border: 1px solid;
          }
          .boxSmallTable{
          border-spacing: 0px;
          padding : 0px 0px 0px 0px;
          border: 1px solid;
          }
          .dataInfoInvoice{
          vertical-align:top;
          font-weight:bold;
          padding : 2px 2px 2px 2px
          }
          <!--Bat buoc phai co - dau hieu nhan biet de change color-->
          <!--Start_color-->
          .invoiceName{
          color: #000000;
          }
          .invoiceNameItalic{
          color: #000000;
          font-style: italic;
          }
          .titleInvoice{
          color: #000000;
          }
          .itemNormal{
          color: #000000;
          }
          .itemBold{
          color: #000000;
          }
          .labelNormal{
          color: #000000;
          }
          .labelBold{
          color: #000000;
          }
          .boxLarge{
          color: #000000;
          border-style: solid;
          border-width: medium;
          }
          .boxSmall{
          color: #000000;
          }


          .borderBottom{
          border-bottom: 2px solid #4C3F57;
          }

          .BG {
          <!--opacity: 0.3;-->
          background-image: url(signature.png);
          background-repeat: no-repeat;
          background-position: center top;
          background-size: 200px 70px;
          }
        </style>
      </head>
      <body >
        <table  id='section-to-print' ALIGN="center" class = "serif boxLarge" style="background-image:url(watermark.png); background-repeat:no-repeat;background-position: center 300px;">
          <tr class = "borderBottom">
            <td align="center" width = "20%">
              <img src="logo.png" align="middle" style="max-height:60px ; max-width: 100%"/>
              <br/>
            </td>
            <td width="50%" align="center" class="header" style="color:#000000; padding-top:10px; padding-bottom:4mm">
              <font class="invoiceName">
                HÓA ĐƠN GIÁ TRỊ GIA TĂNG
              </font>
              <br/>
              <font class="titleInvoice">Bản thể hiện của hóa đơn điện tử</font>
              <br/>
              <xsl:choose>
                <xsl:when test="DLHDon/TTChung/NLap !='null'">
                  <font class="labelNormal">Ngày </font>
                  <!--<font class="labelItalic" >(date) </font>-->
                  <xsl:value-of select="substring(DLHDon/TTChung/NLap, 9, 2)"/>
                  <font class="labelNormal"> tháng </font>
                  <!--<font class="labelItalic" >(month) </font>-->
                  <xsl:value-of select="substring(DLHDon/TTChung/NLap, 6, 2)"/>
                  <font class="labelNormal"> năm </font>
                  <!--<font class="labelItalic" >(year) </font>-->
                  <xsl:value-of select="substring(DLHDon/TTChung/NLap, 1, 4)"/>
                </xsl:when>
                <xsl:otherwise>
                  Ngày..... tháng..... năm....
                </xsl:otherwise>
              </xsl:choose>

            </td>
            <td width="30%" style="vertical-align:top;">
              <!--<table align="right" class= "boxSmall dataInfoInvoice" style = "border: none !important;">-->
              <table align="right" class= "boxSmall" style = "border: none !important;">
                <tr>
                  <td align="left">
                    <font class="labelBold" >Ký hiệu: </font>
										<!--<font class="labelItalic" >(Serial): </font>-->
                  </td>
                  <td align="left" class = "itemNormal">
                   <xsl:value-of select="DLHDon/TTChung/KHMSHDon"/><xsl:value-of select="DLHDon/TTChung/KHHDon"/>
                  </td>
                </tr>
                <tr>
                  <td align="left">
                    <font class="labelBold" >Số: </font>
                    <!--<font class="labelItalic" >(No.): </font>-->
                  </td>
                  <td align="left" class = "itemNormal">
                    <xsl:value-of select="DLHDon/TTChung/SHDon"/>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
          <tr class = "borderBottom">
            <td colspan="3">
              <table width="100%">
                <tr>
                  <td colspan="3" >
                    <table>
                      <tr>
                        <td>
                          <font class="labelBold" >Đơn vị bán hàng: </font>
                          <!--<font class="labelItalic" >(Issued): </font>-->
                          <font class="itemNormal">
                            <xsl:value-of select="DLHDon/NDHDon/NBan/Ten"/>
                          </font>
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
				
				  <tr>
                  <td colspan="3">
                    <table>
                      <tr>
                        <td>
                          <font class="labelBold" >Địa chỉ: </font>
                          <!--<font class="labelItalic" >(Address): </font>-->
                          <font class="itemNormal">
                            <xsl:value-of select="DLHDon/NDHDon/NBan/DChi"/>
                          </font>
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
				
                <tr>
                  <td colspan="3">
                    <table>
                      <tr>
                        <td>
                          <font class="labelBold" >Mã số thuế: </font>
                          <!--<font class="labelItalic" >(Tax code): </font>-->
                          <font class="itemNormal">
                            <!--<strong style = "border: 1px solid #000;"><xsl:value-of select="DLHDon/NDHDon/NBan/MST"/></strong>-->
                            <xsl:variable name = "sellerTaxCodeLength" select = "string-length(DLHDon/NDHDon/NBan/MST)"/>
                            <xsl:variable name = "sellerTaxCode" select = "DLHDon/NDHDon/NBan/MST"/>
                            <xsl:value-of select="$sellerTaxCode"/>
                          </font>
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
              
                <tr>
                  <td colspan="3">
                    <table width="100%">
                      <tr>
                        <td width = "30%" >
                          <font class="labelBold" >Điện thoại: </font>
                          <!--<font class="labelItalic" >(Phone number): </font>-->
                          <font class="itemNormal">
                            <xsl:value-of select="DLHDon/NDHDon/NBan/SDThoai"/>
                          </font>
                        </td>
                        <td width = "20%" >
                           <font class="labelBold" >Số tài khoản:</font>
                          <!--<font class="labelItalic" >(Phone number): </font>-->
						  <font class="itemNormal">
                            <xsl:variable name="FeatureInfo" select="DLHDon/NDHDon/NBan/STKNHang" />
                            <xsl:call-template name="string-replace-all">
                              <xsl:with-param name="text" select="$FeatureInfo"/>
                              <xsl:with-param name="replace" select="';'"/>
                              <xsl:with-param name="by" select="'&#160;'"/>
                              <xsl:with-param name="spl" select="''"/>
                            </xsl:call-template>
                          </font>
                          
                        </td>
                        <td  width = "50%">
                          <font class="labelBold" >Ngân hàng: </font>
                          <!--<font class="labelItalic" >(Account No.): </font>-->
                          <font class="itemNormal">
                            <xsl:variable name="FeatureInfo" select="DLHDon/NDHDon/NBan/TNHang" />
                            <xsl:call-template name="string-replace-all">
                              <xsl:with-param name="text" select="$FeatureInfo"/>
                              <xsl:with-param name="replace" select="';'"/>
                              <xsl:with-param name="by" select="'&#160;'"/>
                              <xsl:with-param name="spl" select="''"/>
                            </xsl:call-template>
                          </font>
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
               
              </table>
            </td>
          </tr>
          <tr>
            <td colspan="3">
              <table width="100%">
                <tr>
                  <td colspan="3">
                    <table width="100%">
                      <tr>
                        <td>
                          <font class="labelBold" >Họ tên người mua hàng: </font>
                          <!--<font class="labelItalic" >(Customer): </font>-->
                          <font class="itemNormal">
                            <xsl:value-of select="DLHDon/NDHDon/NMua/HVTNMHang"/>
                          </font>
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
                <tr>
                  <td colspan="3">
                    <table align="left" width="100%">
                      <tr>
                        <td>
                          <font class="labelBold" >Tên đơn vị: </font>
                          <!--<font class="labelItalic" >(Company): </font>-->
                          <font class="itemNormal">
                            <xsl:value-of select="DLHDon/NDHDon/NMua/Ten"/>
                          </font>
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
				 <tr>
                  <td colspan="3">
                    <table align="left" width="100%">
                      <tr>
                        <td>
                          <font class="labelBold" >Địa chỉ: </font>
                          <!--<font class="labelItalic" >(Address): </font>-->
                          <font class="itemNormal">
                            <xsl:value-of select="DLHDon/NDHDon/NMua/DChi"/>
                          </font>
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
				 <tr>
                  <td colspan="3">
                    <table align="left" width="100%">
                      <tr>
                        
                        <td style="width: 30%">
                          <font class="labelBold" >Mã số thuế: </font>
                          <!--<font class="labelItalic" >(Tax code): </font>-->
                          <font class="itemNormal">
                            <xsl:value-of select="DLHDon/NDHDon/NMua/MST"/>
                          </font>
                        </td>
						<td style="width: 70%">
                          <font class="labelBold" >Hình thức thanh toán: </font>
                          <font class="itemNormal">
                            <xsl:value-of select="DLHDon/TTChung/HTTToan"/>
                          </font>
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
               
               
                <tr>
                  <td colspan="3">
                    <table align="left" width="100%">
                      <tr>
                        <td style="width: 30%">
                          <font class="labelBold" >Số tài khoản: </font>
                          <font class="itemNormal">
                            <xsl:value-of select="DLHDon/NDHDon/NMua/STKNHang"/>
                          </font>
                        </td>
                        <td style="width: 40%">
                          <font class="labelBold" >Ngân hàng: </font>
                          <!--<font class="labelItalic" >(Account No.): </font>-->
                          <font class="itemNormal">
                            <xsl:value-of select="DLHDon/NDHDon/NMua/TNHang"/>
                          </font>
                        </td>
						
						<td style="width: 30%">
                          <font class="labelBold" >Số điện thoại: </font>
                          <!--<font class="labelItalic" >(Account No.): </font>-->
                          <font class="itemNormal">
                            <xsl:value-of select="DLHDon/NDHDon/NMua/SDThoai"/>
                          </font>
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
               
              </table>
            </td>
          </tr>
          <tr>
            <td colspan="3">
              <table width="100%" class= "boxSmallTable" style="font-size: 10pt;">
                <tr width="100%">
                  <td width="5%" align="center" class= "boxSmall">
                    <font class="labelBold" >STT</font>
                    <!--<br/>
                    <font class="labelItalicNormal">(No.)</font>-->
                  </td>
                  <td align="center" class= "boxSmall">
                    <font class="labelBold" >Tên hàng hóa, dịch vụ</font>
                    <!--<br/>
                    <font class="labelItalicNormal" >(Description)</font>-->
                  </td>
                  <td width="8%" align="center" class= "boxSmall">
                    <font class="labelBold" >ĐVT</font>
                    <!--<br/>
                    <font class="labelItalicNormal" >(Unit)</font>-->
                  </td>
                  <td width="8%" align="center" class= "boxSmall">
                    <font class="labelBold" >Số lượng</font>
                    <!--<br/>
                    <font class="labelItalicNormal" >(Qty)</font>-->
                  </td>
                  <td width="10%" align="center" class= "boxSmall">
                    <font class="labelBold" >Đơn giá</font>
										<!--<br/>
										<font class="labelItalicNormal" >(Unit price)</font>-->
                  </td>
                  <td width="11%" align="center" class= "boxSmall">
                    <font class="labelBold" >hành tiền
trước thuế
GTGT</font>
                    <!--<br/>
                    <font class="labelItalicNormal" >(Amount)</font>-->
                  </td>
                  <td width="5%" align="center" class= "boxSmall" >
                    <font class="labelBold" >Thuế suất thuế GTGT (%)</font>
                  </td>
                  <td width="10%" align="center" class= "boxSmall" >
                    <font class="labelBold" >Tiền thuế GTGT</font>
                  </td>
                  <td width="12%" align="center" class= "boxSmall">
                    <font class="labelBold" >Thành tiền sau thuế GTGT</font>
                    <!--<br/>
                    <font class="labelItalicNormal" >(Total)</font>-->
                  </td>
                </tr>
                <tr>
                  <td align="center" class= "boxSmall">
                    <font class="labelBold" >1</font>
                  </td>
                  <td align="center" class= "boxSmall">
                    <font class="labelBold" >2</font>
                  </td>
                  <td align="center" class= "boxSmall">
                    <font class="labelBold" >3</font>
                  </td>
                  <td align="center" class= "boxSmall">
                    <font class="labelBold" >4</font>
                  </td>
                  <td align="center" class= "boxSmall">
                    <font class="labelBold" >5</font>
                  </td>
                  <td align="center" class= "boxSmall">
                    <font class="labelBold" >6 = 4 x 5</font>
                  </td>
                  <td align="center" class= "boxSmall">
                    <font class="labelBold" >7</font>
                  </td>
                  <td align="center" class= "boxSmall">
                    <font class="labelBold" >8 = 6 x 7</font>
                  </td>
                  <td align="center" class= "boxSmall">
                    <font class="labelBold" >9 = 6 + 8</font>
                  </td>
                </tr>
                <xsl:for-each select="DLHDon/NDHDon/DSHHDVu/HHDVu">
                  <tr>
                    <td align="center" class= "boxSmall itemNormal">
                      <xsl:choose>
                        <xsl:when test="STT > 0">
                          <xsl:value-of select="STT"/>
                        </xsl:when>
                        <xsl:otherwise>
                          <font class="labelNormal" ></font>
                        </xsl:otherwise>
                      </xsl:choose>
                    </td>
                    <td align="left" class= "boxSmall itemNormal">
                      <xsl:value-of select="THHDVu"/>
                    </td>
                    <td align="center" class= "boxSmall itemNormal">
                      <xsl:value-of select="DVTinh"/>
                    </td>
                    <td align="right" class= "boxSmall itemNormal">
                      <xsl:if test="SLuong != 'null' and SLuong != ''">
                        <xsl:value-of select="format-number(SLuong, '###.##0,#########')"/>
                      </xsl:if>
                    </td>
                    <td align="right" class= "boxSmall itemNormal">
                      <xsl:if test="DGia != 'null' and DGia != ''">
                        <xsl:value-of select="format-number(DGia, '###.##0,#########')"/>
                      </xsl:if>
                    </td>
                    <td align="right" class= "boxSmall itemNormal">
                      <xsl:if test="ThTien != 'null' and ThTien != ''">
                        <xsl:value-of select="format-number(ThTien, '###.##0,#########')"/>
                      </xsl:if>
                    </td>
                    <td align="right" class= "boxSmall itemNormal">
                      <xsl:choose>
                        <xsl:when test="not(TSuat) = false() and (TSuat = '0%' or TSuat = '5%' or TSuat = '10%' or TSuat = '8%' or contains(TSuat, 'KHAC'))">
                          <xsl:value-of select="TSuat"/>
                        </xsl:when>
                        <xsl:when test="not(TSuat) = false() and (TSuat ='KKKNT' or TSuat = 'KCT')" >
                          \
                        </xsl:when>
                        <xsl:otherwise>
                        </xsl:otherwise>
                      </xsl:choose>
                    </td>
                    <td align="right" class= "boxSmall itemNormal">
                      <xsl:choose>
                        <xsl:when test="not(TSuat) = false() and (TSuat = '0%' or TSuat = '5%' or TSuat = '10%' or TSuat = '8%' or contains(TSuat, 'KHAC')) and not(TTKhac/TTin[TTruong='Tiền thuế dòng (Tiền thuế GTGT)']/DLieu) = false()">
                          <xsl:value-of select="format-number(TTKhac/TTin[TTruong='Tiền thuế dòng (Tiền thuế GTGT)']/DLieu, '###.##0,#########')"/>
                        </xsl:when>
                        <xsl:when test="not(TSuat) = false() and (TSuat ='KKKNT' or TSuat = 'KCT')" >
                          \
                        </xsl:when>
                        <xsl:otherwise>
                        </xsl:otherwise>
                      </xsl:choose>
                    </td>
                    <td align="right" class= "boxSmall itemNormal">
                      <xsl:if test="TTKhac/TTin[TTruong='Thành tiền thanh toán của hàng hóa']/DLieu != 'null'">
                        <xsl:value-of select="format-number(TTKhac/TTin[TTruong='Thành tiền thanh toán của hàng hóa']/DLieu, '###.##0,#########')"/>
                      </xsl:if>
                    </td>
                  </tr>
                </xsl:for-each>
                <xsl:call-template name="loop">
                  <xsl:with-param name="var">
                    <xsl:value-of select="count(//DLHDon/NDHDon/DSHHDVu/HHDVu)"/>
                  </xsl:with-param>
                </xsl:call-template>
                <!-- <tr> -->
                  <!-- <td align="right" colspan="5" class= "boxSmall"> -->
                    <!-- <font class="labelBold" >Cộng tiền hàng hóa, dịch vụ:</font> -->
                    <!-- <font class="labelItalic" >(Invoice total):</font> -->
                  <!-- </td> -->
                  <!-- <td align="right" class= "boxSmall itemNormal"> -->
                    <!-- <xsl:if test="DLHDon/NDHDon/TToan /TgTCThue != 'null'"> -->
                      <!-- <xsl:value-of select="format-number(DLHDon/NDHDon/TToan /TgTCThue, '###.##0,#########')"/> -->
                    <!-- </xsl:if> -->
                  <!-- </td> -->
                  <!-- <td align="right" class= "boxSmall itemNormal"> -->
                    
                  <!-- </td> -->
                  <!-- <td align="right" class= "boxSmall itemNormal"> -->
                    <!-- <xsl:if test="DLHDon/NDHDon/TToan /TgTThue != 'null'"> -->
                      <!-- <xsl:value-of select="format-number(DLHDon/NDHDon/TToan /TgTThue, '###.##0,#########')"/> -->
                    <!-- </xsl:if> -->
                  <!-- </td> -->
                  
                <!-- </tr> -->
                <tr>
                  <td align="center" colspan="8" class= "boxSmall">
                    <font class="labelBold" >Tổng cộng</font>
                    <!--<font class="labelItalic" >(Invoice total):</font>-->
                  </td>
				  <td align="right" class= "boxSmall itemNormal" >
                    <xsl:if test="DLHDon/NDHDon/TToan /TgTTTBSo != 'null'">
                      <xsl:value-of select="format-number(DLHDon/NDHDon/TToan /TgTTTBSo, '###.##0,#########')"/>
                    </xsl:if>
                  </td>
                </tr>
                <tr>
                  <td align="left" colspan="9" class= "boxSmall">
                    <font class="labelBold" >Số tiền viết bằng chữ</font>
                    <!--<font class="labelItalic" >(Amount in words):</font>-->
                    <font class = "itemNormal">
                      <xsl:value-of select="DLHDon/NDHDon/TToan /TgTTTBChu"/>
                    </font>
                  </td>
                </tr>
                <tr>
                  <td colspan="9">
                    <table align="left" width="100%">
                      <tr>
                        <td align="left" style="width: 50%">
                          <font class="lableNormal">Tổng tiền không chịu thuế: </font>
                          <!--<font class="labelItalic" >(Not taxable amount):</font>-->
                          <xsl:for-each select="DLHDon/NDHDon/TToan/THTTLTSuat/LTSuat">
                            <xsl:if test="TSuat = 'KCT'">
                              <font class = "lableNormal">
                                <xsl:value-of select="format-number(ThTien, '###.##0,#########')"/>
                              </font>
                            </xsl:if>
                          </xsl:for-each>
                        </td>
                      </tr>
                      <tr>
                        <td align="left" style="width: 50%">
                          <font class="lableNormal">Tổng tiền chịu thuế 0%: </font>
                          <xsl:for-each select="DLHDon/NDHDon/TToan/THTTLTSuat/LTSuat">
                            <xsl:if test="TSuat = '0%'">
                              <font class = "lableNormal">
                                <xsl:value-of select="format-number(ThTien, '###.##0,#########')"/>
                              </font>
                            </xsl:if>
                          </xsl:for-each>
                        </td>
                      </tr>
                      <tr>
                        <td align="left" style="width: 50%">
                          <font class="lableNormal">Tổng tiền chịu thuế 5%: </font>
                          <xsl:for-each select="DLHDon/NDHDon/TToan/THTTLTSuat/LTSuat">
                            <xsl:if test="TSuat = '5%'">
                              <font class = "lableNormal">
                                <xsl:value-of select="format-number(ThTien, '###.##0,#########')"/>
                              </font>
                            </xsl:if>
                          </xsl:for-each>
                        </td>
                        <td align="left" style="width: 50%">
                          <font class="lableNormal">Tổng tiền thuế GTGT 5%: </font>
                          <xsl:for-each select="DLHDon/NDHDon/TToan/THTTLTSuat/LTSuat">
                            <xsl:if test="TSuat = '5%'">
                              <font class = "lableNormal">
                                <xsl:value-of select="format-number(TThue, '###.##0,#########')"/>
                              </font>
                            </xsl:if>
                          </xsl:for-each>
                        </td>
                      </tr>
                      <tr>
                        <td align="left" style="width: 50%">
                          <font class="lableNormal">Tổng tiền chịu thuế 10%: </font>
                          <xsl:for-each select="DLHDon/NDHDon/TToan/THTTLTSuat/LTSuat">
                            <xsl:if test="TSuat = '10%'">
                              <font class = "lableNormal">
                                <xsl:value-of select="format-number(ThTien, '###.##0,#########')"/>
                              </font>
                            </xsl:if>
                          </xsl:for-each>
                        </td>
                        <td align="left" style="width: 50%">
                          <font class="lableNormal">Tổng tiền thuế GTGT 10%: </font>
                          <xsl:for-each select="DLHDon/NDHDon/TToan/THTTLTSuat/LTSuat">
                            <xsl:if test="TSuat = '10%'">
                              <font class = "lableNormal">
                                <xsl:value-of select="format-number(TThue, '###.##0,#########')"/>
                              </font>
                            </xsl:if>
                          </xsl:for-each>
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
          <tr>
            <td colspan="3">
              <table width="100%">
                <tr>
                  <td align="center" width="50%" style="vertical-align:top">
                    <font class="labelBold" text-align="top">Người mua hàng</font>
                    <br/>
                    <font class="labelItalic" >(Ký, ghi rõ họ tên)</font>
                    <br/>
                    <xsl:if test="not((//*[local-name()='X509SubjectName'])[3]) = false() and (//*[local-name()='X509SubjectName'])[3] != ''">
                      <div class="BG">
                        <div style="height: 30px"  ></div>

                        <font class="labelBold" style="font-weight:bold;color: #FF0000;word-wrap:break-word">
                          Ký bởi <xsl:call-template name="tokenize">
                            <xsl:with-param name="pText" select="(//*[local-name()='X509SubjectName'])[3]"/>
                          </xsl:call-template>
                        </font>

                        <div style="height: 10px"  ></div>
                      </div>
                    </xsl:if>
                  </td>
                  <td  align="center" width="50%">
                    <font class="labelBold" >Người bán hàng</font>
                    <br/>
                    <font class="labelItalic" >(Ký, ghi rõ họ tên)</font>
                    <br/>
                    <div class="BG">
                      <div style="height: 30px"  ></div>
                      <xsl:if test="DLHDon/NDHDon/NBan/Ten != 'null'">
                        <font class="labelBold" style="font-weight:bold;color: #FF0000;word-wrap:break-word">
                          Ký bởi <xsl:call-template name="tokenize">
                          <xsl:with-param name="pText" select="(//*[local-name()='X509SubjectName'])[1]"/>
                        </xsl:call-template>
                        </font>
                        <br/>
                        <font class="labelBold" style="font-weight:bold;color: #FF0000;word-wrap:break-word">
                          Ký ngày
                          <xsl:if test="DLHDon/TTChung/NLap != 'null' and DLHDon/TTChung/NLap != ''">
                            <xsl:value-of select="concat(substring((//*[local-name()='SigningTime'])[1], 9, 2),'/',substring((//*[local-name()='SigningTime'])[1], 6, 2),'/',substring((//*[local-name()='SigningTime'])[1], 1, 4))"/>
                          </xsl:if>
                        </font>
                      </xsl:if>
                      <div style="height: 10px"  ></div>
                    </div>
                  </td>
                </tr>                
              </table>
            </td>
          </tr>
          <tr >
            <td colspan="3">
              <table width="100%" style="padding-top: 10mm; font-size: 10pt">
                <tr>
                  <td align="center"  class="borderBottom">
                    <!--<font class="labelItalic"> (Cần kiểm tra, đối chiếu lập, giao, nhận hóa đơn) </font>-->
                  </td>
                </tr>
                <tr>
                  <td align="center" >
                    <font class="labelItalic"> Đơn vị cung cấp dịch vụ Hóa đơn điện tử: Tập đoàn Công nghiệp - Viễn thông Quân đội (Viettel), MST: 0100109106 </font>
                  </td>
                </tr>
                <tr>
                  <td align="center" >
                    <font class="labelItalic">Tra cứu hóa đơn điện tử tại Website: <xsl:choose>
                      <xsl:when test="not(DLHDon/NDHDon/NBan/TTKhac/TTin[TTruong='Link tra cứu người bán']/DLieu) = false() and DLHDon/NDHDon/NBan/TTKhac/TTin[TTruong='Link tra cứu người bán']/DLieu != ''">
                        <xsl:value-of select="DLHDon/NDHDon/NBan/TTKhac/TTin[TTruong='Link tra cứu người bán']/DLieu"/>
                      </xsl:when>
                      <xsl:otherwise>
                        https://vinvoice.viettel.vn/utilities/invoice-search
                      </xsl:otherwise>
                    </xsl:choose>. Mã số bí mật: </font>
                    <font class = "itemNormal">
                      <xsl:value-of select="DLHDon/TTChung/TTKhac/TTin[TTruong='Mã số bí mật']/DLieu"/>
                    </font>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
        </table>        
      </body>      
    </html>
  </xsl:template>
</xsl:transform>