#  Zonas de Disponibilidad en AKS - Guía Práctica

## ¿Qué son las Zonas de Disponibilidad en Azure?

Las Zonas de Disponibilidad (Availability Zones) son ubicaciones físicas separadas dentro de una región de Azure. Cada zona tiene su propia fuente de energía, red y refrigeración independientes. Utilizarlas en AKS permite distribuir los recursos del clúster (nodos, discos, etc.) entre zonas diferentes, aumentando la disponibilidad y resiliencia.

---

## 🛠️ ¿Cómo afectan a tu clúster de AKS?

### 1. **Despliegue Regional (sin zona especificada)**
- Azure elige aleatoriamente la zona para los nodos.
- No hay garantía de distribución equitativa.
- Si todos los nodos terminan en una sola zona y esa zona falla, el clúster cae.

### 2. **Despliegue Zonal (una zona específica)**
- Todos los recursos se colocan en una sola zona (ej. Zona 1).
- Ventaja: baja latencia.
- Desventaja: si esa zona falla, todo cae.

### 3. **Despliegue Multizona ([1,2,3])**
- Azure intenta distribuir los nodos entre varias zonas.
- Más resiliente ante fallos zonales.
- No garantiza distribución uniforme sin configuraciones especiales (`zoneBalance` no está soportado directamente en AKS).

---

##  Consideraciones sobre almacenamiento

###  Discos ZRS (Zone-Redundant Storage)
- Replican datos entre 3 zonas (alta disponibilidad).
- Síncronos → afectan rendimiento.
- Solo se pueden montar en una VM a la vez.
- Más costosos.

###  Discos LRS (Locally Redundant Storage)
- Replican solo dentro de una zona.
- Más baratos y rápidos.
- Menor tolerancia a fallos de zona.

---

##  Problemas comunes

- **Error al montar volúmenes de Azure Disk**: ocurre si el pod está en una zona y el disco en otra.
- **Solución**: configurar afinidad de zona para pods y nodos.

---

##  Recomendaciones resumidas

| Objetivo            | Configuración recomendada |
|---------------------|---------------------------|
| Coste eficiente     | Despliegue regional + LRS |
| Alta disponibilidad | Multizona + ZRS opcional  |
| Baja latencia       | Zona única + Premium V2   |

---

##  Conclusión

Planifica tu estrategia de zonas **antes de crear el clúster**, ya que no se pueden cambiar después. La configuración depende de tus necesidades: resiliencia, rendimiento o costo. Comprender estos aspectos desde el inicio evitará errores y caídas en producción.

---

##  Referencias

- [AKS Best Practices - Microsoft Docs](https://learn.microsoft.com/en-us/azure/aks/best-practices-app-cluster-reliability)
- [Azure VMSS and Zones](https://learn.microsoft.com/en-us/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-use-availability-zones)
- [Azure Disk Mount Troubleshooting](https://learn.microsoft.com/en-us/troubleshoot/azure/azure-kubernetes/storage/fail-to-mount-azure-disk-volume)

Next step: [Azure Cost Efficiency](https://cloudchronicles.blog/blog/AKS-Best-Practices-Part2-Cost-Efficiency/)