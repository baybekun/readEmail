import os
from tensorflow.keras.models import load_model
import numpy as np
import cv2
import string

symbols = string.ascii_lowercase.upper() + "0123456789"

# Load model keras
model = load_model('C:\Users\lenovo\Documents\TextFile\model.keras')

def predict(img):
    img = img / 255.0
    res = np.array(model.predict(img[np.newaxis, :, :, np.newaxis]))
    ans = np.reshape(res, (6, 36))
    l_ind = []
    probs = []
    for a in ans:
        l_ind.append(np.argmax(a))
        probs.append(np.max(a))

    capt = ''
    for l in l_ind:
        capt += symbols[l]
    return capt

    # Đường dẫn đến thư mục chứa ảnh
image_folder_path = 'C:\\Users\\lenovo\\Pictures\\train3'
def handlebef(imgpath):
    img = cv2.imread(imgpath,cv2.IMREAD_GRAYSCALE)
    return predict(img)