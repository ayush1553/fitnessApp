package com.fitnesstracker.service.impl;

import com.fitnesstracker.exception.NutritionCalculationException;
import com.fitnesstracker.model.MealPlan;
import com.fitnesstracker.model.MealPlanItem;
import com.fitnesstracker.model.NutritionProfile;
import com.fitnesstracker.model.NutritionTarget;
import com.fitnesstracker.service.NutritionCalculator;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

public class StandardNutritionCalculator implements NutritionCalculator {

    @Override
    public double calculateBMR(NutritionProfile profile) {
        if (profile == null) {
            throw new NutritionCalculationException("Profile cannot be null");
        }
        double weight = profile.getWeightKg();
        double height = profile.getHeightCm();
        int age = profile.getAge();
        String sex = profile.getSex() != null ? profile.getSex().trim() : "Male";

        if (weight <= 0 || height <= 0 || age <= 0) {
            throw new NutritionCalculationException("Invalid physical metrics for BMR calculation");
        }

        // Mifflin-St Jeor Formula
        if ("Female".equalsIgnoreCase(sex)) {
            return (10.0 * weight) + (6.25 * height) - (5.0 * age) - 161.0;
        } else {
            return (10.0 * weight) + (6.25 * height) - (5.0 * age) + 5.0;
        }
    }

    @Override
    public double calculateTDEE(NutritionProfile profile) {
        double bmr = calculateBMR(profile);
        String activity = profile.getActivityLevel() != null ? profile.getActivityLevel().toLowerCase(Locale.ROOT) : "moderately active";

        double multiplier;
        if (activity.contains("sedentary")) {
            multiplier = 1.2;
        } else if (activity.contains("light")) {
            multiplier = 1.375;
        } else if (activity.contains("moderate")) {
            multiplier = 1.55;
        } else if (activity.contains("very active")) {
            multiplier = 1.725;
        } else if (activity.contains("extreme")) {
            multiplier = 1.9;
        } else {
            multiplier = 1.55;
        }

        return bmr * multiplier;
    }

    @Override
    public NutritionTarget calculateTarget(NutritionProfile profile) {
        double tdee = calculateTDEE(profile);
        String goal = profile.getFitnessGoal() != null ? profile.getFitnessGoal().toLowerCase(Locale.ROOT) : "maintenance";

        int targetCalories;
        int proteinPct;
        int carbsPct;
        int fatPct;

        if (goal.contains("cutting") || goal.contains("loss")) {
            targetCalories = (int) Math.round(tdee - 500.0);
            if (targetCalories < 1200) targetCalories = 1200; // safe baseline
            proteinPct = 35;
            carbsPct = 40;
            fatPct = 25;
        } else if (goal.contains("bulking") || goal.contains("gain")) {
            targetCalories = (int) Math.round(tdee + 400.0);
            proteinPct = 25;
            carbsPct = 55;
            fatPct = 20;
        } else {
            // Maintenance
            targetCalories = (int) Math.round(tdee);
            proteinPct = 30;
            carbsPct = 45;
            fatPct = 25;
        }

        int proteinCalories = (int) Math.round(targetCalories * (proteinPct / 100.0));
        int carbsCalories = (int) Math.round(targetCalories * (carbsPct / 100.0));
        int fatCalories = (int) Math.round(targetCalories * (fatPct / 100.0));

        int targetProteinG = proteinCalories / 4;
        int targetCarbsG = carbsCalories / 4;
        int targetFatG = fatCalories / 9;

        // Water recommendation: 35ml per kg + activity bonus
        double baseWater = (profile.getWeightKg() * 0.035);
        if (profile.getActivityLevel() != null && (profile.getActivityLevel().toLowerCase().contains("very") || profile.getActivityLevel().toLowerCase().contains("extreme"))) {
            baseWater += 0.8;
        } else if (profile.getActivityLevel() != null && profile.getActivityLevel().toLowerCase().contains("moderate")) {
            baseWater += 0.5;
        }
        double waterTargetL = Math.round(Math.max(2.0, baseWater) * 10.0) / 10.0;

        NutritionTarget target = new NutritionTarget();
        target.setUserId(profile.getUserId());
        target.setProfileId(profile.getId());
        target.setTargetCalories(targetCalories);
        target.setTargetProteinG(targetProteinG);
        target.setTargetCarbsG(targetCarbsG);
        target.setTargetFatG(targetFatG);
        target.setProteinPct(proteinPct);
        target.setCarbsPct(carbsPct);
        target.setFatPct(fatPct);
        target.setWaterTargetL(waterTargetL);
        target.setCalculatedAt(new Timestamp(System.currentTimeMillis()));

        return target;
    }

    @Override
    public MealPlan generateMealPlan(NutritionProfile profile, NutritionTarget target) {
        MealPlan plan = new MealPlan();
        plan.setUserId(profile.getUserId());
        plan.setProfileId(profile.getId());
        plan.setPlanName(profile.getFitnessGoal() + " Personalized Plan (" + profile.getDietPreference() + ")");
        plan.setTotalCalories(target.getTargetCalories());
        plan.setTotalProteinG(target.getTargetProteinG());
        plan.setTotalCarbsG(target.getTargetCarbsG());
        plan.setTotalFatG(target.getTargetFatG());
        plan.setActive(true);

        int mealsCount = profile.getMealsPerDay() > 0 ? profile.getMealsPerDay() : 4;
        String diet = profile.getDietPreference() != null ? profile.getDietPreference().toLowerCase(Locale.ROOT) : "non-vegetarian";
        String exclusions = profile.getFoodExclusions() != null ? profile.getFoodExclusions().toLowerCase(Locale.ROOT) : "";

        List<MealPlanItem> items = new ArrayList<>();

        // Calorie distribution ratios based on meal count
        double[] ratios;
        String[] names;
        if (mealsCount == 3) {
            ratios = new double[]{0.30, 0.40, 0.30};
            names = new String[]{"Breakfast", "Lunch", "Dinner"};
        } else if (mealsCount == 5) {
            ratios = new double[]{0.25, 0.10, 0.35, 0.10, 0.20};
            names = new String[]{"Breakfast", "Morning Snack", "Lunch", "Evening Snack", "Dinner"};
        } else if (mealsCount == 6) {
            ratios = new double[]{0.20, 0.10, 0.30, 0.10, 0.20, 0.10};
            names = new String[]{"Breakfast", "Morning Snack", "Lunch", "Pre-Workout / Afternoon", "Dinner", "Night Snack"};
        } else { // 4 meals
            ratios = new double[]{0.25, 0.35, 0.15, 0.25};
            names = new String[]{"Breakfast", "Lunch", "Evening Snack", "Dinner"};
        }

        for (int i = 0; i < mealsCount; i++) {
            MealPlanItem item = new MealPlanItem();
            item.setMealNumber(i + 1);
            item.setMealName(names[i]);

            int mealCal = (int) Math.round(target.getTargetCalories() * ratios[i]);
            int mealPro = (int) Math.round(target.getTargetProteinG() * ratios[i]);
            int mealCarb = (int) Math.round(target.getTargetCarbsG() * ratios[i]);
            int mealFat = (int) Math.round(target.getTargetFatG() * ratios[i]);

            item.setCalories(mealCal);
            item.setProteinG(mealPro);
            item.setCarbsG(mealCarb);
            item.setFatG(mealFat);

            // Generate foods string according to diet preference and exclusions
            item.setFoodItems(buildFoodSelection(names[i], diet, exclusions, mealCal, mealPro));
            item.setNotes("Target: ~" + mealCal + " kcal, " + mealPro + "g Protein");

            items.add(item);
        }

        plan.setItems(items);
        return plan;
    }

    private String buildFoodSelection(String mealType, String diet, String exclusions, int cal, int pro) {
        boolean isVegan = diet.contains("vegan");
        boolean isVeg = diet.contains("vegetarian") && !diet.contains("non");
        boolean isEgg = diet.contains("eggetarian");
        boolean noDairy = exclusions.contains("dairy") || exclusions.contains("milk");
        boolean noPeanuts = exclusions.contains("peanut") || exclusions.contains("nuts");
        boolean noFish = exclusions.contains("fish") || exclusions.contains("seafood");
        boolean noEggs = exclusions.contains("egg") || isVegan || isVeg;

        String m = mealType.toLowerCase(Locale.ROOT);
        if (m.contains("breakfast")) {
            if (isVegan) {
                return "Rolled oats (80g) cooked with almond milk, chia seeds (15g), 1 sliced banana, pea protein scoop, and mixed berries.";
            } else if (isVeg) {
                if (noDairy) {
                    return "Sprouted moong dal chilla / savory lentil pancakes with mint chutney, avocado slices, and fresh pomegranate.";
                }
                return "Oatmeal with skimmed milk, scoop of whey isolate, 1 tbsp pumpkin seeds, 1 sliced apple, and cinnamon.";
            } else if (isEgg || !noEggs) {
                return "3 whole egg & 2 egg white omelette with spinach & mushrooms, 2 slices whole wheat multigrain toast, and 1 orange.";
            } else {
                return "Scrambled eggs with smoked turkey strips, sauteed spinach, whole wheat toast, and half an avocado.";
            }
        } else if (m.contains("lunch")) {
            if (isVegan) {
                return "Grilled tofu steak (180g), 1.5 cups quinoa, steamed broccoli & bell peppers with sesame olive oil dressing.";
            } else if (isVeg) {
                if (noDairy) {
                    return "Tempeh & chickpea stir-fry with zucchini and sweet potato cubes, brown rice (1 cup), and mixed green salad.";
                }
                return "Low-fat Paneer tikka (150g), 1 cup brown rice, bowl of yellow dal tadka, cucumber salad with lemon dressing.";
            } else if (isEgg) {
                return "Egg bhurji (4 eggs) with bell peppers, 2 whole wheat rotis, bowl of rajma (kidney beans), and fresh green salad.";
            } else {
                if (noFish) {
                    return "Grilled chicken breast (200g), roasted sweet potato cubes (150g), steamed asparagus & broccoli with garlic olive oil.";
                }
                return "Baked wild salmon fillet (180g) or grilled chicken breast, 1 cup quinoa, steamed broccoli florets and avocado slices.";
            }
        } else if (m.contains("snack") || m.contains("pre-workout") || m.contains("afternoon")) {
            if (isVegan) {
                return (noPeanuts ? "Roasted chickpeas (50g) and an apple with sunflower seed butter." : "Roasted almonds & walnuts (30g) with 1 banana and plant-based protein shake.");
            } else if (isVeg) {
                if (noDairy) {
                    return (noPeanuts ? "Sunflower seeds (30g) with mixed berries and rice cakes." : "Roasted almonds (25g), 2 rice cakes with peanut butter, and green tea.");
                }
                return "Greek yogurt (200g) topped with blueberries, chia seeds, and 1 tsp honey.";
            } else if (isEgg) {
                return "2 boiled eggs with salt & pepper, 1 whole wheat toast, and green tea.";
            } else {
                return "Greek yogurt with whey protein blend, handful of mixed walnuts, and fresh strawberries.";
            }
        } else if (m.contains("dinner")) {
            if (isVegan) {
                return "Lentil & bean stew with nutritional yeast, 1 cup wild rice, sauteed kale with garlic and olive oil.";
            } else if (isVeg) {
                if (noDairy) {
                    return "Soya chunk curry (70g dry soya) with turmeric brown rice and roasted cauliflower florets.";
                }
                return "Cottage cheese (paneer 150g) and mixed vegetable stir-fry, 2 multigrain rotis, and bowl of spinach soup.";
            } else if (isEgg) {
                return "Boiled egg curry (3 eggs) with light tomato-onion gravy, steamed basmati rice (1 cup), and cucumber tomato salad.";
            } else {
                return "Herb grilled chicken breast or white fish fillet (180g), large mixed green salad with olive oil vinaigrette, and baked baby potatoes.";
            }
        } else {
            // Night snack / other
            if (isVegan || noDairy) {
                return "Chamomile herbal tea with 15g roasted pumpkin seeds and 5 almonds.";
            }
            return "Warm skimmed milk or casein protein pudding with a pinch of nutmeg.";
        }
    }
}
