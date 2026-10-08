package com.fitnesstracker.service.impl;

import com.fitnesstracker.service.EmailService;
import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Enterprise SMTP implementation of EmailService using Jakarta Mail / Eclipse Angus Mail.
 * 
 * Supports TLS/STARTTLS authentication (e.g. Gmail SMTP, SendGrid, Amazon SES, Outlook, etc.)
 * Reads configuration securely from Environment Variables or smtp.properties.
 * NEVER hardcodes passwords or logs sensitive credentials.
 */
public class SmtpEmailServiceImpl implements EmailService {

    private static final Logger LOGGER = Logger.getLogger(SmtpEmailServiceImpl.class.getName());

    private final String host;
    private final int port;
    private final String username;
    private final String password;
    private final String fromEmail;
    private final String fromName;
    private final boolean isConfigured;

    public SmtpEmailServiceImpl() {
        Properties fileProps = new Properties();
        try (InputStream in = getClass().getClassLoader().getResourceAsStream("smtp.properties")) {
            if (in != null) {
                fileProps.load(in);
            }
        } catch (Exception e) {
            LOGGER.fine("Could not load smtp.properties (using environment variables): " + e.getMessage());
        }

        this.host = getEnvOrProp("SMTP_HOST", fileProps.getProperty("mail.smtp.host", "smtp.gmail.com"));
        
        String portStr = getEnvOrProp("SMTP_PORT", fileProps.getProperty("mail.smtp.port", "587"));
        int parsedPort = 587;
        try {
            parsedPort = Integer.parseInt(portStr.trim());
        } catch (Exception ignored) {
        }
        this.port = parsedPort;

        this.username = getEnvOrProp("SMTP_USERNAME", fileProps.getProperty("mail.smtp.username", ""));
        this.password = getEnvOrProp("SMTP_PASSWORD", fileProps.getProperty("mail.smtp.password", ""));

        String envFrom = getEnvOrProp("SMTP_FROM_EMAIL", fileProps.getProperty("mail.smtp.from.email", ""));
        this.fromEmail = (envFrom != null && !envFrom.trim().isEmpty()) ? envFrom.trim() : this.username;

        this.fromName = getEnvOrProp("SMTP_FROM_NAME", fileProps.getProperty("mail.smtp.from.name", "FitFlow"));

        this.isConfigured = this.username != null && !this.username.trim().isEmpty() 
                         && this.password != null && !this.password.trim().isEmpty();

        if (this.isConfigured) {
            LOGGER.info("SmtpEmailService initialized successfully for host " + this.host + ":" + this.port + " (Sender: " + this.fromEmail + ")");
        } else {
            LOGGER.warning("SMTP credentials (SMTP_USERNAME / SMTP_PASSWORD) not configured. Verification links will be logged to server console for development.");
        }
    }

    private static String getEnvOrProp(String envName, String fallback) {
        String val = System.getenv(envName);
        if (val != null && !val.trim().isEmpty()) {
            return val.trim();
        }
        String sysProp = System.getProperty(envName);
        if (sysProp != null && !sysProp.trim().isEmpty()) {
            return sysProp.trim();
        }
        return (fallback != null) ? fallback.trim() : "";
    }

    @Override
    public boolean sendVerificationEmail(String toEmail, String userName, String verificationLink) {
        String safeName = (userName != null && !userName.trim().isEmpty()) ? userName.trim() : "Athlete";
        String subject = "Verify your FitFlow account";
        String htmlContent = buildVerificationEmailHtml(safeName, verificationLink);

        LOGGER.info("================================================================================");
        LOGGER.info("[SMTP EMAIL DISPATCH] Destination: " + toEmail);
        LOGGER.info("[SMTP EMAIL DISPATCH] Subject: " + subject);
        LOGGER.info("[SMTP EMAIL DISPATCH] Verification Link: " + verificationLink);
        LOGGER.info("================================================================================");

        if (!isConfigured) {
            LOGGER.info("SMTP not configured with credentials. Simulated email delivery in development mode.");
            return true;
        }

        return sendHtmlEmail(toEmail, subject, htmlContent);
    }

    @Override
    public boolean sendPasswordResetEmail(String toEmail, String userName, String resetLink) {
        String safeName = (userName != null && !userName.trim().isEmpty()) ? userName.trim() : "Athlete";
        String subject = "Reset Your FitFlow Password";
        String htmlContent = buildPasswordResetEmailHtml(safeName, resetLink);

        LOGGER.info("================================================================================");
        LOGGER.info("[SMTP PASSWORD RESET DISPATCH] Destination: " + toEmail);
        LOGGER.info("[SMTP PASSWORD RESET DISPATCH] Subject: " + subject);
        LOGGER.info("[SMTP PASSWORD RESET DISPATCH] Reset Link: " + resetLink);
        LOGGER.info("================================================================================");

        if (!isConfigured) {
            LOGGER.info("SMTP not configured with credentials. Simulated reset email in development mode.");
            return true;
        }

        return sendHtmlEmail(toEmail, subject, htmlContent);
    }

    /**
     * Sends an HTML email via Jakarta Mail SMTP.
     */
    private boolean sendHtmlEmail(String toEmail, String subject, String htmlBody) {
        try {
            Properties props = new Properties();
            props.put("mail.smtp.host", this.host);
            props.put("mail.smtp.port", String.valueOf(this.port));
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.connectiontimeout", "10000");
            props.put("mail.smtp.timeout", "10000");
            props.put("mail.smtp.writetimeout", "10000");

            if (this.port == 465) {
                props.put("mail.smtp.ssl.enable", "true");
                props.put("mail.smtp.socketFactory.port", "465");
                props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
            } else {
                props.put("mail.smtp.starttls.enable", "true");
                props.put("mail.smtp.starttls.required", "true");
            }

            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(username, password);
                }
            });

            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(fromEmail, fromName, "UTF-8"));
            message.setRecipient(Message.RecipientType.TO, new InternetAddress(toEmail));
            message.setSubject(subject, "UTF-8");
            message.setContent(htmlBody, "text/html; charset=UTF-8");

            Transport.send(message);
            LOGGER.info("Email successfully dispatched via SMTP to " + toEmail);
            return true;
        } catch (MessagingException me) {
            LOGGER.log(Level.SEVERE, "SMTP MessagingException while delivering email to " + toEmail + ": " + me.getMessage(), me);
            return false;
        } catch (UnsupportedEncodingException ue) {
            LOGGER.log(Level.SEVERE, "UnsupportedEncodingException during SMTP message creation: " + ue.getMessage(), ue);
            return false;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error during SMTP email dispatch: " + e.getMessage(), e);
            return false;
        }
    }

    /**
     * FitFlow Verification Email Template with Inline CSS.
     */
    private String buildVerificationEmailHtml(String userName, String verificationLink) {
        return "<!DOCTYPE html>"
                + "<html>"
                + "<head>"
                + "<meta charset='UTF-8'>"
                + "<meta name='viewport' content='width=device-width, initial-scale=1.0'>"
                + "<title>Verify your FitFlow account</title>"
                + "</head>"
                + "<body style='margin: 0; padding: 0; background-color: #0d1117; font-family: -apple-system, BlinkMacSystemFont, \"Segoe UI\", Roboto, Helvetica, Arial, sans-serif; color: #e6edf3;'>"
                + "  <table width='100%' border='0' cellspacing='0' cellpadding='0' style='background-color: #0d1117; padding: 40px 15px;'>"
                + "    <tr>"
                + "      <td align='center'>"
                + "        <table width='100%' border='0' cellspacing='0' cellpadding='0' style='max-width: 540px; background-color: #161b22; border-radius: 16px; border: 1px solid #30363d; overflow: hidden; box-shadow: 0 10px 30px rgba(0, 0, 0, 0.5);'>"
                + "          <!-- Header / Brand -->"
                + "          <tr>"
                + "            <td style='padding: 36px 36px 20px 36px; text-align: center; border-bottom: 1px solid #21262d; background: linear-gradient(180deg, rgba(16, 185, 129, 0.08) 0%, rgba(22, 27, 34, 0) 100%);'>"
                + "              <div style='display: inline-block; width: 48px; height: 48px; line-height: 48px; background: linear-gradient(135deg, #10b981 0%, #059669 100%); border-radius: 12px; margin-bottom: 12px; font-size: 24px; color: #ffffff; text-align: center;'>⚡</div>"
                + "              <h1 style='margin: 0; font-size: 26px; font-weight: 800; letter-spacing: -0.5px; color: #ffffff;'>FIT<span style='color: #10b981;'>FLOW</span></h1>"
                + "              <p style='margin: 4px 0 0 0; font-size: 13px; color: #8b949e; letter-spacing: 1px; text-transform: uppercase;'>Performance & Fitness Tracking</p>"
                + "            </td>"
                + "          </tr>"
                + "          <!-- Main Body -->"
                + "          <tr>"
                + "            <td style='padding: 36px 36px 28px 36px; text-align: left;'>"
                + "              <h2 style='margin: 0 0 16px 0; font-size: 20px; font-weight: 700; color: #ffffff;'>Verify Your Email Address</h2>"
                + "              <p style='margin: 0 0 16px 0; font-size: 15px; line-height: 1.6; color: #c9d1d9;'>"
                + "                Hello <strong style='color: #ffffff;'>" + escapeHtml(userName) + "</strong>,"
                + "              </p>"
                + "              <p style='margin: 0 0 24px 0; font-size: 15px; line-height: 1.6; color: #8b949e;'>"
                + "                Welcome to FitFlow! To activate your account and start tracking your workouts, nutrition, and performance goals, please confirm your email address below."
                + "              </p>"
                + "              <!-- Call to Action Button -->"
                + "              <table width='100%' border='0' cellspacing='0' cellpadding='0' style='margin: 28px 0;'>"
                + "                <tr>"
                + "                  <td align='center'>"
                + "                    <a href='" + verificationLink + "' target='_blank' style='display: inline-block; padding: 14px 32px; background: linear-gradient(135deg, #10b981 0%, #059669 100%); color: #ffffff; text-decoration: none; font-size: 15px; font-weight: 700; border-radius: 10px; box-shadow: 0 4px 14px rgba(16, 185, 129, 0.4); text-align: center; letter-spacing: 0.3px;'>"
                + "                      VERIFY MY EMAIL"
                + "                    </a>"
                + "                  </td>"
                + "                </tr>"
                + "              </table>"
                + "              <!-- Expiration Notice Box -->"
                + "              <div style='background-color: #0d1117; border: 1px solid #30363d; border-radius: 10px; padding: 14px 18px; margin: 24px 0 16px 0;'>"
                + "                <p style='margin: 0; font-size: 13px; color: #f59e0b; line-height: 1.5; font-weight: 500;'>"
                + "                  ⏱ This verification link expires in <strong>24 hours</strong>."
                + "                </p>"
                + "              </div>"
                + "              <p style='margin: 20px 0 0 0; font-size: 13px; line-height: 1.6; color: #6e7681;'>"
                + "                If the button above does not work, copy and paste this link into your web browser:<br>"
                + "                <a href='" + verificationLink + "' style='color: #10b981; word-break: break-all; text-decoration: underline; font-size: 12px;'>" + verificationLink + "</a>"
                + "              </p>"
                + "              <p style='margin: 16px 0 0 0; font-size: 13px; line-height: 1.5; color: #6e7681;'>"
                + "                If you did not create a FitFlow account, you can safely ignore this email."
                + "              </p>"
                + "            </td>"
                + "          </tr>"
                + "          <!-- Footer -->"
                + "          <tr>"
                + "            <td style='padding: 24px 36px; background-color: #0d1117; border-top: 1px solid #21262d; text-align: center;'>"
                + "              <p style='margin: 0 0 6px 0; font-size: 12px; color: #8b949e; font-weight: 600;'>© FitFlow • Fitness Tracking & Progress Management</p>"
                + "              <p style='margin: 0; font-size: 11px; color: #484f58;'>Elevate your training, master your nutrition, achieve your peak.</p>"
                + "            </td>"
                + "          </tr>"
                + "        </table>"
                + "      </td>"
                + "    </tr>"
                + "  </table>"
                + "</body>"
                + "</html>";
    }

    /**
     * FitFlow Password Reset Email Template with Inline CSS.
     */
    private String buildPasswordResetEmailHtml(String userName, String resetLink) {
        return "<!DOCTYPE html>"
                + "<html>"
                + "<head>"
                + "<meta charset='UTF-8'>"
                + "<meta name='viewport' content='width=device-width, initial-scale=1.0'>"
                + "<title>Reset Your FitFlow Password</title>"
                + "</head>"
                + "<body style='margin: 0; padding: 0; background-color: #0d1117; font-family: -apple-system, BlinkMacSystemFont, \"Segoe UI\", Roboto, Helvetica, Arial, sans-serif; color: #e6edf3;'>"
                + "  <table width='100%' border='0' cellspacing='0' cellpadding='0' style='background-color: #0d1117; padding: 40px 15px;'>"
                + "    <tr>"
                + "      <td align='center'>"
                + "        <table width='100%' border='0' cellspacing='0' cellpadding='0' style='max-width: 540px; background-color: #161b22; border-radius: 16px; border: 1px solid #30363d; overflow: hidden; box-shadow: 0 10px 30px rgba(0, 0, 0, 0.5);'>"
                + "          <!-- Header / Brand -->"
                + "          <tr>"
                + "            <td style='padding: 36px 36px 20px 36px; text-align: center; border-bottom: 1px solid #21262d; background: linear-gradient(180deg, rgba(16, 185, 129, 0.08) 0%, rgba(22, 27, 34, 0) 100%);'>"
                + "              <div style='display: inline-block; width: 48px; height: 48px; line-height: 48px; background: linear-gradient(135deg, #10b981 0%, #059669 100%); border-radius: 12px; margin-bottom: 12px; font-size: 24px; color: #ffffff; text-align: center;'>⚡</div>"
                + "              <h1 style='margin: 0; font-size: 26px; font-weight: 800; letter-spacing: -0.5px; color: #ffffff;'>FIT<span style='color: #10b981;'>FLOW</span></h1>"
                + "              <p style='margin: 4px 0 0 0; font-size: 13px; color: #8b949e; letter-spacing: 1px; text-transform: uppercase;'>Security & Account Recovery</p>"
                + "            </td>"
                + "          </tr>"
                + "          <!-- Main Body -->"
                + "          <tr>"
                + "            <td style='padding: 36px 36px 28px 36px; text-align: left;'>"
                + "              <h2 style='margin: 0 0 16px 0; font-size: 20px; font-weight: 700; color: #ffffff;'>Password Reset Request</h2>"
                + "              <p style='margin: 0 0 16px 0; font-size: 15px; line-height: 1.6; color: #c9d1d9;'>"
                + "                Hello <strong style='color: #ffffff;'>" + escapeHtml(userName) + "</strong>,"
                + "              </p>"
                + "              <p style='margin: 0 0 24px 0; font-size: 15px; line-height: 1.6; color: #8b949e;'>"
                + "                We received a request to reset your FitFlow account password. Click the button below to choose a new password."
                + "              </p>"
                + "              <!-- Call to Action Button -->"
                + "              <table width='100%' border='0' cellspacing='0' cellpadding='0' style='margin: 28px 0;'>"
                + "                <tr>"
                + "                  <td align='center'>"
                + "                    <a href='" + resetLink + "' target='_blank' style='display: inline-block; padding: 14px 32px; background: linear-gradient(135deg, #10b981 0%, #059669 100%); color: #ffffff; text-decoration: none; font-size: 15px; font-weight: 700; border-radius: 10px; box-shadow: 0 4px 14px rgba(16, 185, 129, 0.4); text-align: center; letter-spacing: 0.3px;'>"
                + "                      RESET MY PASSWORD"
                + "                    </a>"
                + "                  </td>"
                + "                </tr>"
                + "              </table>"
                + "              <!-- Expiration Notice Box -->"
                + "              <div style='background-color: #0d1117; border: 1px solid #30363d; border-radius: 10px; padding: 14px 18px; margin: 24px 0 16px 0;'>"
                + "                <p style='margin: 0; font-size: 13px; color: #f59e0b; line-height: 1.5; font-weight: 500;'>"
                + "                  ⏱ This reset link is valid for <strong>1 hour</strong> and can only be used once."
                + "                </p>"
                + "              </div>"
                + "              <p style='margin: 20px 0 0 0; font-size: 13px; line-height: 1.6; color: #6e7681;'>"
                + "                If the button above does not work, copy and paste this link into your web browser:<br>"
                + "                <a href='" + resetLink + "' style='color: #10b981; word-break: break-all; text-decoration: underline; font-size: 12px;'>" + resetLink + "</a>"
                + "              </p>"
                + "              <p style='margin: 16px 0 0 0; font-size: 13px; line-height: 1.5; color: #6e7681;'>"
                + "                If you did not request a password reset, please ignore this email. Your current password will remain unchanged."
                + "              </p>"
                + "            </td>"
                + "          </tr>"
                + "          <!-- Footer -->"
                + "          <tr>"
                + "            <td style='padding: 24px 36px; background-color: #0d1117; border-top: 1px solid #21262d; text-align: center;'>"
                + "              <p style='margin: 0 0 6px 0; font-size: 12px; color: #8b949e; font-weight: 600;'>© FitFlow • Fitness Tracking & Progress Management</p>"
                + "              <p style='margin: 0; font-size: 11px; color: #484f58;'>Stay disciplined, stay focused.</p>"
                + "            </td>"
                + "          </tr>"
                + "        </table>"
                + "      </td>"
                + "    </tr>"
                + "  </table>"
                + "</body>"
                + "</html>";
    }

    private static String escapeHtml(String str) {
        if (str == null) return "";
        return str.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }
}
