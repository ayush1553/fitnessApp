# FitFlow Pro — Online Fitness Tracking & Progress Management Application

An enterprise-grade **Java Web Application** built following classic layered architecture with **Jakarta Servlets**, **JSP**, **JDBC**, **MySQL**, and a dark SaaS fitness analytics dashboard inspired by modern fitness trackers.

---

## 🌟 Visual Theme & Design Language
- **Background Palette**: Charcoal / Deep Dark (`#080909`, `#101211`, `#151817`)
- **Accent Color**: High-Visibility Bright Lime Green (`#C8FF45`)
- **Typography**: Plus Jakarta Sans
- **Visual Features**: Rounded cards, subtle border dividers (`#252925`), circular progress indicators, real-time Chart.js visual analytics, compact responsive sidebar, and custom modals.

---

## 🏛️ System Architecture & Marking Rubric Compliance

### 1. Problem Understanding & Solution Design (8 Marks)
- **Role-Based Access Control**: Strict segregation between `USER` and `ADMIN` personas.
- **Layered Architecture**:
  $$\text{JSP View} \longleftrightarrow \text{Jakarta Servlets (Controllers)} \longleftrightarrow \text{Service Layer} \longleftrightarrow \text{DAO Layer} \longleftrightarrow \text{JDBC PreparedStatement} \longleftrightarrow \text{MySQL 8.0+}$$
- **Modular Design**: Dedicated packages for `model`, `dao`, `service`, `servlet`, `filter`, `exception`, and `util`.

### 2. Core Java Concepts (10 Marks)
- **Encapsulation**: Private fields, strict accessors, encapsulated state in domain models.
- **Inheritance**:
  - `BaseEntity` $\rightarrow$ `User`, `UserProfile`, `Workout`, `Goal`, `Challenge`, `ChallengeParticipant`, `FitnessContent`
  - `User` $\rightarrow$ `RegularUser`, `AdminUser`
  - `FitnessActivity` $\rightarrow$ `RunningActivity`, `CyclingActivity`, `GymActivity`, `SwimmingActivity`, `YogaActivity`
- **Polymorphism & Strategy**: Dynamic calorie calculation via polymorphic `FitnessActivity.calculateCalories(duration, weightKg, intensity)`.
- **Interfaces**: `GenericDAO<T, ID>`, `UserDAO`, `WorkoutDAO`, `GoalDAO`, `ChallengeDAO`, `UserService`, `WorkoutService`, `GoalService`, `ChallengeService`, `AnalyticsService`.
- **Generics**: Generic data access layer with type-safe operations.
- **Collections & Streams**: `List<T>`, `Map<K, V>`, `LinkedHashMap<String, Integer>`, and aggregation collectors.
- **Exception Handling**: Custom exception hierarchy rooted at `AppException` (`UserNotFoundException`, `InvalidWorkoutException`, `UnauthorizedException`, `DuplicateResourceException`, `DatabaseException`).

### 3. Database Integration (JDBC) (8 Marks)
- **Database Engine**: MySQL 8.0+
- **PreparedStatement**: 100% parameter binding for query security against SQL injection.
- **Connection Management**: `DBConnection.java` with HikariCP connection pooling and fallback `DriverManager`.
- **Clean Resource Management**: Try-with-resources and explicit closing of `ResultSet`, `Statement`, and `Connection`.

### 4. Servlets & Web Integration (7 Marks)
- **Servlets**: Jakarta `@WebServlet` annotations handling `GET` and `POST` lifecycle.
- **Session Management**: `HttpSession` storage for authenticated users, session timeout in `web.xml`, flash messaging.
- **Security Filters**: `AuthFilter` for `/user/*`, `AdminAuthFilter` for `/admin/*`, `EncodingFilter` for UTF-8.
- **JSP & JSTL**: Modern JSTL tag library (`c:forEach`, `c:if`, `c:choose`, `fmt:formatDate`, `fmt:formatNumber`) with zero scriptlet clutter.

---

## 🗄️ Database Tables (`fitness_tracker_db`)

| Table Name | Description | Key Relationships |
| :--- | :--- | :--- |
| `users` | User credentials, roles (`USER`/`ADMIN`), status | Core identity table |
| `profiles` | User biometrics (age, height, weight, BMI, goal) | `1:1` with `users.id` |
| `workouts` | Individual logged exercise sessions | `M:1` with `users.id` |
| `goals` | Personal user targets & milestones | `M:1` with `users.id` |
| `challenges` | Global fitness community challenges | Central challenge entity |
| `challenge_participants` | Enrolled members & milestone progress | Unique `(user_id, challenge_id)` |
| `fitness_content` | Community guides & routines | `M:1` with `users.id` |
| `system_settings` | Dynamic runtime configurations | Key-value store |
| `activity_logs` | Comprehensive system audit trail | `M:1` with `users.id` |

---

## 🔑 Sample Development Credentials

| Role | Email | Password | Access Level |
| :--- | :--- | :--- | :--- |
| **Admin** | `admin@fitnesstracker.com` | `admin123` | Full Administrator Portal & Settings |
| **User** | `adam.sterling@example.com` | `user123` | Member Dashboard with Active Workouts |
| **User** | `sarah.connor@example.com` | `user123` | Member Dashboard |
| **User** | `marcus.vance@example.com` | `user123` | Member Dashboard |

---

## 🚀 Setup & Execution Guide

### Prerequisites
1. **Java Development Kit (JDK 17 or higher)**
2. **Apache Maven 3.8+**
3. **MySQL Server 8.0+**
4. **Apache Tomcat 10.1+** (Supports Jakarta EE / Servlet 5.0/6.0)

### Step 1: Database Setup
1. Open your MySQL client (MySQL Workbench, phpMyAdmin, or terminal CLI).
2. Execute the schema script located at:
   ```bash
   mysql -u root -p < database/schema.sql
   ```
3. This creates the database `fitness_tracker_db` and seeds all tables with realistic sample data.

### Step 2: Configure Database Connection
If your MySQL password or port differs from default (`root` / empty password on `localhost:3306`), update:
`src/main/resources/db.properties`
```properties
db.url=jdbc:mysql://localhost:3306/fitness_tracker_db?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true&characterEncoding=UTF-8
db.user=root
db.password=YOUR_PASSWORD_HERE
```
*(You can also set environment variables `FITNESS_DB_URL`, `FITNESS_DB_USER`, `FITNESS_DB_PASSWORD`).*

### Step 3: Build the Project
Open terminal in the project root directory and run:
```bash
mvn clean package
```
This will compile the Java source files and generate `target/fitness-tracker.war`.

### Step 4: Deploy to Apache Tomcat
1. Copy `target/fitness-tracker.war` to your Tomcat `webapps/` folder:
   - On Windows: `C:\Program Files\Apache Software Foundation\Tomcat 10.1\webapps\`
   - On Linux/macOS: `/opt/tomcat/webapps/`
2. Start Tomcat using `bin/startup.bat` (Windows) or `bin/startup.sh` (Linux/macOS).
3. Access the web application in your browser:
   ```
   http://localhost:8080/fitness-tracker/
   ```

---

## 📁 Project Structure

```
fitness-tracker/
├── database/
│   └── schema.sql
├── src/
│   └── main/
│       ├── java/
│       │   └── com/fitnesstracker/
│       │       ├── config/
│       │       │   └── DBConnection.java
│       │       ├── exception/
│       │       ├── model/
│       │       ├── dao/
│       │       │   └── impl/
│       │       ├── service/
│       │       │   └── impl/
│       │       ├── servlet/
│       │       │   ├── auth/
│       │       │   ├── user/
│       │       │   └── admin/
│       │       ├── filter/
│       │       └── util/
│       ├── resources/
│       │   └── db.properties
│       └── webapp/
│           ├── css/
│           ├── js/
│           ├── includes/
│           ├── user/
│           ├── admin/
│           ├── WEB-INF/
│           │   └── web.xml
│           ├── index.jsp
│           ├── login.jsp
│           ├── register.jsp
│           ├── error.jsp
│           └── 404.jsp
├── pom.xml
└── README.md
```
