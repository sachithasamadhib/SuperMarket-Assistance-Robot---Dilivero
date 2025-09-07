# 🛒 Smart Supermarket Assistant Robot

A **Research & Development project** designed to assist supermarket customers who are in a rush.  
This system integrates **mobile app ordering, real-time databases, POS system, and robotic automation** to streamline the shopping experience.

---

## 🚀 Project Overview

Traditional supermarket shopping can be time-consuming, especially for customers in a hurry.  
Our solution introduces a **smart ordering and robotic collection system**:

1. 🧑‍💻 **Customer Orders via Mobile App**  
   - Customers browse and order items through the supermarket's mobile app.  
   - Payment can be made directly through the app.  

2. ☁️ **Data Flow through Firebase**  
   - Order data is uploaded to **Firebase**.  
   - Firebase synchronizes with the **Python-based POS system**.  

3. 🗄️ **Backend & POS Integration**  
   - The **Python POS system** stores order details in a **MySQL database**.  
   - The POS forwards order instructions to the robot.  

4. 🤖 **Autonomous Collecting Robot (ESP32 Controlled)**  
   - An **ESP32-based robot** receives the order data.  
   - The robot navigates inside the supermarket, collects items, and places them into a **collecting container robot**.  

5. 🅿️ **Customer Pickup Point**  
   - Once filled, the container robot moves to a **designated parking spot**.  
   - A **notification is sent** to the customer's mobile app with the pickup location.  

6. ✅ **Quick Collection & Exit**  
   - The customer arrives at the parking spot, collects their goods, and leaves—saving valuable time.  

---

## 🛠️ Tech Stack

- **Frontend (Customer Side):**  
  - Mobile App (Android/iOS)

- **Cloud & Middleware:**  
  - Firebase (real-time order sync)

- **Backend (Supermarket Side):**  
  - Python POS System  
  - MySQL Database  

- **Robotics & Hardware:**  
  - ESP32 (Robot Controller)  
  - Collecting Robot (Autonomous Navigation + Item Collection)

---

## 🎯 Key Features

- ⏱️ Fast shopping experience for customers in a rush  
- 📲 Mobile app ordering & payment  
- 🔄 Real-time order synchronization with Firebase  
- 🖥️ POS integration with MySQL for record keeping  
- 🤖 ESP32-controlled robot for item collection  
- 🅿️ Automatic delivery to a customer pickup spot  
- 🔔 Instant mobile notification when the order is ready  

---

## 📌 Future Enhancements

- AI-based **computer vision** for better navigation & item recognition  
- **Multiple robot coordination** for high-demand scenarios  
- Integration with **RFID tags** for quick item scanning  
- Support for **voice-activated ordering** via mobile app  

---

## 👥 Contributors
We are grateful to the following contributors for their valuable efforts in making this possible:

- [Viraj Wathsala Gunasinghe](https://github.com/virajwathsalag)
- [Sachitha Samadhi Bandara](https://github.com/sachithasamadhib)
- [Ravin Jayasanka](https://github.com/MrRaveen)
- [Sanuja Rasanajna](https://github.com/SanujaRasanajna2007)

## 📷 Demo (Concept)
Project report : [Project report(updated 1.4)PDF.pdf](https://github.com/user-attachments/files/22168182/Project.report.updated.1.4.PDF.pdf)

![1748580027483](https://github.com/user-attachments/assets/723f88cb-8b27-40c0-9f88-378098942fdb)


![1748580544261](https://github.com/user-attachments/assets/e973781c-fec8-4d84-8909-99041ff8f9e0)


![IMG_20250513_172905](https://github.com/user-attachments/assets/6d0cef49-a259-46cc-94f4-9982a5e32e0f)


https://github.com/user-attachments/assets/5e5f9dd9-e1d3-4063-ba61-8231540bcd00



https://github.com/user-attachments/assets/09f823de-80f2-470b-bd99-15a975ea6834



---

## 📄 License

This project is licensed under the **MIT License**.  
You are free to use, modify, and distribute with proper attribution.  

---


