package com.fitnesstracker.model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * Model representing dynamic application configuration stored in database.
 */
public class SystemSetting implements Serializable {
    private static final long serialVersionUID = 1L;

    private Integer id;
    private String settingKey;
    private String settingValue;
    private String description;
    private Timestamp updatedAt;

    public SystemSetting() {
    }

    public SystemSetting(Integer id, String settingKey, String settingValue, String description, Timestamp updatedAt) {
        this.id = id;
        this.settingKey = settingKey;
        this.settingValue = settingValue;
        this.description = description;
        this.updatedAt = updatedAt;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getSettingKey() {
        return settingKey;
    }

    public void setSettingKey(String settingKey) {
        this.settingKey = settingKey;
    }

    public String getSettingValue() {
        return settingValue;
    }

    public void setSettingValue(String settingValue) {
        this.settingValue = settingValue;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
}
