document.addEventListener('DOMContentLoaded', () => {
  document.querySelectorAll('.auth-tab, .switch-form').forEach(btn => {
    btn.addEventListener('click', e => {
      e.preventDefault();
      const target = btn.getAttribute('data-tab') || btn.getAttribute('data-form');

      document.querySelectorAll('.auth-form').forEach(f => f.classList.remove('active'));
      document.querySelector(`#form-${target}`).classList.add('active');

      document.querySelectorAll('.auth-tab').forEach(t => t.classList.remove('active'));
      document.querySelector(`[data-tab="${target}"]`).classList.add('active');
    });
  });

  document.querySelectorAll('.toggle-password').forEach(button => {
    button.addEventListener('click', () => {
      const input = button.parentElement.querySelector('.password-field');
      const icon = button.querySelector('i');
      input.type = input.type === 'password' ? 'text' : 'password';
      icon.classList.toggle('fa-eye');
      icon.classList.toggle('fa-eye-slash');
    });
  });

  const registerForm = document.getElementById('form-register');
  registerForm?.addEventListener('submit', e => {
    const [pwd, confirm] = registerForm.querySelectorAll('input[name=password], input[name=confirm_password]');
    if (pwd.value !== confirm.value) {
      e.preventDefault();
      alert('Las contraseñas no coinciden');
    }
  });
});
