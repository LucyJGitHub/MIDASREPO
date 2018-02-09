     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Validate int calculation basis (SD)')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data module                                 *
      *                                                               *
      *  ZAVCALCB - Validate Interest Calculation Basis               *
      *                                                               *
      *  Function:  This module receives a parameter containing the   *
      *             Interest Calculation Basis and confirms whether   *
      *             it has a valid value.                             *
      *             If it is valid the 10A return code will be blank. *
      *             If it is not it will contain  'Error'.            *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG9342            Date 14Feb06               *
      *                 224743             Date 15Mar04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG9342 - Incorrect error message - MMM0429                  *
      *  224743 - If CIR004 is installed, system should allow         *
      *           interest calculation method '7'.  This module is    *
      *           used by SDYRATRTV instead of ZAVINTCALC so as not   *
      *           to affect dealing module functions.                 *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    U7, U8     Database error                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** DS for Access Programs: Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** DS for SC Switchable Features
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
 
      ** Error message field received as a parameter
     D Msgid1          S                   LIKE(#Msgid)
 
      ** Midas Interest Calculation method - received as a parameter
     D DDICMT          S              1A
 
      ** Parameters for access object AOSARDR0
 
     D PRTCD           S              7A
     D POPTN           S              7A
     D PSARD           S              6A
     D CIR004          S              1A
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
     C                   RESET                   ErrorFound
     C                   RESET                   Msgid1
      *
      *  *-----------------------------*
      *  * Validate Calculation Method *
      *  *-----------------------------*
      *
      **  If the method is not 1,2,3,4,5 or 6 this is an error.
      **  Allow method 7 only if CIR004 is installed.
     C     DDICMT        IFNE      '1'
     C     DDICMT        ANDNE     '2'
     C     DDICMT        ANDNE     '3'
     C     DDICMT        ANDNE     '4'
     C     DDICMT        ANDNE     '5'
     C     DDICMT        ANDNE     '6'
     C     DDICMT        ANDNE     '7'
     C     DDICMT        OREQ      '7'
     C     CIR004        ANDNE     'Y'
 
     C                   MOVE      'Y'           ErrorFound
 
      ** Use message "...not a digit from 1 to 7" if CIR004 is installed,
      ** else use message "...not a digit from 1 to 6"
 
     C                   IF        CIR004 = 'Y'
     C**********         MOVEL     'MMM0429'     MSGID1                                      BUG9342
     C                   MOVEL     'MMM4003'     MSGID1                                      BUG9342
     C                   ELSE
     C                   MOVEL     'MMM0428'     MSGID1
     C                   ENDIF
 
     C                   END
      *
      ** If an error was found, set the return code appropriately
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
 
     C                   RETURN
 
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
     C                   PARM                    RetCodeIn
     C                   PARM                    Msgid1
     C                   PARM                    DDICMT
 
      ** Check is CIR004 is installed
 
     C                   EVAL      CIR004 = 'N'
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CIR004'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
      ** Database error.
 
     C                   IF        PRTCD <> *BLANKS  AND
     C                             PRTCD <> '*NRF   '
     C     *LOCK         IN        LDA
     C/COPY ZACPYSRC,DBFIELDS
     C                   EVAL      DBFILE =  'SCSARDPD'
     C                   EVAL      DBKEY  =  PSARD
     C                   EVAL      DBASE  =  001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CIR004 = 'Y'
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
 
 
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      * Called by: (**calling routines**)                                 *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
 
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
 
     C                   CALLB     'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2004
