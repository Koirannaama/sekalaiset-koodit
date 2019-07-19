from django.urls import path

from . import views

urlpatterns = [
    path('is_auth', views.isAuthenticated),
    path("login", views.loginUser),
    path("logout", views.logoutUser),
    path("save_photo", views.savePhoto),
    path("register", views.registerUser)
]