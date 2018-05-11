<ul class="post-copyright">
  <li class="post-copyright-author">
    <strong>{{ __('post.copyright.author') + __('symbol.colon') }} </strong>{#
  #}{{ post.author | default(config.author) }}{#
#}</li>
  <li class="post-copyright-link">
    <strong>{{ __('post.copyright.link') + __('symbol.colon') }}</strong>
    <a href="{{ post.url | default(post.permalink) }}" title="{{ post.title }}">{{ post.url | default(post.permalink) }}</a>
  </li>
  <li class="post-copyright-date">
    <strong>发布时间：</strong>&nbsp;{{ post.date.format("YYYY-M-D HH:MM") }}
  </li>  
  <li class="post-copyright-license">
    <strong>{{ __('post.copyright.license_title') + __('symbol.colon') }} </strong>{#
  #}{{ __('post.copyright.license_content', theme.post_copyright.license) }}{#
#}</li>
</ul>
