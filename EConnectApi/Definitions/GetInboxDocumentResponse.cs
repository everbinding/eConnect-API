using System;
using System.Xml.Serialization;

namespace EConnectApi.Definitions
{
    [XmlType(AnonymousType = true)]
    [XmlRoot(Namespace = "", IsNullable = false)]
    public class GetInboxDocumentResponse : DocumentBase
    {
        [Obsolete]
        public RuleApplicable RuleApplicable { get; set; }
    }
}