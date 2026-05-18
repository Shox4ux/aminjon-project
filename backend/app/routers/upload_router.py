import io
import os
import uuid
from typing import List

from fastapi import APIRouter, File, HTTPException, Request, UploadFile
from PIL import Image, UnidentifiedImageError

router = APIRouter(prefix="/api/v1/upload", tags=["upload"])

UPLOAD_DIR = "/app/static/images"
ALLOWED_EXTENSIONS = {"jpg", "jpeg", "png", "gif", "webp", "bmp"}
MAX_DIMENSION = 2048

os.makedirs(UPLOAD_DIR, exist_ok=True)


@router.post("/images")
async def upload_images(request: Request, files: List[UploadFile] = File(...)):
    if not files:
        raise HTTPException(status_code=400, detail="No files provided")

    urls = []
    for file in files:
        ext = os.path.splitext(file.filename or "")[1].lower().lstrip(".")
        if ext not in ALLOWED_EXTENSIONS:
            raise HTTPException(
                status_code=400,
                detail=f"Unsupported format '.{ext}'. Allowed: {', '.join(sorted(ALLOWED_EXTENSIONS))}",
            )

        contents = await file.read()

        try:
            img = Image.open(io.BytesIO(contents))
            img.load()
        except (UnidentifiedImageError, Exception):
            raise HTTPException(status_code=400, detail=f"'{file.filename}' is not a valid image")

        # Resize if larger than MAX_DIMENSION, preserving aspect ratio
        if img.width > MAX_DIMENSION or img.height > MAX_DIMENSION:
            img.thumbnail((MAX_DIMENSION, MAX_DIMENSION), Image.LANCZOS)

        # Keep PNG only when transparency is present; everything else → JPEG
        use_png = ext == "png" and img.mode in ("RGBA", "P", "LA")
        out_ext = "png" if use_png else "jpg"
        out_fmt = "PNG" if use_png else "JPEG"

        if out_fmt == "JPEG" and img.mode != "RGB":
            img = img.convert("RGB")

        save_kwargs: dict = {"optimize": True}
        if out_fmt == "JPEG":
            save_kwargs["quality"] = 90

        out_buf = io.BytesIO()
        img.save(out_buf, out_fmt, **save_kwargs)
        out_buf.seek(0)

        filename = f"{uuid.uuid4().hex}.{out_ext}"
        with open(os.path.join(UPLOAD_DIR, filename), "wb") as f:
            f.write(out_buf.read())

        base = str(request.base_url).rstrip("/")
        urls.append(f"{base}/static/images/{filename}")

    return {"urls": urls}
