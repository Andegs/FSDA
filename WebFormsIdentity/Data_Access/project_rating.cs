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
    
    public partial class project_rating
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public project_rating()
        {
            this.project_overall_rating = new HashSet<project_overall_rating>();
        }
    
        public int rating_id { get; set; }
        public string rating { get; set; }
    
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<project_overall_rating> project_overall_rating { get; set; }
    }
}
