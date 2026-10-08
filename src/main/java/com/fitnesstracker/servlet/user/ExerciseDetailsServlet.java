package com.fitnesstracker.servlet.user;

import com.fitnesstracker.model.Exercise;
import com.fitnesstracker.model.User;
import com.fitnesstracker.service.ExerciseService;
import com.fitnesstracker.service.impl.ExerciseServiceImpl;
import com.fitnesstracker.util.FlashMessage;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

@WebServlet(name = "ExerciseDetailsServlet", urlPatterns = {"/user/exercise-details", "/user/exercise", "/user/content/exercise", "/exercise/view"})
public class ExerciseDetailsServlet extends HttpServlet {

    private final ExerciseService exerciseService = new ExerciseServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String idParam = req.getParameter("id");
        String slugParam = req.getParameter("slug");

        Optional<Exercise> optExercise = Optional.empty();

        if (idParam != null && !idParam.trim().isEmpty()) {
            try {
                int id = Integer.parseInt(idParam.trim());
                optExercise = exerciseService.getExerciseById(id);
            } catch (NumberFormatException e) {
                // Ignore and fall back to slug
            }
        }

        if (optExercise.isEmpty() && slugParam != null && !slugParam.trim().isEmpty()) {
            optExercise = exerciseService.getExerciseBySlug(slugParam.trim());
        }

        if (optExercise.isEmpty()) {
            session.setAttribute("flashMessage", FlashMessage.error("The requested exercise guide was not found."));
            resp.sendRedirect(req.getContextPath() + "/user/content?tab=exercises");
            return;
        }

        Exercise exercise = optExercise.get();
        List<Exercise> relatedExercises = exerciseService.getRelatedExercises(exercise.getId(), exercise.getCategory(), 3);

        req.setAttribute("exercise", exercise);
        req.setAttribute("relatedExercises", relatedExercises);

        req.getRequestDispatcher("/user/exercise-details.jsp").forward(req, resp);
    }
}
