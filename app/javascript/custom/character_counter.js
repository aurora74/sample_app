// Character counter for micropost content
document.addEventListener('turbo:load', function() {
  const contentTextarea = document.getElementById('micropost_content');
  const countdown = document.getElementById('micropost_countdown');
  
  if (contentTextarea && countdown && contentTextarea instanceof HTMLTextAreaElement) {
    const maxLength = parseInt(countdown.textContent || '140') || 140;
    
    function updateCounter() {
      if (!contentTextarea || !countdown) return;
      
      const characterCount = contentTextarea.value.length;
      const remainingChars = maxLength - characterCount;
      countdown.textContent = remainingChars.toString();
      
      // Change color when approaching limit
      if (remainingChars < 0) {
        countdown.style.color = 'red';
        countdown.style.fontWeight = 'bold';
      } else if (remainingChars < 10) {
        countdown.style.color = 'red';
        countdown.style.fontWeight = 'normal';
      } else if (remainingChars < 20) {
        countdown.style.color = 'orange';
        countdown.style.fontWeight = 'normal';
      } else {
        countdown.style.color = '';
        countdown.style.fontWeight = 'normal';
      }
    }
    
    // Update counter on input
    contentTextarea.addEventListener('input', updateCounter);
    contentTextarea.addEventListener('keyup', updateCounter);
    contentTextarea.addEventListener('paste', function() {
      // Update after paste content is processed
      setTimeout(updateCounter, 10);
    });
    
    // Initialize counter
    updateCounter();
  }
});
