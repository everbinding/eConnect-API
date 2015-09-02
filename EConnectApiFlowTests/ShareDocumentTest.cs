using System.Text;
using EConnectApi;
using EConnectApi.Definitions;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace EConnectApiFlowTests
{
    [TestClass]
    public class ShareDocumentTest
    {
        [TestMethod]
        public void ShareDocument()
        {
            var parameters = new ShareDocument()
                             {
                                 //DocumentId = "RA000000218DML1000022",
                                 DocumentId = "XCNIN49690",
                                 DocumentType = DocumentType.Outbox,
                                 ShareToUsers = new[]
                                                {
                                                    new ShareDocument.User()
                                                    {
                                                        Id = "thieme@selmit.nl"
                                                    }
                                                }
                             };

            var res = EConnect.Client.ShareDocument(parameters);

            //Assert.AreEqual(parameters.DocumentId, res.DocumentId);

            using (var client = new EConnectClient(new EConnectClientConfigBase()
                                                   {
                                                       ConsumerKey = "4750576f464264645852384a596f644",
                                                       ConsumerSecret = "4b6873535150557a744a6c634a51574",
                                                       RequesterId = "thieme@selmit.nl"
                                                   }))
            {
                var doc = client.GetDocument(new GetDocument()
                                             {
                                                 DocumentId = res.DocumentId
                                             });

                //Assert.AreEqual(res.DocumentId, doc.DocumentId);
            }
        }

    }
}