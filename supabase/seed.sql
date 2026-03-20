-- ============================================================
-- The Kitchen — Supabase schema + seed data
-- Run this in the Supabase SQL editor
-- ============================================================

-- 1. Create the recipes table
create table if not exists public.recipes (
  id            bigint generated always as identity primary key,
  created_at    timestamptz default now() not null,
  name          text not null,
  category      text,
  author        text,
  tags          text[]   default '{}',
  servings      int      default 4,
  ing_groups    jsonb    default '[]',
  steps         jsonb    default '[]',
  notes         text     default '',
  photo_url     text,
  photo_path    text,
  want_try      boolean  default false
);

-- 2. Disable RLS (single-user app, passphrase gated)
alter table public.recipes disable row level security;

-- 3. Seed the 35 recipes
-- (safe to re-run — only inserts if table is empty)
do $$ begin
  if (select count(*) from public.recipes) = 0 then

    insert into public.recipes (name, category, author, tags, servings, ing_groups, steps, notes)
    values (
      'Levain Bread',
      'Bread',
      'Peter Olsson',
      '{"sourdough","advanced"}',
      1,
      '[{"label": "Pre-dough (evening before)", "items": [{"amt": "50-100g", "item": "sourdough base"}, {"amt": "150g", "item": "wheat flour"}, {"amt": "150g", "item": "water"}]}, {"label": "Main dough", "items": [{"amt": "600g", "item": "water"}, {"amt": "200g", "item": "rågsikt"}, {"amt": "650g", "item": "vetemjöl special"}, {"amt": "300g", "item": "pre-dough"}, {"amt": "25g", "item": "salt"}, {"amt": "a little", "item": "rapeseed oil"}]}]'::jsonb,
      '[{"text": "Pre-dough (evening, ~10 hrs before baking): Mix 50-100g sourdough base, 150g wheat flour, 150g water. Let stand above the fridge for 6-9 hours overnight until bubbly. Keep remaining base in fridge for next time.", "subs": []}, {"text": "Main dough (next morning): Mix 600g water, 200g rågsikt, 650g vetemjöl special, and 300g pre-dough until smooth. Err toward more water — a wetter dough is better.", "subs": []}, {"text": "Let sit 40-45 minutes under a cloth.", "subs": []}, {"text": "Add 25g salt and fold dough several times immediately to incorporate. Rest 30 minutes. Add salt bit by bit as you fold for even distribution.", "subs": []}, {"text": "Fold dough again and rest 60 minutes.", "subs": []}, {"text": "Flour a surface. Fold dough into a rectangle: fold in the sides, up-to-down, down-to-up, side-to-side. Oil the container bottom, return the dough. Rise at room temp 3-5 hours until roughly doubled, OR refrigerate overnight.", "subs": []}, {"text": "Preparing for the oven: fold long edges in without overlapping. Sprinkle with flour, place on a floured cloth, cover. Let rise 1 hour (a bit longer if it came from the fridge). Flip onto baking paper.", "subs": []}, {"text": "Preheat oven to 270°C with the baking plate inside and an empty metal container on the bottom rack.", "subs": []}, {"text": "Transfer dough on baking paper to the hot plate. Add 3-4 ice cubes to the bottom container and close oven immediately. Turn heat down to 250°C.", "subs": []}, {"text": "Bake 35-40 minutes. Keep at 250°C for 25 minutes, then lower to 225°C. Do not fear colour — getting heat to the middle matters most.", "subs": []}]'::jsonb,
      'Go for a wetter dough — it should barely hold its shape. Do not use glass containers for the ice steam tray.'
    );

    insert into public.recipes (name, category, author, tags, servings, ing_groups, steps, notes)
    values (
      'Bagels',
      'Bread',
      'King Arthur',
      '{"baking","yeast","boiled"}',
      8,
      '[{"label": "Dough", "items": [{"amt": "1 tbsp (9g)", "item": "instant yeast"}, {"amt": "480g", "item": "King Arthur bread flour"}, {"amt": "2 tsp (12g)", "item": "table salt"}, {"amt": "1 tbsp", "item": "non-diastatic malt powder or dark brown sugar"}, {"amt": "1⅓ cups (303g)", "item": "lukewarm water"}]}, {"label": "Water bath", "items": [{"amt": "2 quarts (1814g)", "item": "water"}, {"amt": "2 tbsp", "item": "non-diastatic malt powder or dark brown sugar"}, {"amt": "1 tbsp", "item": "granulated sugar"}]}, {"label": "Optional toppings", "items": [{"amt": "1", "item": "egg + 1 tbsp water (egg wash)"}, {"amt": "to taste", "item": "sesame seeds, poppy seeds, everything seasoning"}]}]'::jsonb,
      '[{"text": "Knead all dough ingredients vigorously 10 minutes (mixer) or up to 15 minutes (by hand). Dough should thwap the bowl sides and hold its shape without spreading.", "subs": ["Use the dough hook rather than the roller attachment", "Dough is ready when it holds its shape without spreading when you stop the mixer"]}, {"text": "Place in a lightly greased bowl, cover, and rise until noticeably puffy — not necessarily doubled — 1 to 1½ hours.", "subs": []}, {"text": "Divide into 8 pieces (large) or 12 (standard). Roll each into a smooth ball. Cover and rest 30 minutes. Can refrigerate at this point and warm up 30 minutes in the morning.", "subs": []}, {"text": "Prepare water bath: bring water, malt powder, and sugar to a gentle boil. Preheat oven to 220°C.", "subs": []}, {"text": "Poke a hole through the center of each ball and twirl on your finger to stretch to 1½-2 inches diameter.", "subs": []}, {"text": "Boil bagels 4 at a time: 2 minutes, flip, 1 minute more. Remove with a skimmer and return to baking sheet.", "subs": []}, {"text": "Optional: brush with egg wash and add toppings.", "subs": []}, {"text": "Bake 20-25 minutes until deep brown, flipping at the 15-minute mark. Cool completely on a rack.", "subs": []}]'::jsonb,
      'For cinnamon-raisin: knead in 2/3 cup raisins at the end and roll in cinnamon-sugar. For onion-topped: add dried minced onion in the last 2 minutes only — they burn quickly.'
    );

    insert into public.recipes (name, category, author, tags, servings, ing_groups, steps, notes)
    values (
      'Pretzels',
      'Bread',
      'King Arthur',
      '{"baking","snack","boiled"}',
      6,
      '[{"label": "Dough", "items": [{"amt": "298g", "item": "flour"}, {"amt": "6g", "item": "salt"}, {"amt": "1 tsp", "item": "sugar"}, {"amt": "7g", "item": "instant yeast"}, {"amt": "198-227g", "item": "warm water"}]}, {"label": "Topping bath", "items": [{"amt": "227g", "item": "boiling water"}, {"amt": "28g", "item": "baking soda"}]}, {"label": "Finishing", "items": [{"amt": "85g", "item": "unsalted butter, melted"}, {"amt": "to taste", "item": "coarse, kosher, or pretzel salt — or pearl sugar for sweet"}]}]'::jsonb,
      '[{"text": "Combine all dough ingredients and beat until well-combined. Knead by hand or machine ~5 minutes until soft, smooth, and quite slack. Flour the dough, place in a bag, rest 30 minutes.", "subs": []}, {"text": "Combine boiling water and baking soda, stirring until dissolved. Set aside to cool to lukewarm.", "subs": []}, {"text": "Preheat oven to 205°C. Prepare a greased or parchment-lined baking sheet.", "subs": []}, {"text": "Divide dough into six pieces. Roll each into a 12-15 inch rope. Cut each rope crosswise into about 12 pieces.", "subs": []}, {"text": "Dip bites in the baking soda solution, swish gently, leave a couple of minutes. Transfer to baking sheet and top with salt or pearl sugar.", "subs": []}, {"text": "Bake 12-15 minutes until golden brown. Remove and roll in melted butter — pour butter into a bowl with the bites a little at a time.", "subs": ["For cinnamon-sugar pretzels: toss with cinnamon-sugar after buttering", "Store well-wrapped at room temperature and reheat briefly before serving"]}]'::jsonb,
      ''
    );

    insert into public.recipes (name, category, author, tags, servings, ing_groups, steps, notes)
    values (
      'Pizza Dough',
      'Bread',
      'Wolfgang Puck',
      '{"pizza","yeast"}',
      4,
      '[{"label": "", "items": [{"amt": "1 package", "item": "active dry yeast"}, {"amt": "1 tsp", "item": "honey"}, {"amt": "1 cup", "item": "warm water"}, {"amt": "1 tsp", "item": "kosher salt"}, {"amt": "5 tbsp", "item": "extra-virgin olive oil, divided"}, {"amt": "2¾ cups", "item": "all-purpose flour, or more as needed"}, {"amt": "¼ cup", "item": "cornmeal"}]}]'::jsonb,
      '[{"text": "Combine yeast, honey, and ¼ cup warm water. Let stand to dissolve, about 10 minutes.", "subs": []}, {"text": "Add salt, 1 tbsp olive oil, remaining ¾ cup warm water, and flour in batches — 1 cup, then 1 cup, then ½ cup — stirring between additions.", "subs": []}, {"text": "Turn dough onto a floured surface and knead until smooth, fairly firm, and slightly sticky. Add flour as needed.", "subs": []}, {"text": "Transfer to a lightly oiled bowl, cover with a damp towel. Rise in a warm place until doubled, 30-40 minutes.", "subs": []}, {"text": "Divide into 4 equal pieces. Stretch and fold each piece down and under to form rounds. Cover and rise until doubled, 20-30 minutes.", "subs": []}, {"text": "Preheat oven to 450°F (230°C). Dust a baking sheet with cornmeal.", "subs": []}, {"text": "Press each round out to 8-10 inches, forming a crust edge with your fingertips. Brush with 1 tbsp olive oil, add sauce and toppings.", "subs": []}, {"text": "Bake on the lower rack 5 minutes. Move to center and bake until golden, about 10 more minutes.", "subs": []}]'::jsonb,
      'Makes 4 pizza rounds.'
    );

    insert into public.recipes (name, category, author, tags, servings, ing_groups, steps, notes)
    values (
      'Brioche Buns',
      'Bread',
      'Mike & Laura',
      '{"baking","buns","yeast"}',
      8,
      '[{"label": "Sponge", "items": [{"amt": "1 package (2½ tsp)", "item": "dry active yeast"}, {"amt": "½ cup", "item": "flour"}, {"amt": "1 cup", "item": "very warm water"}]}, {"label": "Dough", "items": [{"amt": "1 large", "item": "egg"}, {"amt": "3 tbsp", "item": "melted butter"}, {"amt": "3 tbsp", "item": "sugar"}, {"amt": "1¼ tsp", "item": "salt"}, {"amt": "3 cups", "item": "flour"}]}, {"label": "Glaze", "items": [{"amt": "1", "item": "egg"}, {"amt": "1 tbsp", "item": "milk"}]}]'::jsonb,
      '[{"text": "Whisk yeast, ½ cup flour, and 1 cup very warm water. Let sit 15 minutes until foamy like a beer head.", "subs": []}, {"text": "Add egg, melted butter, sugar, and salt. Whisk to combine.", "subs": []}, {"text": "Add 3 cups flour and knead 5 minutes — dough should not stick to fingers. Add more flour if needed. Knead another 5 minutes.", "subs": []}, {"text": "Form into a ball. Let rise 2 hours in an oiled bowl.", "subs": []}, {"text": "Knock out air, flatten to a rectangle. Cut and form 8 flat rolls. Dust with flour, place on baking sheet, rise 1 hour.", "subs": []}, {"text": "Glaze with egg + milk mixture.", "subs": []}, {"text": "Bake at 190°C for 15 minutes, rotating at the 10-minute mark.", "subs": []}]'::jsonb,
      ''
    );

    insert into public.recipes (name, category, author, tags, servings, ing_groups, steps, notes)
    values (
      'Khachapuri',
      'Bread',
      'Mike & Laura',
      '{"georgian","cheese","baking"}',
      4,
      '[{"label": "Dough", "items": [{"amt": "½ cup", "item": "warm milk"}, {"amt": "⅓ cup", "item": "warm water"}, {"amt": "2 tsp", "item": "dry active yeast"}, {"amt": "1½ tsp", "item": "sugar"}, {"amt": "2 tsp", "item": "olive oil"}, {"amt": "2 cups + ¼-½ cup extra", "item": "all-purpose flour"}, {"amt": "1½ tsp", "item": "kosher salt"}]}, {"label": "Cheese blend", "items": [{"amt": "4 oz", "item": "mozzarella"}, {"amt": "4 oz", "item": "Monterey Jack cheese"}, {"amt": "8 oz", "item": "feta cheese"}]}, {"label": "Topping", "items": [{"amt": "1 tbsp", "item": "butter, cut in 4 slices"}, {"amt": "2 large", "item": "eggs"}, {"amt": "to taste", "item": "sea salt and optional cayenne"}]}]'::jsonb,
      '[{"text": "Make dough: combine milk, water, yeast, sugar, oil, flour, and salt. Knead until smooth. Let rise until doubled.", "subs": []}, {"text": "Grate and crumble cheeses together into the blend.", "subs": []}, {"text": "Divide dough and shape into oval boats. Fill generously with cheese blend. Fold and crimp the pointed ends to seal.", "subs": []}, {"text": "Bake at 475°F (245°C) for 15 minutes until golden.", "subs": []}, {"text": "Remove from oven. Make a well in the center of the melted cheese. Add a pat of butter and crack one egg into each boat.", "subs": []}, {"text": "Return to oven 3-4 minutes until egg is almost but not quite set. You mix the egg into the cheese at the table.", "subs": []}]'::jsonb,
      'See: https://www.youtube.com/watch?v=q5foZ80AENM'
    );

    insert into public.recipes (name, category, author, tags, servings, ing_groups, steps, notes)
    values (
      'Soft Boiled Eggs',
      'Other',
      'Mike & Laura',
      '{"quick","eggs","basics"}',
      2,
      '[{"label": "", "items": [{"amt": "as needed", "item": "eggs"}, {"amt": "a pinch", "item": "salt"}, {"amt": "a splash", "item": "white vinegar"}, {"amt": "as needed", "item": "water"}]}]'::jsonb,
      '[{"text": "Bring water with a pinch of salt and a splash of vinegar to a full boil.", "subs": []}, {"text": "Carefully add eggs. Cook for exactly 7 minutes.", "subs": []}, {"text": "Remove and place in a bowl of cold water in the fridge to stop cooking.", "subs": []}]'::jsonb,
      'The vinegar helps prevent cracking and makes peeling easier.'
    );

    insert into public.recipes (name, category, author, tags, servings, ing_groups, steps, notes)
    values (
      'Guacamole',
      'Mexican',
      'Mike & Laura',
      '{"dip","avocado","quick"}',
      4,
      '[{"label": "", "items": [{"amt": "3", "item": "avocados, peeled, pitted, and mashed"}, {"amt": "1", "item": "lime, juiced"}, {"amt": "1 tsp", "item": "salt"}, {"amt": "½ cup", "item": "red onion, diced"}, {"amt": "3 tbsp", "item": "fresh cilantro, chopped"}, {"amt": "2", "item": "roma tomatoes, diced"}, {"amt": "1 tsp", "item": "garlic, minced"}, {"amt": "1 tsp", "item": "ground cayenne pepper"}, {"amt": "1", "item": "chili, chopped"}, {"amt": "to taste", "item": "Tabasco, black pepper, and salt"}]}]'::jsonb,
      '[{"text": "Combine all ingredients in a bowl.", "subs": []}, {"text": "Mash and mix to desired consistency.", "subs": []}, {"text": "Taste and adjust salt, pepper, Tabasco, and lime.", "subs": []}]'::jsonb,
      'The cayenne is optional, but not optional.'
    );

    insert into public.recipes (name, category, author, tags, servings, ing_groups, steps, notes)
    values (
      'Fried Black Beans',
      'Mexican',
      'Mike & Laura',
      '{"side dish","vegetarian","quick"}',
      4,
      '[{"label": "", "items": [{"amt": "1", "item": "red onion, diced"}, {"amt": "to coat", "item": "olive oil"}, {"amt": "1 can", "item": "black beans"}, {"amt": "to taste", "item": "salt, black pepper, cumin"}, {"amt": "as needed", "item": "water"}]}]'::jsonb,
      '[{"text": "Sauté red onion in olive oil until soft and glassy.", "subs": []}, {"text": "Add black beans, salt, pepper, and cumin.", "subs": []}, {"text": "Add water as needed to prevent sticking. Reduce and cook down into a soft, thick consistency.", "subs": []}]'::jsonb,
      ''
    );

    insert into public.recipes (name, category, author, tags, servings, ing_groups, steps, notes)
    values (
      'Baja Fish Tacos',
      'Mexican',
      'Food Network',
      '{"fish","tacos","summer"}',
      4,
      '[{"label": "Fish & dredge", "items": [{"amt": "1¼ lbs", "item": "skinless halibut fillet, cut into 2×½-inch pieces"}, {"amt": "¾ cup", "item": "all-purpose flour"}, {"amt": "½ tsp", "item": "chili powder"}, {"amt": "to taste", "item": "kosher salt and black pepper"}, {"amt": "for frying", "item": "vegetable oil"}]}, {"label": "Red cabbage slaw", "items": [{"amt": "¼ head", "item": "red cabbage, thinly sliced"}, {"amt": "½ cup", "item": "fresh cilantro, roughly chopped"}, {"amt": "1", "item": "lime, juiced"}, {"amt": "2 tbsp", "item": "honey or agave nectar"}, {"amt": "½ cup", "item": "mayonnaise"}]}, {"label": "To assemble", "items": [{"amt": "12", "item": "corn tortillas"}, {"amt": "1", "item": "Hass avocado, sliced"}, {"amt": "½ cup", "item": "fresh salsa or mango habanero salsa"}, {"amt": "to serve", "item": "lime wedges"}]}]'::jsonb,
      '[{"text": "Heat about 3 inches vegetable oil in a medium pot to 375°F (190°C).", "subs": []}, {"text": "Make slaw: toss cabbage, cilantro, lime juice, honey, and mayo. Season with salt. Can add chopped chilis.", "subs": []}, {"text": "Warm tortillas in a skillet or wrapped in a damp cloth in the microwave. Keep wrapped to stay warm.", "subs": []}, {"text": "Mix flour, chili powder, salt, and pepper. Add beer to the batter for extra flavour. Dredge fish in the flour mixture.", "subs": []}, {"text": "Fry fish in batches until golden and just cooked through, 2-3 minutes. Drain on paper towel, season with salt.", "subs": []}, {"text": "Fill tortillas with fish, avocado, slaw, and salsa. Serve with lime wedges.", "subs": []}]'::jsonb,
      'Add beer to the batter. Use mango salsa and chopped red chili in the slaw for the best version.'
    );

    insert into public.recipes (name, category, author, tags, servings, ing_groups, steps, notes)
    values (
      'Taco Sauce',
      'Sauce & Dip',
      'Mike & Laura',
      '{"sauce","quick","Mexican"}',
      4,
      '[{"label": "", "items": [{"amt": "½ cup", "item": "sour cream"}, {"amt": "⅓ cup", "item": "mayonnaise"}, {"amt": "2 tbsp", "item": "lime juice"}, {"amt": "1 tsp", "item": "garlic powder"}, {"amt": "1 tsp", "item": "Sriracha, or to taste"}]}]'::jsonb,
      '[{"text": "Combine all ingredients in a bowl.", "subs": []}, {"text": "Whisk until well blended.", "subs": []}, {"text": "Serve in a squeeze bottle.", "subs": []}]'::jsonb,
      ''
    );

    insert into public.recipes (name, category, author, tags, servings, ing_groups, steps, notes)
    values (
      'Blackened Salmon Tacos',
      'Mexican',
      'Mike & Laura',
      '{"fish","tacos","mango"}',
      3,
      '[{"label": "Salmon", "items": [{"amt": "2", "item": "skin-on salmon fillets"}, {"amt": "1 tbsp", "item": "sweet and spicy seafood rub"}, {"amt": "½ tsp", "item": "chili powder"}, {"amt": "to taste", "item": "salt and black pepper"}, {"amt": "2 tbsp", "item": "olive oil"}]}, {"label": "Mango salsa", "items": [{"amt": "3", "item": "ripe mangoes, diced"}, {"amt": "1", "item": "avocado, diced"}, {"amt": "1", "item": "orange bell pepper, diced"}, {"amt": "1", "item": "jalapeño, seeded and diced"}, {"amt": "1", "item": "lime, juiced"}, {"amt": "2 tbsp", "item": "fresh cilantro, chopped"}, {"amt": "1 pinch", "item": "salt"}]}, {"label": "To assemble", "items": [{"amt": "6", "item": "corn tortillas"}, {"amt": "3 large", "item": "limes, cut into wedges"}]}]'::jsonb,
      '[{"text": "Make salsa: combine all salsa ingredients. Cover and refrigerate.", "subs": []}, {"text": "Rub seasoning over one side of each salmon fillet.", "subs": []}, {"text": "Heat oiled skillet over medium-high. Cook salmon skin-side down 4-5 minutes until skin is crisp. Flip, peel off skin, season top, cook 4-5 more minutes until flaky.", "subs": []}, {"text": "Slice each fillet lengthwise into 3 pieces.", "subs": []}, {"text": "Pan-fry tortillas in a lightly oiled skillet ~30 seconds per side until pliable.", "subs": []}, {"text": "Assemble: one piece of salmon per tortilla, top with salsa and a squeeze of lime.", "subs": []}]'::jsonb,
      'Can substitute a red bell pepper for the orange one.'
    );

    insert into public.recipes (name, category, author, tags, servings, ing_groups, steps, notes)
    values (
      'Mango Salsa',
      'Sauce & Dip',
      'Mike & Laura',
      '{"salsa","mango","spicy"}',
      6,
      '[{"label": "", "items": [{"amt": "3", "item": "ripe mangoes, diced"}, {"amt": "1", "item": "avocado, diced"}, {"amt": "1", "item": "orange bell pepper, diced"}, {"amt": "1", "item": "jalapeño, seeded and diced"}, {"amt": "2", "item": "habaneros, diced, or to taste"}, {"amt": "1", "item": "lime, juiced"}, {"amt": "2 tbsp", "item": "fresh cilantro, chopped"}, {"amt": "1 pinch", "item": "salt"}]}]'::jsonb,
      '[{"text": "Combine all ingredients in a large bowl.", "subs": []}, {"text": "Mix. Cover and refrigerate — ideally overnight.", "subs": []}]'::jsonb,
      'Sitting overnight improves the flavour and takes some kick out of the habanero.'
    );

    insert into public.recipes (name, category, author, tags, servings, ing_groups, steps, notes)
    values (
      'Green Salsa',
      'Sauce & Dip',
      'Mike & Laura',
      '{"salsa","avocado","fresh"}',
      4,
      '[{"label": "", "items": [{"amt": "1 small", "item": "cucumber"}, {"amt": "2", "item": "avocados"}, {"amt": "1", "item": "jalapeño"}, {"amt": "4", "item": "green onions (scallions)"}, {"amt": "1", "item": "lime, zested"}, {"amt": "2", "item": "limes, juiced (fresh squeezed)"}, {"amt": "1 tsp", "item": "salt"}, {"amt": "2 tbsp", "item": "olive oil"}, {"amt": "2 tbsp", "item": "fresh cilantro, chopped"}]}]'::jsonb,
      '[{"text": "Combine all ingredients. Mix well. Cover and store in the fridge.", "subs": []}]'::jsonb,
      ''
    );

    insert into public.recipes (name, category, author, tags, servings, ing_groups, steps, notes)
    values (
      'Panko Halloumi Tacos',
      'Mexican',
      'Mike & Laura',
      '{"vegetarian","halloumi","tacos"}',
      4,
      '[{"label": "Halloumi", "items": [{"amt": "as needed", "item": "halloumi, cut into ½ cm slices"}, {"amt": "as needed", "item": "all-purpose flour"}, {"amt": "as needed", "item": "eggs, whisked"}, {"amt": "as needed", "item": "panko breadcrumbs"}, {"amt": "for frying", "item": "vegetable oil (175°C / 350°F)"}]}, {"label": "To assemble", "items": [{"amt": "to serve", "item": "mango or green salsa"}, {"amt": "to serve", "item": "sour cream"}, {"amt": "to serve", "item": "Sriracha"}, {"amt": "to serve", "item": "tortillas"}]}]'::jsonb,
      '[{"text": "Cut halloumi into ½ cm slices. Dab dry with a paper towel.", "subs": []}, {"text": "Dredge each slice: flour → whisked egg (really slather it on — egg can be reluctant to adhere) → panko.", "subs": []}, {"text": "Let sit on a metal mesh cooling rack to dry slightly.", "subs": []}, {"text": "Fry at 175°C (350°F) until the bottom is golden, then flip and finish the tops.", "subs": []}, {"text": "Cool on a rack over paper towels.", "subs": []}, {"text": "Assemble on warmed tortillas with salsa, sour cream, and Sriracha.", "subs": ["Heat tortillas in the oven before serving", "Sourdough discard tortillas are excellent here"]}]'::jsonb,
      ''
    );

    insert into public.recipes (name, category, author, tags, servings, ing_groups, steps, notes)
    values (
      'Buffalo Chicken Sandwich',
      'Burger & Sandwich',
      'Mike & Laura',
      '{"chicken","fried","spicy"}',
      4,
      '[{"label": "Chicken & marinade", "items": [{"amt": "4", "item": "chicken breasts, cut in half widthwise"}, {"amt": "2 cups", "item": "buttermilk"}, {"amt": "1 tsp", "item": "salt"}, {"amt": "1 tsp", "item": "black pepper"}, {"amt": "1 tsp", "item": "paprika"}, {"amt": "¼ tsp", "item": "cayenne"}, {"amt": "½ tsp", "item": "white pepper"}, {"amt": "1 tsp", "item": "ground dried herbs (oregano, thyme, rosemary, sage)"}, {"amt": "optional", "item": "MSG or dry ranch dressing"}]}, {"label": "Buffalo sauce", "items": [{"amt": "⅔ cup", "item": "Frank''s Louisiana hot sauce"}, {"amt": "½ cup (1 stick)", "item": "cold unsalted butter"}, {"amt": "1½ tbsp", "item": "white vinegar"}, {"amt": "¼ tsp", "item": "Worcestershire sauce"}, {"amt": "½ tsp", "item": "Tabasco or Sriracha"}, {"amt": "¼ tsp", "item": "cayenne pepper"}, {"amt": "⅛ tsp", "item": "garlic powder"}]}, {"label": "Dredge", "items": [{"amt": "2 cups", "item": "flour"}, {"amt": "1 tsp", "item": "salt"}, {"amt": "½ tsp", "item": "paprika"}, {"amt": "¼ tsp", "item": "cayenne"}, {"amt": "½ tsp", "item": "white pepper"}, {"amt": "½ tsp", "item": "garlic powder"}, {"amt": "½ tsp", "item": "onion powder"}, {"amt": "2", "item": "eggs (for second dip)"}]}, {"label": "Frying & assembly", "items": [{"amt": "as needed", "item": "rapeseed oil for frying (350-357°F)"}, {"amt": "optional", "item": "crumbled blue cheese or blue cheese dressing"}, {"amt": "optional", "item": "pickles and pickled red onions"}, {"amt": "optional", "item": "chopped cayenne or habanero (garnish)"}]}]'::jsonb,
      '[{"text": "Night before — marinate: cut chicken breasts in half widthwise. Mix with the rub spices, then cover with buttermilk overnight.", "subs": []}, {"text": "Make buffalo sauce: combine all sauce ingredients over medium heat until simmering at the sides. This makes a lot of sauce — consider scaling back.", "subs": []}, {"text": "First dredge: dry off the buttermilk slightly, then thoroughly dredge all chicken in the flour mixture. Let dry on a rack.", "subs": ["Mix all dredge ingredients in a wide bowl first", "Press the flour mixture firmly into each piece of chicken", "Goal is to build up little coagulations of batter", "Consider adding panko to the dredge for extra crunchiness"]}, {"text": "Double dredge: beat 2 eggs into the remaining marinade. Re-dip each piece in the buttermilk, then dredge again. This step is crucial for the crunchy craggy crust and sealing in moisture.", "subs": ["The first dredge creates clumps that get picked up in this pass", "Break up very large clumps, leave smaller ones — they add texture", "Let rest on a rack before frying", "Optionally add MSG (dry ranch or pure MSG) to the rub or dredge"]}, {"text": "Fry in rapeseed oil at 350-357°F for 4-5 minutes. Drain and rest on a wire rack for at least 10 minutes.", "subs": []}, {"text": "Toss in buffalo sauce. Finish with a quick bake in the oven, brushing on more sauce so it reduces over the chicken.", "subs": []}, {"text": "Assemble the sandwich.", "subs": ["Blue cheese crumbles or blue cheese dressing", "Pickles and pickled red onions", "Garnish with chopped cayenne or habanero"]}]'::jsonb,
      'Start the bread the day before — use Peter''s levain for rolls or brioche buns. Try with chicken thighs sometime.'
    );

    insert into public.recipes (name, category, author, tags, servings, ing_groups, steps, notes)
    values (
      'Big Kahuna Burger',
      'Burger & Sandwich',
      'Babbish',
      '{"smash burger","pineapple","Hawaiian"}',
      1,
      '[{"label": "", "items": [{"amt": "1", "item": "red onion, sliced into rings"}, {"amt": "2 tbsp", "item": "butter, divided"}, {"amt": "3 thin", "item": "pineapple slices"}, {"amt": "1 tbsp", "item": "vegetable oil"}, {"amt": "4 oz", "item": "ground beef, divided into two balls"}, {"amt": "2 slices", "item": "Monterey Jack cheese"}, {"amt": "1", "item": "King''s Hawaiian roll, toasted in butter"}, {"amt": "½ tbsp", "item": "ketchup"}, {"amt": "½ tbsp", "item": "teriyaki sauce"}]}]'::jsonb,
      '[{"text": "Heat 1 tbsp butter until foaming in a sauté pan. Cook red onion slowly over low heat, tossing constantly, until soft and caramelized — about 30 minutes. Set aside.", "subs": []}, {"text": "Wipe out pan. Heat remaining butter over medium heat until sizzling. Sauté pineapple slices until lightly charred on both sides. Set aside.", "subs": []}, {"text": "Heat vegetable oil in a cast iron skillet over high heat until smoking. Place beef balls several inches apart and smash down firmly with a large flat spatula. Cook ~60 seconds until bottom is charred and crispy.", "subs": []}, {"text": "Flip and immediately top with cheese. Remove from heat but leave in the pan while assembling so cheese melts completely.", "subs": []}, {"text": "Dress the butter-toasted bun with ketchup and teriyaki sauce. Top with burgers, caramelized onions, and charred pineapple.", "subs": []}, {"text": "See a cardiologist.", "subs": []}]'::jsonb,
      ''
    );

    insert into public.recipes (name, category, author, tags, servings, ing_groups, steps, notes)
    values (
      'Gyros',
      'Burger & Sandwich',
      'Food Wishes',
      '{"lamb","greek","flatbread"}',
      8,
      '[{"label": "Meat loaf", "items": [{"amt": "1 lb", "item": "ground lamb"}, {"amt": "1 lb", "item": "ground beef"}, {"amt": "½ cup", "item": "yellow onion, finely diced (use food processor)"}, {"amt": "4 cloves", "item": "garlic, crushed"}, {"amt": "1 tbsp", "item": "fresh rosemary, minced"}, {"amt": "2 tsp", "item": "dried oregano"}, {"amt": "2-3 tsp", "item": "kosher salt, or to taste"}, {"amt": "1 tsp", "item": "freshly ground black pepper"}, {"amt": "1 tsp", "item": "cumin"}, {"amt": "1 tsp", "item": "paprika"}, {"amt": "⅛ tsp", "item": "cinnamon"}, {"amt": "⅛ tsp", "item": "cayenne"}, {"amt": "2 tbsp", "item": "breadcrumbs"}]}, {"label": "Pickled onions", "items": [{"amt": "to taste", "item": "red onions"}, {"amt": "to cover", "item": "red wine vinegar"}]}, {"label": "To serve", "items": [{"amt": "to serve", "item": "Lebanese Mountain Bread (see recipe)"}, {"amt": "to serve", "item": "Tzatziki (see recipe)"}]}]'::jsonb,
      '[{"text": "Use a food processor on the onion for more consistent texture in the loaf.", "subs": []}, {"text": "Combine all meat and spice ingredients thoroughly. Cook a small piece to test seasoning before forming.", "subs": []}, {"text": "Form into a loaf. Bake at 350°F for 45 minutes or until internal temperature reaches 160°F.", "subs": []}, {"text": "Make pickled red onions: slice about ⅛-inch thick and cover with red wine vinegar for a few hours or overnight. They turn a beautiful pink.", "subs": []}, {"text": "Prepare Lebanese Mountain Bread and Tzatziki the night before (see those recipes).", "subs": []}, {"text": "Slice meat and serve in flatbread with tzatziki, pickled onions, and other desired toppings.", "subs": []}]'::jsonb,
      'Prepare bread and tzatziki the night before.'
    );

    insert into public.recipes (name, category, author, tags, servings, ing_groups, steps, notes)
    values (
      'Tzatziki',
      'Sauce & Dip',
      'Food Wishes',
      '{"greek","yogurt","dip"}',
      6,
      '[{"label": "", "items": [{"amt": "1 large", "item": "English cucumber, peeled and grated"}, {"amt": "½ tsp", "item": "salt"}, {"amt": "2 cups", "item": "Greek yogurt"}, {"amt": "4 cloves", "item": "garlic, minced"}, {"amt": "1 pinch", "item": "cayenne, or to taste"}, {"amt": "½", "item": "lemon, juiced"}, {"amt": "2 tbsp", "item": "fresh dill, chopped"}, {"amt": "1 tbsp", "item": "fresh mint, chopped"}, {"amt": "to taste", "item": "salt and black pepper"}]}]'::jsonb,
      '[{"text": "Sprinkle grated cucumber with ½ tsp salt and let stand 10-15 minutes to draw out juice.", "subs": []}, {"text": "Squeeze as much moisture as possible from the cucumber using a paper or cloth towel. Mix into yogurt.", "subs": []}, {"text": "Add garlic, cayenne, and lemon juice. Mix thoroughly.", "subs": []}, {"text": "Stir in dill and mint. Season with salt and pepper. Adjust all seasonings to taste.", "subs": []}, {"text": "Cover and refrigerate 3-4 hours or overnight. Garnish with a sprig of dill and a pinch of cayenne before serving.", "subs": []}]'::jsonb,
      ''
    );

    insert into public.recipes (name, category, author, tags, servings, ing_groups, steps, notes)
    values (
      'Lebanese Mountain Bread',
      'Bread',
      'Food Wishes',
      '{"flatbread","yeast"}',
      8,
      '[{"label": "Sponge", "items": [{"amt": "½ cup", "item": "bread flour"}, {"amt": "1 tsp", "item": "dry active yeast"}, {"amt": "1 tsp", "item": "sugar"}, {"amt": "½ cup", "item": "warm water"}]}, {"label": "Dough", "items": [{"amt": "¾ tsp", "item": "kosher salt (or ½ tsp fine salt)"}, {"amt": "1 tbsp", "item": "olive oil"}, {"amt": "1 cup", "item": "bread flour, plus more as needed"}]}]'::jsonb,
      '[{"text": "Make sponge: stir together ½ cup bread flour, yeast, sugar, and ½ cup warm water. Cover and rest 30-60 minutes until bubbly.", "subs": []}, {"text": "Add salt, olive oil, and 1 cup flour. Work 2 minutes. Transfer to an oiled bowl and coat the ball.", "subs": []}, {"text": "Cover and rise in a warm place 1 to 1½ hours.", "subs": []}, {"text": "Quick knead to degas. Place in a ziplock bag and refrigerate overnight.", "subs": []}, {"text": "Roll out portions very thin and cook on a hot, dry skillet until charred spots appear and the bread puffs — about 1-2 minutes per side.", "subs": []}]'::jsonb,
      'Used for gyros. See: https://www.youtube.com/watch?v=DfObqgc0TnQ'
    );

    insert into public.recipes (name, category, author, tags, servings, ing_groups, steps, notes)
    values (
      'Thanksgiving Sandwich',
      'Burger & Sandwich',
      'You Suck at Cooking',
      '{"leftover","turkey","comfort food"}',
      1,
      '[{"label": "Hot filling", "items": [{"amt": "generous", "item": "pulled turkey"}, {"amt": "several slices", "item": "mashed potatoes"}, {"amt": "to taste", "item": "gravy"}, {"amt": "to taste", "item": "hot sauce"}, {"amt": "some", "item": "stuffing"}, {"amt": "to taste", "item": "shredded cheese"}]}, {"label": "Bread & condiments", "items": [{"amt": "2 slices", "item": "bread"}, {"amt": "to taste", "item": "mayonnaise"}, {"amt": "to taste", "item": "sour cream"}, {"amt": "to taste", "item": "cranberry sauce"}, {"amt": "to taste", "item": "sliced dill pickles"}, {"amt": "to taste", "item": "salt and pepper"}]}]'::jsonb,
      '[{"text": "On a sheet of tin foil, place turkey, sliced mashed potatoes, gravy, hot sauce, stuffing, and shredded cheese.", "subs": []}, {"text": "Heat in the oven at 250-300°F until cheese is really melted and everything is hot.", "subs": []}, {"text": "Toast bread. Put mayo on the bottom slice and sour cream on the top.", "subs": ["If you don''t like one, put both on whichever side you prefer — but get some moisture in there"]}, {"text": "Slide the hot ingredients onto the bread.", "subs": []}, {"text": "Add a layer of cranberry sauce and sliced dill pickles. Salt and pepper.", "subs": []}, {"text": "Put the top slice on and cut it. Should be almost as structurally sound as a building.", "subs": []}]'::jsonb,
      ''
    );

    insert into public.recipes (name, category, author, tags, servings, ing_groups, steps, notes)
    values (
      'Breakfast Burrito',
      'Breakfast',
      'You Suck at Cooking',
      '{"eggs","beans","burrito"}',
      1,
      '[{"label": "", "items": [{"amt": "to taste", "item": "fried black beans (see recipe)"}, {"amt": "2-3", "item": "green onions, chopped"}, {"amt": "2-3", "item": "eggs"}, {"amt": "to taste", "item": "olive oil"}, {"amt": "1 large", "item": "flour tortilla"}, {"amt": "to taste", "item": "shredded cheese"}, {"amt": "to taste", "item": "diced tomato and avocado"}, {"amt": "to taste", "item": "hot sauce and other sauces"}]}]'::jsonb,
      '[{"text": "Make fried black beans (see that recipe).", "subs": []}, {"text": "Cook green onions in olive oil. Add eggs and scramble together. Skip green onion if you don''t like it.", "subs": []}, {"text": "Warm tortilla in a pan.", "subs": []}, {"text": "Lay tortilla flat. Spread sauce (or add later). Add eggs, grate cheese over, add beans, then tomato and avocado.", "subs": []}, {"text": "Add more sauce until you feel regret. Roll up.", "subs": []}]'::jsonb,
      'Have a knife, fork, napkin, and hazmat suit ready.'
    );

    insert into public.recipes (name, category, author, tags, servings, ing_groups, steps, notes)
    values (
      'Croque Madame',
      'Breakfast',
      'Babbish',
      '{"french","eggs","brunch"}',
      2,
      '[{"label": "Béchamel", "items": [{"amt": "2 tbsp", "item": "butter"}, {"amt": "2 tbsp", "item": "flour"}, {"amt": "1¼ cups", "item": "milk"}, {"amt": "to taste", "item": "salt, pepper, freshly ground nutmeg"}]}, {"label": "Sandwich", "items": [{"amt": "4 thin slices", "item": "rustic bread"}, {"amt": "1 tbsp", "item": "melted butter (for bread)"}, {"amt": "as needed", "item": "butter for toasting and cooking eggs"}, {"amt": "several slices", "item": "ham"}, {"amt": "½ cup", "item": "gruyère cheese, shredded"}]}, {"label": "Topping", "items": [{"amt": "2", "item": "eggs"}]}]'::jsonb,
      '[{"text": "Make béchamel: melt butter in a saucepan and whisk in flour. Cook 2 minutes, whisking constantly — do not let it brown. Slowly add milk while continuing to whisk until thick and creamy. Season with salt, pepper, and nutmeg. Set aside.", "subs": []}, {"text": "Preheat broiler.", "subs": []}, {"text": "Brush bread with melted butter. Brown in a buttered pan, pile high with ham. Place open-faced on a broiler pan.", "subs": []}, {"text": "Place gruyère on each bread slice. Close sandwiches. Spoon béchamel over the top.", "subs": []}, {"text": "Broil 2-3 minutes until béchamel is browned and bubbly.", "subs": []}, {"text": "Meanwhile, fry eggs in butter with a lid — whites should be set, yolks runny. Season with salt and pepper.", "subs": []}, {"text": "Plate sandwiches. Place a fried egg on top of each one. Eat.", "subs": []}]'::jsonb,
      ''
    );

    insert into public.recipes (name, category, author, tags, servings, ing_groups, steps, notes)
    values (
      'Turkish Chicken Kebabs',
      'Other',
      'Chef John / Food Wishes',
      '{"grilled","chicken","turkish"}',
      8,
      '[{"label": "Marinade", "items": [{"amt": "2 cups", "item": "plain whole milk Turkish yogurt"}, {"amt": "4 tbsp", "item": "olive oil"}, {"amt": "4-6 tbsp", "item": "freshly squeezed lemon juice"}, {"amt": "4 tbsp", "item": "ketchup"}, {"amt": "12 cloves", "item": "garlic, finely minced"}, {"amt": "2 tbsp", "item": "kosher salt"}, {"amt": "2 tsp", "item": "freshly ground black pepper"}, {"amt": "2 tbsp", "item": "Aleppo red pepper flakes"}, {"amt": "2 tsp", "item": "paprika"}, {"amt": "3 tsp", "item": "cumin"}, {"amt": "¼ tsp", "item": "cinnamon"}, {"amt": "2 kg", "item": "boneless skinless chicken thighs"}]}, {"label": "To serve", "items": [{"amt": "to serve", "item": "hummus"}, {"amt": "to serve", "item": "red onion, cucumber, tomato, parsley"}, {"amt": "to serve", "item": "tzatziki or yogurt"}, {"amt": "to serve", "item": "fresh lemon wedges"}, {"amt": "to serve", "item": "flatbread or wrap"}]}]'::jsonb,
      '[{"text": "Prepare marinade: combine all marinade ingredients. Add chicken a little at a time, ensuring each piece is thoroughly coated. Refrigerate 2-8 hours.", "subs": []}, {"text": "Thread chicken onto long metal kebab skewers.", "subs": []}, {"text": "Grill 2-3 minutes undisturbed before turning — you want it to caramelize and harden so it does not stick. After that, turn regularly.", "subs": []}, {"text": "Cook until internal temperature reaches 70°C.", "subs": []}, {"text": "Serve on flatbread with hummus, red onion, cucumber, tomato, parsley, and tzatziki, with lemon wedges.", "subs": []}]'::jsonb,
      'Makes 8 large portions.'
    );

    insert into public.recipes (name, category, author, tags, servings, ing_groups, steps, notes)
    values (
      'Spätzle',
      'Pasta',
      'Mike & Laura',
      '{"german","pasta","side dish"}',
      2,
      '[{"label": "", "items": [{"amt": "2.2 cups", "item": "all-purpose flour"}, {"amt": "½ cup", "item": "milk"}, {"amt": "4", "item": "eggs"}, {"amt": "1 tsp", "item": "ground nutmeg"}, {"amt": "2 pinches", "item": "freshly ground white pepper"}, {"amt": "1 tsp", "item": "salt"}, {"amt": "2 tbsp", "item": "butter"}, {"amt": "2 tbsp", "item": "fresh parsley, chopped"}]}]'::jsonb,
      '[{"text": "Mix flour, salt, white pepper, and nutmeg together. Beat eggs well and add alternately with milk to the dry ingredients. Mix until smooth. Dough should be fairly firm.", "subs": []}, {"text": "Press dough through a spätzle maker or large-holed grater directly into simmering salted water. Cook until all pasta in each batch floats. Drain well.", "subs": []}, {"text": "Brown butter in a pan until nutty. Sauté cooked spätzle in the browned butter. Sprinkle with fresh parsley.", "subs": ["Variation: mince bacon in a pan and heat spätzle in the bacon drippings instead of butter"]}]'::jsonb,
      'Double or increase by 1.5x for two people as a main. Great finished with caramelized onions.'
    );

    insert into public.recipes (name, category, author, tags, servings, ing_groups, steps, notes)
    values (
      'Grandma Czajka''s Pierogies',
      'Pasta',
      'Grandma Czajka / Mike & Laura',
      '{"polish","comfort food","dumplings"}',
      10,
      '[{"label": "Potato & cheese filling", "items": [{"amt": "1 lb", "item": "farmer''s cheese or cream cheese"}, {"amt": "6 medium", "item": "potatoes, skinned, boiled, and mashed"}, {"amt": "to taste", "item": "salt and pepper"}, {"amt": "1-2 tbsp", "item": "flour (if too moist)"}, {"amt": "optional", "item": "4 mint leaves, finely chopped"}]}, {"label": "Cabbage filling", "items": [{"amt": "2 heads", "item": "cabbage, finely chopped"}, {"amt": "1", "item": "onion, sliced (optional)"}, {"amt": "to taste", "item": "butter, salt, and pepper"}, {"amt": "1 lb", "item": "sauerkraut (or to taste)"}]}, {"label": "Dough (makes ~40 pierogies)", "items": [{"amt": "4 cups", "item": "KA flour, fluffed"}, {"amt": "1 tbsp", "item": "salt"}, {"amt": "½ cup", "item": "melted butter"}, {"amt": "1 cup", "item": "lukewarm whole milk"}, {"amt": "2", "item": "eggs, well beaten"}]}, {"label": "For finishing", "items": [{"amt": "as needed", "item": "butter for frying"}]}]'::jsonb,
      '[{"text": "Potato-cheese filling: combine farmer''s cheese, mashed potatoes, salt, pepper, and flour if the mixture is too moist. Optionally add 4 finely chopped mint leaves.", "subs": []}, {"text": "Cabbage filling: sauté chopped cabbage with butter and sliced onion, salt, and pepper. When cooked down, add sauerkraut and cook until all liquid is absorbed.", "subs": []}, {"text": "Dough: combine flour, salt, butter, milk, and eggs in order. Mix until dough pulls off the sides of the bowl.", "subs": ["Cut dough in half and cover the second half until ready", "Roll out to ⅛ inch thick", "Cut as many 3.75-inch circles as possible, reroll scraps — most efficient with two people"]}, {"text": "Fill and seal: add heaped spoons of filling to the center of each disk. Close edges and seal firmly. Water may be needed if dough has dried. Set aside to dry.", "subs": ["Can be frozen at this point — but they can stick together, so the next step is better for storage"]}, {"text": "Boil in batches of 10-15. They are done when they rise and sit flat on the surface. Remove with a slotted spoon, shake off excess water.", "subs": []}, {"text": "Optionally fry lightly in butter until a little browning appears on the surface.", "subs": []}]'::jsonb,
      'Dough makes ~40 pierogies. Make 2-3 batches for the full amount of filling above.'
    );

    insert into public.recipes (name, category, author, tags, servings, ing_groups, steps, notes)
    values (
      'Pasta con Sarde',
      'Pasta',
      'Armando',
      '{"sicilian","sardines","fennel"}',
      4,
      '[{"label": "", "items": [{"amt": "1 large bunch", "item": "fennel leaves and stalks, chopped"}, {"amt": "3 cloves", "item": "garlic, smashed (skin on)"}, {"amt": "1", "item": "dried hot pepper, broken up (or crushed red pepper)"}, {"amt": "1 tin", "item": "sardines in oil"}, {"amt": "as needed", "item": "water"}, {"amt": "to taste", "item": "fresh lemon juice"}, {"amt": "to serve", "item": "orecchiette pasta"}, {"amt": "to reserve", "item": "1 cup pasta cooking water"}]}]'::jsonb,
      '[{"text": "Smash garlic cloves (skin on) and break up a dried hot pepper. Break up a few sardines and add garlic, pepper, and sardines to a heated pan.", "subs": []}, {"text": "Let garlic start to brown on the skin, then add the chopped fennel.", "subs": []}, {"text": "Once fennel heats up, add water — do not let it dry out.", "subs": []}, {"text": "As fennel cooks, add the rest of the sardines.", "subs": []}, {"text": "Cook down until fennel is soft and sardines have dissolved into the sauce.", "subs": []}, {"text": "Cook orecchiette and reserve 1 cup pasta water.", "subs": []}, {"text": "Finish pasta in the sauce pan with pasta water. Spritz the dish with fresh lemon juice.", "subs": []}]'::jsonb,
      'Armando''s recipe. Try the Chef John Sicilian version sometime — quite different.'
    );

    insert into public.recipes (name, category, author, tags, servings, ing_groups, steps, notes)
    values (
      'Kantareller Pizza',
      'Pizza',
      'Mike & Laura',
      '{"chanterelle","swedish","seasonal"}',
      2,
      '[{"label": "Chanterelles", "items": [{"amt": "as needed", "item": "chanterelles"}, {"amt": "to taste", "item": "butter, salt, and black pepper"}]}, {"label": "Caramelized shallots", "items": [{"amt": "5", "item": "banana shallots"}, {"amt": "2 tbsp", "item": "butter"}, {"amt": "1 tsp", "item": "granulated sugar"}, {"amt": "3 tsp", "item": "white wine vinegar"}]}, {"label": "Base", "items": [{"amt": "1 dl", "item": "crème fraîche"}, {"amt": "1 dl", "item": "västerbotten cheese, grated"}, {"amt": "1 clove", "item": "garlic, grated or pressed"}]}, {"label": "Toppings", "items": [{"amt": "to taste", "item": "dried figs, sliced"}, {"amt": "to taste", "item": "pine nuts"}, {"amt": "to taste", "item": "crudo or prosciutto"}, {"amt": "to taste", "item": "mozzarella (shredded or in chunks)"}, {"amt": "to finish", "item": "fresh chives or shallots, chopped"}]}]'::jsonb,
      '[{"text": "Fry chanterelles in butter, reducing until golden and flavourful. Season with salt and black pepper.", "subs": []}, {"text": "Caramelize shallots: fry in butter over medium heat until soft and sweet. Add sugar and fry a few more minutes. Add vinegar and let boil briefly. Season with salt.", "subs": []}, {"text": "Mix crème fraîche, grated västerbotten, and grated garlic. Spread on the pizza base.", "subs": []}, {"text": "Top with chanterelles, caramelized shallots, dried figs, pine nuts, crudo, and mozzarella.", "subs": []}, {"text": "Bake until crust is golden and cheese is bubbly.", "subs": []}, {"text": "Finish with chopped fresh chives or shallots.", "subs": []}]'::jsonb,
      'Based on a dream (or maybe an ICA Buffé recipe).'
    );

    insert into public.recipes (name, category, author, tags, servings, ing_groups, steps, notes)
    values (
      'German Potato Salad',
      'Salad',
      'Stanley',
      '{"german","potato","picnic"}',
      8,
      '[{"label": "", "items": [{"amt": "2-3 per person", "item": "medium potatoes"}, {"amt": "1", "item": "red onion, freshly cut"}, {"amt": "½ glass", "item": "pickled cucumber, finely cut (Felix or Lidl sliced — NOT saltgurka)"}, {"amt": "~100ml", "item": "pickle juice from the jar"}, {"amt": "a good dash", "item": "ordinary white vinegar"}, {"amt": "a bit", "item": "sunflower oil"}, {"amt": "to taste", "item": "mayonnaise (not too much, not too little)"}, {"amt": "to taste", "item": "salt and freshly ground pepper"}, {"amt": "to finish", "item": "fresh parsley, chopped"}]}]'::jsonb,
      '[{"text": "Boil potatoes with the peel in well-salted water over medium heat. After 35 minutes test with a fork — they should be soft all the way through.", "subs": []}, {"text": "Remove and let cool, best in the fridge.", "subs": []}, {"text": "Once cool, peel and cut into slices about 3mm thick.", "subs": []}, {"text": "In a large bowl combine sliced potatoes with freshly cut red onion and finely cut pickled cucumber.", "subs": []}, {"text": "Add salt and pepper, about 100ml pickle juice, a good dash of white vinegar, a bit of sunflower oil, and mayonnaise. Add fresh parsley.", "subs": []}, {"text": "Let sit in the fridge for a few hours. Adjust salt, pepper, and vinegar to taste. Add more parsley on top before serving.", "subs": []}]'::jsonb,
      'The ratios are key — not too much mayo, not too little. The pickle juice makes all the difference. Must use the right pickles: Felix or Lidl sliced. NOT saltgurka, as otherwise it tastes awful.'
    );

    insert into public.recipes (name, category, author, tags, servings, ing_groups, steps, notes)
    values (
      'Pesto',
      'Sauce & Dip',
      'Mike & Laura',
      '{"italian","basil","quick"}',
      4,
      '[{"label": "", "items": [{"amt": "4 cloves", "item": "garlic, peeled"}, {"amt": "¼ tsp", "item": "kosher salt"}, {"amt": "1 large bunch", "item": "fresh basil (about 4-5 oz)"}, {"amt": "3 tbsp", "item": "pine nuts"}, {"amt": "2 oz", "item": "Parmigiano-Reggiano, grated on a microplane"}, {"amt": "½ cup", "item": "mild extra virgin olive oil"}]}]'::jsonb,
      '[{"text": "Combine garlic, salt, basil, and pine nuts in a food processor. Pulse to a rough paste.", "subs": []}, {"text": "Add Parmigiano-Reggiano and pulse to combine.", "subs": []}, {"text": "With processor running, drizzle in olive oil and blend to desired consistency.", "subs": []}]'::jsonb,
      ''
    );

    insert into public.recipes (name, category, author, tags, servings, ing_groups, steps, notes)
    values (
      'Fig and Olive Tapenade',
      'Sauce & Dip',
      'Mike & Laura',
      '{"fig","olive","appetizer"}',
      8,
      '[{"label": "Tapenade", "items": [{"amt": "1 cup", "item": "dried figs, chopped"}, {"amt": "½ cup", "item": "water"}, {"amt": "1 tbsp", "item": "olive oil"}, {"amt": "2 tbsp", "item": "balsamic vinegar"}, {"amt": "1 tsp", "item": "dried rosemary"}, {"amt": "1 tsp", "item": "dried thyme"}, {"amt": "¼ tsp", "item": "cayenne pepper"}, {"amt": "⅔ cup", "item": "kalamata olives, chopped"}, {"amt": "2 cloves", "item": "garlic, minced"}, {"amt": "to taste", "item": "salt and pepper"}]}, {"label": "To serve", "items": [{"amt": "⅓ cup", "item": "walnuts, chopped and toasted"}, {"amt": "1 package (8 oz)", "item": "goat cheese"}, {"amt": "to serve", "item": "French bread or crackers"}]}]'::jsonb,
      '[{"text": "Combine figs and water in a saucepan over medium heat. Bring to a boil and cook until tender and liquid has reduced.", "subs": []}, {"text": "Remove from heat and stir in olive oil, balsamic vinegar, rosemary, thyme, and cayenne.", "subs": []}, {"text": "Add olives and garlic. Mix well. Season with salt and pepper. Cover and refrigerate 4 hours or overnight.", "subs": []}, {"text": "Toast walnuts: spread on a baking sheet, 350°F oven for 10 minutes until lightly browned and fragrant.", "subs": []}, {"text": "Unwrap goat cheese and place on a serving platter. Spoon tapenade over cheese, sprinkle with toasted walnuts. Serve with bread or crackers.", "subs": []}]'::jsonb,
      'Overnight refrigeration significantly improves the flavour.'
    );

    insert into public.recipes (name, category, author, tags, servings, ing_groups, steps, notes)
    values (
      'Plum Habanero Jam',
      'Condiment',
      'Mike & Laura',
      '{"jam","habanero","preserves"}',
      8,
      '[{"label": "", "items": [{"amt": "2 kg", "item": "plums, prepared weight"}, {"amt": "½ cup (125ml)", "item": "water"}, {"amt": "1.5 kg", "item": "granulated sugar"}, {"amt": "1½ tbsp", "item": "lemon juice"}, {"amt": "to taste", "item": "habaneros and other chillies (scotch bonnet, lemon drop, jalapeño)"}]}]'::jsonb,
      '[{"text": "Sterilize jars: preheat oven to 130°C (270°F). Wash jars and lids. Heat on a baking tray at least 20 minutes until completely dry and very hot.", "subs": []}, {"text": "Quarter plums. Place with water in a large wide saucepan. Simmer covered over low-medium heat, stirring occasionally, until soft — 15-20 minutes. Blend with a stick blender if you prefer less chunky.", "subs": []}, {"text": "Add sugar, peppers, and lemon juice. Stir frequently, uncovered, until sugar dissolves.", "subs": []}, {"text": "Bring to a rolling boil for 5-15 minutes, stirring frequently. After 5 minutes, test for set.", "subs": ["Wrinkle test: spoon small amount onto a chilled plate, cool, push with fingertip — if it wrinkles it is ready", "Thermometer: jam is set at 104°C (220°F)", "If not set, boil another 5 minutes and test again"]}, {"text": "Remove from heat. If there is scum on the surface, add 1 tsp butter and stir to dissolve it. Let stand 10 minutes.", "subs": []}, {"text": "Ladle carefully into hot sterilized jars. Seal immediately. Label when cool. Store in a cool dark place.", "subs": []}]'::jsonb,
      'Wear long sleeves — hot jam burns are serious. 2023 batch: 2 scotch bonnet, 1 habanero, 1 lemon drop, 1 jalapeño, 1 chilli.'
    );

    insert into public.recipes (name, category, author, tags, servings, ing_groups, steps, notes)
    values (
      'Plum Habanero Hot Sauce',
      'Condiment',
      'Mike & Laura',
      '{"hot sauce","fermented","habanero"}',
      12,
      '[{"label": "Fermentation (2+ weeks)", "items": [{"amt": "1½ lbs (680g)", "item": "habaneros"}, {"amt": "5 cloves", "item": "garlic"}, {"amt": "as needed", "item": "canning salt and water (3-3.5% brine — water weight × 0.03)"}]}, {"label": "Sauce", "items": [{"amt": "½ medium", "item": "onion"}, {"amt": "2", "item": "mangos or plums, peeled and diced"}, {"amt": "4 tbsp", "item": "fresh lime juice (~2 limes)"}, {"amt": "24 oz", "item": "pineapple juice (reduce significantly first)"}, {"amt": "¾ cup", "item": "apple cider vinegar"}, {"amt": "½ cup", "item": "honey (reduce somewhat)"}, {"amt": "¼ tbsp", "item": "allspice"}, {"amt": "¼ tbsp", "item": "cumin"}, {"amt": "¼ tbsp", "item": "ground clove"}, {"amt": "½ tbsp", "item": "ginger"}]}]'::jsonb,
      '[{"text": "Fermentation: de-stem and roughly chop habaneros. Remove outer layer of garlic and smash. Add both to a Mason jar with 3-3.5% salt water brine. Cover with an airlock or rubber-banded bag — do NOT screw on a canning lid. Ferment at least two weeks in a cool dark space.", "subs": []}, {"text": "Really reduce the pineapple juice and honey before combining — the sauce is too sweet otherwise.", "subs": []}, {"text": "Save 1 cup of the pepper brine from the jar; discard the rest. Combine all sauce ingredients except brine in a blender. Blend until smooth.", "subs": []}, {"text": "Add to a pot and simmer covered on low for 20 minutes.", "subs": []}, {"text": "Adjust consistency with saved brine if too thick.", "subs": []}, {"text": "Optional but recommended: pass through a fine mesh strainer to remove seeds and large pulp.", "subs": []}, {"text": "Optional: simmer again to thicken further.", "subs": []}, {"text": "Cool, then refrigerate overnight before using to allow spices to meld.", "subs": []}]'::jsonb,
      '2024: Made two batches — one plum/habanero, one mango/lemon drop. Next time decrease pineapple juice and honey — a bit too sweet. Second straining and simmer worked well for thickness.'
    );

    insert into public.recipes (name, category, author, tags, servings, ing_groups, steps, notes)
    values (
      'Boilermaker Tailgate Chili',
      'Chili & Stew',
      'Mike & Laura',
      '{"chili","beef","crowd pleaser"}',
      8,
      '[{"label": "Meat", "items": [{"amt": "2 lbs", "item": "ground beef chuck"}, {"amt": "1 lb", "item": "bulk Italian sausage"}]}, {"label": "Beans & tomatoes", "items": [{"amt": "3 cans (15 oz)", "item": "chili beans, drained"}, {"amt": "1 can (15 oz)", "item": "chili beans in spicy sauce"}, {"amt": "2 cans (28 oz)", "item": "diced tomatoes with juice"}, {"amt": "1 can (6 oz)", "item": "tomato paste"}]}, {"label": "Vegetables & flavour", "items": [{"amt": "1 large", "item": "yellow onion, chopped"}, {"amt": "3 stalks", "item": "celery, chopped"}, {"amt": "1", "item": "green bell pepper, seeded and chopped"}, {"amt": "1", "item": "red bell pepper, seeded and chopped"}, {"amt": "2", "item": "green chile peppers, seeded and chopped"}, {"amt": "1 tbsp", "item": "bacon bits"}, {"amt": "4 cubes", "item": "beef bouillon"}, {"amt": "½ cup", "item": "beer"}]}, {"label": "Spices", "items": [{"amt": "¼ cup", "item": "chili powder"}, {"amt": "1 tbsp", "item": "Worcestershire sauce"}, {"amt": "1 tbsp", "item": "minced garlic"}, {"amt": "1 tbsp", "item": "dried oregano"}, {"amt": "2 tsp", "item": "ground cumin"}, {"amt": "2 tsp", "item": "hot pepper sauce (e.g. Tabasco)"}, {"amt": "1 tsp", "item": "dried basil"}, {"amt": "1 tsp", "item": "salt"}, {"amt": "1 tsp", "item": "black pepper"}, {"amt": "1 tsp", "item": "cayenne pepper"}, {"amt": "1 tsp", "item": "paprika"}, {"amt": "1 tsp", "item": "white sugar"}]}, {"label": "To serve", "items": [{"amt": "1 bag", "item": "corn chips (Fritos)"}, {"amt": "1 package (8 oz)", "item": "shredded cheddar cheese"}]}]'::jsonb,
      '[{"text": "Heat a large stock pot over medium-high. Crumble ground chuck and sausage into the hot pan. Cook until evenly browned. Drain off excess grease.", "subs": []}, {"text": "Add all beans, diced tomatoes, tomato paste, onion, celery, bell peppers, chile peppers, bacon bits, bouillon, and beer.", "subs": []}, {"text": "Add all spices. Stir to blend thoroughly. Cover and simmer over low heat for at least 2 hours, stirring occasionally.", "subs": []}, {"text": "After 2 hours, taste and adjust salt, pepper, and chili powder. The longer it simmers, the better it tastes.", "subs": []}, {"text": "Serve topped with corn chips and shredded cheddar.", "subs": []}]'::jsonb,
      'Even better the next day.'
    );

    insert into public.recipes (name, category, author, tags, servings, ing_groups, steps, notes)
    values (
      'White Chili',
      'Chili & Stew',
      'Mike & Laura',
      '{"vegetarian","beans","light"}',
      4,
      '[{"label": "", "items": [{"amt": "2 tsp", "item": "olive oil"}, {"amt": "½ medium", "item": "yellow onion, diced"}, {"amt": "1 tsp", "item": "dried oregano"}, {"amt": "¼ tsp", "item": "kosher salt, plus more to taste"}, {"amt": "⅛ tsp", "item": "black pepper, plus more to taste"}, {"amt": "3 cloves", "item": "garlic, minced"}, {"amt": "2 tsp", "item": "ground cumin"}, {"amt": "2 cups", "item": "low-sodium vegetable broth"}, {"amt": "1 can (15 oz)", "item": "cannellini beans, rinsed"}, {"amt": "1 can (15 oz)", "item": "navy beans, rinsed"}, {"amt": "1 can (15 oz)", "item": "chickpeas, rinsed"}, {"amt": "1 can (4 oz)", "item": "diced green chiles"}, {"amt": "¼ tsp", "item": "ground cloves"}, {"amt": "⅛-¼ tsp", "item": "ground cayenne (use less for less heat)"}, {"amt": "1 medium", "item": "lime, juiced"}]}, {"label": "Optional toppings", "items": [{"amt": "to taste", "item": "fresh cilantro"}, {"amt": "to taste", "item": "lime wedges"}, {"amt": "to taste", "item": "sliced scallions"}, {"amt": "to taste", "item": "grated cheese"}, {"amt": "to taste", "item": "diced avocado"}, {"amt": "to taste", "item": "sour cream or cashew sour cream"}, {"amt": "to taste", "item": "a dash of green Tabasco"}]}]'::jsonb,
      '[{"text": "Set a medium-to-large pot over low heat. Add olive oil, onion, oregano, salt, and pepper. Cook stirring occasionally until soft and translucent, about 8 minutes.", "subs": []}, {"text": "Add garlic and cumin. Cook stirring frequently for another minute.", "subs": []}, {"text": "Add broth, all beans, green chiles, cloves, and cayenne. Stir to combine. Bring to a boil, then reduce to a simmer for 3-5 minutes.", "subs": []}, {"text": "Remove from heat. Run a potato masher through 5-6 times to smash a few beans and thicken the chili. Squeeze lime over the top and stir. Adjust seasoning.", "subs": []}, {"text": "Serve with desired toppings.", "subs": []}]'::jsonb,
      'Vegan without cheese and sour cream. Great with cashew sour cream as a vegan option.'
    );

  end if;
end $$;

-- 4. Create the recipe-photos storage bucket
-- Run this separately in the Supabase dashboard > Storage, or via:
insert into storage.buckets (id, name, public)
values ('recipe-photos', 'recipe-photos', true)
on conflict (id) do nothing;

-- Allow all operations on the bucket (no auth, personal app)
create policy "Public recipe photos" on storage.objects
  for all using (bucket_id = 'recipe-photos')
  with check (bucket_id = 'recipe-photos');