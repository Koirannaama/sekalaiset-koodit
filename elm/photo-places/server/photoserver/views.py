from django.shortcuts import render
from django.http import HttpResponse, JsonResponse

def isAuthenticated(request):
  return JsonResponse({"isAuth": "true"})