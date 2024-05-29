import { Controller } from "@hotwired/stimulus"
import mapboxgl from 'mapbox-gl'

export default class extends Controller {
  static values = {
    apiKey: String,
    markers: Array,
    polygons: Array
  }

  connect() {
    mapboxgl.accessToken = this.apiKeyValue

    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/mapbox/satellite-streets-v12"
    })

    this.map.on('load', () => {
      this.#addMarkersToMap()
      this.#addPolygonsToMap()
      this.#fitMapToBounds()
    })
  }

  #addMarkersToMap() {
    this.markersValue.forEach((marker) => {
      const popup = new mapboxgl.Popup().setHTML(marker.info_window_html)

      const customMarker = document.createElement("div")
      customMarker.innerHTML = marker.marker_html

      new mapboxgl.Marker(customMarker)
        .setLngLat([marker.lng, marker.lat])
        .setPopup(popup)
        .addTo(this.map)
    })
  }

  #addPolygonsToMap() {
    this.polygonsValue.forEach((polygon) => {
      this.map.addSource(`polygon-${polygon.id}`, {
        'type': 'geojson',
        'data': {
          'type': 'Feature',
          'geometry': {
            'type': 'Polygon',
            'coordinates': polygon.coordinates // or polygon.coordinates for MultiPolygon ?
          }
        }
      })

      this.map.addLayer({
        'id': `polygon-fill-${polygon.id}`,
        'type': 'fill',
        'source': `polygon-${polygon.id}`,
        'layout': {},
        'paint': {
          'fill-color': '#FF5A1F',
          'fill-opacity': 0.5
        },
        'minzoom': 0,
        'maxzoom': 22
      })

      this.map.addLayer({
        'id': `polygon-outline-${polygon.id}`,
        'type': 'line',
        'source': `polygon-${polygon.id}`,
        'layout': {},
        'paint': {
          'line-color': '#000',
          'line-width': 3
        },
        'minzoom': 0,
        'maxzoom': 22
      })
    })
  }

  #fitMapToBounds() {
    const bounds = new mapboxgl.LngLatBounds();
    this.markersValue.forEach(marker => bounds.extend([marker.lng, marker.lat]));
    this.polygonsValue.forEach(polygon => {
      const coordinates = polygon.coordinates.flat(geometryType === 'MultiPolygon' ? 2 : 1);
      coordinates.forEach(coord => bounds.extend(coord));
    });
    this.map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0 });
  }
}
