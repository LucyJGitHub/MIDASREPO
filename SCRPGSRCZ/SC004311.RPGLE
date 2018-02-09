     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SC Copy API Log to API MQ Series Msg Queue')
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SC004311 - Copy API Log to API MQ Series Message Queue       *
      *                                                               *
      *  Function:  This module will copy the contents of API log     *
      *             files into the API MQ series message queues of    *
      *             either the support system or the main system.     *
      *                                                               *
      *  Component of: SC004310 - 'Support' to 'Main' Transition      *
      *                           Processing                          *
      *                SC004340 - 24x7 Reopen Input Cycle Processing  *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *  Prev Amend No. CSC011  *CREATE    Date 18Sep01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSC011 - 24x7 Midas Availability                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         End of file (APLOGFL0)                          *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRPROAP  - Process all records from API Log File             *
      *  SRSEND   - Send the message to the MQ Series Message Queue   *
      * *PSSR    - Error processing                                   *
      * *INZSR   - Initialise                                         *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FAPLOGFL0  UF   E           K DISK           INFSR(*PSSR)
      ** Joined Log File
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **------------------------------------------------------------------------
 
      **------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D SC24X7        E DS           256    EXTNAME(SC24X7) DTAARA(SC24X7)
 
      ** +--- Named indicators -------------------------------------------+
      ** ¦                                                                ¦
      ** ¦ Map variable names to indicators to allow use of names instead ¦
      ** ¦ of numbers; base the following data structure on a pointer to  ¦
      ** ¦ the indicator array.                                           ¦
     D Indicators      DS                  BASED(pIndicator)
      ** ¦                                                                ¦
     D  EoF                    1      1
      ** ¦                                                                ¦
      ** ¦ Set the indicator array pointer                                ¦
     D pIndicator      S               *   INZ(%Addr(*In))
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PSwtchOvrMde    S              1
      ** Switchover Mode
 
     D WSysPrfx        S              2
      ** Midas System Prefix
 
     D PReturnCode     S             10
      ** Return Code
 
     D PLocQue         S             20    INZ('MIDASxx.TRANSACT.Q')
      ** Message queue local_queue
 
     D PString         S           6000
      ** String to send to API MQ series message queues
 
     D WRun            S              1
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Process all records from  Log File.
 
     C                   EXSR      SRPROAP
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPROAP - Process all records from Log File                   *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SRSEND                                                 *
      *                                                               *
      *****************************************************************
 
     C     SRPROAP       BEGSR
 
     C     *LOVAL        SETLL     APLOGFL0
     C                   READ      APLOGFL0                               01
 
     C                   DOW       EOF = False
 
      ** Move the record to a string of length 6000.
 
     C                   EVAL      PString = APTRAN
 
      ** Send to API MQ Series Message Queue.
 
     C                   EXSR      SRSEND
 
      ** Delete the record from the API Valid Log file.
 
     C                   DELETE    APLOGFL0
 
     C                   READ      APLOGFL0                               01
 
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSEND - Send the message to the MQ Series Message Queue      *
      *                                                               *
      * Called by: SRPROAP                                            *
      *                                                               *
      * Calls: ZA000001, *PSSR                                        *
      *                                                               *
      *****************************************************************
 
     C     SRSEND        BEGSR
 
     C                   CALLB     'ZA000001'
     C                   PARM      *BLANKS       PReturnCode
     C                   PARM                    PLocQue
     C                   PARM                    PString
 
     C                   IF        PReturnCode <> *BLANKS
     C                   EVAL      DBASE = 1
     C                   EVAL      DBKEY = '*CALL'
     C                   EVAL      DBFILE = 'ZA000001'
     C                   EVAL      DBPGM = 'SC004311'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
     C                   PARM                    PSwtchOvrMde
 
      ** Set-up the Message Queue Local_Queue Name
     C                   IN        SC24X7
 
      ** Message Queue Local_queue name is 'MIDASXX.TRANSACT.Q'.  If
      ** Switchover Mode is 'S' , XX is the 'support system prefix'.  While
      ** if Switchover Mode is ' ', XX is the 'main system prefix'.
     C                   IF        PSwtchOvrMde='S'
     C                   EVAL      WSysPrfx=S1SUPP
     C                   ENDIF
 
     C                   IF        PSwtchOvrMde=' '
     C                   EVAL      WSysPrfx=S1MAIN
     C                   ENDIF
 
      ** Setup the Message Queue Local_Queue name.
 
     C                   EVAL      %SUBST(PLocQue:6:2) = WSysPrfx
 
     C                   ENDSR
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      * Called by: SRSEND                                                 *
      *                                                                   *
      * Calls: DBERRCTL                                                   *
      *                                                                   *
      *********************************************************************
 
     C     *PSSR         BEGSR
 
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      ********************************************************************
      /EJECT
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
