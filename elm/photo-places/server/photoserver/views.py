from django.shortcuts import render
from django.http import HttpResponse, JsonResponse
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.models import User
from django.middleware.csrf import get_token, rotate_token
from django.views.decorators.csrf import ensure_csrf_cookie
from django.template import RequestContext
import json

# TODO: HTTP method decorators

def isAuthenticated(request):
  isAuthenticated = request.user.is_authenticated
  token = get_token(request)
  response = {"isAuth": isAuthenticated}

  response["token"] = token

  return JsonResponse(response)

@ensure_csrf_cookie
def loginUser(request):
  data = json.loads(request.body)
  username = data["username"]
  password = data["password"]
  user = authenticate(request, username=username, password=password)
  
  if user is not None:
    login(request, user)
    token = get_token(request)
    #return HttpResponse("OK", status=200, context_instance=RequestContext(request))
    return JsonResponse({"isAuth": True, "token": token})

  else:
    return HttpResponse("Not a valid user", status=401)

@ensure_csrf_cookie
def logoutUser(request):
  logout(request)
  return HttpResponse("OK", status=200)
