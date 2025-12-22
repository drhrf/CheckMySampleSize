# app.R
library(shiny)

ui <- fluidPage(
  tags$head(
    # Optional font (will fall back gracefully if offline)
    tags$link(
      rel = "stylesheet",
      href = "https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap"
    ),
    
    # Google Translate widget (needs internet access in the client browser)
    tags$script(src = "https://translate.google.com/translate_a/element.js?cb=googleTranslateElementInit"),
    tags$script(HTML("
      function googleTranslateElementInit() {
        new google.translate.TranslateElement(
          {
            pageLanguage: 'en',
            includedLanguages: 'en,pt,es,fr,de,it',
            layout: google.translate.TranslateElement.InlineLayout.SIMPLE
          },
          'google_translate_element'
        );
      }
    ")),
    
    # Styling inspired by the LabInfoS site’s clean header + card sections
    tags$style(HTML("
      :root{
        --bg: #f6f7fb;
        --card: #ffffff;
        --text: #0f172a;
        --muted: #5b6472;
        --border: #e6e8ef;
        --accent: #0b4f6c;
        --accent2:#0ea5a4;
        --shadow: 0 10px 25px rgba(15, 23, 42, 0.06);
        --radius: 18px;
      }

      body{
        font-family: Inter, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Arial, sans-serif;
        background: var(--bg);
        color: var(--text);
      }

      .topbar{
        position: sticky;
        top: 0;
        z-index: 1000;
        background: rgba(255,255,255,0.88);
        backdrop-filter: blur(10px);
        border-bottom: 1px solid var(--border);
      }
      .topbar-inner{
        max-width: 1150px;
        margin: 0 auto;
        padding: 14px 18px;
        display: flex;
        align-items: flex-start;
        justify-content: space-between;
        gap: 16px;
      }

      .brand{
        display: flex;
        gap: 12px;
        align-items: center;
        min-width: 320px;
      }
      .brand-logo{
        height: 44px;
        width: auto;
        border-radius: 12px;
        border: 1px solid var(--border);
        background: white;
        box-shadow: 0 4px 12px rgba(15, 23, 42, 0.06);
        object-fit: contain;
      }
      .logo-placeholder{
        height: 44px;
        width: 44px;
        border-radius: 12px;
        display:flex;
        align-items:center;
        justify-content:center;
        font-weight: 800;
        letter-spacing: 0.5px;
        color: white;
        background: linear-gradient(135deg, var(--accent), var(--accent2));
        box-shadow: 0 10px 18px rgba(14,165,164,0.18);
      }
      .brand-text{ line-height: 1.15; }
      .app-name{
        font-size: 20px;
        font-weight: 800;
        margin: 0;
      }
      .tagline{
        margin-top: 4px;
        font-size: 13px;
        color: var(--muted);
      }

      .actions{
        display:flex;
        align-items:flex-start;
        gap: 14px;
      }
      .mini-links{
        margin-top: 2px;
        font-size: 13px;
        color: var(--muted);
        white-space: nowrap;
      }
      .mini-links a{
        color: var(--accent);
        text-decoration: none;
        font-weight: 700;
      }
      .mini-links a:hover{ text-decoration: underline; }
      .dot{ margin: 0 6px; color: #9aa3b2; }

      .translate-box{
        text-align:right;
        min-width: 200px;
      }
      .translate-label{
        font-size: 12px;
        color: var(--muted);
        margin-bottom: 4px;
      }
      #google_translate_element{
        display:inline-block;
        padding: 6px 10px;
        border: 1px solid var(--border);
        border-radius: 12px;
        background: white;
        box-shadow: 0 6px 18px rgba(15, 23, 42, 0.05);
      }

      .page{
        max-width: 1150px;
        margin: 18px auto 28px auto;
        padding: 0 18px;
      }

      .lab-card{
        background: var(--card);
        border: 1px solid var(--border);
        border-radius: var(--radius);
        box-shadow: var(--shadow);
      }

      .row{
        margin-left: 0;
        margin-right: 0;
      }
      .col-sm-4, .col-sm-8{
        padding-left: 10px;
        padding-right: 10px;
      }

      .well{
        background: transparent;
        border: none;
        box-shadow: none;
        padding: 0;
      }

      .card-pad{
        padding: 16px 16px 8px 16px;
      }
      .card-pad-main{
        padding: 18px;
      }

      .chips{
        display:flex;
        flex-wrap: wrap;
        gap: 10px;
        margin-bottom: 14px;
      }
      .chip{
        background: rgba(11,79,108,0.06);
        border: 1px solid rgba(11,79,108,0.12);
        border-radius: 999px;
        padding: 7px 12px;
        font-size: 13px;
        color: #103246;
      }
      .chip strong{ font-weight: 800; }

      p{
        line-height: 1.45;
        margin: 0 0 10px 0;
      }
      hr{
        border-top: 1px solid var(--border);
      }
      .note{
        color: var(--muted);
        font-size: 13px;
      }

      .control-label{
        font-weight: 800;
        color: #111827;
      }
      .form-control{
        border-radius: 12px;
        border: 1px solid var(--border);
        box-shadow: none;
      }
      .checkbox{
        margin-top: 10px;
      }

      .topic-title{
        margin-top: 4px;
        margin-bottom: 10px;
      }
      .study-q{
        padding: 12px 14px;
        border: 1px solid rgba(11,79,108,0.14);
        background: rgba(11,79,108,0.04);
        border-radius: 14px;
        margin-bottom: 16px;
        text-align: center;
      }
      .study-q .label{
        font-size: 18px;
        text-align: center;
        font-weight: 500;
        color: #1f3342;
        letter-spacing: 0.2px;
        margin-bottom: 16px;
      }
      .study-q .question{
        font-size: 14px;
        margin-top: 10px;
        color: #0f172a;
        text-align: center;
      }
    "))
  ),
  
  div(
    class = "topbar",
    div(
      class = "topbar-inner",
      div(
        class = "brand",
        tags$div(id = "logo_fallback", class = "logo-placeholder", style = "display:none;", "L"),
        uiOutput("logo_ui"),
        div(
          class = "brand-text",
          tags$div(class = "app-name", "CheckMySampleSize"),
          tags$div(class = "tagline", HTML("Study design &nbsp;•&nbsp; Biostatistics &nbsp;•&nbsp; Practical power thinking"))
        )
      ),
      div(
        class = "actions",
        div(
          class = "mini-links",
          tags$a(href = "https://drhrf.github.io/LabInfoS/index.html", target = "_blank", "LabInfoS"),
          tags$span(class = "dot", "•"),
          tags$a(href = "https://github.com/drhrf", target = "_blank", "GitHub")
        ),
        div(
          class = "translate-box",
          tags$div(class = "translate-label", "Translate:"),
          tags$div(id = "google_translate_element")
        )
      )
    )
  ),
  
  div(
    class = "page",
    sidebarLayout(
      sidebarPanel(
        class = "lab-card card-pad",
        numericInput("n_total", "Expected total sample size (N):", value = 60, min = 2, step = 1),
        
        selectInput(
          "analysis_goal",
          "Primary analysis goal:",
          choices = c(
            "Two-group mean comparison (parallel groups)" = "mean_2g",
            "Multi-group mean comparison (ANOVA-type)"     = "mean_kg",
            "Paired or repeated-measures comparison"       = "paired",
            "Binary outcome comparison (risk / odds)"      = "binary",
            "Regression (explanatory / association)"       = "reg_assoc",
            "Regression (prediction-oriented)"             = "reg_pred",
            "Correlation / association (exploratory)"      = "correlation"
          )
        ),
        
        numericInput("k_groups", "Number of groups (if applicable):", value = 2, min = 1, step = 1),
        
        uiOutput("k_groups_help"),
        
        tags$div(style = "height: 8px;"),
        
        sliderInput("alpha", "Significance level (α):", min = 0.001, max = 0.10, value = 0.05, step = 0.001),
        
        sliderInput("target_power", "Target power (1 − β):", min = 0.50, max = 0.95, value = 0.80, step = 0.01),
        
        checkboxInput("allow_nonparametric", "Allow non-parametric / resampling approaches?", value = TRUE),
        
        tags$div(style = "margin-top: 12px;"),
        plotOutput("alphaPowerPlot", height = "220px"),
        tags$div(style = "height: 8px;"),
        uiOutput("alphaPowerNote")
      ),
      
      mainPanel(
        class = "lab-card card-pad-main",
        uiOutput("chips_ui"),
        
        tags$h3(class = "topic-title", "Study question"),
        uiOutput("study_question_ui"),
        
        tags$h3(class = "topic-title", "Feasibility guidance"),
        uiOutput("advice"),
        
        tags$hr(),
        tags$h4("Design summary"),
        verbatimTextOutput("summary"),
        tags$hr(),
        tags$p(
          class = "note",
          HTML(
            "This app deliberately avoids doing a formal power calculation. It’s meant to help you choose analyses that are <strong>plausible</strong> at your N and avoid designs that are fragile, over-parameterized, or multiplicity-heavy."
          )
        )
      )
    )
  )
)

server <- function(input, output, session) {
  
  tier_from_n <- function(n) {
    if (n < 12)  return("very small (pilot only)")
    if (n < 20)  return("very small")
    if (n < 30)  return("small (fragile inference)")
    if (n < 40)  return("small")
    if (n < 60)  return("lower-moderate")
    if (n < 80)  return("moderate")
    if (n < 120) return("upper-moderate")
    if (n < 200) return("large")
    "very large"
  }
  
  goal_label <- function(goal_code) {
    switch(
      goal_code,
      mean_2g     = "Two-group mean comparison (parallel groups)",
      mean_kg     = "Multi-group mean comparison (ANOVA-type)",
      paired      = "Paired or repeated-measures comparison",
      binary      = "Binary outcome comparison (risk / odds)",
      reg_assoc   = "Regression (explanatory / association)",
      reg_pred    = "Regression (prediction-oriented)",
      correlation = "Correlation / association (exploratory)",
      goal_code
    )
  }
  
  # Study question builder
  study_question_text <- function(goal_code, k) {
    k <- max(1, as.integer(k))
    switch(
      goal_code,
      mean_2g = "Among two groups, is the average outcome meaningfully different?",
      mean_kg = paste0("Across ", k, " groups, is there evidence that group means differ (and which planned contrasts matter)?"),
      paired  = "Within the same individuals, does the outcome change from baseline to follow-up (or across timepoints)?",
      binary  = "Do groups differ in the probability of an event (risk), and what is the size of that difference?",
      reg_assoc = "Is the outcome associated with the exposure after accounting for key confounders (with a prespecified model)?",
      reg_pred  = "Can we predict the outcome for new individuals with acceptable performance and calibration?",
      correlation = "Are two continuous variables associated (and is the association robust to outliers and non-linearity)?",
      "What is the primary question this study is trying to answer?"
    )
  }
  
  alpha_power_text <- function(alpha, power) {
    beta <- 1 - power
    paste0(
      "<strong>α and power (planning targets, not computed here):</strong> ",
      "α = ", sprintf("%.3f", alpha),
      " is the long-run probability of a <em>Type I error</em> (false positive) <em>under the null</em> for a single primary test (often two-sided unless specified). ",
      "Target power = ", sprintf("%.2f", power),
      " corresponds to β = ", sprintf("%.2f", beta),
      " probability of a <em>Type II error</em> (false negative) <em>under a specific alternative</em>—i.e., assuming a particular effect size and variability. ",
      "<strong>This app does not compute achieved power.</strong> Without an effect size (and noise) assumption, changing α/power targets does not make a small study “adequate”; it just changes the standard you wish you could meet."
    )
  }
  
  group_balance_note <- function(n, k) {
    if (k <= 1) return(NULL)
    per_group <- floor(n / k)
    remainder <- n - per_group * k
    
    if (remainder == 0) {
      paste0(
        "Balanced allocation implies about <strong>", per_group, " per group</strong>. ",
        "If allocation is unbalanced, your <strong>smallest group</strong> dominates uncertainty."
      )
    } else {
      paste0(
        "Balanced integer allocation is about <strong>", per_group, " per group</strong>, with ",
        remainder, " participant(s) left over. ",
        "At small per-group N, even mild imbalance can matter."
      )
    }
  }
  
  n_sensitivity_text <- function(n, k) {
    n_plus10 <- n + 10
    n_plus20 <- n + 20
    pg_now   <- floor(n / max(1, k))
    pg_10    <- floor(n_plus10 / max(1, k))
    pg_20    <- floor(n_plus20 / max(1, k))
    
    paste0(
      "<strong>Sensitivity to small N changes:</strong> at N = ", n, ", you have ~<strong>", pg_now,
      "</strong> per group (if groups apply). If you can reach N = ", n_plus10,
      ", that becomes ~<strong>", pg_10, "</strong>; at N = ", n_plus20,
      ", ~<strong>", pg_20, "</strong>. In borderline designs, those small jumps can be the difference between “fragile” and “workable.”"
    )
  }
  
  implied_delta <- function(alpha, target_power) {
    zcrit <- qnorm(1 - alpha / 2)
    
    power_given_delta <- function(delta) {
      pnorm(-zcrit, mean = delta, sd = 1) + (1 - pnorm(zcrit, mean = delta, sd = 1))
    }
    
    p0 <- power_given_delta(0)  # equals alpha for symmetric two-sided test
    
    if (target_power <= p0 + 1e-6) return(0)
    
    upper <- 6
    while (power_given_delta(upper) < target_power && upper < 50) upper <- upper * 1.5
    if (power_given_delta(upper) < target_power) return(upper)
    
    uniroot(function(d) power_given_delta(d) - target_power, lower = 0, upper = upper)$root
  }
  
  `%||%` <- function(a, b) if (!is.null(a)) a else b
  
  group_rules <- function(goal) {
    switch(
      goal,
      mean_2g = list(
        minN = 2, minK = 2, maxK = 2, fixedK = 2,
        label = "Number of groups (fixed at 2 for this goal):",
        help  = "Two-group comparisons assume exactly two groups."
      ),
      mean_kg = list(
        minN = 3, minK = 3, maxK = Inf, fixedK = NULL,
        label = "Number of groups (k ≥ 3):",
        help  = "ANOVA-type comparisons assume 3+ groups."
      ),
      paired = list(
        minN = 2, minK = 1, maxK = 1, fixedK = 1,
        label = "Number of groups (not used for paired designs):",
        help  = "Paired/repeated-measures designs don’t use a group count in the same way; set to 1."
      ),
      binary = list(
        minN = 2, minK = 2, maxK = Inf, fixedK = NULL,
        label = "Number of groups (k ≥ 2):",
        help  = "Binary outcomes often use 2 groups; 3+ groups is fine, but you should plan contrasts and avoid “all pairs” fishing."
      ),
      # Regression / correlation: groups are optional (stratification/subgroups)
      list(
        minN = 2, minK = 1, maxK = Inf, fixedK = NULL,
        label = "Number of groups (optional; used for per-group breakdowns):",
        help  = "Only relevant if you plan subgroup/stratified summaries; otherwise leave as 1."
      )
    )
  }
  
  observeEvent(list(input$analysis_goal, input$n_total, input$k_groups), {
    req(input$analysis_goal)
    
    goal  <- input$analysis_goal
    rules <- group_rules(goal)
    
    n_in <- as.integer(input$n_total %||% 2)
    k_in <- as.integer(input$k_groups %||% 1)
    
    if (is.na(n_in) || n_in < 2) n_in <- 2
    if (is.na(k_in) || k_in < 1) k_in <- 1
    
    n_min <- rules$minN %||% 2
    if (n_in < n_min) n_in <- n_min
    
    # keep UI min coherent (and correct value if needed)
    updateNumericInput(session, "n_total", min = n_min, value = n_in)
    
    minK  <- rules$minK %||% 1
    fixed <- rules$fixedK
    
    # never allow k > N (and avoid Inf in numericInput max)
    maxK_ui <- n_in
    k_out <- if (!is.null(fixed)) {
      fixed
    } else {
      max(minK, min(k_in, maxK_ui))
    }
    
    updateNumericInput(
      session, "k_groups",
      label = rules$label,
      min = minK,
      max = maxK_ui,
      value = k_out
    )
  }, ignoreInit = TRUE)
  
  output$k_groups_help <- renderUI({
    rules <- group_rules(input$analysis_goal)
    tags$div(class = "note", HTML(rules$help))
  })
  
  output$logo_ui <- renderUI({
    tags$img(
      src = "LabInfoS_logo.png",
      class = "brand-logo",
      alt = "LabInfoS logo",
      onerror = "this.onerror=null; this.style.display='none'; document.getElementById('logo_fallback').style.display='flex';"
    )
  })
  
  output$chips_ui <- renderUI({
    n <- input$n_total
    k <- max(1, input$k_groups)
    tg <- tier_from_n(n)
    per_group <- floor(n / k)
    
    chip1 <- tags$div(class = "chip", HTML(paste0("N: <strong>", n, "</strong>")))
    chip2 <- tags$div(class = "chip", HTML(paste0("Regime: <strong>", tg, "</strong>")))
    chip3 <- tags$div(class = "chip", HTML(paste0("Per-group (balanced): <strong>", per_group, "</strong>")))
    chip4 <- tags$div(class = "chip", HTML(paste0("Goal: <strong>", goal_label(input$analysis_goal), "</strong>")))
    
    tags$div(class = "chips", chip1, chip2, chip3, chip4)
  })
  
  # NEW: UI for study question section
  output$study_question_ui <- renderUI({
    q <- study_question_text(input$analysis_goal, input$k_groups)
    div(
      class = "study-q",
      tags$div(class = "label", "What are you trying to answer?"),
      tags$div(class = "question", HTML(paste0("<strong>", q, "</strong>")))
    )
  })
  
  output$advice <- renderUI({
    n  <- input$n_total
    k  <- max(1, input$k_groups)
    tg <- tier_from_n(n)
    per_group <- floor(n / k)
    
    paragraphs <- character()
    
    paragraphs <- c(
      paragraphs,
      paste0(
        "With total N = <strong>", n, "</strong>, you are in a <strong>", tg, "</strong> regime. ",
        "In this zone, feasibility is mostly driven by expected effect size, outcome noise, and how many parameters you try to estimate."
      ),
      paste0(
        "<strong>Effective N warning:</strong> the N you enter here is a headcount. ",
        "If observations are correlated (repeated measures, clustering by site/ward/family, batch effects), ",
        "the <em>effective</em> sample size can be meaningfully smaller, which reduces precision and power."
      ),
      alpha_power_text(input$alpha, input$target_power),
      paste0(
        "<strong>Common trap:</strong> α is not “the probability your finding is wrong.” It’s a long-run false-positive rate <em>under the null</em>. ",
        "If you run many tests, the chance of at least one false positive rises unless you pre-specify a primary analysis or control multiplicity."
      ),
      n_sensitivity_text(n, k)
    )
    
    if (input$analysis_goal == "mean_2g") {
      paragraphs <- c(
        paragraphs,
        paste0(
          "<strong>Two-group mean comparison:</strong> balanced allocation implies about <strong>", per_group, " per group</strong>. ",
          "Small per-group changes (e.g., 9→12 or 14→18) can noticeably change stability, assumption diagnostics, and plausibility of detecting anything but large effects."
        )
      )
      
      if (per_group < 10) {
        paragraphs <- c(paragraphs, "Per-group N < <strong>10</strong> is usually <strong>pilot territory</strong>. Prioritize estimation (effect size + CI), protocol refinement, and learning variance. Null results are ambiguous.")
      } else if (per_group < 15) {
        paragraphs <- c(paragraphs, "Per-group N around <strong>10–14</strong> can support a basic comparison if effects aren’t subtle and measurement is stable. Keep covariates minimal; avoid subgroup analyses.")
      } else if (per_group < 25) {
        paragraphs <- c(paragraphs, "Per-group N around <strong>15–24</strong> is often workable for t-tests/linear models. Small covariate adjustment can be reasonable if pre-specified.")
      } else {
        paragraphs <- c(paragraphs, "Per-group N ≥ <strong>25</strong> is typically comfortable for standard two-group workflows and more credible diagnostics. Modest adjustment is feasible; interaction testing should stay rare and motivated.")
      }
      
      note <- group_balance_note(n, k)
      if (!is.null(note)) paragraphs <- c(paragraphs, note)
    }
    
    if (input$analysis_goal == "mean_kg") {
      paragraphs <- c(
        paragraphs,
        paste0(
          "<strong>Multi-group mean comparison:</strong> with <strong>", k, "</strong> groups, balanced allocation implies about <strong>", per_group, " per group</strong>. ",
          "As groups increase, total N gets diluted, and post-hoc pairwise comparisons become especially underpowered."
        )
      )
      
      if (per_group < 10) {
        paragraphs <- c(paragraphs, "Per-group N < <strong>10</strong>: treat as exploratory/pilot. Global tests might run, but pairwise follow-ups are likely unstable.")
      } else if (per_group < 20) {
        paragraphs <- c(paragraphs, "Per-group N around <strong>10–19</strong>: plan contrasts up front instead of testing everything against everything.")
      } else {
        paragraphs <- c(paragraphs, "Per-group N ≥ <strong>20</strong>: ANOVA/linear-model approaches are more defensible, especially with pre-specified contrasts and disciplined multiplicity handling.")
      }
    }
    
    if (input$analysis_goal == "paired") {
      paragraphs <- c(
        paragraphs,
        "<strong>Paired/repeated measures:</strong> these designs can be efficient because each participant acts as their own control, especially when within-subject correlation is high and measurement noise is controlled."
      )
      
      if (n < 12) {
        paragraphs <- c(paragraphs, "With N < <strong>12</strong> paired units, focus on trajectories and estimation; tests can be very sensitive to outliers.")
      } else if (n < 25) {
        paragraphs <- c(paragraphs, "With N around <strong>12–24</strong>, paired t-tests or simple mixed models can be feasible if missingness is limited.")
      } else {
        paragraphs <- c(paragraphs, "With N ≥ <strong>25</strong>, mixed models become more reliable, but informativeness still depends on missingness and timepoint structure.")
      }
    }
    
    if (input$analysis_goal == "binary") {
      paragraphs <- c(paragraphs, "<strong>Binary outcomes:</strong> feasibility depends heavily on <strong>event counts</strong>. Same N, different event rates → different informativeness.",
                      "Key driver is <strong>number of events</strong> (and non-events), not N alone. Sparse events can cause <em>separation</em> and unstable odds ratios; penalized approaches (e.g., Firth) or simpler estimands may be more defensible.")
      
      if (n < 50) {
        paragraphs <- c(paragraphs, "With N < <strong>50</strong>, emphasize absolute risks + CIs. Rare events can make logistic regression unstable or fail.")
      } else if (n < 120) {
        paragraphs <- c(paragraphs, "With N around <strong>50–119</strong>, simple risk comparisons are often interpretable. Logistic regression can work for a small number of pre-specified predictors, depending on event counts.")
      } else {
        paragraphs <- c(paragraphs, "With N ≥ <strong>120</strong> (and adequate events), logistic regression becomes more stable and modest adjustment is more defensible.")
      }
      
      note <- group_balance_note(n, k)
      if (!is.null(note)) paragraphs <- c(paragraphs, note)
    }
    
    if (input$analysis_goal == "reg_assoc") {
      paragraphs <- c(paragraphs, "<strong>Explanatory regression:</strong> feasible when you keep predictors disciplined, avoid automated selection, and don’t ask the model to do interpretability and fishing at the same time.",
                      "Adjusted regression estimates <strong>associations conditional on the model</strong>; causal interpretation requires design and assumptions (confounding control, temporality, measurement validity), not just adding covariates.")
      
      if (n < 30) {
        paragraphs <- c(paragraphs, "With N < <strong>30</strong>, keep it extremely small (one main exposure + 1–2 essential covariates).")
      } else if (n < 80) {
        paragraphs <- c(paragraphs, "With N around <strong>30–79</strong>, modest adjustment can be fine, but every extra parameter costs stability. Interactions should be rare.")
      } else {
        paragraphs <- c(paragraphs, "With N ≥ <strong>80</strong>, adjusted models become more credible; non-linearity checks and a small number of interactions can be considered if strongly motivated.")
      }
      
      if (k > 1) {
        paragraphs <- c(paragraphs, paste0("If you stratify across <strong>", k, "</strong> groups, your effective per-group N is about <strong>", per_group, "</strong>, which often forces a simpler model within each stratum."))
      }
    }
    
    if (input$analysis_goal == "reg_pred") {
      paragraphs <- c(paragraphs, "<strong>Prediction modeling:</strong> needs enough data to fit and validate without fooling yourself. Performance estimates at small N are noisy and optimistic unless you’re careful.",
                      "At limited N, apparent performance is often <strong>optimistic</strong> (especially with model/feature tuning). Use resampling that includes the entire modelling pipeline (nested CV when tuning), report uncertainty, and prefer external validation when possible.")
      
      if (n < 60) {
        paragraphs <- c(paragraphs, "With N < <strong>60</strong>, treat this as prototyping. Keep models simple; use strong regularization; expect wide uncertainty.")
      } else if (n < 150) {
        paragraphs <- c(paragraphs, "With N around <strong>60–149</strong>, internal validation is possible but still noisy. Avoid high-dimensional feature sets unless regularization and leakage control are solid.")
      } else {
        paragraphs <- c(paragraphs, "With N ≥ <strong>150</strong>, prediction workflows become more defensible. Report calibration as well as discrimination.")
      }
    }
    
    if (input$analysis_goal == "correlation") {
      paragraphs <- c(paragraphs, "<strong>Correlation:</strong> at small N it’s volatile and easily distorted by outliers and restricted range. Visual checks are not optional.",
                      "Report <strong>r</strong> with a confidence interval (e.g., via Fisher z), because sampling variability is large at small N; a single p-value can hide that uncertainty.")
      
      if (n < 20) {
        paragraphs <- c(paragraphs, "With N < <strong>20</strong>, prioritize scatterplots and uncertainty intervals. Treat hypothesis tests as fragile.")
      } else if (n < 50) {
        paragraphs <- c(paragraphs, "With N around <strong>20–49</strong>, Pearson/Spearman tests can be used, but effect estimates are still noisy. Consider sensitivity to outliers.")
      } else {
        paragraphs <- c(paragraphs, "With N ≥ <strong>50</strong>, correlation estimates stabilize and partial correlation becomes more plausible (with a small number of covariates).")
      }
      
      if (k > 1) {
        paragraphs <- c(paragraphs, paste0("If you compute correlations within each of <strong>", k, "</strong> groups, per-group N is about <strong>", per_group, "</strong>, which can drastically increase uncertainty."))
      }
    }
    
    if (isTRUE(input$allow_nonparametric)) {
      paragraphs <- c(paragraphs, "<span class='note'><strong>Non-parametric / resampling:</strong> often improves robustness to assumption violations, but it doesn’t compensate for too few observations or too many model parameters.</span>")
    }
    
    tagList(lapply(paragraphs, function(x) tags$p(HTML(x))))
  })
  
  output$summary <- renderText({
    n <- input$n_total
    k <- max(1, input$k_groups)
    per_group <- floor(n / k)
    beta <- 1 - input$target_power
    
    paste(
      sprintf("Total N: %d", n),
      sprintf("Primary analysis goal: %s", goal_label(input$analysis_goal)),
      sprintf("Groups (k): %d", k),
      sprintf("Approx per-group N (balanced): %d", per_group),
      sprintf("Alpha (Type I error rate under null): %.3f", input$alpha),
      sprintf("Target power: %.2f  (Beta = %.2f Type II error under assumed alternative)", input$target_power, beta),
      sep = "\n"
    )
  })
  
  output$alphaPowerNote <- renderUI({
    alpha <- input$alpha
    power <- input$target_power
    delta <- implied_delta(alpha, power)
    
    tags$p(
      class = "note",
      HTML(paste0(
        "Illustrative plot (two-sided Z test, unit variance). The curve shift <strong>Δ</strong> is chosen so the shaded <strong>power</strong> matches your target at the selected <strong>α</strong> (not derived from your N). ",
        "<br/>",
        "<br/>Current: α = ", sprintf("%.3f", alpha),
        ", target power = ", sprintf("%.2f", power),
        ", implied Δ ≈ ", sprintf("%.2f", delta), "."
      ))
    )
  })
  
  output$alphaPowerPlot <- renderPlot({
    alpha <- input$alpha
    target_power <- input$target_power
    
    zcrit <- qnorm(1 - alpha / 2)
    delta <- implied_delta(alpha, target_power)
    
    x_min <- min(-4.5, delta - 4.5)
    x_max <- max(4.5,  delta + 4.5)
    x <- seq(x_min, x_max, length.out = 1200)
    
    d0 <- dnorm(x, mean = 0, sd = 1)
    d1 <- dnorm(x, mean = delta, sd = 1)
    
    shade_under_curve <- function(x, y, idx, col) {
      xs <- x[idx]
      ys <- y[idx]
      if (length(xs) < 2) return()
      polygon(
        x = c(xs, rev(xs)),
        y = c(rep(0, length(xs)), rev(ys)),
        border = NA,
        col = col
      )
    }
    
    col_alpha <- rgb(220, 38, 38,  alpha = 70, maxColorValue = 255)
    col_power <- rgb(14, 165, 164, alpha = 60, maxColorValue = 255)
    col_beta  <- rgb(107, 114, 128, alpha = 60, maxColorValue = 255)
    
    op <- par(no.readonly = TRUE)
    on.exit(par(op), add = TRUE)
    
    # Two rows: plot + legend band
    layout(matrix(c(1, 2), ncol = 1), heights = c(5, 1.0))
    
    # ---- Panel 1: the plot ----
    par(mar = c(1.5, 2.6, 2.2, 0.6), mgp = c(1.6, 0.35, 0))
    
    plot(
      x, d0,
      type = "n",
      xlab = "",
      ylab = "Density",
      main = "Alpha and power (illustration)",
      ylim = c(0, max(d0, d1) * 1.18)
    )
    
    shade_under_curve(x, d0, x <= -zcrit, col_alpha)
    shade_under_curve(x, d0, x >=  zcrit, col_alpha)
    
    shade_under_curve(x, d1, x > -zcrit & x < zcrit, col_beta)
    shade_under_curve(x, d1, x <= -zcrit, col_power)
    shade_under_curve(x, d1, x >=  zcrit, col_power)
    
    lines(x, d0, lwd = 2)
    lines(x, d1, lwd = 2, lty = 2)
    abline(v = c(-zcrit, zcrit), lty = 3)
    
    # ---- Panel 2: legend only (3 centered lines) ----
    par(mar = c(0, 0, 0, 0))
    plot.new()
    par(xpd = NA)
    
    # Line 1: H0 / H1
    legend(
      x = 0.5, y = 0.78, xjust = 0.5, yjust = 0.5,
      legend = c("H0", "H1 (shifted)"),
      lty = c(1, 2),
      lwd = c(2, 2),
      col = c("black", "black"),
      bty = "n",
      cex = 0.7,
      ncol = 2,
      x.intersp = 0.6,
      seg.len = 0.9
    )
    
    # Filled-square style for shaded areas
    fill_cols <- c(
      rgb(220, 38, 38,  maxColorValue = 255),  # alpha
      rgb(14, 165, 164, maxColorValue = 255),  # power
      rgb(107, 114, 128, maxColorValue = 255)  # beta
    )
    
    # Line 2: alpha / power (FILLED)
    legend(
      x = 0.5, y = 0.42, xjust = 0.5, yjust = 0.5,
      legend = c("α (H0)", "Power (H1)"),
      pch = c(22, 22),
      pt.cex = 1.0,
      pt.bg = fill_cols[1:2],
      col = "black",          # border color for squares + text color
      bty = "n",
      cex = 0.7,
      ncol = 2,
      x.intersp = 0.6
    )
    
    # Line 3: beta (FILLED)
    legend(
      x = 0.5, y = 0.12, xjust = 0.5, yjust = 0.5,
      legend = c("β (H1)"),
      pch = 22,
      pt.cex = 1.0,
      pt.bg = fill_cols[3],
      col = "black",
      bty = "n",
      cex = 0.7,
      ncol = 1
    )
    
    par(xpd = FALSE)
    
  })
  
}

shinyApp(ui, server)
