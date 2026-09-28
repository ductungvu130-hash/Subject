---
name: SportHub
colors:
  surface: '#f7f9fb'
  surface-dim: '#d8dadc'
  surface-bright: '#f7f9fb'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f2f4f6'
  surface-container: '#eceef0'
  surface-container-high: '#e6e8ea'
  surface-container-highest: '#e0e3e5'
  on-surface: '#191c1e'
  on-surface-variant: '#3d4a3d'
  inverse-surface: '#2d3133'
  inverse-on-surface: '#eff1f3'
  outline: '#6d7b6c'
  outline-variant: '#bccbb9'
  surface-tint: '#006e2f'
  primary: '#006e2f'
  on-primary: '#ffffff'
  primary-container: '#22c55e'
  on-primary-container: '#004b1e'
  inverse-primary: '#4ae176'
  secondary: '#3755c3'
  on-secondary: '#ffffff'
  secondary-container: '#708cfd'
  on-secondary-container: '#00217a'
  tertiary: '#9d4300'
  on-tertiary: '#ffffff'
  tertiary-container: '#ff8e4d'
  on-tertiary-container: '#6d2d00'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#6bff8f'
  primary-fixed-dim: '#4ae176'
  on-primary-fixed: '#002109'
  on-primary-fixed-variant: '#005321'
  secondary-fixed: '#dde1ff'
  secondary-fixed-dim: '#b8c4ff'
  on-secondary-fixed: '#001453'
  on-secondary-fixed-variant: '#173bab'
  tertiary-fixed: '#ffdbca'
  tertiary-fixed-dim: '#ffb690'
  on-tertiary-fixed: '#341100'
  on-tertiary-fixed-variant: '#783200'
  background: '#f7f9fb'
  on-background: '#191c1e'
  surface-variant: '#e0e3e5'
typography:
  display-lg:
    fontFamily: Inter
    fontSize: 44px
    fontWeight: '700'
    lineHeight: 52px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Inter
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
  headline-lg-mobile:
    fontFamily: Inter
    fontSize: 28px
    fontWeight: '700'
    lineHeight: 36px
  title-lg:
    fontFamily: Inter
    fontSize: 22px
    fontWeight: '600'
    lineHeight: 28px
  body-lg:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  label-lg:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
    letterSpacing: 0.1px
  label-sm:
    fontFamily: Inter
    fontSize: 11px
    fontWeight: '500'
    lineHeight: 16px
    letterSpacing: 0.5px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  base: 4px
  xs: 8px
  sm: 12px
  md: 16px
  lg: 24px
  xl: 32px
  gutter: 16px
  margin-mobile: 20px
---

## Brand & Style
The brand personality is high-energy, professional, and premium, designed to bridge the gap between casual athletes and elite sporting facilities. The UI leverages **Material Design 3 (MD3)** principles to ensure a systematic and accessible experience while injecting a "dynamic" spirit through high-contrast accents and fluid motion.

The design style is **Corporate / Modern** with a focus on high-performance utility. It utilizes tonal surfaces and clean white space to maintain a premium feel, ensuring that the interface never feels cluttered despite the data-heavy nature of sports bookings. The emotional response should be one of motivation, reliability, and speed—reflecting the "get up and go" nature of sports.

## Colors
The palette is rooted in the "Turf & Stadium" aesthetic. **Vibrant Green** serves as the primary action color, symbolizing energy and the field of play. **Deep Sporty Blue** provides a grounded, professional contrast used for secondary actions and navigation elements.

- **Primary (#22C55E):** Used for main CTA buttons, active states, and success indicators.
- **Secondary (#1E40AF):** Used for headers, selection chips, and reinforcing the professional "club" feel.
- **Surface & Background:** The main background is pure `#FFFFFF`. Tonal surfaces for cards and containers use `#F8FAFC` to create soft distinction without adding visual noise.
- **Accent/Tertiary:** A subtle splash of Orange (#F97316) is reserved for urgent notifications or "Hot" booking slots.

## Typography
This design system utilizes **Inter** for its exceptional legibility and modern, systematic appearance. The type hierarchy is strictly defined to handle Vietnamese diacritics without overlapping or vertical crowding.

- **Headlines:** Use Bold weights (700) with slight negative letter-spacing for a compact, impactful look suitable for sports headlines.
- **Body:** Standard weights (400) ensure readability for facility descriptions and terms of service.
- **Labels:** Semi-bold weights (600) are used for buttons and category chips to ensure they stand out as interactive elements.
- **Language Support:** All scales are optimized for Vietnamese (Tiếng Việt), ensuring line-heights accommodate taller character stacks (e.g., "ể", "ổ").

## Layout & Spacing
The layout follows a **Fluid Grid** model optimized for mobile-first interaction. 

- **Grid System:** A 4-column grid for mobile with 16px gutters. 
- **Margins:** 20px safe-area margins on the left and right of the screen to prevent "edge-clutter."
- **Rhythm:** An 8px linear scale is used for vertical rhythm, while 4px increments are used for internal component padding.
- **Mobile Optimization:** Bottom-sheet patterns are preferred for facility filters and time-slot selections to ensure one-handed usability (thumb-zone optimization).

## Elevation & Depth
In alignment with Material Design 3, depth is conveyed through **Tonal Layers** and **Ambient Shadows**. 

1. **Level 0 (Flat):** Main background (#FFFFFF).
2. **Level 1 (Card):** Surface color #F8FAFC with a 1px border (#E2E8F0) and no shadow. Used for secondary info.
3. **Level 2 (Interactive):** White surface with a "Premium Soft" shadow: `0px 4px 12px rgba(30, 64, 175, 0.08)`. The slight blue tint in the shadow creates a cleaner, more modern feel than neutral grey.
4. **Level 3 (Floating):** Used for Floating Action Buttons (FAB) and active modals. Shadow: `0px 8px 24px rgba(0, 0, 0, 0.12)`.

## Shapes
The shape language is "Soft Rounded," utilizing a 12px to 16px corner radius to evoke a friendly yet professional atmosphere.

- **Small Components (Buttons, Inputs):** 12px (`rounded-md`).
- **Medium Components (Cards, Modals):** 16px (`rounded-lg`).
- **Large Components (Banners):** 24px (`rounded-xl`).
- **Full Rounding:** Reserved for category chips (e.g., "Bóng đá", "Cầu lông") and status indicators to differentiate them from actionable buttons.

## Components
Consistent component behavior is vital for a high-performance booking app:

- **Action Buttons:** Primary buttons use the Vibrant Green background with White text and a subtle elevation shadow. On press, they darken by 10%.
- **Sport-Specific Chips:** Use a combination of a 24px icon (Football, Badminton, etc.) and a label. Unselected: Light grey background. Selected: Deep Sporty Blue with white text.
- **Elevated Cards:** Used for facility listings. They must include a high-quality image with a 16px top-corner radius, followed by title, rating, and price per hour.
- **Modern Input Fields:** Outlined style with a 12px radius. The border color is `#E2E8F0`, turning `Primary Green` on focus. Labels should be floating or positioned clearly above the field.
- **Booking Bar:** A fixed bottom-screen component for mobile, containing the total price and a "Đặt ngay" (Book Now) primary button.
- **Status Badges:** Use soft-tinted backgrounds (e.g., Light Green for "Còn sân", Light Red for "Hết chỗ").