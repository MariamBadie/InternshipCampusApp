// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getAnalytics } from "firebase/analytics";

// Your web app's Firebase configuration
const firebaseConfig = {
  apiKey: "AIzaSyDdwt6XiHvlk46DtZXwrl6c4NPXfnw708o",
  authDomain: "campus-app-d0e52.firebaseapp.com",
  databaseURL: "https://campus-app-d0e52-default-rtdb.firebaseio.com",
  projectId: "campus-app-d0e52",
  storageBucket: "campus-app-d0e52.appspot.com",
  messagingSenderId: "709052786972",
  appId: "1:709052786972:web:ed7d94965cc1e8b1ef32d9",
  measurementId: "G-G81QMC0GV2"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);