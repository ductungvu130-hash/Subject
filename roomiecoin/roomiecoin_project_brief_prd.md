# Project Brief: RoomieCoin

## 1. Project Overview
**RoomieCoin** is an AI-enhanced expense management and household coordination platform designed specifically for roommates. It simplifies the complexities of shared living by providing a centralized hub for tracking shared costs, settling debts, managing household chores, and maintaining room information.

## 2. Target Audience
- University students sharing apartments.
- Young professionals living in shared houses.
- Small groups managing collective funds for shared activities.

## 3. Core Features & Functional Requirements

### 3.1. Expense Management
- **Add Expense**: Users can log new expenses with details like amount, description, category, and date.
- **Bill Upload**: Supports drag-and-drop file uploads for invoices/receipts with preview functionality.
- **Split Logic**: Automated splitting of costs among roommates (equal split or custom).
- **Expense History**: A comprehensive table view of all past transactions with filtering by month, category, and payer.

### 3.2. Financial Overview & Analytics
- **Dashboard**: High-level summary of total monthly spending, individual balances, and settlement status.
- **Spending Distribution**: Visual breakdown of expenses by category (Food, Utilities, Rent, etc.) using interactive charts.
- **Recent Activity**: A chronological feed of the latest financial and chore-related events.

### 3.3. Debt Settlement
- **Settle Up**: A dedicated interface to view outstanding debts and initiate payments.
- **QR Payment**: Generation of payment QR codes for quick, error-free bank transfers or e-wallet payments.

### 3.4. Household Coordination
- **Chore Management (Việc nhà)**: A Kanban-style board for tracking household tasks (To Do, Done). Includes urgency labels and assigned roommates.
- **Room Management (Phòng của bạn)**: View room details, member list, and role assignments (e.g., Room Lead).
- **Member Invitation**: Invite new members via unique IDs or room codes.

### 3.5. User Profile & Settings
- **Personal Profile**: Manage user information (Avatar, Name) and view individual identification IDs.
- **Notifications**: System alerts for new expenses, chore reminders, and settlement requests.
- **System Settings**: Global app configurations and account management.

## 4. Visual Identity & Design System

### 4.1. Color Palette
- **Primary**: Corporate Blue (#003d9b) - Used for primary actions, branding, and active states.
- **Secondary/Accent**: Golden Yellow (#ffd700 / #feaa00) - Used for warnings, highlighted status, and brand accents.
- **Background**: Neutral Light (#f9f9ff) - Ensuring a clean, minimalist aesthetic.
- **Surface**: Pure White (#ffffff) - Used for cards and containers to create depth.

### 4.2. Typography
- **Headlines**: Hanken Grotesk - Modern, bold, and highly readable.
- **Body & Labels**: Hanken Grotesk & JetBrains Mono (for metadata/labels) - Professional and clean.

### 4.3. Key UI Components
- **Global Sidebar**: A fixed navigation menu containing: Overview, Room Info, Add Expense, Settle Up, History, Chores, and Profile.
- **Top Navigation Bar**: Features a global search bar, notification/settings shortcuts, and user avatar with name.
- **Unified Branding**: Minimalist "Piggy Bank & Coin" logo integrated consistently across all headers.

## 5. Technology Stack (Frontend)
- **Framework**: HTML5 & Vanilla JavaScript.
- **Styling**: Tailwind CSS (Utility-first approach).
- **Icons**: Material Symbols Outlined.
- **Interactions**: CSS Transitions & DOM-based JavaScript logic for state management (Modals, Kanban updates, etc.).

## 6. Roadmap & Future Enhancements
- **Debt Simplification Algorithm**: To minimize the number of transactions needed to settle all debts.
- **Mobile Native App**: Porting the existing mobile-optimized designs to a native environment.
- **Shared Shopping List**: Integrated with the expense engine.
- **Dark Mode**: High-contrast theme for night-time usage.