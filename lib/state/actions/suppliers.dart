import '../../models/supplier.dart';
enum VisibilityFilter { all, active, completed }

class LoadSuppliersAction {}

class SuppliersNotLoadedAction {}

class ClearCompletedAction {}

class SuppliersLoadedAction {
  final List<Supplier> suppliers;

  SuppliersLoadedAction(this.suppliers);

  @override
  String toString() {
    return 'SuppliersLoadedAction{suppliers: $suppliers}';
  }
}


class UpdateSupplierAction {
  final int id;
  final Supplier updatedSupplier;

  UpdateSupplierAction(this.id, this.updatedSupplier);

  @override
  String toString() {
    return 'UpdateSupplierAction{id: $id, updatedSupplier: $updatedSupplier}';
  }
}

class DeleteSupplierAction {
  final String id;

  DeleteSupplierAction(this.id);

  @override
  String toString() {
    return 'DeleteSupplierAction{id: $id}';
  }
}


class AddSupplierAction {
  final Supplier supplier;

  AddSupplierAction(this.supplier);

  @override
  String toString() {
    return 'AddSupplierAction{Supplier: $supplier}';
  }
}

class UpdateFilterAction {
  final VisibilityFilter newFilter;

  UpdateFilterAction(this.newFilter);

  @override
  String toString() {
    return 'UpdateFilterAction{newFilter: $newFilter}';
  }
}