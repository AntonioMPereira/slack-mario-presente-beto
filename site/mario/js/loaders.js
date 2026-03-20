// Resolve absolute paths to be relative to the mario/ subdirectory
const BASE = new URL('./', import.meta.url).pathname.replace(/js\/$/, '');
export function resolveURL(url) {
    if (url.startsWith('/')) {
        return BASE + url.slice(1);
    }
    return url;
}

export function loadImage(url) {
    return new Promise(resolve => {
        const image = new Image();
        image.addEventListener('load', () => {
            resolve(image);
        });
        image.src = resolveURL(url);
    });
}

export function loadJSON(url) {
    return fetch(resolveURL(url))
    .then(r => r.json());
}
