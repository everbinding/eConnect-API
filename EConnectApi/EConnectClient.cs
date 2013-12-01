﻿using System;
using EConnectApi.Definitions;

namespace EConnectApi
{
    public class EConnectClient : IDisposable
    {
        private readonly BaseClient _client;
 
        public EConnectClient(IEConnectClientConfig config)
        {
            _client = new BaseClient(config);
        }

        public SendDocumentResponse SendDocument(SendDocument document)
        {
            return _client.SendRequest<SendDocumentResponse>("SEND_DOC", document);
        }

        public GetDocumentsResponse GetDocuments(IDocumentsRequest parameters)
        {
            return _client.SendRequest<GetDocumentsResponse>("RETRIEVE_DOCS", parameters);
        }

        public GetDocumentResponse GetDocument(GetDocument parameters)
        {
            return _client.SendRequest<GetDocumentResponse>("RETRIEVE_DOC", parameters);
        }

        public GetInboxDocumentsResponse GetInboxDocuments(IInboxDocumentsRequest parameters)
        {
            return _client.SendRequest<GetInboxDocumentsResponse>("RETRIEVE_INBOX_DOCS", parameters);
        }

        public GetInboxDocumentResponse GetInboxDocument(IInboxDocumentRequest parameters)
        {
            return _client.SendRequest<GetInboxDocumentResponse>("RETRIEVE_INBOX_DOC", parameters);
        }

        public GetOutboxDocumentsResponse GetOutboxDocuments(IOutboxDocumentsRequest parameters)
        {
            return _client.SendRequest<GetOutboxDocumentsResponse>("RETRIEVE_OUTBOX_DOCS", parameters);
        }

        public GetOutboxDocumentResponse GetOutboxDocument(IOutboxDocumentRequest parameters)
        {
            return _client.SendRequest<GetOutboxDocumentResponse>("RETRIEVE_OUTBOX_DOC", parameters);
        }

        public SetDocumentStatusResponse SetDocumentStatus(SetDocumentStatus parameters)
        {
            return _client.SendRequest<SetDocumentStatusResponse>("SET_DOC_STATUS", parameters);
        }

        public SetInboxDocumentStatusResponse SetDocumentStatus(SetInboxDocumentStatus parameters)
        {
            return _client.SendRequest<SetInboxDocumentStatusResponse>("SET_INBOX_DOC_STATUS", parameters);
        }

        public GetDocumentStatusResponse GetDocumentStatus(GetDocumentStatus parameters)
        {
            return _client.SendRequest<GetDocumentStatusResponse>("GET_DOC_STATUS", parameters);
        }

        public GetDocumentStatusResponse GetInboxDocumentStatus(GetInboxDocumentStatus parameters)
        {
            return _client.SendRequest<GetDocumentStatusResponse>("GET_INBOX_DOC_STATUS", parameters);
        }

        public GetDocumentStatusResponse GetOutboxDocumentStatus(GetOutboxDocumentStatus parameters)
        {
            return _client.SendRequest<GetDocumentStatusResponse>("GET_OUTBOX_DOC_STATUS", parameters);
        }

        public EnquireCompanyResponse EnquireCompany(EnquireCompany parameters)
        {
            return _client.SendRequest<EnquireCompanyResponse>("ENQUIRE_COMPANY", parameters);
        }

        public SearchCompanyResponse SearchCompany(SearchCompany parameters)
        {
            return _client.SendRequest<SearchCompanyResponse>("SEARCH_COMPANY", parameters);
        }

        public void Dispose()
        {
            // Clean up
            //_client.Close();
        }
    }
}
