import 'package:flutter/material.dart';

/// Un campo de búsqueda (ComboBox) profesional y fácil de usar.
/// Permite filtrar una lista de elementos mientras el usuario escribe.
class FormToolsSearchField<T extends Object> extends StatelessWidget {
  /// Lista de elementos disponibles para seleccionar.
  final List<T> items;

  /// Función que convierte un elemento de tipo [T] en una cadena para mostrar.
  final String Function(T) labelBuilder;

  /// Llamado cuando se selecciona un elemento.
  final void Function(T?)? onSelected;

  /// Decoración del campo de texto.
  final InputDecoration? decoration;

  /// Mensaje de error a mostrar si el campo es obligatorio y está vacío.
  final String? errorMessage;

  /// Si el campo es obligatorio.
  final bool isRequired;

  /// Altura máxima de la lista de opciones desplegable.
  final double maxHeight;

  /// Widget opcional para mostrar cuando no hay resultados.
  final Widget? noResultsWidget;

  /// Función opcional para construir el widget de cada opción en la lista.
  final Widget Function(BuildContext, T)? itemBuilder;

  const FormToolsSearchField({
    super.key,
    required this.items,
    required this.labelBuilder,
    this.onSelected,
    this.decoration,
    this.errorMessage = 'Seleccione una opción',
    this.isRequired = false,
    this.maxHeight = 200.0,
    this.noResultsWidget,
    this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Autocomplete<T>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return items;
        }
        return items.where((T item) {
          return labelBuilder(item)
              .toLowerCase()
              .contains(textEditingValue.text.toLowerCase());
        });
      },
      displayStringForOption: labelBuilder,
      onSelected: (T selection) {
        if (onSelected != null) {
          onSelected!(selection);
        }
      },
      fieldViewBuilder: (
        BuildContext context,
        TextEditingController textEditingController,
        FocusNode focusNode,
        VoidCallback onFieldSubmitted,
      ) {
        return TextFormField(
          controller: textEditingController,
          focusNode: focusNode,
          onFieldSubmitted: (String value) {
            onFieldSubmitted();
          },
          decoration: decoration ?? const InputDecoration(
            labelText: 'Buscar...',
            border: OutlineInputBorder(),
            suffixIcon: Icon(Icons.search),
          ),
          validator: (value) {
            if (isRequired && (value == null || value.isEmpty)) {
              return errorMessage;
            }
            return null;
          },
        );
      },
      optionsViewBuilder: (
        BuildContext context,
        AutocompleteOnSelected<T> onSelected,
        Iterable<T> options,
      ) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(8.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: maxHeight,
                // El ancho debe coincidir con el campo de texto si es posible,
                // pero Autocomplete lo maneja un poco diferente.
                // Usamos un ancho razonable o dejamos que se ajuste.
                maxWidth: MediaQuery.of(context).size.width - 48, // Margen básico
              ),
              child: options.isEmpty
                  ? (noResultsWidget ?? const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('No se encontraron resultados'),
                    ))
                  : ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: options.length,
                      itemBuilder: (BuildContext context, int index) {
                        final T option = options.elementAt(index);
                        if (itemBuilder != null) {
                          return InkWell(
                            onTap: () => onSelected(option),
                            child: itemBuilder!(context, option),
                          );
                        }
                        return ListTile(
                          title: Text(labelBuilder(option)),
                          onTap: () {
                            onSelected(option);
                          },
                        );
                      },
                    ),
            ),
          ),
        );
      },
    );
  }
}
