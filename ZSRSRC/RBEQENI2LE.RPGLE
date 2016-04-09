     D*****************************************************************
     D*                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
     D*  Last Amend No. CRT004  *CREATE    Date 02JUN00               *
     D*                                                               *
     D*---------------------------------------------------------------*
     D*                                                               *
     D*  CRT004 - Cashier Midas TCP/IP interface.                     *
     D*                                                               *
     D*****************************************************************
     D REPEQI        E DS                  EXTNAME(REPEQIPD)
     D** Enquiry Details Incoming Request Message
     D*
     D  P@QSN                 15     24
     D  WAACN                153    162
     D*
     D REPEQO        E DS                  EXTNAME(REPEQOPD)
     D** Enquiry Details Outgoing Request Message
     D*
     D P@QDR           DS           170
     D** Data queue message to be received
     D*
     D P@QDS           DS          2560
     I** Data queue message to be sent
     I*
