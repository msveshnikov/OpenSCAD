# Autumn Hollow

Autumn Hollow is a small interactive Three.js village scene built with the
OpenSCAD models in this folder. The houses, evergreen trees, and pumpkins in the
scene, along with cars modeled in `VillageCar.scad`, are loaded from STL
exports rather than approximated with browser-created geometry.

## View the village

Serve this folder over HTTP so the browser can load the STL files:

```powershell
py -m http.server 8000
```

Then open <http://localhost:8000/AutumnVillage.html>. The page loads Three.js and
its controls from jsDelivr, so an internet connection is also needed.

Drag to orbit, scroll to zoom, use **Window lights** to toggle the house lights,
and use **Reset view** to return to the starting camera position. Two little
cars cruise back and forth along the path, with rolling wheels and wobbling
rubber-duck passengers.

## OpenSCAD models

- `CozyHouse.scad` — gable-roof house; exported to `CozyHouse.stl`
- `Tree.scad` — evergreen; exported to `Tree.stl`
- `NicePumpkin.scad` — carved pumpkin; exported to `NicePumpkin.stl`
- `VillageCar.scad` — compact car; exported to `VillageCar.stl`

The STL files are the runtime assets used by the village. If you edit a source
model, regenerate its STL with OpenSCAD, for example:

```powershell
openscad --export-format binstl -o CozyHouse.stl CozyHouse.scad
openscad --export-format binstl -o Tree.stl Tree.scad
openscad --export-format binstl -o NicePumpkin.stl NicePumpkin.scad
openscad --export-format binstl -o VillageCar.stl VillageCar.scad
```
