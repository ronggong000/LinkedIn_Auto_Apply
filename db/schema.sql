-- Initial SQL draft for Seek Auto Apply Accelerator
-- PostgreSQL 14+

CREATE TABLE users (
  id UUID PRIMARY KEY,
  email VARCHAR(255) UNIQUE NOT NULL,
  full_name VARCHAR(255) NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE profiles (
  id UUID PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  phone VARCHAR(50),
  location VARCHAR(255),
  work_rights_status VARCHAR(100),
  visa_type VARCHAR(100),
  sponsorship_required BOOLEAN,
  expected_salary_min NUMERIC(12,2),
  expected_salary_max NUMERIC(12,2),
  salary_currency VARCHAR(10) DEFAULT 'AUD',
  notice_period_days INTEGER,
  available_from DATE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE experiences (
  id UUID PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  company_name VARCHAR(255) NOT NULL,
  role_title VARCHAR(255) NOT NULL,
  start_date DATE,
  end_date DATE,
  is_current BOOLEAN NOT NULL DEFAULT FALSE,
  summary TEXT,
  achievements JSONB,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE education (
  id UUID PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  institution VARCHAR(255) NOT NULL,
  degree VARCHAR(255),
  field_of_study VARCHAR(255),
  start_date DATE,
  end_date DATE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE skills (
  id UUID PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  skill_name VARCHAR(255) NOT NULL,
  proficiency_level VARCHAR(50),
  years_experience NUMERIC(4,1),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (user_id, skill_name)
);

CREATE TABLE base_resumes (
  id UUID PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  file_name VARCHAR(255) NOT NULL,
  file_url TEXT NOT NULL,
  parsed_content JSONB,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE job_posts (
  id UUID PRIMARY KEY,
  source_platform VARCHAR(50) NOT NULL DEFAULT 'seek',
  source_url TEXT,
  company_name VARCHAR(255),
  role_title VARCHAR(255),
  location VARCHAR(255),
  raw_description TEXT,
  parsed_requirements JSONB,
  parsed_responsibilities JSONB,
  parsed_keywords JSONB,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE generated_documents (
  id UUID PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  job_post_id UUID REFERENCES job_posts(id) ON DELETE SET NULL,
  doc_type VARCHAR(50) NOT NULL, -- resume / cover_letter
  file_format VARCHAR(20) NOT NULL, -- pdf / docx / md
  file_url TEXT NOT NULL,
  llm_model VARCHAR(100),
  prompt_version VARCHAR(50),
  content_json JSONB,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE applications (
  id UUID PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  job_post_id UUID REFERENCES job_posts(id) ON DELETE SET NULL,
  status VARCHAR(50) NOT NULL DEFAULT 'draft', -- draft/reviewed/submitted/failed
  submitted_at TIMESTAMPTZ,
  resume_document_id UUID REFERENCES generated_documents(id) ON DELETE SET NULL,
  cover_letter_document_id UUID REFERENCES generated_documents(id) ON DELETE SET NULL,
  notes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE question_answers (
  id UUID PRIMARY KEY,
  application_id UUID NOT NULL REFERENCES applications(id) ON DELETE CASCADE,
  question_text TEXT NOT NULL,
  normalized_key VARCHAR(100),
  answer_text TEXT,
  answer_type VARCHAR(30), -- text/single_choice/multi_choice/number
  confidence_score NUMERIC(4,3),
  requires_human_review BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_profiles_user_id ON profiles(user_id);
CREATE INDEX idx_experiences_user_id ON experiences(user_id);
CREATE INDEX idx_education_user_id ON education(user_id);
CREATE INDEX idx_skills_user_id ON skills(user_id);
CREATE INDEX idx_base_resumes_user_id ON base_resumes(user_id);
CREATE INDEX idx_generated_documents_user_id ON generated_documents(user_id);
CREATE INDEX idx_generated_documents_job_post_id ON generated_documents(job_post_id);
CREATE INDEX idx_applications_user_id ON applications(user_id);
CREATE INDEX idx_applications_job_post_id ON applications(job_post_id);
CREATE INDEX idx_question_answers_application_id ON question_answers(application_id);

