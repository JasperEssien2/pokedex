abstract class EntityMapper<M, E> {
  M fromEntity(E entity);

  E toEntity(M model);
}
