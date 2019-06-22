from django.shortcuts import render
from django.http import HttpResponse, JsonResponse
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.models import User
from django.middleware.csrf import get_token, rotate_token
from django.views.decorators.csrf import ensure_csrf_cookie
from django.template import RequestContext
import json
from photoserver.models import Photo

# TODO: HTTP method decorators

def isAuthenticated(request):
  isAuthenticated = request.user.is_authenticated
  token = get_token(request)
  response = {"isAuth": isAuthenticated, "token": token}

  return JsonResponse(response)

@ensure_csrf_cookie
def loginUser(request):
  data = json.loads(request.body)
  if not "username" in data or not "password" in data:
    return HttpResponse("No credentials received", status=400)

  username = data["username"]
  password = data["password"]
  user = authenticate(request, username=username, password=password)
  
  if user is not None:
    login(request, user)
    token = get_token(request)
    return JsonResponse({"isAuth": True, "token": token})

  else:
    return HttpResponse("Not a valid user", status=401)

@ensure_csrf_cookie
def logoutUser(request):
  logout(request)
  return HttpResponse("OK", status=200)

@ensure_csrf_cookie
def savePhoto(request):
  if not request.user.is_authenticated:
    return HttpResponse("Not logged in", status=401)

  data = json.loads(request.body)

  if not "url" in data:
    return HttpResponse("No photo url received", status=400)

  photoURL = data["url"]
  user = request.user
  photo = Photo(url=photoURL, user=user)
  photo.save()

  return HttpResponse("OK", status=200)
