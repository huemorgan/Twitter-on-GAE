# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def statistics(options={})
    track_id = "UA-2699390-21"
    user_segment = (options[:is_user]) ? "user" : "visitor"

    str = <<-EOF
      <script type="text/javascript">
      var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
      document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
      </script>
      <script type="text/javascript">
      try {
      var pageTracker = _gat._getTracker("#{track_id}");
        pageTracker._trackPageview();
        pageTracker._setVar('#{user_segment}');
      } catch(err) {}
      </script>
    EOF
    if options[:environment] == 'production'
      str
    else
      "<!-- tracker:#{track_id} user_segment:#{user_segment} -->"
    end
  end
  
  def hr(title)
    str = <<-EOF
      <div class="hr_wrapper" style="height:1em;">
      <hr size="1">
      <span class="hr_title" style="position:relative;top:-1.2em;left:20px;background:white">&nbsp;&nbsp;#{title}&nbsp;&nbsp;</span>
      </div>
    EOF
    str
  end
end
