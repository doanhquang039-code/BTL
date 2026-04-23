package model;

import java.math.BigDecimal;

public class User {
    private int userCode;
    private String username;
    private String password;
    private String fullName;
    private String role;
    private String birthDate;
    private String position;
    private String address;
    private String identityNumber;
    private String cardIssueDate;
    private String cardExpiryDate;
    private BigDecimal depositAmount;
    private int maxBorrowBooks;

    public User() {}

    public User(int userCode, String username, String password, String fullName, String role) {
        this.userCode = userCode;
        this.username = username;
        this.password = password;
        this.fullName = fullName;
        this.role = role;
    }

    public int getUserCode() { return userCode; }
    public void setUserCode(int userCode) { this.userCode = userCode; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public String getBirthDate() { return birthDate; }
    public void setBirthDate(String birthDate) { this.birthDate = birthDate; }

    public String getPosition() { return position; }
    public void setPosition(String position) { this.position = position; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getIdentityNumber() { return identityNumber; }
    public void setIdentityNumber(String identityNumber) { this.identityNumber = identityNumber; }

    public String getCardIssueDate() { return cardIssueDate; }
    public void setCardIssueDate(String cardIssueDate) { this.cardIssueDate = cardIssueDate; }

    public String getCardExpiryDate() { return cardExpiryDate; }
    public void setCardExpiryDate(String cardExpiryDate) { this.cardExpiryDate = cardExpiryDate; }

    public BigDecimal getDepositAmount() { return depositAmount; }
    public void setDepositAmount(BigDecimal depositAmount) { this.depositAmount = depositAmount; }

    public int getMaxBorrowBooks() { return maxBorrowBooks; }
    public void setMaxBorrowBooks(int maxBorrowBooks) { this.maxBorrowBooks = maxBorrowBooks; }
}
