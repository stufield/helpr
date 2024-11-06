#' Praise User
#'
#' Part of collaboration is being friendly to your users.
#' Praise your colleagues with encouragement when they
#' use your code appropriately and when it runs error free!
#' This is a wrapper around the \pkg{praise} package and
#' takes no arguments. Additional flexibility may be added
#' in the future. Output can be suppressed by setting the
#' `"signal.quiet"` option (see example).
#'
#' @examples
#' # random praise 1
#' give_praise()
#'
#' # random praise 2
#' give_praise()
#'
#' # suppress praise
#' withr::with_options(list(signal.quiet = TRUE), give_praise())
#' @export
give_praise <- function() {
  x   <- .capitalize(sample(praises$exclamation, 1L))
  y   <- .capitalize(sample(praises$adjective, 1L))
  pr  <- sprintf("%s! You are %s!", x, y)
  col <- sample(c("red", "green", "blue", "magenta", "cyan"), 1)
  .inform(add_color(pr, col), class = "condition")
}

.capitalize <- function(x) {
  paste0(toupper(substr(x, 1L, 1L)), substr(x, 2L, nchar(x)))
}

praises <- list(
  adjective = c("ace", "amazing", "astonishing", "astounding",
                "awe-inspiring", "awesome", "badass", "beautiful",
                "bedazzling", "bee's knees", "best", "breathtaking",
                "brilliant", "cat's meow", "cat's pajamas", "classy",
                "cool", "dandy", "dazzling", "delightful", "divine",
                "doozie", "epic", "excellent", "exceptional", "exquisite",
                "extraordinary", "fabulous", "fantastic", "fantabulous",
                "fine", "finest", "first-class", "first-rate", "flawless",
                "funkadelic", "geometric", "glorious", "gnarly", "good",
                "grand", "great", "groovy", "groundbreaking", "hunky-dory",
                "impeccable", "impressive", "incredible", "kickass",
                "kryptonian", "laudable", "legendary", "lovely", "luminous",
                "magnificent", "majestic", "marvelous", "mathematical",
                "mind-blowing", "neat", "outstanding", "peachy", "perfect",
                "phenomenal", "pioneering", "polished", "posh", "praiseworthy",
                "premium", "priceless", "prime", "primo", "rad", "remarkable",
                "riveting", "sensational", "shining", "slick", "smashing",
                "solid", "spectacular", "splendid",  "stellar", "striking",
                "stunning", "stupendous", "stylish", "sublime", "super",
                "super-duper", "super-excellent", "superb", "superior",
                "supreme", "swell", "terrific", "tiptop", "top-notch",
                "transcendent", "tremendous", "ultimate", "unreal",
                "well-made", "wicked", "wonderful", "wondrous", "world-class"),
  adverb = c("beautifully", "bravely", "brightly", "calmly", "carefully",
             "cautiously", "cheerfully", "clearly", "correctly",
             "courageously", "daringly", "deliberately", "doubtfully",
             "eagerly", "easily", "elegantly", "enormously",
             "enthusiastically", "faithfully", "fast", "fondly",
             "fortunately", "frankly", "frantically", "generously", "gently",
             "gladly", "gracefully", "happily", "healthily", "honestly",
             "joyously", "justly", "kindly", "neatly", "openly", "patiently",
             "perfectly", "politely", "powerfully", "quickly", "quietly",
             "rapidly", "really", "regularly", "repeatedly", "rightfully",
             "seriously", "sharply", "smoothly", "speedily", "successfully",
             "swiftly", "tenderly", "thoughtfully", "truthfully", "warmly",
             "well", "wisely"),
  adverb_manner = c("beautifully", "bravely", "brightly", "calmly",
                    "carefully", "cautiously", "cheerfully", "clearly",
                    "correctly", "courageously", "daringly", "deliberately",
                    "doubtfully", "eagerly", "easily", "elegantly",
                    "enormously", "enthusiastically", "faithfully", "fast",
                    "fondly", "fortunately", "frankly", "frantically",
                    "generously", "gently", "gladly", "gracefully", "happily",
                    "healthily", "honestly", "joyously", "justly", "kindly",
                    "neatly", "openly", "patiently", "perfectly", "politely",
                    "powerfully", "quickly", "quietly", "rapidly", "really",
                    "regularly", "repeatedly", "rightfully", "seriously",
                    "sharply", "smoothly", "speedily", "successfully",
                    "swiftly", "tenderly", "thoughtfully", "truthfully",
                    "warmly", "well", "wisely"),
  created = c("assembled", "brewed", "built", "created", "composed",
              "constructed", "designed", "devised", "forged", "formed",
              "initiated", "invented", "made", "organized", "planned",
              "prepared", "set up"),
  creating = c("assembling", "brewing", "building", "creating", "composing",
               "constructing", "designing", "devising", "forging", "forming",
               "initiating", "inventing", "making", "organizing", "planning",
               "preparin", "setting up"),
  exclamation = c("ah", "aha", "ahh", "ahhh", "aw", "aww", "awww", "aye",
                  "gee", "ha", "hah", "hmm", "ho-ho", "huh", "heh",
                  "hooray", "hurrah", "hurray", "huzzah", "mhm", "mm", "mmh",
                  "mmhm", "mmm", "oh", "ole", "uh-hu", "wee", "whee", "whoa",
                  "wow", "wowie", "yahoo", "yay", "yeah", "yee-haw", "yikes",
                  "yippie", "yow", "yowza"),
  rpackage = c("code", "library (or package?)", "package", "program",
               "project", "software", "R package")
)
