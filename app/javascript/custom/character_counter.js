document.addEventListener("turbo:load", () => {
  const textarea = document.getElementById("micropost_content");
  const counter  = document.getElementById("micropost_countdown");

  if (!(textarea instanceof HTMLTextAreaElement) || !counter) return;

  const maxLength = 140;
  const label     = counter.textContent.trim();

  function update() {
    const remaining = maxLength - textarea.value.length;
    counter.textContent = `${remaining} ${label}`;

    if (remaining < 0) {
      counter.style.color = "red";
      counter.style.fontWeight = "bold";
    } else if (remaining < 10) {
      counter.style.color = "red";
      counter.style.fontWeight = "normal";
    } else if (remaining < 20) {
      counter.style.color = "orange";
      counter.style.fontWeight = "normal";
    } else {
      counter.style.color = "";
      counter.style.fontWeight = "normal";
    }
  }

  textarea.addEventListener("input", update);
  textarea.addEventListener("keyup", update);
  textarea.addEventListener("paste", () => setTimeout(update, 10));

  update();
});
