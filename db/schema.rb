# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "administrators", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "phone"
    t.string "department"
    t.string "university"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.index ["confirmation_token"], name: "index_administrators_on_confirmation_token", unique: true
    t.index ["email"], name: "index_administrators_on_email", unique: true
    t.index ["reset_password_token"], name: "index_administrators_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_administrators_on_unlock_token", unique: true
  end

  create_table "answers", id: :serial, force: :cascade do |t|
    t.integer "response_id"
    t.integer "question_id"
    t.string "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_answers_on_question_id"
    t.index ["response_id", "question_id"], name: "index_answers_on_response_id_and_question_id", unique: true
    t.index ["response_id"], name: "index_answers_on_response_id"
  end

  create_table "courses", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "semester"
    t.string "section"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "faculty_id"
    t.index ["faculty_id"], name: "index_courses_on_faculty_id"
  end

  create_table "courses_students", id: false, force: :cascade do |t|
    t.bigint "course_id", null: false
    t.bigint "student_id", null: false
    t.index ["course_id", "student_id"], name: "index_courses_students_on_course_id_and_student_id", unique: true
  end

  create_table "faculties", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "phone"
    t.string "department"
    t.string "university"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "administrator_id"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.boolean "approved", default: false, null: false
    t.index ["administrator_id"], name: "index_faculties_on_administrator_id"
    t.index ["confirmation_token"], name: "index_faculties_on_confirmation_token", unique: true
    t.index ["email"], name: "index_faculties_on_email", unique: true
    t.index ["reset_password_token"], name: "index_faculties_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_faculties_on_unlock_token", unique: true
  end

  create_table "questions", id: :serial, force: :cascade do |t|
    t.string "content"
    t.integer "priority"
    t.integer "survey_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["survey_id"], name: "index_questions_on_survey_id"
  end

  create_table "responses", id: :serial, force: :cascade do |t|
    t.integer "survey_id"
    t.integer "student_id"
    t.boolean "completed", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["student_id"], name: "index_responses_on_student_id"
    t.index ["survey_id", "student_id"], name: "index_responses_on_survey_id_and_student_id", unique: true
    t.index ["survey_id"], name: "index_responses_on_survey_id"
  end

  create_table "students", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.string "student_id"
    t.string "university"
    t.index ["confirmation_token"], name: "index_students_on_confirmation_token", unique: true
    t.index ["email"], name: "index_students_on_email", unique: true
    t.index ["reset_password_token"], name: "index_students_on_reset_password_token", unique: true
    t.index ["student_id", "university"], name: "index_students_on_student_id_and_university", unique: true
    t.index ["unlock_token"], name: "index_students_on_unlock_token", unique: true
  end

  create_table "students_teams", id: false, force: :cascade do |t|
    t.bigint "student_id", null: false
    t.bigint "team_id", null: false
    t.index ["student_id", "team_id"], name: "index_students_teams_on_student_id_and_team_id", unique: true
  end

  create_table "surveys", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "course_id"
    t.index ["course_id"], name: "index_surveys_on_course_id"
  end

  create_table "teams", id: :serial, force: :cascade do |t|
    t.integer "survey_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "released", default: false
    t.index ["id", "survey_id"], name: "index_teams_on_id_and_survey_id", unique: true
    t.index ["survey_id"], name: "index_teams_on_survey_id"
  end

  add_foreign_key "answers", "questions"
  add_foreign_key "answers", "responses"
  add_foreign_key "courses", "faculties"
  add_foreign_key "faculties", "administrators"
  add_foreign_key "questions", "surveys"
  add_foreign_key "responses", "students"
  add_foreign_key "responses", "surveys"
  add_foreign_key "surveys", "courses"
  add_foreign_key "teams", "surveys"
end
