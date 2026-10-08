-- ====================================================================
-- SEED DATA: EXPANDED WORKOUTS, NUTRITION, RECOVERY & ARTICLES
-- ====================================================================
USE `fitness_tracker_db`;

-- Add additional rich guides matching all subtabs without deleting existing articles
INSERT INTO `fitness_content` (`user_id`, `title`, `description`, `content_body`, `category`, `subcategory`, `read_time_minutes`, `level`, `image_url`, `status`, `created_at`) 
VALUES
-- Gym Workout Guide
(1, 'Heavy Compound Lifting & Gym Rack Safety Protocols',
 'Learn bar placement, safety pin settings, breathing mechanics, and gym etiquette for heavy compound barbell training.',
 '## Foundation of Barbell Training\n\nCompound barbell movements (Squats, Bench Press, Deadlifts, Overhead Press) are the most time-efficient tools for full-body strength.\n\n## 1. Setting Up Safety Pins & Spotter Arms\n- In the power rack, set safety pins 1-2 inches below your lowest point of parallel descent.\n- Test pin height with an empty bar before loading working weights.\n\n## 2. Valsalva Breathing Technique\n- Inhale deeply into your belly (diaphragmatic expansion).\n- Brace your core 360 degrees as if taking a punch.\n- Hold pressure through the sticking point, exhaling only at the top.',
 'Workout Routines', 'Gym', 6, 'Intermediate', 'assets/images/content/strength-training.webp', 'APPROVED', NOW() - INTERVAL 15 DAY),

-- Nutrition: Pre-Workout
(1, 'Pre-Workout Fueling: Timing, Macros & Nutrient Density',
 'Optimize energy, muscular endurance, and mental focus with strategic pre-exercise carbohydrate and hydration timing.',
 '## The Goal of Pre-Workout Nutrition\n\nProper pre-workout nutrition ensures optimal muscle glycogen levels and blood glucose stability without digestive discomfort.\n\n## The 2-3 Hour Meal\nConsume balanced lean protein and low-glycemic complex carbohydrates:\n- 150g grilled chicken or tofu\n- 150g sweet potato or brown rice\n- 1 glass of water with electrolytes\n\n## The 30-45 Minute Fast Fuel\nIf training early morning or after work, opt for rapidly digestible simple carbs:\n- 1 medium banana with 1 rice cake and honey\n- 200ml coconut water',
 'Nutrition & Diet', 'Pre-Workout', 5, 'All Levels', 'assets/images/content/protein-meal-prep.webp', 'APPROVED', NOW() - INTERVAL 14 DAY),

-- Nutrition: Post-Workout
(1, 'Post-Workout Anabolic Recovery & Glycogen Refueling',
 'Maximize protein synthesis rates and replenish depleted muscular energy stores within the critical 2-hour post-workout window.',
 '## Capitalizing on Post-Exercise Insulin Sensitivity\n\nFollowing resistance training, muscle cells exhibit heightened GLUT4 glucose transporter activity, pulling nutrients directly into muscle tissue.\n\n## The Ideal 3:1 Recovery Ratio\nFor intense training sessions lasting over 60 minutes:\n- **Protein:** 0.4g to 0.5g per kg bodyweight (e.g. 30-40g whey or lean meat)\n- **Carbohydrates:** 0.8g to 1.0g per kg bodyweight (e.g. rice, oatmeal, fruits)\n- **Hydration:** Replenish 1.25L of fluids per kg of bodyweight lost during exercise.',
 'Nutrition & Diet', 'Post-Workout', 5, 'All Levels', 'assets/images/content/healthy-nutrition.webp', 'APPROVED', NOW() - INTERVAL 13 DAY),

-- Nutrition: Healthy Fats
(1, 'Essential Healthy Fats & Hormonal Balance Playbook',
 'Why dietary fat is critical for testosterone, hormone synthesis, joint lubrication, and fat-soluble vitamin absorption.',
 '## The Importance of Dietary Lipids\n\nEliminating healthy fats impairs testosterone production, skin barrier health, and neural transmission.\n\n## Top Clean Fat Sources\n- **Monounsaturated:** Extra virgin olive oil, avocados, almonds.\n- **Omega-3 Fatty Acids:** Wild salmon, chia seeds, flaxseeds, walnuts.\n- **Daily Recommendation:** 20% to 30% of total daily caloric intake.',
 'Nutrition & Diet', 'Healthy Fats', 5, 'All Levels', 'assets/images/content/healthy-nutrition.webp', 'APPROVED', NOW() - INTERVAL 12 DAY),

-- Nutrition: Weight Management
(1, 'Sustainable Body Recomposition & Calorie Deficit Strategies',
 'How to calculate your maintenance TDEE, establish a gentle 300-calorie deficit, and preserve lean muscle while losing fat.',
 '## The Math of Body Recomposition\n\nCrash diets cause muscle wasting and metabolic slowdown. Sustainable fat loss requires a moderate 15-20% caloric deficit combined with heavy resistance training.\n\n## Key Principles for Success\n- Maintain high protein (2.0g per kg bodyweight).\n- Prioritize whole single-ingredient foods with high satiety index (potatoes, oats, lean meats).\n- Track weekly averages rather than daily scale fluctuations.',
 'Nutrition & Diet', 'Weight Management', 6, 'Intermediate', 'assets/images/content/protein-meal-prep.webp', 'APPROVED', NOW() - INTERVAL 10 DAY),

-- Recovery: Rest Day
(1, 'Central Nervous System Deload & Rest Day Optimization',
 'How to utilize scheduled rest days to restore neurotransmitter balance, tendon health, and psychological drive.',
 '## Recognizing Central Nervous System Fatigue\n\nWhile muscles recover in 48-72 hours, high-intensity neural pathways and joint connective tissue require dedicated low-stress rest periods.\n\n## Rest Day Protocol\n- **Sleep:** 8-9 hours uninterrupted sleep.\n- **Mobility:** 15 minutes of gentle walking and cat-cow flows.\n- **Nutrition:** Maintain baseline protein; do not slash calories aggressively.\n- **Mental Recharge:** Engage in hobbies completely outside the gym.',
 'Recovery & Wellness', 'Rest Day', 5, 'All Levels', 'assets/images/content/recovery.webp', 'APPROVED', NOW() - INTERVAL 8 DAY),

-- Recovery: Stretching
(1, 'Full-Body Daily Static & Dynamic Stretching Sequence',
 'A 15-minute complete head-to-toe stretching sequence to improve joint range of motion and prevent muscular stiffness.',
 '## Dynamic vs Static Stretching\n- **Dynamic:** Use before workouts to warm up synovial fluid in joints.\n- **Static:** Hold for 30-45 seconds after workouts to lengthen contracted muscle fibers.\n\n## Key Sequence Movements\n1. Standing Thoracic Extension (5 breaths)\n2. Kneeling Lunge Hip Flexor Stretch (45s each)\n3. Seated Hamstring Stretch (45s each)\n4. Pigeon Pose for Glute / Piriformis relief (60s each)\n5. Doorway Pec & Bicep Stretch (30s each)',
 'Recovery & Wellness', 'Stretching', 5, 'All Levels', 'assets/images/content/mobility.webp', 'APPROVED', NOW() - INTERVAL 7 DAY),

-- Fitness Article: Workout
(1, 'Progressive Overload: 5 Ways to Progress Beyond Adding Weight',
 'Explore rep velocity, paused eccentrics, reduced rest intervals, and volume manipulation when weight plates run out.',
 '## Beyond Just Adding Weight on the Bar\n\nWhen standard progressive overload stalls, utilize these biomechanical progression levers:\n\n1. **Tempo & Pauses:** Add a 3-second eccentric phase or a 2-second isometric pause at the bottom.\n2. **Range of Motion:** Train through a deeper, more challenging active range.\n3. **Rest Density:** Reduce rest intervals from 90s to 60s while maintaining the same weight and reps.\n4. **Technique Quality:** Execute reps with zero momentum or form breakdown.',
 'Workout Routines', 'Workout', 6, 'Advanced', 'assets/images/content/strength-training.webp', 'APPROVED', NOW() - INTERVAL 5 DAY),

-- Fitness Article: Fitness Science
(1, 'The Science of Hypertrophy: Mechanical Tension & Motor Unit Recruitment',
 'A deep physiological dive into mechanotransduction, Henneman size principle, and the effective reps model.',
 '## Mechanotransduction Explained\n\nWhen muscle fibers contract against high mechanical resistance, mechanosensors on the cell membrane convert mechanical tension into chemical cascades that activate mTORC1.\n\n## The Effective Reps Hypothesis\nOnly the final 4-5 repetitions prior to failure provide maximum mechanical tension on high-threshold motor units. This explains why sets taken within 1-3 Reps in Reserve (RIR) stimulate equivalent growth across varied rep ranges.',
 'Motivation', 'Fitness Science', 7, 'Advanced', 'assets/images/content/strength-training.webp', 'APPROVED', NOW() - INTERVAL 3 DAY);
