using System.Xml.Serialization;

namespace EConnectApi.Definitions
{
    [XmlType(AnonymousType = true, Namespace = "http://ws.vg.pw.com/external/1.0")]
    [XmlRoot(Namespace = "http://ws.vg.pw.com/external/1.0", ElementName = "GetDocuments", IsNullable = false)]
    public class GetDocumentsFromGroup : GetDocumentsFromGroupBase, IDocumentsRequest
    {
        // Nothing extra
    }
}