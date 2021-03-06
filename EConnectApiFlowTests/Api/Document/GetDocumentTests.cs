﻿using System.Linq;
using EConnectApi.Definitions;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace EConnectApiFlowTests.Api.Document
{
    [TestClass]
    public class GetDocumentTests
    {
        [TestMethod]
        public void GetDocument_ByDocumentId()
        {
            var doc = EConnect.Client.GetDocuments(new GetDocumentsOfAnUser() { Limit = 1}).Documents.First();

            var details = EConnect.Client.GetDocument(new GetDocument() { DocumentId = doc.DocumentId });

            Assert.AreEqual(doc.DocumentEConnect, details.DocumentEConnect);
            Assert.IsNotNull(details.Payload);
            Assert.IsNotNull(details.PossibleStatuses);
            Assert.IsNotNull(details.DocumentEConnectDetails);
        }
    }
}
