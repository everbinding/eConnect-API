using System.Xml.Serialization;

namespace EConnectApi.Definitions
{
    [XmlType(AnonymousType = true, Namespace = "http://ws.vg.pw.com/external/1.0")]
    [XmlRoot(Namespace = "http://ws.vg.pw.com/external/1.0", IsNullable = false, ElementName = "GetDocumentPDF")]
    public class GetDocumentPdf : GetDocumentBase
    {

    }
}