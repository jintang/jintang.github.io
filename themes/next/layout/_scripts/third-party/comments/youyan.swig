{% if theme.youyan_uid %}
  {% set uid = theme.youyan_uid %}
{% endif %}

{% if page.comments %}
  <!-- UY BEGIN -->
  <script type="text/javascript" src="http://v2.uyan.cc/code/uyan.js?uid={{uid}}"></script>
  <!-- UY END -->
{% endif %}
