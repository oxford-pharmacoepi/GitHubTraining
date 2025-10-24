library(gh)
library(purrr)
library(readr)
library(dplyr)
library(glue)
library(purrr)

disease <- c(
  "Asthma", "Common cold", "Influenza", "COVID-19", "Pneumonia", "Tuberculosis",
  "Bronchitis", "COPD", "Type 2 diabetes", "Type 1 diabetes", "Hypertension",
  "Coronary artery disease", "Heart failure", "Myocardial infarction", "Stroke",
  "Alzheimer's disease", "Parkinson's disease", "Epilepsy", "Multiple sclerosis",
  "Rheumatoid arthritis", "Systemic lupus erythematosus", "Osteoarthritis",
  "Chronic kidney disease", "Cirrhosis", "Hepatitis B", "Hepatitis C", "Malaria",
  "HIV/AIDS", "Leukemia", "Breast cancer", "Prostate cancer", 
  "Lung cancer", "Pancreatic cancer", "Stomach cancer", "Cervical cancer",
  "Skin cancer", "Depression", "Anxiety disorder", "Schizophrenia",
  "Bipolar disorder", "Obesity", "Gout", "Peptic ulcer disease",
  "Gallstones", "Appendicitis", "Migraine", "Glaucoma", "Cataract",
  "Psoriasis", "Eczema"
)
users <- c("catalamarti", "cecicampanile", "ajoedicke")

step1 <- list(
  title = "Create a codelist of {disease}",
  body = "Create a codelist of **{disease}**, you can follow this steps to make sure you don't miss anything:\n
  - [ ] Make sure you are in *your branch*
  - [ ] Make sure *your branch* is updated from main
  - [ ] Create the codelist that you are asked to create (use CodelistGenerator functions, `getCandidateCodes()`)
  - [ ] Save it in the codelist folder
  - [ ] Commit
  - [ ] Push
  - [ ] Open a Pull Request and link the Pull Request to the issue"
)
step2 <- list(
  title = "Create a concept set expression of {disease}",
  body = "Create a concept set expression of **{disease}**, you can follow this steps to make sure you don't miss anything:\n
  - [ ] Make sure you are in *your branch*
  - [ ] Make sure *your branch* is updated from main.
  - [ ] Go to *ATLAS* and create the concept set expression
  - [ ] Export the json file from ATLAS and save it locally (copy paste)
  - [ ] Import the json file
  - [ ] Save the concept set expression as csv in the conceptsets folder
  - [ ] Delete the json file
  - [ ] Commit
  - [ ] Push
  - [ ] Open a Pull Request and link the Pull Request to the issue
  - [ ] Ask for a review of @{reviewer}"
)
step3 <- list(
  title = "Convert the concept set of {disease} and covert it to codelist",
  body = "Create a concept set expression of **{disease}**, you can follow this steps to make sure you don't miss anything:\n
  - [ ] Make sure you are in *your branch*
  - [ ] Make sure *your branch* is updated from main.
  - [ ] Import the concept set expression
  - [ ] Convert it into a `codelist` (use `validateConceptSetArgument()`)
  - [ ] Export as csv in the `codelist` folder
  - [ ] Commit
  - [ ] Push
  - [ ] Open a Pull Request and link the Pull Request to the issue"
)

disCodelist <- sample(x = disease, size = length(users))
disConceptSet <- sample(x = setdiff(disease, disCodelist), size = length(users))
s1 <- tibble(
  assignee = users,
  disease = disCodelist,
  label = "STEP 1"
)
s2 <- tibble(
  assignee = users,
  disease = disConceptSet,
  reviewer = c(users[-1], users[1]),
  label = "STEP 2"
)
s3 <- tibble(
  assignee = users,
  disease = c(disConceptSet[-(1:2)], disConceptSet[1:2]),
  label = "STEP 3"
)
bind_rows(s1, s2, s3) |>
  pmap(\(step, assignee, disease, label, reviewer) {
    temp <- switch (label, "STEP 1" = step1, "STEP 2" = step2, "STEP 3" = step3)
    body <- glue(temp$body)
    title <- glue(temp$title)
    params <- list(title = title, body = body, assignees = list(assignee), labels = list(label))
    gh("POST /repos/oxford-pharmacoepi/TestRepository/issues", .params = params)
  })
