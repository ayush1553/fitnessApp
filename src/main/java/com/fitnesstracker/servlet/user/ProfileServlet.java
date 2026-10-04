package com.fitnesstracker.servlet.user;

import com.fitnesstracker.exception.AppException;
import com.fitnesstracker.model.User;
import com.fitnesstracker.model.UserProfile;
import com.fitnesstracker.service.ActivityLogService;
import com.fitnesstracker.service.UserService;
import com.fitnesstracker.service.impl.ActivityLogServiceImpl;
import com.fitnesstracker.service.impl.UserServiceImpl;
import com.fitnesstracker.util.FlashMessage;
import com.fitnesstracker.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Optional;

@WebServlet(name = "ProfileServlet", urlPatterns = {"/user/profile", "/profile/update", "/profile/password"})
public class ProfileServlet extends HttpServlet {

    private final UserService userService = new UserServiceImpl();
    private final ActivityLogService activityLogService = new ActivityLogServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User currentUser = (User) session.getAttribute("currentUser");

        Optional<User> freshUser = userService.getUserById(currentUser.getId());
        freshUser.ifPresent(u -> {
            session.setAttribute("currentUser", u);
            req.setAttribute("user", u);
            req.setAttribute("profile", u.getProfile());
        });

        req.getRequestDispatcher("/user/profile.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User currentUser = (User) session.getAttribute("currentUser");
        String path = req.getServletPath();

        try {
            if ("/profile/password".equals(path)) {
                String currentPass = req.getParameter("currentPassword");
                String newPass = req.getParameter("newPassword");
                String confirmPass = req.getParameter("confirmPassword");

                if (newPass == null || !newPass.equals(confirmPass)) {
                    throw new AppException("New passwords do not match.");
                }

                userService.changePassword(currentUser.getId(), currentPass, newPass);
                activityLogService.logActivity(currentUser.getId(), "PASSWORD_CHANGED", "Password changed successfully", req.getRemoteAddr());
                session.setAttribute("flashMessage", FlashMessage.success("Password updated successfully!"));
            } else {
                String name = req.getParameter("name");
                int age = ValidationUtil.parsePositiveInt(req.getParameter("age"), 0);
                double heightCm = ValidationUtil.parsePositiveDouble(req.getParameter("heightCm"), 0.0);
                double weightKg = ValidationUtil.parsePositiveDouble(req.getParameter("weightKg"), 0.0);
                String fitnessGoal = req.getParameter("fitnessGoal");
                String activityLevel = req.getParameter("activityLevel");
                String profileImage = req.getParameter("profileImage");

                userService.updateProfile(currentUser.getId(), name,
                        age > 0 ? age : null,
                        heightCm > 0 ? heightCm : null,
                        weightKg > 0 ? weightKg : null,
                        fitnessGoal, activityLevel, profileImage);

                // Refresh user in session
                Optional<User> refreshed = userService.getUserById(currentUser.getId());
                refreshed.ifPresent(u -> session.setAttribute("currentUser", u));

                activityLogService.logActivity(currentUser.getId(), "PROFILE_UPDATED", "Updated profile settings", req.getRemoteAddr());
                session.setAttribute("flashMessage", FlashMessage.success("Profile updated successfully!"));
            }
        } catch (AppException e) {
            session.setAttribute("flashMessage", FlashMessage.error(e.getMessage()));
        } catch (Exception e) {
            session.setAttribute("flashMessage", FlashMessage.error("Failed to update profile: " + e.getMessage()));
        }

        resp.sendRedirect(req.getContextPath() + "/user/profile");
    }
}
