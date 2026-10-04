package com.fitnesstracker.model;

import java.sql.Date;
import java.sql.Time;

public class WaterLog extends BaseEntity {
    private int userId;
    private Date logDate;
    private double amountLiters;
    private Time logTime;

    public WaterLog() {
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public Date getLogDate() {
        return logDate;
    }

    public void setLogDate(Date logDate) {
        this.logDate = logDate;
    }

    public double getAmountLiters() {
        return amountLiters;
    }

    public void setAmountLiters(double amountLiters) {
        this.amountLiters = amountLiters;
    }

    public Time getLogTime() {
        return logTime;
    }

    public void setLogTime(Time logTime) {
        this.logTime = logTime;
    }
}
