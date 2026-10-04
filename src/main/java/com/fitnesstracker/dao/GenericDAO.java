package com.fitnesstracker.dao;

import java.io.Serializable;
import java.util.List;
import java.util.Optional;

/**
 * Generic Data Access Object interface illustrating Java Generics and abstraction.
 *
 * @param <T> Domain entity type
 * @param <ID> Primary key identifier type
 */
public interface GenericDAO<T, ID extends Serializable> {
    
    T save(T entity);

    boolean update(T entity);

    boolean delete(ID id);

    Optional<T> findById(ID id);

    List<T> findAll();
}
