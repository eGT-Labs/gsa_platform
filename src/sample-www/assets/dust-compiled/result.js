(function(){dust.register("result",body_0);function body_0(chk,ctx){return chk.write("<div id=\"results-topline\" class=\"row\"><div id=\"result-count\" class=\"col-md-6 col-sm-6\">").helper("result_count",ctx,{},{"count":body_1,"status":body_2}).write("</div><div id=\"results-sorted-by\" class=\"col-md-6 col-sm-6\">Sorted by <span class=\"selected\">").reference(ctx.get(["sorted_by"], false),ctx,"h").write("</span></div></div><div class=\"pagination-box\"><ul class=\"pagination\">").helper("pager",ctx,{},{}).write("</ul></div>").section(ctx.get(["docs"], false),ctx,{"block":body_3},{}).write("<div class=\"pagination-box\"><ul class=\"pagination\">").helper("pager",ctx,{},{}).write("</ul></div>");}function body_1(chk,ctx){return chk.reference(ctx.get(["numFound"], false),ctx,"h");}function body_2(chk,ctx){return chk.reference(ctx.get(["status"], false),ctx,"h");}function body_3(chk,ctx){return chk.write("<div class=\"result-item\" data-solr-id=\"").reference(ctx.get(["id"], false),ctx,"h").write("\" data-attachment-url=\"").helper("get_attachment_url",ctx,{},{}).write("\"><div class=\"row listing-top\"><div class=\"listing-top-left col-md-10 col-sm-10\"><h3 class=\"title\"><a href=\"").helper("doc_url",ctx,{},{}).write("\" target=\"_blank\">").reference(ctx.get(["title"], false),ctx,"h",["s"]).write("</a></h3><div class=\"agency-name\">").reference(ctx.get(["agency"], false),ctx,"h").write("</div></div><div class=\"listing-top-right col-md-2 col-sm-2\">").section(ctx.get(["score"], false),ctx,{"block":body_4},{}).write("</div></div><div class=\"row listing-main\"><div class=\"listing-left col-md-8 col-sm-8\"><blockquote class=\"listing-text\"><div class=\"content-snippet\">").helper("content_short",ctx,{},{}).write("</div></blockquote><!--").exists(ctx.get(["highlights"], false),ctx,{"block":body_6},{}).write("--></div><div class=\"listing-right col-md-4 col-sm-4\"><div class=\"tags\">").section(ctx.get(["tags"], false),ctx,{"block":body_7},{}).write("</div><div class=\"listing-right-more\">").exists(ctx.get(["id"], false),ctx,{"block":body_8},{}).exists(ctx.get(["contact"], false),ctx,{"block":body_9},{}).exists(ctx.get(["FBO_SETASIDE"], false),ctx,{"block":body_10},{}).write("<div class=\"listing-source-box listing-data-box\"><span class=\"listing-data-label\"><span class=\"glyphicon glyphicon-link\"></span>Source: </span><span class=\"listing-data\">").helper("data_source_link",ctx,{},{"data_source":body_11}).write("</span></div></div></div></div><div class=\"row listing-bottom\"><div class=\"listing-dates col-md-8 col-sm-8 row\"><div class=\"listing-due-box col-md-6 col-sm-6\"><span class=\"glyphicon glyphicon-calendar\"></span>Due: <span class=\"listing-due-date\">").helper("formatDate",ctx,{},{"value":body_12}).write("</span></div><div class=\"listing-posted-box col-md-6\" col-sm-6><span class=\"glyphicon glyphicon-pushpin\"></span>Posted: <span class=\"listing-posted-date\">").helper("formatDate",ctx,{},{"value":body_13}).write("</span></div></div><div class=\"listing-actions col-md-4 col-sm-4\"><a class=\"listing-save\"><span class=\"glyphicon glyphicon-star-empty\"></span>Save</a><a class=\"listing-more\"><span class=\"glyphicon glyphicon-plus\"></span>More detail</a></div></div></div>");}function body_4(chk,ctx){return chk.write("<div class=\"score\"><div class=\"score-dots\"><span class=\"score-dots\">").helper("score_dots",ctx,{},{"score":body_5}).write("</span></div><div class=\"score-text\"><strong>").reference(ctx.get(["score"], false),ctx,"h").write("%</strong> RELEVANT</div></div>");}function body_5(chk,ctx){return chk.reference(ctx.get(["score"], false),ctx,"h");}function body_6(chk,ctx){return chk.write("<blockquote class=\"listing-text-more\"></blockquote>");}function body_7(chk,ctx){return chk.write("<span class=\"tag\">").reference(ctx.get(["tag"], false),ctx,"h").write("</span>");}function body_8(chk,ctx){return chk.write("<div class=\"listing-id-box listing-data-box\"><div class=\"listing-data-label\">Opportunity #</div><div class=\"listing-id listing-data\">").reference(ctx.get(["solnbr"], false),ctx,"h").write("</div></div>");}function body_9(chk,ctx){return chk.write("<div class=\"listing-contact-box listing-data-box\"><div class=\"listing-data-label\">Contact</div><div class=\"listing-contact listing-data\">").reference(ctx.get(["contact"], false),ctx,"h").write("</div></div>");}function body_10(chk,ctx){return chk.write("<div class=\"listing-setaside-box listing-data-box\"><div class=\"listing-data-label\">Set aside for</div><div class=\"listing-setaside listing-data\">").helper("set_aside",ctx,{},{}).write("</div></div>");}function body_11(chk,ctx){return chk.reference(ctx.get(["data_source"], false),ctx,"h");}function body_12(chk,ctx){return chk.reference(ctx.get(["close_dt"], false),ctx,"h");}function body_13(chk,ctx){return chk.reference(ctx.get(["posted_dt"], false),ctx,"h");}return body_0;})();