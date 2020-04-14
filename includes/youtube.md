{% if output.name == "website" %}
<center>
<iframe width="560" height="315" src="https://www.youtube.com/embed/{{ video_id }}" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</center>
{% else %}
{% hint style='tip' %}
Watch our video on YouTube: https://www.youtube.com/embed/{{ video_id }}
{% endhint %}

{% endif %}