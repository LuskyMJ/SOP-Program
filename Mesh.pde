class Mesh {
  PVector[] verteces;
  PVector[] polygons;
  PVector scale, rotation, translation;

  Mesh(PVector[] verteces, PVector[] polygons) {
    this.verteces = verteces;
    this.polygons = polygons;
    this.scale = new PVector(1, 1, 1);
    this.rotation = new PVector(0, 0, 0);
    this.translation = new PVector(0, 0, 0);
  }

  Mesh setScale(PVector scale) {
    this.scale = scale;
    return this;
  }

  Mesh setRotation(PVector rotation) {
    this.rotation = rotation;
    return this;
  }

  Mesh setTranslation(PVector translation) {
    this.translation = translation;
    return this;
  }
}
