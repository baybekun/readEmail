using Google.Apis.Auth.OAuth2;
using Google.Apis.Gmail.v1;
using Google.Apis.Gmail.v1.Data;
using Google.Apis.Services;
using Google.Apis.Util.Store;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Xml;
using HtmlAgilityPack;
using System.IO.Compression;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using System.Collections.ObjectModel;
using ImageMagick;
using Python.Runtime;
using OpenQA.Selenium.Support.UI;
using static System.Runtime.InteropServices.JavaScript.JSType;
using System.Threading;



class Program
{
    //[Obsolete]
    static void Main(string[] args)

    {
        // Create a Timer object with a specified interval (in milliseconds)
        Timer timer = new Timer(DoWork, null, TimeSpan.Zero, TimeSpan.FromSeconds(1));

        Console.WriteLine("Program started.");


        Runtime.PythonDLL = @"C:\Program Files\Python311\python311.dll";

        //Đường dẫn đến file JSON chứa thông tin xác thực
        string credentialsPath = "C:\\Users\\lenovo\\Downloads\\";

        // Tạo xác thực từ file JSON
        UserCredential credential;
        using (var stream = new FileStream(credentialsPath, FileMode.Open, FileAccess.Read))
        {
            credential = GoogleWebAuthorizationBroker.AuthorizeAsync(
                GoogleClientSecrets.Load(stream).Secrets,
                new[] { GmailService.Scope.GmailReadonly },
                "user",
                System.Threading.CancellationToken.None,
                new FileDataStore("TestApp")).Result;
        }

        // Tạo dịch vụ Gmail
        var service = new GmailService(new BaseClientService.Initializer()
        {
            HttpClientInitializer = credential,
            ApplicationName = "TestApp",
        });

        //Thay nội dung tìm kiếm trong email
        string content = "00000024";

        string subjectQuery = content;
        string contentQuery = content;

        // Xây dựng cú pháp truy vấn cho Subject và Content
        string query = $"subject:{subjectQuery} OR {contentQuery}";

        ListMessagesResponse emailListResponse = ListMessagesByQuery(service, "me", query);


        // Hiển thị thông tin email
        DisplayEmailInformation(service, emailListResponse);
        PythonEngine.Shutdown();

        Console.WriteLine("Kết thúc quá trình đến sau giải captcha vui lòng thêm tính năng");
        // Stop the timer when the program is about to exit
        timer.Dispose();
      

 

   

    }
    // Method to be executed by the timer
    static void DoWork(object state)
    {
        // Your logic for the repeated task goes here
        Console.WriteLine("Doing some work...");
    }

    private static ListMessagesResponse ListMessagesByQuery(GmailService service, string userId, string query)
    {
        try
        {
            var request = service.Users.Messages.List(userId);
            request.Q = query;

            return request.Execute();
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error listing emails by query: {ex.Message}");
            return null;
        }
    }


    private static void DisplayEmailInformation(GmailService service, ListMessagesResponse emailListResponse)
    {
        if (emailListResponse != null && emailListResponse.Messages != null && emailListResponse.Messages.Count > 0)
        {
            foreach (var email in emailListResponse.Messages)
            {
                Message emailDetails = service.Users.Messages.Get("me", email.Id).Execute();
                string emailContent = GetEmailContent(service, "me", email.Id);

                Console.WriteLine($"Subject: {emailDetails.Payload.Headers.FirstOrDefault(h => h.Name == "Subject")?.Value}");
                Console.WriteLine($"From: {emailDetails.Payload.Headers.FirstOrDefault(h => h.Name == "From")?.Value}");
                Console.WriteLine($"Content: {emailContent}");

                // Kiểm tra và tải tệp đính kèm
                DownloadAttachments(service, "me", email.Id);

                Console.WriteLine();
            }
        }
        else
        {
            Console.WriteLine("No matching emails found.");
        }
    }


    private static string GetEmailContent(GmailService service, string userId, string messageId)
    {
        try
        {
            Message message = service.Users.Messages.Get(userId, messageId).Execute();
            string body = "";

            if (message.Payload.Body != null)
            {
                body = message.Payload.Body.Data;
            }
            else if (message.Payload.Parts != null)
            {
                foreach (MessagePart part in message.Payload.Parts)
                {
                    if (part.Body != null && !System.String.IsNullOrEmpty(part.Body.Data))
                    {
                        body = Encoding.UTF8.GetString(Convert.FromBase64String(part.Body.Data));
                    }
                }
            }

            return body;
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error getting email content: {ex.Message}");
            return "";
        }
    }

    private static void DownloadAttachments(GmailService service, string userId, string messageId)
    {
        try
        {
            Message message = service.Users.Messages.Get(userId, messageId).Execute();

            if (message.Payload.Parts != null)
            {
                foreach (MessagePart part in message.Payload.Parts)
                {
                    if (part.Filename != null && part.Body.AttachmentId != null)
                    {
                        string attachmentId = part.Body.AttachmentId;
                        MessagePartBody attachPart = service.Users.Messages.Attachments.Get(userId, messageId, attachmentId).Execute();

                        // Xử lý dữ liệu Base64
                        string fileDataString = attachPart.Data.Replace('-', '+').Replace('_', '/');
                        while (fileDataString.Length % 4 != 0)
                        {
                            fileDataString += "=";
                        }

                        byte[] fileData = Convert.FromBase64String(fileDataString);

                        // Kiểm tra nếu thư mục TemporaryEmail không tồn tại, tạo mới
                        string directoryPath = "E:\\readEmail\\Savedata\\TemporaryEmail\\Temporary";
                        if (!Directory.Exists(directoryPath))
                        {
                            Directory.CreateDirectory(directoryPath);
                        }

                        // Lưu tệp đính kèm
                        string fullPath = Path.Combine(directoryPath, part.Filename);
                        File.WriteAllBytes(fullPath, fileData);


                        // Kiểm tra xem tệp vừa tải về có phải là XML hay không
                        if (IsXmlFile(fullPath))
                        {
                            // Nếu là tệp XML, thực hiện đọc hóa đơn XML và tải lên trang web
                            ProcessXmlFile(fullPath);
                            break;
                        }
                        else
                        {
                            Console.WriteLine($"The downloaded file '{part.Filename}' is not an XML file.");
                            

                            // Nếu không phải là XML, kiểm tra xem có phải là file nén không
                            if (IsZipFile(fullPath))
                            {
                                // Nếu là file nén, giải nén và kiểm tra và xử lý các tệp .xml trong thư mục giải nén
                                UnzipAndProcessXmlFiles(fullPath);
                            }
                        }

                        Console.WriteLine($"Attachment '{part.Filename}' processed successfully.");
                    }
                }
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error processing attachments: {ex.Message}");
        }
    }

    private static bool IsXmlFile(string filePath)
    {
        try
        {
            // Đọc nội dung của tệp và kiểm tra xem có phải là XML không
            string fileContent = File.ReadAllText(filePath);
            var xmlDoc = new System.Xml.XmlDocument();
            xmlDoc.LoadXml(fileContent);
            return true;
        }
        catch (Exception)
        {
            return false;
        }
    }

    private static void ProcessXmlFile(string filePath)
    {
        try
        {
            string PathXml = "E:\\readEmail\\Savedata\\Savedata\\TemporaryEmail\\Temporary";

            string[] xmlFiles = Directory.GetFiles(PathXml, "*.xml", SearchOption.AllDirectories);
            if (xmlFiles.Length > 0)
            {


                Console.WriteLine("Found XML files in the extracted folder:");

                foreach (string xmlFilePath in xmlFiles)
                {
                    Console.WriteLine(xmlFilePath);
                    UploadXmlFileUsingWebDriver(xmlFilePath);
                    break;
                }
                // Xóa thư mục ExtractedData sau khi upload thành công
                DeleteExtractedDataFolder(PathXml);

            }
            else
            {
                Console.WriteLine("No XML files found in the extracted folder.");
            }
            
            
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error processing XML file: {ex.Message}");
        }
    }



    private static bool IsZipFile(string filePath)
    {
        return Path.GetExtension(filePath).Equals(".zip", StringComparison.OrdinalIgnoreCase);
    }

    private static void UnzipAndProcessXmlFiles(string zipFilePath)
    {
        try
        {
            string extractPath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "E:\\readEmail\\Savedata\\TemporaryFolder\\ExtractedData");
            ZipFile.ExtractToDirectory(zipFilePath, extractPath);

            // Kiểm tra và xử lý các file .xml trong thư mục giải nén
            string[] xmlFiles = Directory.GetFiles(extractPath, "*.xml", SearchOption.AllDirectories);

            if (xmlFiles.Length > 0)
            {
                Console.WriteLine("Found XML files in the extracted folder:");

                foreach (string xmlFilePath in xmlFiles)
                {
                    Console.WriteLine(xmlFilePath);
                    UploadXmlFileUsingWebDriver(xmlFilePath);
                    break;
                }
                // Xóa thư mục ExtractedData sau khi upload thành công
                DeleteExtractedDataFolder(extractPath);

            }
            else
            {
                Console.WriteLine("No XML files found in the extracted folder.");
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error extracting and processing XML files: {ex.Message}");
        }
    }

    private static void DeleteExtractedDataFolder(string folderPath)
    {
        try
        {
            if (Directory.Exists(folderPath))
            {
                Directory.Delete(folderPath, true);
                Console.WriteLine($"The folder '{folderPath}' has been deleted successfully.");
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error deleting the folder: {ex.Message}");
        }
    }



    private static void UploadXmlFileUsingWebDriver(string xmlFilePath)
    {
        string url = "https://hoadondientu.gdt.gov.vn/";
        string directoryPath = "E:\\readEmail\\PythonLoadmodel\\PythonLoadmodel\\pythonEnCodecaptcha\\captcha_images_v2";

        // Khởi tạo WebDriver
        using (IWebDriver driver = new ChromeDriver())
        {
            try
            {
                driver.Navigate().GoToUrl(url);
                System.Threading.Thread.Sleep(1000);
                if (!Directory.Exists(directoryPath))
                    Directory.CreateDirectory(directoryPath);
                IWebElement closeButton = driver.FindElement(By.ClassName("ant-modal-close"));
                closeButton.Click();
                System.Threading.Thread.Sleep(1000);
                IWebElement clickButtonNext = driver.FindElement(By.ClassName("ant-tabs-tab-next"));
                clickButtonNext.Click();
                System.Threading.Thread.Sleep(1000);
                string divTextDHD = "Đọc hóa đơn XML";
                IWebElement divElementDHD = driver.FindElement(By.XPath($"//div[text()='{divTextDHD}']"));
                divElementDHD.Click();
                IWebElement clickButtonReadIVXML = driver.FindElement(By.ClassName("ant-tabs-tab-active"));
                clickButtonReadIVXML.Click();
                // Find the file input element by its type attribute with the value "file"
                IWebElement fileInput = driver.FindElement(By.CssSelector("input[type='file']"));
                // Send the path of the XML file to the file input element
                fileInput.SendKeys(xmlFilePath);
                // Wait for a few seconds to allow the file to be uploaded
                Console.WriteLine("File uploaded successfully.");
                System.Threading.Thread.Sleep(1000);
                // Sử dụng XPath để chọn button bên trong div
                //IWebElement clickButtonCheckInvoice = driver.FindElement(By.XPath("//div[contains(@class, 'ant-col')]//button[contains(., 'Kiểm tra thông tin hóa đơn')]"));
                //clickButtonCheckInvoice.Click();

                //EnCaptcha
                System.Threading.Thread.Sleep(3000);

                while (true)
                {
                    // Sử dụng XPath để chọn button bên trong div
                    IWebElement clickButtonCheckInvoicelop = driver.FindElement(By.XPath("//div[contains(@class, 'ant-col')]//button[contains(., 'Kiểm tra thông tin hóa đơn')]"));
                    clickButtonCheckInvoicelop.Click();

                    System.Threading.Thread.Sleep(2000);
                    IWebElement parentSubmitModelDiv1 = driver.FindElement(By.XPath("//div[contains(@class, 'ant-modal-body')]"));
                    IWebElement imgNode = parentSubmitModelDiv1.FindElement(By.ClassName("cmYBSe"));
                    dynamic rescaptcha = "";

                    if (imgNode != null)
                    {
                        string imgbyte = imgNode.GetAttribute("src").Substring(26);
                        byte[] bytes = Convert.FromBase64String(imgbyte);
                        string imageName = "p.svg";
                        string svgPath = Path.Combine(directoryPath, imageName);
                        File.WriteAllBytes(svgPath, bytes);
                        string pngPath = Path.Combine(directoryPath, "p" + ".png");
                        ConvertSvgToPng(svgPath, pngPath);
                        System.Threading.Thread.Sleep(2000);
                        PythonEngine.Initialize();
                        using (Py.GIL())
                        {
                            dynamic sys = Py.Import("sys");
                            sys.path.append(@"E:\readEmail\PythonLoadmodel\pythonEnCodecaptcha");

                            dynamic pythonScript = Py.Import("run");
                            var imgpath = new PyString("E:/readEmail/PythonLoadmodel/pythonEnCodecaptcha/captcha_images_v2/p.png");

                            dynamic result = pythonScript.handlebef(imgpath);
                            rescaptcha = result;
                            Console.WriteLine(rescaptcha);
                        }

                        IWebElement parentModelDiv = driver.FindElement(By.XPath("//div[contains(@class, 'ant-modal')]"));
                        IWebElement inputCaptchaCheckInvoice = parentModelDiv.FindElement(By.TagName("input"));
                        System.Threading.Thread.Sleep(1000);
                        inputCaptchaCheckInvoice.SendKeys((string)rescaptcha);

                        IWebElement parentSubmitModelDiv = driver.FindElement(By.XPath("//div[contains(@class, 'ant-modal-body')]"));
                        IWebElement buttonSMModel = parentSubmitModelDiv.FindElement(By.XPath(".//button[@type='submit']"));
                        buttonSMModel.Click();
                        System.Threading.Thread.Sleep(1000);
                        ReadOnlyCollection<IWebElement> errorSpans = driver.FindElements(By.XPath("//span[contains(@class, 'ant-notification-notice-message-single-line-auto-margin')]"));
                        if (errorSpans.Count > 0)
                        {
                            Console.WriteLine("Mã captcha không đúng.");
                            continue; // Lặp lại quá trình giải captcha
                        }
                        else if(errorSpans.Count == 0)
                        {
                            Console.WriteLine("Mã captcha đúng.");
                            PythonEngine.Shutdown();

                            break;
                        }
                    }
                    else
                    {
                        Console.WriteLine("Không tìm thấy thẻ <img> chứa ảnh captcha.");
                        break;
                    }

                }

                driver.Quit();

                void ConvertSvgToPng(string svgPath, string pngPath)
                {
                    using (var image = new MagickImage(svgPath))
                    {
                        image.Format = MagickFormat.Png;
                        image.Alpha(AlphaOption.Remove);
                        image.BackgroundColor = MagickColors.Transparent;
                        image.Write(pngPath);
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex);
            }
        }
    }

   




}
