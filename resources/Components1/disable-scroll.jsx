import React, { useEffect } from 'react';

// Removed the type annotation for 'showModal' from the props destructuring
export function DisableScroll({ showModal }) {
  useEffect(() => {
    if (showModal) {
      document.body.classList.add('overflow-hidden');
    } else {
      document.body.classList.remove('overflow-hidden');
    }

    // Cleanup: alisin ang class kung ma-unmount ang component
    return () => {
      document.body.classList.remove('overflow-hidden');
    };
  }, [showModal]);

  // Wala nang kailangang i-render
  return null;
}
