$(document).on('turbolinks:load', function () {
  $(document).ready(function(){
    $(".admin").on("click",function(){
      var id = $(this).attr('data-id');
      swal({
        title: I18n.t('backend.users.user.title'),
        type: I18n.t('backend.users.user.type'),
        showCancelButton: true,
        confirmButtonColor: I18n.t('backend.users.user.confirmButtonColor'),
        cancelButtonColor: I18n.t('backend.users.user.cancelButtonColor'),
        confirmButtonText: I18n.t('backend.users.user.confirmButtonText')
      }).then(function(isConfirm) {
        if (isConfirm.value == true) {
          $.ajax({
            method: 'POST',
            headers: {'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')},
            url: "/backend/users/" + id + "/role",
            dataType: 'json',
            success: function (data) {
              $('#admin-'+data["user"]["id"]).addClass('hidden');
              $('#member-'+data["user"]["id"]).removeClass('hidden');
              swal(
                I18n.t('backend.users.user.change'),
                I18n.t('backend.users.user.change_sucsess'),
                I18n.t('backend.users.user.success')
              )
            }
          });
        }
      })
    });
    $(".member").on("click",function(){
      var id = $(this).attr('data-id');
      swal({
        title: I18n.t('backend.users.user.title'),
        type: I18n.t('backend.users.user.type'),
        showCancelButton: true,
        confirmButtonColor: I18n.t('backend.users.user.confirmButtonColor'),
        cancelButtonColor: I18n.t('backend.users.user.cancelButtonColor'),
        confirmButtonText: I18n.t('backend.users.user.confirmButtonText')
      }).then(function(isConfirm) {
        if (isConfirm.value == true) {
          $.ajax({
            method: 'POST',
            headers: {'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')},
            url: "/backend/users/" + id + "/role",
            dataType: 'json',
            success: function (data) {
              $('#member-'+data["user"]["id"]).addClass('hidden');
              $('#admin-'+data["user"]["id"]).removeClass('hidden');
              swal(
                I18n.t('backend.users.user.change'),
                I18n.t('backend.users.user.change_sucsess'),
                I18n.t('backend.users.user.success')
              )
            }
          });
        }
      })
    });
  });
});
