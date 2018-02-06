     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas CG Validate FTP password')
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG3601 - Validate FTP password                               *
      *                                                               *
      *  Function:  This module will validate the FTP password        *
      *             of the Correspondence Manager ICD.                *
      *                                                               *
      *  Component of: SD9595                                         *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *  Prev Amend No. CCG015  *CREATE    Date 09Aug01               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CCG015 - Correspondence Manager Phase 1                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *   01  - Incorrect character found in CHECK operation          *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRINIT  - Initialisation                                     *
      *                                                               *
      *  *PSSR   - Error processing                                   *
      *  *INZSR  - Initialise                                         *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
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
 
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
     D Digits          C                   '0123456789'
     D Letters         C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ+
     D                                     abcdefghijklmnopqrstuvwxyz'
     D BlankChar       C                   ' '
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D PMsgIdArr       S              7    DIM(25)
     D WArray          S              1    DIM(20)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PUser           S             20
     D PPassword       S             20
     D PType           S              1
     D PRtnCode        S              7
     D WRun            S              1
     D WLen            S              2S 0
     D WPosition       S              2S 0
     D WCtr            S              2S 0
     D Idx             S              2S 0
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically:             ¦
      ** ¦ *INZSR is executed at program activation                   ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
     C                   EXSR      SRINIT
 
      ** FTP password must not be blanks
 
     C                   IF        PPassword = *BLANKS
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      PMsgIdArr(Idx) = 'CGD2570'
     C                   EVAL      PRtnCode = '*ERROR '
     C                   ELSE
 
      ** FTP password must not have interleaving blanks
 
     C     BlankChar     CHECKR    PPassword     WLen
     C     BlankChar     SCAN      PPassword     WPosition
     C                   IF        WPosition <> 0 AND WPosition < WLen
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      PMsgIdArr(Idx) = 'CGD2571'
     C                   EVAL      PRtnCode = '*ERROR '
     C                   ENDIF
 
      ** FTP password must be at least 7 characters
 
     C                   IF        WLen <= 6
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      PMsgIdArr(Idx) = 'CGD2572'
     C                   EVAL      PRtnCode = '*ERROR '
     C                   ENDIF
 
      ** FTP password must be a mix of letter(s) and digit(s)
 
     C                   EVAL      WCtr = 1
     C                   EVAL      WArray(*) = *BLANKS
     C                   MOVEA     PPassword     WArray
     C                   DOU       *IN01 = '0' OR WCtr > 20
     C     Letters       CHECK     WArray(WCtr)                           01
     C                   EVAL      WCtr = WCtr + 1
     C                   ENDDO
 
     C                   IF        WCtr > 20
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      PMsgIdArr(Idx) = 'CGD2574'
     C                   EVAL      PRtnCode = '*ERROR '
 
     C                   ELSE
     C                   EVAL      WCtr = 1
 
     C                   DOU       *IN01 = '0' OR WCtr > 20
     C     Digits        CHECK     WArray(WCtr)                           01
     C                   EVAL      WCtr = WCtr + 1
     C                   ENDDO
 
     C                   IF        WCtr > 20
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      PMsgIdArr(Idx) = 'CGD2574'
     C                   EVAL      PRtnCode = '*ERROR '
     C                   ENDIF
     C                   ENDIF
 
      ** FTP password must be different from the user name
 
     C                   IF        PPassword = PUser
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      PMsgIdArr(Idx) = 'CGD2573'
     C                   EVAL      PRtnCode = '*ERROR '
     C                   ENDIF
 
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINIT - Initialisation                                      *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
 
     C     SRINIT        BEGSR
 
     C                   RESET                   PMsgIdArr
     C                   EVAL      PRtnCode = *BLANKS
     C                   EVAL      Idx = 0
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *Entry        PLIST
     C                   PARM                    PUser
     C                   PARM                    PPassword
     C                   PARM                    PMsgIdArr
     C                   PARM                    PRtnCode
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
 
     C                   CALLB     'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
