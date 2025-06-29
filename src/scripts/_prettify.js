// Split hierarchical tags
var tagsContainerEl = document.querySelectorAll(".prettify-tags > *");
if (tagsContainerEl.length > 0) {
    var tags = [];
    tagsContainerEl.forEach((tagEl) => {
        tagEl.classList.add("prettify-tag");
        tags.push(tagEl.innerHTML);
        tags.forEach((tag) => {
            var childTag = tag.split("::").filter(Boolean);
            tagEl.innerHTML = childTag[childTag.length - 1].trim();
        });
    });
} else {
    tagsContainerEl = document.querySelector(".prettify-tags");
    var tags = tagsContainerEl.innerHTML.split(" ").filter(Boolean);
    var html = "";
    tags.forEach((tag) => {
        var childTag = tag.split("::").filter(Boolean);
        html +=
            "<span class='prettify-tag'>" +
            childTag[childTag.length - 1] +
            "</span>";
    });
    tagsContainerEl.innerHTML = html;
}

// Breadcrumbs to current deck
var deckEl = document.querySelector(".prettify-deck");
var subDecks = deckEl.innerHTML.split("::").filter(Boolean);
html = [];
subDecks.forEach((subDeck) => {
    html.push("<span class='prettify-subdeck'>" + subDeck + "</span>");
});
deckEl.innerHTML = html.join("&nbsp;/&nbsp;");
