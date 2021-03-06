﻿using System;
using System.Xml.Serialization;

namespace EConnectApi.Definitions
{
    [XmlType(AnonymousType = true, Namespace = "http://ws.vg.pw.com/external/1.0")]
    [XmlRoot(Namespace = "http://ws.vg.pw.com/external/1.0", IsNullable = false)]
    public class EnquireCompany
    {
        [Obsolete]
        [XmlElement(ElementName = "TemporaryIdentifier")]
        public string TemporaryId { get; set; }
        public string EntityId { get; set; }
    }
}
