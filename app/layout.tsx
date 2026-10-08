import type {Metadata} from 'next';
import './globals.css';
export const metadata:Metadata={title:'Iron Club | Gym Management',description:'Gym members, memberships, attendance, classes and payments.'};
export default function RootLayout({children}:{children:React.ReactNode}){return <html lang="en"><body>{children}</body></html>}
