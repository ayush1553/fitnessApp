package com.fitnesstracker.util;

import java.io.Serializable;

/**
 * Encapsulates temporary alerts/toast messages passed across redirects in HttpSession.
 */
public class FlashMessage implements Serializable {
    private static final long serialVersionUID = 1L;

    public enum Type {
        SUCCESS("success", "fa-circle-check"),
        DANGER("danger", "fa-triangle-exclamation"),
        WARNING("warning", "fa-circle-exclamation"),
        INFO("info", "fa-circle-info");

        private final String cssClass;
        private final String iconClass;

        Type(String cssClass, String iconClass) {
            this.cssClass = cssClass;
            this.iconClass = iconClass;
        }

        public String getCssClass() {
            return cssClass;
        }

        public String getIconClass() {
            return iconClass;
        }
    }

    private final String message;
    private final Type type;

    public FlashMessage(String message, Type type) {
        this.message = message;
        this.type = type;
    }

    public static FlashMessage success(String message) {
        return new FlashMessage(message, Type.SUCCESS);
    }

    public static FlashMessage error(String message) {
        return new FlashMessage(message, Type.DANGER);
    }

    public static FlashMessage warning(String message) {
        return new FlashMessage(message, Type.WARNING);
    }

    public static FlashMessage info(String message) {
        return new FlashMessage(message, Type.INFO);
    }

    public String getMessage() {
        return message;
    }

    public Type getType() {
        return type;
    }
}
