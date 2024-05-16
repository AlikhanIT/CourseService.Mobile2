class Endpoints {
  static const register = '/api/User/register';
  static const login = '/api/User/authenticate';
  static const refresh = '/api/User/authenticate';
  static const validate = '/api/User/authenticate';
  static const userInfo = '/api/User/info';

  static const testRoute = '/api/Courses/test-route';
  static const countries = '/api/Courses/countries';
  static const clearCache = '/api/Courses/clear-cache';
  static const checkLanguage = '/api/Courses/check-language';
  static const createCourse = '/api/Courses/create-course/{courseName}';
  static const addCourse = '/api/Courses/add-course/{userId}/{courseId}';
  static const userCourses = '/api/Courses/user-course/{userId}';
  static const courseDetails = '/api/Courses/course-details/{id}';
}