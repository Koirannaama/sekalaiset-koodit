from django.db import models
from django.conf import settings

class Photo(models.Model):
    url = models.CharField(max_length=250)
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
  