require 'httparty'

#query_params = {"wstoken" => "6119349a84160e607330feba4cb1299d", "moodlewsrestformat" => "json"}
query_params = {"wstoken" => "moodle_webservices_token", "moodlewsrestformat" => "json"}

#query_params_to_merge=query_params.merge({"wsfunction" => "core_webservice_get_site_info"})

#query_params_to_merge=query_params.merge({"wsfunction" => "core_course_get_contents", "courseid" => "2"})

query_params_to_merge=query_params.merge({"wsfunction" => "core_course_get_courses"})

#query_params_to_merge=query_params.merge({"wsfunction" => "core_course_get_course_content_items", "courseid" => "2"})

puts query_params_to_merge

response = HTTParty.get("http://localhost/moodle/webservice/rest/server.php", :query => query_params_to_merge)
#response = HTTParty.get("http://test.pan-learning.org/moodle/webservice/rest/server.php", :query => query_params_to_merge)

puts response.code

puts JSON.pretty_generate(response.parsed_response)
