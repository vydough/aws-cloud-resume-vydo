// Retro googly-eye pupil tracks the mouse, matching the Mac template's interaction.
(function () {
  var eyeCircle = document.getElementById('eyeCircle');
  var eyePupil = document.getElementById('eyePupil');
  if (!eyeCircle || !eyePupil) return;

  var maxOffset = 6; // px the pupil is allowed to drift from center

  function movePupil(clientX, clientY) {
    var rect = eyeCircle.getBoundingClientRect();
    var centerX = rect.left + rect.width / 2;
    var centerY = rect.top + rect.height / 2;

    var dx = clientX - centerX;
    var dy = clientY - centerY;
    var distance = Math.sqrt(dx * dx + dy * dy) || 1;
    var clamped = Math.min(distance, maxOffset);

    var offsetX = (dx / distance) * clamped;
    var offsetY = (dy / distance) * clamped;

    eyePupil.style.transform = 'translate(' + offsetX.toFixed(1) + 'px, ' + offsetY.toFixed(1) + 'px)';
  }

  window.addEventListener('mousemove', function (e) {
    movePupil(e.clientX, e.clientY);
  });
})();

// Single interactive action: scroll down to reveal the resume.
(function () {
  var btn = document.getElementById('viewResumeBtn');
  var target = document.getElementById('resume');
  if (!btn || !target) return;

  btn.addEventListener('click', function () {
    target.scrollIntoView({ behavior: 'smooth', block: 'start' });
  });
})();

// Fade/slide each resume window into view as the user scrolls.
(function () {
  var items = document.querySelectorAll('.reveal');
  if (!items.length) return;

  if (!('IntersectionObserver' in window)) {
    items.forEach(function (el) { el.classList.add('in-view'); });
    return;
  }

  var observer = new IntersectionObserver(
    function (entries) {
      entries.forEach(function (entry) {
        if (entry.isIntersecting) {
          entry.target.classList.add('in-view');
          observer.unobserve(entry.target);
        }
      });
    },
    { threshold: 0.15, rootMargin: '0px 0px -60px 0px' }
  );

  items.forEach(function (el) { observer.observe(el); });
})();

//javascript code
const counter = document.querySelector(".counter-number");
async function updateCounter() {
  let response = await fetch("https://zc23ngen4iwnwqe6v5gtr6ojm40dfxbw.lambda-url.ap-southeast-2.on.aws/");
  let data = await response.json();
  counter.innerHTML = ` Live website visit counter:  ${data}`;
}

updateCounter();


