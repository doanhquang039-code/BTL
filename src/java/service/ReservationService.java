/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package service;

import common.Activity;
import common.Search;
import model.Reservation;

/**
 *
 * @author admoi
 */
public abstract class ReservationService implements Activity<Reservation>,Search<Reservation>{

    public abstract void add(int userCode, int bookCode);
    public abstract boolean createForUser(int userCode, int bookCode);
    public abstract boolean existsPendingReservation(int userCode, int bookCode);
    public abstract boolean existsPendingReservationExcluding(int userCode, int bookCode, int reservationCode);
    
}
