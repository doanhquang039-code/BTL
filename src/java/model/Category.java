/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

public class Category {
    private int categoryCode;
    private String name;

    public Category() {}
    public Category(int categoryCode, String name) {
        this.categoryCode = categoryCode;
        this.name = name;
    }

    // Getters and Setters
    public int getCategoryCode() { return categoryCode; }
    public void setCategoryCode(int categoryCode) { this.categoryCode = categoryCode; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
}