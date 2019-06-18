# rappiEx
prueba técnica Rappi

1.- Capaz de la aplicación:
En mi aplicación utilicé el MVC y para el consumo del servicio creé un framework que tiene el modelo y el consumo del servicio con Alamofire, seguí el patrón de diseño MVVM para ese servicio. 
Mi modelo está contenido en el framework, se encuentra en la carpeta Models y en ese proyecto están las pruebas unitarias de cada servicio.
En la app principal se encuentran las vistas y los controllers en sus respectivas tarjetas.
La persistencia la realicé con userDefaults donde guardo los objetos que tienen la información de cada película mostrada en el collectionview principal. Para guardar el objeto, le apliqué un encode a cada modelo y su respectiva clase. Esto se puede ver en el framework.
------- Descripción de clases para la app principal
1.1- Vistas:
1.1.1 Views/LoadingView.swift: Contiene la carga de un xib para mostrar una ventana de carga.
1.1.2 Views/LoadingView.xib: Xib que tiene la pantalla de carga.
1.1.3 Views/MainView/MainCell.swift: Contiene la declaración de una celda personalizada para el collectionView principal.
1.1.4 Views/MainView/MainCell.xib: Xib que tiene el diseño de la celda personalizada.
1.2 - Controllers
1.2.1 - Controller/MainController.swift: Contiene toda la definición del controlador principal, incluye una barra de búsqueda offline para filtrar películas que estén en el collectionView, un botón "Search" en la navigationBar que sirve para buscar una película y visualizarla en el collectionView. También incluye un segmentedControl donde se muestran las películas más populares, las que están en el top y los upcoming donde cada vez que haces click, se llama a un servicio (si es necesario porque puede estar la información en la caché y ya no se llama, para volver a llamar el servicio basta con jalar el collection hacia abajo y por medio de un refreshControl se manda a llamar el servicio nuevamente).
1.2.2 - Controller/DetailMovieController.swift: Contiene el detalle de cada película.
------- Descripción de clases para el framework del consumo de servicios.
1.1 MVVM/Manager/ServiceManager.swift: Clase que contiene el consumo del servicio con alamofire, la respuesta se manda con un closure declarado en el viewModel.
1.2 MVVM/Manager/ServiceViewModel.swift: Clase que contiene mi viewModel, funciona como interactor entre el consumo del servicio y la vista (u otra clase) que lo manda a llamar.
1.3 Los modelos del request y response se encuentran en la carpeta Models
1.4 Las pruebas unitarias de los servicios se hicieron en la clase de nombre "ApiTheMovieDBTests.swift"

Principio de responsabilidad única:
Se refiere a que un objeto declarado debe de encargarse de una única acción, cada clase debe de encargarse de un objetivo preciso.
¿Qué características tiene un buen código?
1. Las capaz de negocio, lógica y vista deben estar separadas aplicando algún patrón de arquitectura. 
2. Utilizar las ventajas que nos proporcione el lenguaje de programación tal como sus métodos especiales, etcétera.
3. Tener cuidado con el manejo de la memoria y evitar las fugas de memoria, en caso de swift los retain cycles.
4. Evitar el uso excesivo de pods.

