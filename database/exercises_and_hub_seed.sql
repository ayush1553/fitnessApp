-- ====================================================================
-- SCHEMA UPDATE: FITNESS LEARNING HUB & EXERCISE LIBRARY
-- ====================================================================
USE `fitness_tracker_db`;

-- 1. Create EXERCISES table
CREATE TABLE IF NOT EXISTS `exercises` (
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

-- 2. Enhance fitness_content table with subcategory and tags if not present
ALTER TABLE `fitness_content` 
ADD COLUMN IF NOT EXISTS `subcategory` VARCHAR(100) DEFAULT 'General',
ADD COLUMN IF NOT EXISTS `read_time_minutes` INT DEFAULT 4,
ADD COLUMN IF NOT EXISTS `level` VARCHAR(50) DEFAULT 'All Levels';

-- 3. Seed comprehensive Exercise Library
DELETE FROM `exercises`;

INSERT INTO `exercises` (`name`, `slug`, `category`, `difficulty`, `equipment`, `target_muscles`, `secondary_muscles`, `description`, `instructions`, `common_mistakes`, `form_tips`, `default_sets`, `default_reps`, `default_duration_seconds`, `video_url`, `thumbnail_url`, `status`) VALUES
-- CHEST
('Classic Push-Up', 'classic-push-up', 'Chest', 'Beginner', 'Bodyweight', 'Pectoralis Major', 'Triceps, Anterior Deltoids, Core', 
 'The foundational upper-body calisthenics movement for developing chest, shoulder, and core strength.',
 '1. Start in a high plank position with hands slightly wider than shoulder-width apart.\n2. Engage your core, squeeze glutes, and maintain a straight line from heels to head.\n3. Lower your chest until it is approximately 2 inches from the floor, keeping elbows at a 45-degree angle.\n4. Push forcefully through your palms to return to the starting plank position.',
 'Flaring elbows outward at 90 degrees, sagging hips or hyperextending lower back, incomplete range of motion.',
 'Keep neck neutral by looking slightly ahead on the floor; actively screw palms into the floor to create shoulder torque.',
 3, '12-15 reps', 45, 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4', 'assets/images/content/strength-training.webp', 'ACTIVE'),

('Incline Dumbbell Bench Press', 'incline-dumbbell-bench-press', 'Chest', 'Intermediate', 'Dumbbells, Adjustable Bench', 'Upper Pectoralis (Clavicular Head)', 'Anterior Deltoids, Triceps',
 'Premier mass builder for the upper chest fibers, providing balanced bilateral development.',
 '1. Set an incline bench to 30-45 degrees. Sit with dumbbells resting on your knees.\n2. Kick the weights up to your shoulders as you lie back against the pad.\n3. Retract scapulae and press dumbbells upward, converging slightly at the peak without clanking.\n4. Lower slowly under control over 3 seconds until feeling a deep stretch across upper chest.',
 'Arching lower back off the bench excessively, setting bench incline too high (turns into shoulder press), bouncing at the bottom.',
 'Keep your shoulder blades retracted and depressed into the pad throughout the entire movement.',
 4, '8-10 reps', 60, 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4', 'assets/images/content/strength-training.webp', 'ACTIVE'),

('Parallel Bar Chest Dips', 'chest-dips', 'Chest', 'Advanced', 'Dip Station', 'Lower Pectoralis, Sternal Head', 'Triceps, Anterior Deltoids',
 'High-intensity compound bodyweight exercise targeting the lower chest and pushing power.',
 '1. Mount the parallel dip bars with arms locked and torso tilted forward about 25-30 degrees.\n2. Cross your feet and flare elbows slightly outward to bias chest recruitment.\n3. Lower your body under control until shoulders are below elbows (or at 90-degree angle).\n4. Press back up powerfully while maintaining the forward torso lean.',
 'Staying completely upright (shifts load to triceps), allowing shoulders to roll forward at bottom, using momentum.',
 'Keep chest proud and elbows tucked at roughly 45 degrees relative to torso to protect the anterior rotator cuff.',
 3, '8-12 reps', 45, 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4', 'assets/images/content/strength-training.webp', 'ACTIVE'),

-- BACK
('Wide-Grip Pull-Up', 'wide-grip-pull-up', 'Back', 'Intermediate', 'Pull-Up Bar', 'Latissimus Dorsi', 'Biceps, Rhomboids, Rear Deltoids, Grip',
 'The gold standard bodyweight movement for building a wide, V-tapered back.',
 '1. Grip pull-up bar with an overhand grip slightly wider than shoulder-width.\n2. Hang with arms fully extended and engage your scapulae downward.\n3. Drive elbows down and back toward your hips while pulling chest to the bar.\n4. Pause briefly at the top, then lower yourself smoothly to a full dead hang.',
 'Kicking legs or using kipping momentum, failing to reach full dead-hang at bottom, shrugging shoulders up to ears.',
 'Think of pulling your elbows down to your pockets rather than pulling your chin over the bar.',
 4, '6-10 reps', 60, 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyBlazes.mp4', 'assets/images/content/strength-training.webp', 'ACTIVE'),

('Single-Arm Dumbbell Row', 'single-arm-dumbbell-row', 'Back', 'Beginner', 'Dumbbell, Flat Bench', 'Latissimus Dorsi, Rhomboids', 'Biceps, Rear Delts, Core',
 'Unilateral rowing staple that eliminates muscle imbalances and builds core antirotational strength.',
 '1. Place left knee and left hand firmly on a flat bench with spine parallel to floor.\n2. Grip a dumbbell with right hand in a neutral grip at full arm extension.\n3. Pull the dumbbell upward toward your hip crease, driving through your right elbow.\n4. Squeeze shoulder blade back at peak contraction, then lower with a controlled eccentric stretch.',
 'Twisting torso to yank weight up, pulling straight up to chest instead of sweeping back to hip.',
 'Maintain a solid flat back and brace abs as if preparing for a punch throughout every repetition.',
 3, '10-12 reps/side', 45, 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4', 'assets/images/content/strength-training.webp', 'ACTIVE'),

-- SHOULDERS
('Standing Overhead Dumbbell Press', 'standing-overhead-dumbbell-press', 'Shoulders', 'Intermediate', 'Dumbbells', 'Anterior & Lateral Deltoids', 'Triceps, Upper Trapezius, Core',
 'Comprehensive shoulder builder requiring overhead stability and standing core engagement.',
 '1. Stand with feet shoulder-width apart, holding dumbbells at shoulder level with knuckles facing ceiling.\n2. Brace glutes and abdominal wall firmly to prevent lower-back hyperextension.\n3. Press dumbbells directly overhead in a smooth arc until arms are extended overhead.\n4. Lower dumbbells under strict control back to chin level.',
 'Leaning back and turning the press into an incline bench press, pressing forward instead of directly overhead.',
 'Lock your ribs down toward your pelvis and contract your quads/glutes to create a rock-solid foundation.',
 3, '8-12 reps', 45, 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4', 'assets/images/content/strength-training.webp', 'ACTIVE'),

('Dumbbell Lateral Raise', 'dumbbell-lateral-raise', 'Shoulders', 'Beginner', 'Light Dumbbells', 'Lateral Deltoids', 'Upper Traps, Forearms',
 'Isolation exercise essential for building shoulder width and the rounded 3D shoulder cap look.',
 '1. Stand tall with light dumbbells at sides, slight bend in elbows, and torso tipped forward 5 degrees.\n2. Raise arms out to sides in the scapular plane (30 degrees forward of direct lateral).\n3. Lift until elbows reach shoulder height, leading with elbows rather than wrists.\n4. Pause for a split second at the peak, then lower smoothly over 2-3 seconds.',
 'Using heavy weights and swinging hips/torso, raising wrists higher than elbows, shrugging traps excessively.',
 'Pour the water: imagine slightly tilting the front bells downward at peak contraction to isolate side delts.',
 4, '12-15 reps', 45, 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4', 'assets/images/content/strength-training.webp', 'ACTIVE'),

-- ARMS
('Incline Dumbbell Bicep Curl', 'incline-dumbbell-bicep-curl', 'Arms', 'Beginner', 'Dumbbells, Incline Bench', 'Biceps Brachii (Long Head)', 'Brachialis, Forearms',
 'Places the long head of the bicep under maximum passive stretch for superior hypertrophy stimulus.',
 '1. Lie back on an incline bench set to 45-60 degrees with dumbbells hanging straight down.\n2. Keep upper arms pinned perpendicular to the floor behind your torso.\n3. Curl dumbbells upward while supinating wrists (palms facing upward) as you reach the top.\n4. Squeeze biceps hard at top contraction, then lower slowly through the full deep stretch.',
 'Swinging elbows forward to assist the curl, lifting shoulders off the pad, rushing through the bottom stretch.',
 'Keep shoulders completely relaxed and pinned against bench; do not let elbows drift forward.',
 3, '10-12 reps', 45, 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4', 'assets/images/content/strength-training.webp', 'ACTIVE'),

('Cable Tricep Rope Pushdown', 'cable-tricep-rope-pushdown', 'Arms', 'Beginner', 'Cable Machine, Rope Attachment', 'Triceps Brachii (Lateral & Medial Heads)', 'Forearms',
 'High-tension triceps isolation exercise allowing peak lateral contraction through rope spread.',
 '1. Attach a rope to a high cable pulley. Grip rope with neutral grip and stand with slight forward hip hinge.\n2. Pin elbows tight against your ribs; upper arms remain stationary.\n3. Push rope down until arms are fully locked, spreading rope handles outward at bottom.\n4. Squeeze triceps hard for 1 second, then control weight up until forearms reach 90 degrees.',
 'Letting elbows flare or travel forward/backward, using body momentum to push weight down.',
 'Spread the rope apart at the very bottom of the rep to ignite deep triceps lateral head activation.',
 3, '12-15 reps', 45, 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4', 'assets/images/content/strength-training.webp', 'ACTIVE'),

-- LEGS
('Barbell Back Squat', 'barbell-back-squat', 'Legs', 'Intermediate', 'Barbell, Squat Rack', 'Quadriceps, Gluteus Maximus', 'Hamstrings, Adductors, Core, Lower Back',
 'The king of all lower-body compound movements for massive leg strength and athletic power.',
 '1. Position bar on upper traps (high bar) or across rear delts (low bar). Unrack and step back 2 paces.\n2. Stand with feet shoulder-width apart, toes pointed slightly outward at 15-30 degrees.\n3. Inhale deeply into abdomen, brace core, and initiate squat by breaking at hips and knees simultaneously.\n4. Descend until hip crease is below top of knees (parallel or below), then drive up through mid-foot.',
 'Knees caving inward (valgus collapse), heel lifting off floor, collapsing chest forward (stripper squat).',
 'Push the floor away with entire foot and actively push knees out in line with toes during ascent.',
 4, '6-8 reps', 90, 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyBlazes.mp4', 'assets/images/content/strength-training.webp', 'ACTIVE'),

('Bulgarian Split Squat', 'bulgarian-split-squat', 'Legs', 'Intermediate', 'Dumbbells, Bench', 'Quadriceps, Glutes', 'Hamstrings, Calves, Core Stability',
 'Unilateral leg punishment that crushes quad/glute strength and solves pelvic imbalances.',
 '1. Stand 2-3 feet in front of a flat bench. Place top of one foot rearward onto bench.\n2. Hold dumbbells at sides with tall upright torso.\n3. Lower back knee toward floor in a controlled descent until front thigh is parallel to ground.\n4. Drive through front heel and mid-foot to stand back up to starting position.',
 'Placing front foot too close to bench (cramps knee joint), shifting weight onto back foot, leaning torso sideways.',
 'Keep 85% of your weight firmly centered over your front foot and descend straight down like an elevator.',
 3, '8-10 reps/side', 60, 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4', 'assets/images/content/strength-training.webp', 'ACTIVE'),

-- CORE
('Standard Forearm Plank', 'standard-forearm-plank', 'Core', 'Beginner', 'Mat / Bodyweight', 'Rectus Abdominis, Transverse Abdominis', 'Obliques, Glutes, Shoulders',
 'Essential isometric core pillar exercise for anti-extension spinal stability and postural integrity.',
 '1. Lie facedown and prop yourself up onto forearms with elbows aligned directly under shoulders.\n2. Extend legs back on toes with feet hip-width apart.\n3. Contract glutes, tuck pelvis into posterior pelvic tilt, and pull belly button up toward spine.\n4. Breathe smoothly while holding perfectly rigid tension from head to heels.',
 'Sagging hips causing lumbar arching, hiking hips up like a mountain, holding breath.',
 'Actively pull your elbows toward your toes to generate intense full-core abdominal irradiation.',
 3, '45-60 sec hold', 60, 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4', 'assets/images/content/strength-training.webp', 'ACTIVE'),

('Side Plank with Hip Dip', 'side-plank-hip-dip', 'Core', 'Intermediate', 'Bodyweight / Mat', 'Internal & External Obliques', 'Quadratus Lumborum, Gluteus Medius',
 'Rotational and lateral core strength builder for sculptured waistlines and injury-proof lower back.',
 '1. Lie on side with elbow directly beneath shoulder and feet stacked on top of each other.\n2. Raise hips until body forms a straight diagonal line from head to feet.\n3. Slowly dip hips down until they graze 1 inch above the floor.\n4. Drive hips back up to full alignment, squeezing lower oblique at peak.',
 'Rolling top hip forward or backward, allowing top shoulder to collapse inward, sagging neck.',
 'Keep your top hand on top hip or extended straight up toward ceiling to ensure chest remains open.',
 3, '12 reps/side', 45, 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4', 'assets/images/content/strength-training.webp', 'ACTIVE'),

('Mountain Climbers', 'mountain-climbers', 'Core', 'Beginner', 'Bodyweight', 'Rectus Abdominis, Hip Flexors', 'Shoulders, Quads, Cardiovascular System',
 'Dynamic high-speed core and conditioning movement that burns calories while engaging deep core.',
 '1. Begin in high push-up position with hands directly under shoulders and core tight.\n2. Drive right knee rapidly toward chest without letting hips bounce up.\n3. Return right foot and immediately drive left knee toward chest in an alternating fluid rhythm.\n4. Maintain a steady, brisk pace while keeping back flat and shoulders stable.',
 'Bouncing hips up and down, letting lower back arch, landing heavily on toes.',
 'Keep your shoulders fixed directly above wrists; think of sprinting horizontally along the floor.',
 3, '45-60 seconds', 45, 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4', 'assets/images/content/cardio.webp', 'ACTIVE'),

-- FULL BODY
('Burpees (Chest to Floor)', 'burpees-chest-to-floor', 'Full Body', 'Intermediate', 'Bodyweight', 'Full Body Aerobic & Muscular', 'Chest, Quads, Core, Calves, Triceps',
 'The ultimate full-body calisthenic test of aerobic stamina, power output, and functional agility.',
 '1. Stand tall with feet shoulder-width apart.\n2. Drop hips back, place hands on floor, and kick feet back into high plank.\n3. Drop chest and thighs completely to touch floor.\n4. Push up forcefully, jump feet back under hips, and leap vertically with hands clapping overhead.',
 'Bending from lower back rather than hinging at hips, omitting full chest floor contact, landing stiff-legged.',
 'Land softly on the balls of your feet and immediately transition into the next repetition without hesitating.',
 4, '15-20 reps', 60, 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4', 'assets/images/content/cardio.webp', 'ACTIVE'),

('Explosive Kettlebell Swing', 'kettlebell-swing', 'Full Body', 'Intermediate', 'Kettlebell', 'Glutes, Hamstrings, Posterior Chain', 'Core, Latissimus, Grip, Heart',
 'Ballistic hip-hinge power movement that builds explosive glutes and athletic work capacity.',
 '1. Stand with feet wider than shoulder-width, kettlebell 1 foot in front of you on floor.\n2. Hinge at hips with flat back, grab horn with both hands, and hike bell back between legs like a football.\n3. Stand up explosively by driving hips forward and squeezing glutes to float bell to chest level.\n4. Let kettlebell swing back freely between legs, catching momentum with hips, and repeat.',
 'Squatting the bell down instead of hinging hips, lifting bell with shoulders/arms, hyperextending back at top.',
 'The arms are just ropes: 100% of the upward propulsion comes from explosive hip thrust and glute contraction.',
 4, '15-20 reps', 60, 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyBlazes.mp4', 'assets/images/content/strength-training.webp', 'ACTIVE'),

-- MOBILITY
('The World\'s Greatest Stretch', 'worlds-greatest-stretch', 'Mobility', 'Beginner', 'Mat / Bodyweight', 'Hip Flexors, Thoracic Spine, Hamstrings', 'Glutes, Calves, Groin',
 'Multi-joint dynamic mobility routine that targets all major restrictions in one fluid flow.',
 '1. Step forward into a deep lunge with right foot. Place both hands flat inside right foot on mat.\n2. Drop right elbow toward right inside ankle to deepen hip stretch.\n3. Rotate torso to the right, extending right arm straight up to the ceiling while following hand with eyes.\n4. Return hand to floor, rock hips back to straighten front leg and stretch hamstring.\n5. Step forward and switch to left leg.',
 'Rushing through transitions without breathing, rounding upper back excessively during thoracic rotation.',
 'Inhale deeply as you rotate toward ceiling; exhale as you reach toward ankle to release hip tension.',
 3, '5 reps/side', 60, 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4', 'assets/images/content/mobility.webp', 'ACTIVE'),

('90/90 Hip Mobility Flow', '90-90-hip-flow', 'Mobility', 'Beginner', 'Mat / Bodyweight', 'Internal & External Hip Rotators', 'Glutes, Piriformis, Lower Back',
 'Restores rotational freedom in the hip capsules to protect knees and alleviate lower back stiffness.',
 '1. Sit on floor with front leg bent at 90 degrees in front and rear leg bent at 90 degrees to side.\n2. Keep spine tall and tall chest proud. Hinge forward at waist over front shin until deep stretch.\n3. Hold for 3-5 deep belly breaths.\n4. Lift both knees and transition windshield-wiper style to the opposite side without hands touching ground.',
 'Rounding spine instead of hinging from pelvis, forcing knees down past pain thresholds.',
 'Keep feet flexed at 90 degrees throughout the transition to stabilize knee ligaments.',
 3, '60s per side', 60, 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4', 'assets/images/content/mobility.webp', 'ACTIVE');

-- 4. Update existing and seed additional Workout Guides, Nutrition Guides, Recovery Guides, and Articles in fitness_content
UPDATE `fitness_content` SET `subcategory` = 'Cardio', `read_time_minutes` = 5, `level` = 'Beginner' WHERE `id` = 1;
UPDATE `fitness_content` SET `subcategory` = 'Mobility', `read_time_minutes` = 4, `level` = 'All Levels' WHERE `id` = 2;
UPDATE `fitness_content` SET `subcategory` = 'Protein', `read_time_minutes` = 6, `level` = 'Intermediate' WHERE `id` = 3;
UPDATE `fitness_content` SET `subcategory` = 'Strength', `read_time_minutes` = 5, `level` = 'Advanced' WHERE `id` = 4;
UPDATE `fitness_content` SET `subcategory` = 'Motivation', `read_time_minutes` = 4, `level` = 'All Levels' WHERE `id` = 5;

-- Insert additional rich items if not already existing
INSERT INTO `fitness_content` (`user_id`, `title`, `description`, `content_body`, `category`, `subcategory`, `read_time_minutes`, `level`, `image_url`, `status`, `created_at`) VALUES
-- Workout Guides
(1, 'Complete Beginner 4-Week Strength Blueprint',
 'A step-by-step foundation program focusing on compound movement mastery and neuromuscular adaptation for lifters starting their journey.',
 '## The Philosophy of Beginner Progressive Overload\n\nWhen starting resistance training, consistency and technique take precedence over extreme weight. This 4-week program builds foundational motor patterns.\n\n## Weekly Split Overview\n- **Monday:** Full Body A (Squat, Push-Up, Dumbbell Row)\n- **Wednesday:** Full Body B (Romanian Deadlift, Overhead Press, Lat Pulldown)\n- **Friday:** Full Body C (Lunge, Incline DB Press, Plank Hold)\n\n## Warm-up Protocol\nSpend 5-8 minutes performing dynamic mobility before lifting:\n- Arm circles and band pull-aparts\n- Bodyweight squats (15 reps)\n- World\'s Greatest Stretch (5 reps/side)\n\n## Progression Strategy\nAdd 1 rep or 1-2 kg to each exercise every session as long as form remains pristine.',
 'Workout Routines', 'Beginner', 6, 'Beginner', 'assets/images/content/strength-training.webp', 'APPROVED', NOW() - INTERVAL 12 DAY),

(1, 'Hypertrophy Muscle Building Masterclass: The Science of Growth',
 'Understand mechanical tension, muscle damage, and metabolic stress to construct science-backed training splits for maximum muscle gains.',
 '## The Three Pillars of Hypertrophy\n\nMuscular hypertrophy is driven by three distinct physiological stimuli:\n\n1. **Mechanical Tension:** Lifting moderately heavy loads (65-85% 1RM) through a full active range of motion under high control.\n2. **Metabolic Stress:** The accumulation of metabolites (lactate, hydrogen ions) through higher rep ranges (12-20 reps) with controlled rest intervals.\n3. **Muscle Fiber Recruitment:** Training within 1-3 reps in reserve (RIR) of technical failure.\n\n## Optimal Volume Guidelines\nTarget 10-20 hard sets per muscle group per week distributed across 2-3 sessions for maximal protein synthesis frequency.',
 'Workout Routines', 'Muscle Building', 7, 'Advanced', 'assets/images/content/strength-training.webp', 'APPROVED', NOW() - INTERVAL 11 DAY),

(1, 'Fat Loss Conditioning: Tabata & Metabolic Circuitry',
 'High-efficiency 20-minute metabolic conditioning circuits designed to maximize caloric expenditure and preserve lean muscle mass.',
 '## The Power of Metabolic Conditioning\n\nMetabolic circuits keep heart rates elevated in Zone 4-5 while taxing large muscle groups, sustaining elevated calorie burn for hours after the session.\n\n## The 20-Minute Protocol\n- **Interval Format:** 40 seconds work, 20 seconds rest.\n- **Station 1:** Kettlebell Goblet Squats\n- **Station 2:** Mountain Climbers to Push-Up\n- **Station 3:** Alternating Reverse Lunges\n- **Station 4:** Dumbbell Thrusters\n- **Station 5:** Plank Shoulder Taps\n\nRest 60 seconds between full rounds. Perform 3 complete cycles.',
 'Workout Routines', 'Fat Loss', 5, 'Intermediate', 'assets/images/content/cardio.webp', 'APPROVED', NOW() - INTERVAL 9 DAY),

(1, 'Zero-Equipment Home Workout Protocol',
 'Sculpt strength, core endurance, and agility anywhere with this calibrated bodyweight training routine requiring zero gym equipment.',
 '## Minimalist Calisthenics Routine\n\nNo gym? No problem. Using leverage and tempo changes, you can stimulate muscle adaptation anywhere.\n\n## The Home Calisthenics Routine (4 Rounds)\n- **Pike Push-Ups:** 10-12 reps (targets shoulders)\n- **Bulgarian Split Squats (couch elevated):** 12 reps each leg\n- **Doorframe or Towel Rows:** 15 reps (targets lats)\n- **Diamond Push-Ups:** 10-12 reps (targets triceps and inner chest)\n- **Hollow Body Holds:** 45 seconds (core stabilizer)',
 'Workout Routines', 'Home', 4, 'Beginner', 'assets/images/content/strength-training.webp', 'APPROVED', NOW() - INTERVAL 8 DAY),

-- Nutrition Guides
(1, 'The Complete Protein Playbook: Timing, Quality & Absorption',
 'Everything you need to know about leucine thresholds, essential amino acids, plant vs animal sources, and daily macro distribution.',
 '## Demystifying Protein Synthesis\n\nTo stimulate Muscle Protein Synthesis (MPS), your body needs a threshold amount of essential amino acids, particularly **Leucine** (~2.5g to 3g per meal).\n\n## Optimal Meal Distribution\nInstead of consuming 80% of your protein at dinner, distribute intake across 4-5 meals:\n- Breakfast: 30-40g protein\n- Lunch: 35-45g protein\n- Afternoon Snack: 25-30g protein\n- Dinner: 40-50g protein\n\n## Top High-Leucine Sources\n- Whey protein isolate\n- Chicken and turkey breast\n- Salmon, tuna, and white fish\n- Eggs and liquid egg whites\n- Tofu, tempeh, and pea-rice protein blends',
 'Nutrition & Diet', 'Protein', 6, 'Intermediate', 'assets/images/content/protein-meal-prep.webp', 'APPROVED', NOW() - INTERVAL 6 DAY),

(1, 'Complex Carbohydrates & Glycogen Timing for Peak Performance',
 'Harness the fueling power of complex carbohydrates and intra-workout carbs to sustain high training volume without fatigue.',
 '## The Role of Muscle Glycogen\n\nCarbohydrates are your muscles\' primary high-intensity fuel source. Depleted glycogen stores lead to premature fatigue, poor recovery, and sluggish lifts.\n\n## Pre-Workout Fueling (1-2 Hours Before)\nConsume 30-50g of easily digestible complex carbs with low fiber and moderate protein:\n- Rolled oats with sliced banana\n- Cream of rice with protein powder\n- Sourdough toast with almond butter\n\n## Post-Workout Replenishment\nWithin 2 hours post-workout, consume 40-60g of carbs to rapidly stimulate glycogen resynthesis and insulin-mediated nutrient uptake.',
 'Nutrition & Diet', 'Carbohydrates', 5, 'All Levels', 'assets/images/content/healthy-nutrition.webp', 'APPROVED', NOW() - INTERVAL 5 DAY),

(1, 'Essential Healthy Fats & Hormonal Health Guide',
 'Why eliminating dietary fats destroys testosterone and joint recovery, and how to source the best Omega-3 fatty acids.',
 '## Fats Are Essential for Endocrine Function\n\nDietary fats provide building blocks for testosterone, estrogen, and cell membranes. Dropping fat below 15-20% of total calories can severely impair hormone production.\n\n## The Healthy Fat Roster\n- **Monounsaturated Fats:** Extra virgin olive oil, avocados, almonds, cashews.\n- **Polyunsaturated (Omega-3 EPA/DHA):** Wild salmon, sardines, walnuts, chia seeds, flaxseeds.\n- **Target Ratio:** 0.8g to 1.2g of dietary fat per kg of body weight daily.',
 'Nutrition & Diet', 'Fats', 5, 'All Levels', 'assets/images/content/healthy-nutrition.webp', 'APPROVED', NOW() - INTERVAL 4 DAY),

(1, 'Sunday Meal Prep: The 90-Minute Batch Cooking Method',
 'Save hours during the workweek and never miss your fitness macros with this step-by-step batch cooking strategy.',
 '## Step-by-Step Batch Cooking Blueprint\n\nSpend 90 minutes on Sunday to prepare 10 balanced meals:\n\n1. **Sheet Pan Roasting (0-30 mins):** Roast 1.5kg chicken breast and 1kg broccoli/peppers on 2 baking sheets at 200°C.\n2. **Grain Boiling (15-40 mins):** Cook 500g quinoa or jasmine rice in a rice cooker.\n3. **Portion & Pack (45-60 mins):** Weigh portions with a digital scale into airtight glass containers.\n4. **Sauce Variety (60-75 mins):** Use distinct low-calorie seasonings (chimichurri, teriyaki, salsa) so every meal tastes fresh.',
 'Nutrition & Diet', 'Meal Prep', 6, 'All Levels', 'assets/images/content/protein-meal-prep.webp', 'APPROVED', NOW() - INTERVAL 3 DAY),

(1, 'Hydration & Electrolytes: The Unsung Performance Multiplier',
 'Even a 2% drop in hydration reduces strength by 10% and spikes perceived exertion. Master your daily hydration strategy.',
 '## The Impact of Dehydration on Athletic Performance\n\nWater regulates body temperature, joint lubrication, and cellular nutrient transport. When dehydrated, blood volume drops, straining cardiovascular output.\n\n## The Golden Hydration Rules\n- Drink 500ml water immediately upon waking to offset nocturnal dehydration.\n- Aim for 35-45ml water per kg of body weight daily.\n- Add a pinch of sodium, potassium, and magnesium to workout fluids for sessions over 45 minutes.',
 'Nutrition & Diet', 'Hydration', 4, 'All Levels', 'assets/images/content/healthy-nutrition.webp', 'APPROVED', NOW() - INTERVAL 2 DAY),

-- Recovery Guides
(1, 'The Science of Deep Sleep & Anabolic Recovery',
 'Optimize slow-wave and REM sleep cycles to trigger natural growth hormone release and central nervous system repair.',
 '## Sleep: The Most Anabolic Tool in Your Arsenal\n\nOver 80% of daily Human Growth Hormone (HGH) is secreted during deep slow-wave sleep (Stage 3 and 4 NREM).\n\n## 5 Sleep Optimization Protocols\n1. **Temperature:** Keep bedroom temperature between 18°C and 20°C (65-68°F).\n2. **Light Control:** Eliminate blue light screens 60 minutes before bed; use blackout curtains.\n3. **Caffeine Curfew:** Cease caffeine intake at least 8-10 hours prior to sleep.\n4. **Evening Magnesium:** Supplement 200-400mg Magnesium Glycinate 30 mins before sleep.\n5. **Consistent Circadian Rhythm:** Sleep and wake at the same time ±30 mins every day.',
 'Recovery & Wellness', 'Sleep', 6, 'All Levels', 'assets/images/content/recovery.webp', 'APPROVED', NOW() - INTERVAL 4 DAY),

(1, 'Active Recovery Days: What to Do on Rest Days',
 'Why sitting on the couch slows recovery, and how low-intensity cardio and mobility flush metabolic waste from sore muscles.',
 '## Active vs Passive Rest\n\nLight movement increases blood flow without creating additional muscle tissue micro-trauma, speeding up the clearance of metabolic waste and reducing Delayed Onset Muscle Soreness (DOMS).\n\n## Ideal Active Recovery Activities\n- **30-45 Minute Zone 2 Incline Walk:** Gentle aerobic stimulus that enhances capillary density.\n- **Swimming / Water Aerobics:** Non-impact joint decompression.\n- **Full Body Foam Rolling & Dynamic Stretching:** 15-20 minutes targeting calves, IT bands, glutes, and lats.',
 'Recovery & Wellness', 'Recovery', 5, 'All Levels', 'assets/images/content/recovery.webp', 'APPROVED', NOW() - INTERVAL 2 DAY),

-- Fitness Articles
(1, 'The Neuroscience of Habit Formation in Fitness',
 'How dopamine loops, trigger-action cues, and habit stacking transform grueling workout discipline into effortless daily routines.',
 '## How the Brain Automates Fitness Behaviors\n\nDiscipline is an exhaustible cognitive resource. Sustainable fitness relies on building automatic basal ganglia loops rather than relying on pure willpower.\n\n## The 3-Part Habit Loop\n1. **Cue:** Place your workout clothes and shoes next to your bed the night before.\n2. **Routine:** Start with just 5 minutes of stretching (make the barrier to entry microscopic).\n3. **Reward:** Track the workout streak in FitFlow and enjoy post-workout endorphins.\n\n## Habit Stacking Technique\nAttach your new fitness habit to an established ritual: \"After I pour my morning coffee, I will immediately complete my 10-minute mobility routine.\"',
 'Motivation', 'Science', 5, 'All Levels', 'assets/images/content/mental-fatigue.webp', 'APPROVED', NOW() - INTERVAL 1 DAY);
