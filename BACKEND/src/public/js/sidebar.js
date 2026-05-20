document.addEventListener('DOMContentLoaded', () => {
    console.log('Sidebar iniciado');

    const sidebarModal = document.getElementById('sidebarModal');
    const modalOverlay = document.getElementById('modalOverlay');
    const menuToggle = document.getElementById('menuToggle');
    const closeSidebar = document.getElementById('closeSidebar');

    if (!sidebarModal || !modalOverlay || !menuToggle || !closeSidebar) {
        console.error("Error: Elementos del menú no encontrados.");
        return;
    }

    function openMenu() {
        sidebarModal.classList.add('open');
        modalOverlay.classList.add('active');
        document.body.style.overflow = "hidden";
    }

    function closeMenu() {
        sidebarModal.classList.remove('open');
        modalOverlay.classList.remove('active');
        document.body.style.overflow = "auto";
    }

    menuToggle.addEventListener('click', openMenu);
    closeSidebar.addEventListener('click', closeMenu);
    modalOverlay.addEventListener('click', closeMenu);

    document.addEventListener('keydown', e => {
        if (e.key === "Escape") closeMenu();
    });
});
