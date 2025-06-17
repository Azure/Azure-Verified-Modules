const TAGLIST_CACHE_KEY = 'taglistCache';
const TAGLIST_CACHE_TTL = 24 * 60 * 60 * 1000; // 24 hours in milliseconds

// the URL parameter ?reloadTaglist will force a reload of the taglist
function getCachedTaglist() {
  const cached = localStorage.getItem(TAGLIST_CACHE_KEY);
  if (cached) {
    const { data, timestamp } = JSON.parse(cached);
    const params = new URLSearchParams(window.location.search);

    if (Date.now() - timestamp < TAGLIST_CACHE_TTL && !params.has('reloadTaglist')) {
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
    var tagListUrl = window.relearn.absBaseUri + '/js/taglist.json';
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

document.addEventListener('DOMContentLoaded', function () {
  // find all tags, that should be enriched with a tooltip
  const tags = document.querySelectorAll('span.taxonomy-tags');

  // load and add all tags
  loadTaglist().then(taglist => {
    if (taglist) {
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
    }
  });
});
