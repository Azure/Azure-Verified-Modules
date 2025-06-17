document.addEventListener('DOMContentLoaded', function () {
  const tags = document.querySelectorAll('span.taxonomy-tags');

  // load all tags, that should be enriched with a tooltip
  var tagListUrl = paramsBase + '/js/taglist.json';
  fetch(tagListUrl)
  .then(response => {
    if (!response.ok) {
      throw new Error('Network response was not ok');
    }
    return response.json();
  })
  .then(data => {
    const taglist = data || [];
    // enrich tags with tooltip
    tags.forEach(function(tag) {
      try {
        var tagName = tag.textContent.trim();
        var tagEnrichment = taglist[tagName];
        if (tagEnrichment !== undefined) {
          tag.title = tagEnrichment;
        }
      } catch (error) {
        console.error('Error getting current script URL:', error);
      }
    });
  })
  .catch(error => {
    console.error('Error loading taglist.json:', error);
  });
});
