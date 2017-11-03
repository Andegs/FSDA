//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace WebFormsIdentity.Data_Access
{
    using System;
    using System.Collections.Generic;
    
    public partial class partner_indicators
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public partner_indicators()
        {
            this.indicator_report_planner = new HashSet<indicator_report_planner>();
            this.project_indicator_disaggregation = new HashSet<project_indicator_disaggregation>();
        }
    
        public int partner_indicator_id { get; set; }
        public int project_id { get; set; }
        public Nullable<int> indicator_type_id { get; set; }
        public string indicator { get; set; }
        public string target { get; set; }
        public Nullable<int> fsda_indicator_id { get; set; }
    
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<indicator_report_planner> indicator_report_planner { get; set; }
        public virtual project project { get; set; }
        public virtual fsda_indicators fsda_indicators { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<project_indicator_disaggregation> project_indicator_disaggregation { get; set; }
        public virtual indicator_types indicator_types { get; set; }
    }
}
