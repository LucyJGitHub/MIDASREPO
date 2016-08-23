     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Cashier TCP/IP worker process')
      *****************************************************************
      *                                                               *
      *  Midas - Cashier Interface Module                             *
      *                                                               *
      *  RE004520 - Midas Cashier TCP/IP Worker Process               *
      *                                                               *
      *  Function:  This process is the initial procedure for each    *
      *             process submitted by the listener.                *
      *             Its main function is to receive the socket desc.  *
      *             from the listener and call the related RE service *
      *             program.                                          *
      *  Author: Alain Differdange                                    *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *  Last Amend No. CRT004  *CREATE    Date 25Jun00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRT004 - Cashier Midas TCP/IP interface.                     *
      *                                                               *
      *****************************************************************
     F/EJECT
      *
      *
     D/EJECT
      *
      *  Data structure for compilation  - Copyright insertion
      *
     D CPYR@#          DS
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
     D  CPY@##                 1     20
      * Compile-time arrays to hold message types and associated jobs
 
      *
      * Prototype Definitions
      *
     D take_Ds         pr            10i 0
     d  jobid                        20
 
     D rcv_tcp         pr            10i 0
     d                               10i 0 Const
     d                               50
 
     D Get_Jobint      pr            16
 
      *
      * Others Variables
      *
     D ScktNum         S             10I 0
     D RetCode         S             10I 0
     D Str             S             50
 
      /COPY ZSRSRC,RBEQENI2LE
 
      /EJECT
      *****************************************************************
      *
      * Main Processing
      *
     C                   exsr      srmain
      *
      * Return to calling program
      *
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      * *inzsr - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *inzsr        BEGSR
      *
     C     *entry        PLIST
     C                   PARM                    JOBINT           16
     C                   PARM                    BRC               4
     C                   PARM                    USERID           10
     C                   PARM                    UNITID            3
     C                   PARM                    SRVPGM           10
      * Save job Internal Number from Listener
     c                   movel     jobint        jobintlong       20
      * Retrieve Job Internal Number from Worker
     c                   movel     *blanks       jobuser          10
     c                   EVAL      jobint = Get_Jobint
      * Transfer Job Internal Number from Worker to the Listener via Data queue
     c                   movel     brc           brcm              3
     c                   eval      P@QSN = 'RE4500' + brcm                      DataQueue Name
     c                   eval      P@QLS = '*LIBL'                              DataQ Library
     c                   eval      P@QNS = 16                                   DataQ Length
     c                   eval      P@QDS = jobint                               DataQueue Data
     C                   EXSR      SDQMS
      * Take Descriptor from the Listener.
     c                   eval      ScktNum = take_ds(jobintlong )
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * srmain - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     srmain        BEGSR
 
     C                   call      srvpgm
     C                   PARM                    SCKTNUM
     C                   PARM                    BRC               4
     C                   PARM                    USERID           10
     C                   PARM                    UNITID            3
 
     C     srmainx       ENDSR
      /EJECT
      *****************************************************************
      /COPY ZSRSRC,RBSDQMSLE
**CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2001
