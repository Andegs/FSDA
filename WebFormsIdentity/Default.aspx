<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" 
    AutoEventWireup="true" CodeBehind="Default.aspx.cs" 
    Inherits="WebFormsIdentity.Default" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <asp:Label ID="HeaderLabel" runat="server" CssClass="h4">Welcome!</asp:Label>
    <hr />
    The need to track, demonstrate and communicate the results of what we do is 
    becoming increasingly important as our clients and partners demand for greater 
    accountability. As FSDA, we owe our stakeholders with the support of whom we 
    are able to carry out interventions, a duty to work for tangible, demonstrable
    and measurable results.
    <br /><br />
    Here at FSDA, we have been working hard to improve the way we capture, analyze 
    and report the results of the work that we do with our partners. The development 
    of a robust FSDA MRM Manual, Impact Oriented Measurement framework and deployment 
    of appropriate information and communication technology tools are part of our 
    endeavor to streamline reporting by our partners and by us to our audiences.
    <br /><br />
    The new online quarterly reporting system provides a platform through which we 
    can collect relevant and timely information.  Through this system, we hope 
    to remove the inefficiencies associated with delayed submission of 
    reports and loss of records during submission/storage, and to streamline 
    the sometimes- cumbersome feedback mechanisms and haphazard analysis of 
    reports. We hope to improve accessibility of our reports to our audiences 
    and thereby improve accountability. These are exciting prospects to look 
    forward to.
    <br /><br />
    We encourage our partners to use these tools, learn from them and make 
    proposals for improving them. In the end, we shall have made a key step 
    forward in promoting the use of evidence to inform our programming choices 
    and management decisions.
    <br /><br />
    We encourage our partners to use these tools, learn from them and make 
    proposals for improving them. In the end, we shall have made a key step 
    forward in promoting the use of evidence to inform our programming choices 
    and management decisions.
    <br /><br />

    <%--<% if (User.IsInRole("User"))
        { %>
    <p style="color:red">You are a User Role</p>
    <% } %>

    <p>
    <asp:Label ID="Label1" runat="server" Visible="false" ForeColor="Red"></asp:Label>
    </p>

    <p>  
        This page displays the claims associated with a Forms authenticated user.          
    </p>  
    <h3>Your Claims</h3>  
    <p>  
        <asp:GridView ID="ClaimsGridView" runat="server" CellPadding="3" 
            UseAccessibleHeader="true">
            <AlternatingRowStyle BackColor="White" />  
            <HeaderStyle BackColor="#7AC0DA" ForeColor="White" />  
        </asp:GridView>  
    </p>--%>






    <!-- Landing Page -->
    <%--<div class="intro-header">
        <div class="container">
            <div class="row">
                <div class="intro-message col-sm-6">
                    <h1>
                        Bootstrap3</h1>
                    <h2>
                        Templates
                    </h2>
                    <h3>
                        for Dot.Net Developers</h3>
                    <hr class="intro-divider">
                    <ul class="list-inline intro-social-buttons">
                        <li><a href="https://twitter.com/" class="btn btn-success btn-lg"><i class="fa fa-twitter fa-fw">
                        </i><span class="network-name">Twitter</span></a> </li>
                        <li><a href="https://github.com/" class="btn btn-default btn-lg"><i class="fa fa-github fa-fw">
                        </i><span class="network-name">Github</span></a> </li>
                        <li><a href="#" class="btn btn-primary btn-lg"><i class="fa fa-facebook fa-fw"></i><span
                            class="network-name">facebook</span></a> </li>
                    </ul>
                </div>
            </div>
        </div>
    </div>--%>


    <!-- Start Our Services -->
    <%--<div id="our-services">
        <div class="container padding-top padding-bottom">
            <div class="row section-title text-center">
                <div class="col-sm-8 col-sm-offset-2">
                    <h1>
                        <span>Our</span> Services</h1>
                    <p>
                        There is a saying “Time and tide waits for none”. The saying is indeed true. Time
                        waits for none. It comes and goes. Time is absolutely unbound able. Neither money
                        nor position can buy it. Nothing on earth can subdue or conquer it.</p>
                </div>
            </div>
            <div class="row text-center">
                <div class="col-sm-6 col-md-3 service">
                    <div class="service-content">
                        <i class="fa fa-desktop"></i>
                        <h2>
                            Responsive Layout</h2>
                        <p>
                            The most remarkable feature of time is its preciousness. Its value is unfathomable
                            and its power is inestimable.</p>
                    </div>
                </div>
                <div class="col-sm-6 col-md-3 service">
                    <div class="service-content">
                        <i class="fa fa-bell"></i>
                        <h2>
                            Clean Design</h2>
                        <p>
                            The most remarkable feature of time is its preciousness. Its value is unfathomable
                            and its power is inestimable.</p>
                    </div>
                </div>
                <div class="col-sm-6 col-md-3 service">
                    <div class="service-content">
                        <i class="fa fa-coffee"></i>
                        <h2>
                            Great Support</h2>
                        <p>
                            The most remarkable feature of time is its preciousness. Its value is unfathomable
                            and its power is inestimable.</p>
                    </div>
                </div>
                <div class="col-sm-6 col-md-3 service">
                    <div class="service-content">
                        <i class="fa fa-bug"></i>
                        <h2>
                            Good Features</h2>
                        <p>
                            The most remarkable feature of time is its preciousness. Its value is unfathomable
                            and its power is inestimable.
                        </p>
                    </div>
                </div>
                <div class="col-sm-6 col-md-3 service">
                    <div class="service-content">
                        <i class="fa fa-copyright"></i>
                        <h2>
                            Copywriting</h2>
                        <p>
                            The most remarkable feature of time is its preciousness. Its value is unfathomable
                            and its power is inestimable.
                        </p>
                    </div>
                </div>
                <div class="col-sm-6 col-md-3 service">
                    <div class="service-content">
                        <i class="fa fa-power-off"></i>
                        <h2>
                            Web design</h2>
                        <p>
                            The most remarkable feature of time is its preciousness. Its value is unfathomable
                            and its power is inestimable.
                        </p>
                    </div>
                </div>
                <div class="col-sm-6 col-md-3 service">
                    <div class="service-content">
                        <i class="fa fa-adjust"></i>
                        <h2>
                            Programming</h2>
                        <p>
                            The most remarkable feature of time is its preciousness. Its value is unfathomable
                            and its power is inestimable.
                        </p>
                    </div>
                </div>
                <div class="col-sm-6 col-md-3 service">
                    <div class="service-content">
                        <i class="fa fa-briefcase"></i>
                        <h2>
                            Marketing &amp; PR</h2>
                        <p>
                            The most remarkable feature of time is its preciousness. Its value is unfathomable
                            and its power is inestimable.
                        </p>
                    </div>
                </div>
            </div>
        </div>
        <div class="height">
        </div>
    </div>--%>
    <!-- /# Our Services -->


    <!-- Slider -->
    <%--<div id="myCarousel" class="carousel slide" data-ride="carousel">
        <!-- Indicators -->
        <ol class="carousel-indicators">
            <li data-target="#myCarousel" data-slide-to="0" class="active"></li>
            <li data-target="#myCarousel" data-slide-to="1"></li>
            <li data-target="#myCarousel" data-slide-to="2"></li>
        </ol>

        <!-- Wrapper for slides -->
        <div class="carousel-inner" role="listbox">
            <div class="item active">
                <img src="images/333.jpg" />
            </div>
            <div class="item">
                <img src="images/444.jpg" />
            </div>
            <div class="item">
                <img src="images/555.jpg" />
            </div>
        </div>
        <!-- Left and right controls -->
        <a class="left carousel-control" href="#myCarousel" role="button" data-slide="prev">
            <span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span><span class="sr-only">
                Previous</span> </a><a class="right carousel-control" href="#myCarousel" role="button"
                    data-slide="next"><span class="glyphicon glyphicon-chevron-right" aria-hidden="true">
                    </span><span class="sr-only">Next</span> </a>
    </div>--%>


    <%--<div class="container padding-bottom">
        <div class="row section-title text-center">
            <div class="col-sm-8 col-sm-offset-2">
                <h1>
                    <span>Our</span> Clients</h1>
                <p>
                    aspxtemplates is a Powerful, Modern looking, Creative, Fully Responsive Multi-Purpose
                    Multi-Page & One-Page .net Template.. Be it Business, Corporate, Portfolio, Agency,
                    Magazine, Parallax, Blog etc.</p>
            </div>
        </div>
        <div class="text-center our-clients">
            <ul>
                <li><a href="#">
                    <img class="img-responsive" src="images/client1.png" alt="" /></a></li>
                <li><a href="#">
                    <img class="img-responsive" src="images/client2.png" alt="" /></a></li>
                <li><a href="#">
                    <img class="img-responsive" src="images/client3.png" alt="" /></a></li>
                <li><a href="#">
                    <img class="img-responsive" src="images/client4.png" alt="" /></a></li>
                <li><a href="#">
                    <img class="img-responsive" src="images/client5.png" alt="" /></a></li>
            </ul>
        </div>
        <!--/our-clients -->


    </div>--%>

</asp:Content>
