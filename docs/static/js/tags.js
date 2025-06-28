var enrichTags = function(){
  const TAGLIST_CACHE_KEY = 'taglistCache'; // the value is also used as URL parameter to force a reload
  const TAGLIST_CACHE_TTL = 24 * 60 * 60 * 1000; // 24 hours in milliseconds

  // the URL parameter ?taglistCache will force a reload of the taglist
  function getCachedTaglist() {
    const cached = localStorage.getItem(TAGLIST_CACHE_KEY);
    if (cached) {
      const { data, timestamp } = JSON.parse(cached);
      const params = new URLSearchParams(window.location.search);

      if (Date.now() - timestamp < TAGLIST_CACHE_TTL && !params.has(TAGLIST_CACHE_KEY)) {
        return data;
      }
    }
    return null;
  }

  function setCachedTaglist(data) {
    localStorage.setItem(TAGLIST_CACHE_KEY, JSON.stringify({
      data,
      timestamp: Date.now()
    }));
  }

  function loadTaglist() {
    const cachedData = getCachedTaglist();
    if (cachedData) {
      return Promise.resolve(cachedData);
    } else {
      var tagListUrl = window.relearn.absBaseUri + '/js/taglist.json'; // this relies on the relearn theme to provide the correct base URI
      return fetch(tagListUrl)
        .then(response => {
          if (!response.ok) throw new Error('Network response was not ok');
          return response.json();
        })
        .then(data => {
          setCachedTaglist(data);
          return data;
        })
        .catch(error => {
          console.error('Error loading taglist.json:', error);
          return null;
        });
    }
  }

  function FindAndEnrichTags(){
    document.addEventListener('DOMContentLoaded', function () {
      // find all tags, that should be enriched with a tooltip
      var filterTags = document.querySelectorAll('span.taxonomy-tags');
      var codeTags = document.querySelectorAll('code');
      var elementsWithTags = Array.from(filterTags).concat(Array.from(codeTags));

      // load and add all tags
      loadTaglist().then(taglist => {
        if (taglist) {
          // enrich tags with tooltip
          elementsWithTags.forEach(function(tag) {
            try {
              var tagName = tag.textContent.trim();
              var tagEnrichment = taglist[tagName];
              if (tagEnrichment !== undefined) {
                tag.title = tagEnrichment;
              }
            } catch (error) {
              console.error('Error enriching tag tooltip:', error);
            }
          });
        }
      });
    });
  }

  return {
    Start: FindAndEnrichTags
  };
}();

enrichTags.Start();
