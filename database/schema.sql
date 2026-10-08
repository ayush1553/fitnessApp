-- ====================================================================
-- DATABASE SCHEMA: ONLINE FITNESS TRACKING AND PROGRESS MANAGEMENT
-- Database Engine: MySQL 8.0+
-- Character Set: utf8mb4 / Collation: utf8mb4_unicode_ci
-- ====================================================================

CREATE DATABASE IF NOT EXISTS `fitness_tracker_db`
DEFAULT CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE `fitness_tracker_db`;

-- Drop tables in reverse dependency order for clean migrations
DROP TABLE IF EXISTS `activity_logs`;
DROP TABLE IF EXISTS `system_settings`;
DROP TABLE IF EXISTS `exercises`;
DROP TABLE IF EXISTS `fitness_content`;
DROP TABLE IF EXISTS `challenge_participants`;
DROP TABLE IF EXISTS `challenges`;
DROP TABLE IF EXISTS `goals`;
DROP TABLE IF EXISTS `password_reset_tokens`;
DROP TABLE IF EXISTS `email_verification_tokens`;
DROP TABLE IF EXISTS `workouts`;
DROP TABLE IF EXISTS `profiles`;
DROP TABLE IF EXISTS `users`;

-- --------------------------------------------------------------------
-- 1. USERS TABLE
-- Core user entity supporting authentication, status, and role-based access control
-- --------------------------------------------------------------------
CREATE TABLE `users` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(100) NOT NULL,
    `email` VARCHAR(150) NOT NULL UNIQUE,
    `password` VARCHAR(255) NOT NULL, -- Stored as SHA-256 hash with salt
    `role` ENUM('USER', 'ADMIN') NOT NULL DEFAULT 'USER',
    `status` ENUM('ACTIVE', 'INACTIVE', 'SUSPENDED') NOT NULL DEFAULT 'ACTIVE',
    `email_verified` BOOLEAN NOT NULL DEFAULT FALSE,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX `idx_users_email` (`email`),
    INDEX `idx_users_role` (`role`),
    INDEX `idx_users_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------------------
-- 1.1 EMAIL VERIFICATION TOKENS TABLE
-- Cryptographic tokens for email verification flow
-- --------------------------------------------------------------------
CREATE TABLE `email_verification_tokens` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `user_id` INT NOT NULL,
    `token_hash` VARCHAR(64) NOT NULL,
    `expires_at` TIMESTAMP NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `used_at` TIMESTAMP NULL DEFAULT NULL,
    INDEX `idx_evt_token_hash` (`token_hash`),
    INDEX `idx_evt_user_id` (`user_id`),
    CONSTRAINT `fk_evt_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------------------
-- 1.2 PASSWORD RESET TOKENS TABLE
-- Cryptographic tokens for secure password recovery
-- --------------------------------------------------------------------
CREATE TABLE `password_reset_tokens` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `user_id` INT NOT NULL,
    `token_hash` VARCHAR(64) NOT NULL,
    `expires_at` TIMESTAMP NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `used_at` TIMESTAMP NULL DEFAULT NULL,
    INDEX `idx_prt_token_hash` (`token_hash`),
    INDEX `idx_prt_user_id` (`user_id`),
    CONSTRAINT `fk_prt_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------------------
-- 2. PROFILES TABLE
-- 1-to-1 relationship with `users` storing biometric and fitness parameters
-- --------------------------------------------------------------------
CREATE TABLE `profiles` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `user_id` INT NOT NULL UNIQUE,
    `age` INT DEFAULT NULL,
    `height_cm` DECIMAL(5,2) DEFAULT NULL,
    `weight_kg` DECIMAL(5,2) DEFAULT NULL,
    `fitness_goal` VARCHAR(255) DEFAULT 'Stay fit and active',
    `activity_level` ENUM('SEDENTARY', 'LIGHTLY_ACTIVE', 'MODERATELY_ACTIVE', 'VERY_ACTIVE') DEFAULT 'MODERATELY_ACTIVE',
    `profile_image` VARCHAR(255) DEFAULT 'default-avatar.png',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT `fk_profiles_user` FOREIGN KEY (`user_id`) 
        REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------------------
-- 3. WORKOUTS TABLE
-- Logs individual exercise sessions with polymorphic activity types & metrics
-- --------------------------------------------------------------------
CREATE TABLE `workouts` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `user_id` INT NOT NULL,
    `workout_type` ENUM('Running', 'Walking', 'Cycling', 'Swimming', 'Gym', 'Yoga', 'Strength Training', 'Other') NOT NULL,
    `duration_minutes` INT NOT NULL,
    `intensity` ENUM('Low', 'Medium', 'High') NOT NULL DEFAULT 'Medium',
    `calories_burned` INT NOT NULL,
    `workout_date` DATE NOT NULL,
    `notes` TEXT DEFAULT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT `fk_workouts_user` FOREIGN KEY (`user_id`) 
        REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX `idx_workouts_user_date` (`user_id`, `workout_date`),
    INDEX `idx_workouts_type` (`workout_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------------------
-- 4. GOALS TABLE
-- Personal user targets (e.g. running 50km, burning 5000 kcal, 20 gym visits)
-- --------------------------------------------------------------------
CREATE TABLE `goals` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `user_id` INT NOT NULL,
    `title` VARCHAR(150) NOT NULL,
    `description` TEXT DEFAULT NULL,
    `target_value` DECIMAL(10,2) NOT NULL,
    `current_value` DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    `unit` VARCHAR(50) NOT NULL DEFAULT 'km',
    `deadline` DATE NOT NULL,
    `status` ENUM('IN_PROGRESS', 'COMPLETED', 'EXPIRED', 'CANCELLED') NOT NULL DEFAULT 'IN_PROGRESS',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT `fk_goals_user` FOREIGN KEY (`user_id`) 
        REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX `idx_goals_user_status` (`user_id`, `status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------------------
-- 5. CHALLENGES TABLE
-- Community / Global challenges created by Admin or system
-- --------------------------------------------------------------------
CREATE TABLE `challenges` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `title` VARCHAR(150) NOT NULL,
    `description` TEXT NOT NULL,
    `category` VARCHAR(50) NOT NULL DEFAULT 'General',
    `target_value` DECIMAL(10,2) NOT NULL,
    `unit` VARCHAR(50) NOT NULL DEFAULT 'KM',
    `start_date` DATE NOT NULL,
    `end_date` DATE NOT NULL,
    `status` ENUM('UPCOMING', 'ACTIVE', 'COMPLETED', 'ARCHIVED') NOT NULL DEFAULT 'ACTIVE',
    `image_url` VARCHAR(500) DEFAULT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX `idx_challenges_status` (`status`),
    INDEX `idx_challenges_dates` (`start_date`, `end_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------------------
-- 6. CHALLENGE PARTICIPANTS TABLE
-- Tracks user participation in community challenges (Prevents duplicate joining)
-- --------------------------------------------------------------------
CREATE TABLE `challenge_participants` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `user_id` INT NOT NULL,
    `challenge_id` INT NOT NULL,
    `progress` DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    `status` ENUM('IN_PROGRESS', 'COMPLETED', 'DROPPED') NOT NULL DEFAULT 'IN_PROGRESS',
    `joined_date` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `completed_date` TIMESTAMP NULL DEFAULT NULL,
    CONSTRAINT `fk_cp_user` FOREIGN KEY (`user_id`) 
        REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `fk_cp_challenge` FOREIGN KEY (`challenge_id`) 
        REFERENCES `challenges` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `uk_user_challenge` UNIQUE (`user_id`, `challenge_id`),
    INDEX `idx_cp_user_challenge` (`user_id`, `challenge_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------------------
-- 7. FITNESS CONTENT TABLE
-- Articles, guides, workouts, nutrition tips submitted by users & moderated by Admins
-- --------------------------------------------------------------------
CREATE TABLE `fitness_content` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `user_id` INT NOT NULL,
    `title` VARCHAR(200) NOT NULL,
    `description` TEXT NOT NULL,
    `content_body` MEDIUMTEXT DEFAULT NULL,
    `category` ENUM('Workout Routines', 'Nutrition & Diet', 'Cardio & Endurance', 'Recovery & Wellness', 'Motivation') NOT NULL,
    `subcategory` VARCHAR(100) DEFAULT 'General',
    `read_time_minutes` INT DEFAULT 4,
    `level` VARCHAR(50) DEFAULT 'All Levels',
    `image_url` VARCHAR(500) DEFAULT NULL,
    `status` ENUM('PENDING', 'APPROVED', 'REJECTED') NOT NULL DEFAULT 'PENDING',
    `rejection_reason` VARCHAR(255) DEFAULT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT `fk_content_user` FOREIGN KEY (`user_id`) 
        REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX `idx_content_status` (`status`),
    INDEX `idx_content_category` (`category`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------------------
-- 7.1 EXERCISES TABLE
-- Movement library with video guides, instructions, difficulty, equipment, muscles
-- --------------------------------------------------------------------
CREATE TABLE `exercises` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(150) NOT NULL,
    `slug` VARCHAR(150) NOT NULL UNIQUE,
    `category` ENUM('Chest', 'Back', 'Shoulders', 'Arms', 'Legs', 'Core', 'Full Body', 'Mobility') NOT NULL,
    `difficulty` ENUM('Beginner', 'Intermediate', 'Advanced') NOT NULL DEFAULT 'Beginner',
    `equipment` VARCHAR(100) NOT NULL DEFAULT 'Bodyweight',
    `target_muscles` VARCHAR(255) NOT NULL,
    `secondary_muscles` VARCHAR(255) DEFAULT NULL,
    `description` TEXT NOT NULL,
    `instructions` MEDIUMTEXT NOT NULL,
    `common_mistakes` MEDIUMTEXT DEFAULT NULL,
    `form_tips` MEDIUMTEXT DEFAULT NULL,
    `default_sets` INT DEFAULT 3,
    `default_reps` VARCHAR(50) DEFAULT '10-12 reps',
    `default_duration_seconds` INT DEFAULT 45,
    `video_url` VARCHAR(500) DEFAULT NULL,
    `thumbnail_url` VARCHAR(500) DEFAULT NULL,
    `status` ENUM('ACTIVE', 'INACTIVE') NOT NULL DEFAULT 'ACTIVE',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX `idx_exercise_category` (`category`),
    INDEX `idx_exercise_difficulty` (`difficulty`),
    INDEX `idx_exercise_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------------------
-- 8. SYSTEM SETTINGS TABLE
-- Key-value pair configuration manageable by Admin
-- --------------------------------------------------------------------
CREATE TABLE `system_settings` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `setting_key` VARCHAR(100) NOT NULL UNIQUE,
    `setting_value` TEXT NOT NULL,
    `description` VARCHAR(255) DEFAULT NULL,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------------------
-- 9. ACTIVITY LOGS TABLE
-- Comprehensive audit trail for system events
-- --------------------------------------------------------------------
CREATE TABLE `activity_logs` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `user_id` INT DEFAULT NULL,
    `action` VARCHAR(100) NOT NULL,
    `details` TEXT DEFAULT NULL,
    `ip_address` VARCHAR(45) DEFAULT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_logs_user` FOREIGN KEY (`user_id`) 
        REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
    INDEX `idx_logs_user` (`user_id`),
    INDEX `idx_logs_action` (`action`),
    INDEX `idx_logs_created` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ====================================================================
-- SAMPLE DATA SEEDING
-- Passwords are hashed with SHA-256 for "admin123" and "user123"
-- SHA-256("admin123") = 240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9
-- SHA-256("user123")  = e606e38b0d8c19b24cf0ee3808183162ea7cd63ff7912dbb22b5e803286b4446
-- ====================================================================

-- 1. USERS
INSERT INTO `users` (`id`, `name`, `email`, `password`, `role`, `status`, `created_at`) VALUES
(1, 'Admin Officer', 'admin@fitnesstracker.com', '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', 'ADMIN', 'ACTIVE', NOW() - INTERVAL 30 DAY),
(2, 'Adam Sterling', 'adam.sterling@example.com', 'e606e38b0d8c19b24cf0ee3808183162ea7cd63ff7912dbb22b5e803286b4446', 'USER', 'ACTIVE', NOW() - INTERVAL 25 DAY),
(3, 'Sarah Connor', 'sarah.connor@example.com', 'e606e38b0d8c19b24cf0ee3808183162ea7cd63ff7912dbb22b5e803286b4446', 'USER', 'ACTIVE', NOW() - INTERVAL 20 DAY),
(4, 'Marcus Vance', 'marcus.vance@example.com', 'e606e38b0d8c19b24cf0ee3808183162ea7cd63ff7912dbb22b5e803286b4446', 'USER', 'ACTIVE', NOW() - INTERVAL 15 DAY);

-- 2. PROFILES
INSERT INTO `profiles` (`user_id`, `age`, `height_cm`, `weight_kg`, `fitness_goal`, `activity_level`, `profile_image`) VALUES
(1, 32, 180.00, 78.50, 'Maintain system operational fitness', 'MODERATELY_ACTIVE', 'default-avatar.png'),
(2, 28, 178.00, 74.00, 'Build endurance & marathon preparation', 'VERY_ACTIVE', 'default-avatar.png'),
(3, 26, 168.00, 59.00, 'Toning and functional core strength', 'MODERATELY_ACTIVE', 'default-avatar.png'),
(4, 34, 182.00, 85.00, 'Muscle hypertrophy & strength training', 'VERY_ACTIVE', 'default-avatar.png');

-- 3. WORKOUTS (Extensive real data across current and past weeks for Adam Sterling user_id=2)
INSERT INTO `workouts` (`user_id`, `workout_type`, `duration_minutes`, `intensity`, `calories_burned`, `workout_date`, `notes`) VALUES
(2, 'Running', 45, 'High', 420, CURDATE() - INTERVAL 6 DAY, 'Morning outdoor run at 5:15 pace'),
(2, 'Gym', 60, 'High', 480, CURDATE() - INTERVAL 5 DAY, 'Push day: Bench press, incline DB, cable flyes'),
(2, 'Cycling', 40, 'Medium', 310, CURDATE() - INTERVAL 4 DAY, 'Evening trail cycling sprint intervals'),
(2, 'Swimming', 50, 'High', 450, CURDATE() - INTERVAL 3 DAY, 'Freestyle 1500m laps with recovery kicks'),
(2, 'Yoga', 30, 'Low', 120, CURDATE() - INTERVAL 2 DAY, 'Vinyasa flow active recovery session'),
(2, 'Strength Training', 55, 'High', 410, CURDATE() - INTERVAL 1 DAY, 'Pull day: Deadlifts, pull-ups, barbell rows'),
(2, 'Running', 35, 'High', 330, CURDATE(), 'Interval sprints on track: 8x400m'),
-- Workouts for user 3
(3, 'Yoga', 45, 'Low', 150, CURDATE() - INTERVAL 4 DAY, 'Morning power yoga session'),
(3, 'Running', 30, 'Medium', 240, CURDATE() - INTERVAL 2 DAY, 'Park loop jog'),
(3, 'Gym', 50, 'Medium', 320, CURDATE() - INTERVAL 1 DAY, 'Legs & core workout'),
-- Workouts for user 4
(4, 'Gym', 75, 'High', 550, CURDATE() - INTERVAL 3 DAY, 'Heavy squats 5x5 and leg accessories'),
(4, 'Strength Training', 60, 'High', 460, CURDATE() - INTERVAL 1 DAY, 'Overhead presses and weighted dips');

-- 4. GOALS (For Adam Sterling user_id=2 and others)
INSERT INTO `goals` (`user_id`, `title`, `description`, `target_value`, `current_value`, `unit`, `deadline`, `status`) VALUES
(2, 'Run 50 KM', 'Complete 50 kilometers in outdoor running this month', 50.00, 32.00, 'KM', CURDATE() + INTERVAL 14 DAY, 'IN_PROGRESS'),
(2, 'Burn 10,000 Calories', 'Burn 10k total active calories through structured workouts', 10000.00, 7420.00, 'kcal', CURDATE() + INTERVAL 20 DAY, 'IN_PROGRESS'),
(2, 'Complete 20 Gym Sessions', 'Maintain gym consistency by hitting 20 sessions', 20.00, 14.00, 'Sessions', CURDATE() + INTERVAL 18 DAY, 'IN_PROGRESS'),
(2, '100 KM Cycling Milestone', 'Accumulate century cycling distance', 100.00, 100.00, 'KM', CURDATE() - INTERVAL 2 DAY, 'COMPLETED'),
(3, 'Morning Yoga 15 Days', 'Consistency streak for mindfulness and flexibility', 15.00, 9.00, 'Days', CURDATE() + INTERVAL 10 DAY, 'IN_PROGRESS'),
(4, 'Bench Press 100kg Target', 'Progressive overload training target', 100.00, 95.00, 'KG', CURDATE() + INTERVAL 30 DAY, 'IN_PROGRESS');

-- 5. CHALLENGES
INSERT INTO `challenges` (`id`, `title`, `description`, `category`, `target_value`, `unit`, `start_date`, `end_date`, `status`, `image_url`) VALUES
(1, '30-Day Running Challenge', 'Push your stamina to the limit! Complete 50 kilometers of running in 30 days.', 'Cardio', 50.00, 'KM', CURDATE() - INTERVAL 18 DAY, CURDATE() + INTERVAL 12 DAY, 'ACTIVE', 'assets/images/challenges/running.jpg'),
(2, 'Calorie Crusher 15,000', 'Torch 15,000 active calories across any workout category during the month.', 'Endurance', 15000.00, 'kcal', CURDATE() - INTERVAL 10 DAY, CURDATE() + INTERVAL 20 DAY, 'ACTIVE', 'assets/images/challenges/hiit.jpg'),
(3, 'Summer Century Ride', 'Conquer 100 kilometers of cycling outdoors or on stationary bikes.', 'Cycling', 100.00, 'KM', CURDATE() - INTERVAL 5 DAY, CURDATE() + INTERVAL 25 DAY, 'ACTIVE', 'assets/images/challenges/cycling.jpg'),
(4, 'Core & Strength Sprint', 'Log 25 comprehensive strength or gym sessions in 4 weeks.', 'Strength', 25.00, 'Sessions', CURDATE() + INTERVAL 5 DAY, CURDATE() + INTERVAL 35 DAY, 'UPCOMING', 'assets/images/challenges/strength.jpg');

-- 6. CHALLENGE PARTICIPANTS
INSERT INTO `challenge_participants` (`user_id`, `challenge_id`, `progress`, `status`, `joined_date`, `completed_date`) VALUES
(2, 1, 32.00, 'IN_PROGRESS', NOW() - INTERVAL 18 DAY, NULL),
(2, 2, 8540.00, 'IN_PROGRESS', NOW() - INTERVAL 10 DAY, NULL),
(3, 1, 44.00, 'IN_PROGRESS', NOW() - INTERVAL 17 DAY, NULL),
(4, 2, 12200.00, 'IN_PROGRESS', NOW() - INTERVAL 9 DAY, NULL),
(4, 3, 68.00, 'IN_PROGRESS', NOW() - INTERVAL 4 DAY, NULL);

-- 7. FITNESS CONTENT
INSERT INTO `fitness_content` (`user_id`, `title`, `description`, `content_body`, `category`, `image_url`, `status`, `created_at`) VALUES
(2, 'Mastering the 5K: Pacing and Breathing Techniques', 
 'Learn the rhythm of 2-2 stride breathing and cadence control to shave minutes off your 5K race pace without burning out.',
 '## The Foundation of 5K Speed & Endurance\n\nThe 5-kilometer distance is a unique athletic balance: it demands high aerobic capacity while pushing close to your lactate threshold. Many runners start too fast in the first kilometer, creating early oxygen debt that leads to severe deceleration.\n\n## 1. Rhythmic 2-2 Stride Breathing Pattern\n\nSynchronizing your respiration with foot strikes stabilizes your diaphragm and maintains efficient oxygenation:\n- Inhale smoothly for 2 footsteps (left, right)\n- Exhale fully for 2 footsteps (left, right)\n- If you enter the final sprint, switch to a rapid 2-1 or 1-1 rhythm to clear carbon dioxide rapidly.\n\n## 2. Cadence Optimization (170-180 SPM)\n\nA cadence between 170 and 180 strides per minute minimizes ground contact time, reducing vertical bounce and joint impact on knees and hips.\n\n## 3. Negative Split Pacing Strategy\n\nDivide your 5K into three distinct phases:\n- **KM 1–2:** Controlled cruise at 5 seconds slower than goal pace.\n- **KM 3–4:** Lock into your exact target race pace.\n- **KM 5:** Accelerate into your maximum sustainable kick.',
 'Cardio & Endurance', 'assets/images/content/5k-running.webp', 'APPROVED', NOW() - INTERVAL 10 DAY),

(3, 'Post-Workout Mobility Flow for Hip and Spine Relief', 
 'A 10-minute guided mobility sequence to decompress tight hip flexors and lower back after intense running or deadlifts.',
 '## Why Mobility is Essential After Heavy Sessions\n\nHeavy compound movements like deadlifts, squats, and sustained running compress the spinal column and tighten the psoas muscles. Passive sitting after training locks these shortened muscle lengths in place.\n\n## 1. 90/90 Hip Opener Flow (2 Mins Each Side)\n\nSit on the floor with both knees bent at 90-degree angles. Keep the torso upright and gently hinge forward from the pelvis. This actively targets internal and external hip rotators.\n\n## 2. World\'s Greatest Stretch (5 Reps / Side)\n\nStep into a deep lunge, place both hands inside your front foot, and rotate your thoracic spine toward the ceiling. Breathe deeply into the open ribcage.\n\n## 3. Cat-Cow Thoracic Wave\n\nOn all fours, rhythmically articulate each vertebra from the tailbone to the neck. Synchronize with slow diaphragmatic nasal breathing to signal the parasympathetic nervous system into recovery mode.',
 'Recovery & Wellness', 'assets/images/content/mobility.webp', 'APPROVED', NOW() - INTERVAL 7 DAY),

(4, 'High Protein Macro Planning on a Budget', 
 'Practical strategies for meal prepping lean chicken, eggs, lentils, and Greek yogurt to hit 160g protein daily without overspending.',
 '## The Protein Paradox: Quality Without High Costs\n\nBuilding lean muscle tissue or preserving strength during a calorie deficit requires consistent daily protein intake (1.6g to 2.2g per kg of body weight). You don\'t need expensive cuts of meat or exotic supplements to reach your targets.\n\n## Top Cost-Effective Protein Powerhouses\n\n- **Chicken Breast & Thighs:** High biological value, versatile for batch roasting with paprika and garlic.\n- **Whole Eggs & Liquid Egg Whites:** Perfect balance of bioavailable amino acids and healthy micronutrients.\n- **Brown Lentils & Chickpeas:** Inexpensive plant protein loaded with soluble dietary fiber for gut health.\n- **0% Greek Yogurt / Quark:** Fast casein and whey protein source requiring zero cooking time.\n\n## Sample 160g Daily Protein Blueprint\n\n- **Breakfast:** 3 whole eggs + 2 slices whole-grain toast + 150g Greek yogurt (42g protein)\n- **Lunch:** 180g roasted chicken breast + brown rice + steamed greens (48g protein)\n- **Snack:** 1 scoop whey or 200g cottage cheese with berries (25g protein)\n- **Dinner:** Lentil chili with lean ground turkey or tofu (45g protein)',
 'Nutrition & Diet', 'assets/images/content/protein-meal-prep.webp', 'APPROVED', NOW() - INTERVAL 4 DAY),

(2, 'Advanced HIIT Protocol for Maximum Metabolic Afterburn', 
 'Utilize the Tabata 20-10 interval ratio with compound bodyweight exercises to boost EPOC (excess post-exercise oxygen consumption).',
 '## Unleashing EPOC (Excess Post-Exercise Oxygen Consumption)\n\nHigh-Intensity Interval Training triggers an elevated metabolic rate that burns additional calories for hours post-workout.\n\n## 4-Round Power Circuit (20s Work / 10s Rest)\n\n- **Station 1:** Explosive Kettlebell Swings (Hips back, full glute lock)\n- **Station 2:** Battle Rope Waves (High speed, athletic quarter squat stance)\n- **Station 3:** Plyometric Box Jumps or Tuck Jumps\n- **Station 4:** Burpee to Overhead Press\n\nRest 90 seconds between full rounds. Repeat for 4 rounds total.',
 'Workout Routines', 'assets/images/content/strength-training.webp', 'APPROVED', NOW() - INTERVAL 1 DAY),

(3, 'Overcoming Mid-Plateau Mental Fatigue', 
 'Actionable mindset reframing techniques when strength progression slows down or workout enthusiasm dips.',
 '## The Psychology of the Training Plateau\n\nProgress in physical fitness is non-linear. After the rapid neural adaptations of beginner training, every seasoned athlete hits periods where progress stalls and motivation flags.\n\n## 1. Differentiating Central Nervous System Fatigue from Lack of Drive\n\nWhen grip strength drops, resting heart rate elevates, and sleep quality degrades, your nervous system is signaling systemic fatigue, not mental weakness. Implement a scheduled deload week immediately.\n\n## 2. Shift Focus from Outcome Goals to Process Streaks\n\nInstead of measuring only weight on the bar, track sleep consistency, daily water targets, and training consistency streaks. Small daily wins rebuild momentum.\n\n## 3. Deliberate Deloading Strategy\n\nReduce training volume by 40–50% while maintaining moderate intensity. This allows joint structures and hormonal balances to supercompensate.',
 'Motivation', 'assets/images/content/mental-fatigue.webp', 'APPROVED', NOW() - INTERVAL 12 HOUR);

-- 8. SYSTEM SETTINGS
INSERT INTO `system_settings` (`setting_key`, `setting_value`, `description`) VALUES
('app_name', 'FITFLOW Pro Fitness Tracker', 'Official title of the web application'),
('allow_registration', 'true', 'Allows new users to create accounts'),
('challenges_enabled', 'true', 'Enables global challenge system for users'),
('content_moderation', 'true', 'Requires admin review before fitness content is published'),
('max_challenge_days', '60', 'Maximum duration allowed for new challenges'),
('default_calorie_target', '2200', 'Default daily calorie burn recommendation');

-- --------------------------------------------------------------------
-- 10. NUTRITION PROFILES TABLE
-- --------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `nutrition_profiles` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `user_id` INT NOT NULL UNIQUE,
    `age` INT NOT NULL,
    `sex` ENUM('MALE', 'FEMALE') NOT NULL DEFAULT 'MALE',
    `height_cm` DECIMAL(5,2) NOT NULL,
    `weight_kg` DECIMAL(5,2) NOT NULL,
    `activity_level` ENUM('SEDENTARY', 'LIGHTLY_ACTIVE', 'MODERATELY_ACTIVE', 'VERY_ACTIVE', 'EXTREMELY_ACTIVE') NOT NULL DEFAULT 'MODERATELY_ACTIVE',
    `fitness_goal` ENUM('CUTTING', 'MAINTENANCE', 'BULKING') NOT NULL DEFAULT 'MAINTENANCE',
    `diet_type` ENUM('VEGETARIAN', 'NON_VEGETARIAN', 'VEGAN', 'EGGETARIAN') NOT NULL DEFAULT 'NON_VEGETARIAN',
    `meals_per_day` INT NOT NULL DEFAULT 4,
    `food_exclusions` TEXT DEFAULT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT `fk_np_user` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------------------
-- 11. NUTRITION TARGETS TABLE
-- --------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `nutrition_targets` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `user_id` INT NOT NULL UNIQUE,
    `daily_calories` INT NOT NULL,
    `protein_grams` INT NOT NULL,
    `carbs_grams` INT NOT NULL,
    `fat_grams` INT NOT NULL,
    `bmr` INT NOT NULL,
    `tdee` INT NOT NULL,
    `bmi` DECIMAL(4,1) NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT `fk_nt_user` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------------------
-- 12. MEAL PLANS TABLE
-- --------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `meal_plans` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `user_id` INT NOT NULL,
    `plan_date` DATE NOT NULL,
    `meal_count` INT NOT NULL DEFAULT 4,
    `daily_calories` INT NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_mp_user` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
    INDEX `idx_mp_user_date` (`user_id`, `plan_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------------------
-- 13. MEAL PLAN ITEMS TABLE
-- --------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `meal_plan_items` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `meal_plan_id` INT NOT NULL,
    `meal_type` ENUM('BREAKFAST', 'MID_MORNING_SNACK', 'LUNCH', 'EVENING_SNACK', 'DINNER', 'POST_WORKOUT') NOT NULL,
    `meal_name` VARCHAR(150) NOT NULL,
    `food_items` TEXT NOT NULL,
    `calories` INT NOT NULL,
    `protein_grams` INT NOT NULL,
    `carbs_grams` INT NOT NULL,
    `fat_grams` INT NOT NULL,
    CONSTRAINT `fk_mpi_plan` FOREIGN KEY (`meal_plan_id`) REFERENCES `meal_plans`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------------------
-- 14. NUTRITION LOGS TABLE
-- --------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `nutrition_logs` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `user_id` INT NOT NULL,
    `log_date` DATE NOT NULL,
    `meal_type` ENUM('BREAKFAST', 'MID_MORNING_SNACK', 'LUNCH', 'EVENING_SNACK', 'DINNER', 'POST_WORKOUT', 'OTHER') NOT NULL,
    `food_name` VARCHAR(150) NOT NULL,
    `calories` INT NOT NULL,
    `protein_grams` INT NOT NULL DEFAULT 0,
    `carbs_grams` INT NOT NULL DEFAULT 0,
    `fat_grams` INT NOT NULL DEFAULT 0,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_nl_user` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
    INDEX `idx_nl_user_date` (`user_id`, `log_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------------------
-- 15. WATER LOGS TABLE
-- --------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `water_logs` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `user_id` INT NOT NULL,
    `log_date` DATE NOT NULL,
    `amount_liters` DECIMAL(4,2) NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_wl_user` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
    INDEX `idx_wl_user_date` (`user_id`, `log_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------------------
-- 10. SAMPLE NUTRITION SEEDS
-- --------------------------------------------------------------------
INSERT INTO `nutrition_profiles` (`user_id`, `age`, `sex`, `height_cm`, `weight_kg`, `activity_level`, `fitness_goal`, `diet_type`, `meals_per_day`, `food_exclusions`) VALUES
(2, 28, 'MALE', 178.00, 74.00, 'VERY_ACTIVE', 'CUTTING', 'NON_VEGETARIAN', 4, 'No peanuts');

INSERT INTO `nutrition_targets` (`user_id`, `daily_calories`, `protein_grams`, `carbs_grams`, `fat_grams`, `bmr`, `tdee`, `bmi`) VALUES
(2, 2350, 145, 250, 70, 1720, 2750, 23.4);

INSERT INTO `meal_plans` (`id`, `user_id`, `plan_date`, `meal_count`, `daily_calories`) VALUES
(1, 2, CURDATE(), 4, 2350);

INSERT INTO `meal_plan_items` (`meal_plan_id`, `meal_type`, `meal_name`, `food_items`, `calories`, `protein_grams`, `carbs_grams`, `fat_grams`) VALUES
(1, 'BREAKFAST', 'Oatmeal Power Bowl with Berries', 'Rolled oats 80g, Skim milk 250ml, Banana 1 medium, Whey protein scoop, Chia seeds 10g', 520, 35, 75, 10),
(1, 'LUNCH', 'Grilled Chicken & Quinoa Salad', 'Chicken breast 180g, Quinoa 150g, Mixed greens, Cherry tomatoes, Olive oil dressing', 680, 48, 62, 18),
(1, 'EVENING_SNACK', 'Greek Yogurt with Almonds & Honey', 'Greek yogurt (0%) 200g, Raw almonds 20g, Honey 1 tsp', 340, 22, 28, 14),
(1, 'DINNER', 'Baked Salmon with Sweet Potato & Asparagus', 'Wild salmon fillet 170g, Sweet potato 200g, Steamed asparagus, Steamed brown rice', 610, 40, 65, 17);

INSERT INTO `nutrition_logs` (`user_id`, `log_date`, `meal_type`, `food_name`, `calories`, `protein_grams`, `carbs_grams`, `fat_grams`) VALUES
(2, CURDATE(), 'BREAKFAST', 'Oatmeal Power Bowl with Berries', 520, 35, 75, 10),
(2, CURDATE(), 'LUNCH', 'Grilled Chicken & Quinoa Salad', 680, 48, 62, 18),
(2, CURDATE(), 'EVENING_SNACK', 'Protein Shake & Banana', 310, 27, 35, 4);

INSERT INTO `water_logs` (`user_id`, `log_date`, `amount_liters`) VALUES
(2, CURDATE(), 2.40);

