(() => {
  const navToggle = document.querySelector('.nav-toggle');
  const navList = document.querySelector('#primary-navigation');
  const copyAnnouncement = document.querySelector('#copy-announcement');
  const updatesDialog = document.querySelector('#updates-dialog');

  if (navToggle && navList) {
    const closeMenu = () => {
      navToggle.setAttribute('aria-expanded', 'false');
      navList.classList.remove('is-open');
    };

    navToggle.addEventListener('click', () => {
      const isOpen = navToggle.getAttribute('aria-expanded') === 'true';
      navToggle.setAttribute('aria-expanded', String(!isOpen));
      navList.classList.toggle('is-open', !isOpen);
    });

    navList.querySelectorAll('a').forEach((link) => link.addEventListener('click', closeMenu));
    document.addEventListener('keydown', (event) => {
      if (event.key === 'Escape') closeMenu();
    });
  }

  const announceCopy = (message) => {
    if (copyAnnouncement) copyAnnouncement.textContent = message;
    const status = document.querySelector('#copy-status');
    if (status) status.textContent = message;
  };

  const fallbackCopy = (text) => {
    const textarea = document.createElement('textarea');
    textarea.value = text;
    textarea.setAttribute('readonly', '');
    textarea.style.position = 'fixed';
    textarea.style.opacity = '0';
    document.body.appendChild(textarea);
    textarea.select();
    let copied = false;
    try {
      copied = document.execCommand('copy');
    } catch (error) {
      copied = false;
    }
    textarea.remove();
    return copied;
  };

  document.querySelectorAll('[data-copy]').forEach((button) => {
    button.addEventListener('click', async () => {
      const text = button.dataset.copy;
      let copied = false;

      try {
        if (navigator.clipboard?.writeText) {
          await navigator.clipboard.writeText(text);
          copied = true;
        }
      } catch (error) {
        copied = fallbackCopy(text);
      }

      if (!copied) copied = fallbackCopy(text);
      const label = button.querySelector('.copy-button__label');
      if (copied) {
        if (label) label.textContent = '복사됨';
        announceCopy('명령을 클립보드에 복사했습니다.');
        window.setTimeout(() => {
          if (label) label.textContent = '명령 복사';
        }, 1800);
      } else {
        announceCopy('자동 복사에 실패했습니다. 명령을 직접 선택해 복사해 주세요.');
      }
    });
  });

  const updatesButton = document.querySelector('.updates-button');
  const closeDialog = () => updatesDialog?.close();

  if (updatesButton && updatesDialog) {
    updatesButton.addEventListener('click', () => updatesDialog.showModal());
    updatesDialog.querySelector('[data-dialog-close]')?.addEventListener('click', closeDialog);
    updatesDialog.addEventListener('click', (event) => {
      if (event.target === updatesDialog) closeDialog();
    });
  }
})();
