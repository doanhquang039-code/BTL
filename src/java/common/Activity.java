/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package common;

import java.util.List;
/**
 *
 * @author admoi
 */
public interface Activity<E> {
     void add(E e);
    
    void update(E e, int id);
    
    void delete(int id);
    
    List<E> findAll();
    
    E findById(int id);
}
