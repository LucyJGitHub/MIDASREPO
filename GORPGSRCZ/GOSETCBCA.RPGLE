     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Setup Equation Consumer Account TRAP Records')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOSETCBCA - Setup Equation Consumer Account TRAP Records     *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. BUG14101A          Date 29Jun07               *
      *                 BUG14101           Date 19Jun07               *
      *                 CRE026  *CREATE    Date 24May06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG14101A - Recompile due to LIBL                            *
      *  BUG14101 - Background job EQ_ONL_SYN is generated errors     *
      *             and looping                                       *
      *  CRE026 - Consumer Banking                                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *    XX    - Function of Indicator                              *
      *    99    -  Used for CHAIN Operations                         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *PSSR     -  Program exception error routine                 *
      *  *INZSR    -  Initialisation Subroutine                       *
      *  SETUP_TRAP-  Subroutine to Setup Transaction Index Record    *
      *                                                               *
      *  The *INZSR subroutine will only get called automatically     *
      *  on entry to the module the first time it is run              *
      *  (unless you end the program with LR on).  Similarly          *
      *  D-spec initialisation only happens the first time.  Use      *
      *  RESET for subsequent passes.                                 *
      *                                                               *
      *****************************************************************
 
     FGPUTXEL0  IF A E           K DISK    INFSR(*PSSR)
      ** Branch extension file
     FSDBRCXL1  IF   E           K DISK    INFSR(*PSSR)
     FCA02LF    IF   E           K DISK    INFSR(*PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
     D EQAC          E DS                  EXTNAME(SC10LF)
 
      ** T R A N S A C T I O N    D E T A I L S
     D T_TRAP        E DS                  EXTNAME(GPETRAPPD)
 
      *Work variable for midas day number conversion
     D W_SDAT1         S              6
     D W_SDAT1_7       S              7                                                     BUG14101
     D W_SDAT2         S              6
      *Work field for Branch extension file
     D W_BRCH          S              3
     D W_BRCX          S              3                                                     BUG14101
 
     D I#RTCD          S              7
     D I#ERMS          S             50
     D T_PRRN          S              5  0
     D DateIn          S              6
     D DaynoOut        S              5  0
     D BJDFIN          S              1
     D ErrorFlag       S              1
      ***************************************************************
      /EJECT
      ***************************************************************
 
      ***************************************************************
      *                MAIN PROCESSING                              *
      ***************************************************************
      *
      ** Entry Parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD
     C                   PARM                    I#ERMS
      *
      ** Inputs
      *
     C                   PARM                    EQAC
      *
      ** Outputs
      *
     C                   PARM                    T_TRAP
     C                   PARM                    T_PRRN
 
      *
      ** Setup Transaction Index Record
      *
     C                   EXSR      SETUP_TRAP
      *
      ** Return
      *
     C                   RETURN
      *
      *****************************************************************
      *                                                               *
      *  SETUP_TRAP - SETUP TRANSACTION INDEX RECORD                  *
      *                                                               *
      *  Called By: MAIN PROCESSING                                   *
      *                                                               *
      *  Calls:     *PSSR, ZDATE1                                     *
      *****************************************************************
     C     SETUP_TRAP    BEGSR
      *
      ** Clear Transaction Index
      *
     C                   CLEAR                   T_TRAP
      *
      ** Zone
      *
     C                   EVAL      T_ZONE = O#ZONE
      *
      ** Module
      *
     C                   EVAL      T_MOD = 'EQ'
      *
      ** Sub module
      *
     C                   EVAL      T_SMOD = 'CBCA'
      *
      ** Customer number
      *
     C                   EVAL      T_CNUM = SCAN
      *
      ** Portfolio reference
      *
     C                   EVAL      T_PTFR = *Blanks
      *
      ** Booking Branch
      *
     C**********         EVAL      W_BRCH = %TRIM(SCAB)                                     BUG14101
     C     SCAB          CHAIN     CA02LF                                                   BUG14101
     C                   IF        %FOUND(CA02LF)                                           BUG14101
     C                   EVAL      W_BRCH = %TRIM(CABRNM)                                   BUG14101
     C                   ELSE                                                               BUG14101
     C                   EVAL      I#ERMS = 'BRANCH ' + W_BRCH + ' NOT FOUND ' +            BUG14101
     C                             'IN EQUATION BRANCH DTL FILE'                            BUG14101
     C                   EXSR      *PSSR                                                    BUG14101
     C                   ENDIF                                                              BUG14101
      *                                                                                     BUG14101
     C     W_BRCH        CHAIN     SDBRCXL1
     C                   IF        %FOUND(SDBRCXL1)
     C                   EVAL      T_BRCA = BXBRCD
 
     C                   ELSE
     C**********         EVAL      I#ERMS = 'BRANCH ' + W_BRCH + ' NOT FOUND ' +            BUG14101
     C**********                   'IN EQUATION BRANCH EXT FILE'                            BUG14101
     C**********         EXSR      *PSSR                                                    BUG14101
     C                   EVAL      I#RTCD = '*NOEXT*'                                       BUG14101
     C                   RETURN                                                             BUG14101
     C                   ENDIF
      *
      ** Book
      *
     C                   EVAL      T_BOOK = *Blanks
      *
      ** Account Currency
      *
     C                   EVAL      T_ACCY = SCCCY
      *
      ** Transaction Reference
      *
     C                   EVAL      T_TREF = SCAB + SCAN + SCAS
      *
      ** Identifier
      *
     C     GPUTXEK       CHAIN     GPUTXED0                           99
     C     *IN99         IFEQ      *ON
      /COPY GOCPYSRC,GOGETNTID
     C                   EVAL      XEZONE = T_ZONE
     C                   EVAL      XEMOD = T_MOD
     C                   EVAL      XESMOD = T_SMOD
     C                   EVAL      XETREF = T_TREF
     C                   Z-ADD     O#NTID        XEID
     C                   WRITE     GPUTXED0
     C                   ENDIF
     C                   Z-ADD     XEID          T_ID
     C                   Z-ADD     *ZERO         T_PRRN
      *
      ** Shortname
      *
     C                   EVAL      T_SNAM = T_TREF
      *
      ** Transaction Type
      *
     C                   EVAL      T_TRTP = SCACT
      *
      ** Start Date
      *
     C**********         Move      SCOAD         W_SDAT1                                    BUG14101
     C                   Move      SCOAD         W_SDAT1_7                                  BUG14101
     C                   Move      W_SDAT1_7     W_SDAT1                                    BUG14101
     C                   EVAL      W_SDAT2 = %SUBST(W_SDAT1:5:2) +
     C                                       %SUBST(W_SDAT1:3:2) +
     C                                       %SUBST(W_SDAT1:1:2)
 
     C                   CALLB     'ZDATE1'
     C                   PARM      W_SDAT2       DateIn
     C                   PARM                    DaynoOut
     C                   PARM      'D'           BJDFIN
     C                   PARM                    ErrorFlag
 
     C                   IF        ErrorFlag = 'Y'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO ZDATE1'
     C                   EXSR      *PSSR
      *
     C                   ELSE
     C                   EVAL      T_SDAT = DaynoOut
     C                   ENDIF
      *
      ** End Date
      *
     C                   Z-ADD     *ZERO         T_EDAT
      *
      ** Industry Code
      *
     C                   EVAL      T_LICD = SCP5R
      *
      ** Country Code
      *
     C                   EVAL      T_CNCD = SCCNAL
      *
      ** Action
      *
     C                   EVAL      T_ACTN = 'A'
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *                                                               *
      * *INZSR - Initial Subroutine                                   *
      *                                                               *
      *  Called By: Called automatically at program start             *
      *                                                               *
      *  Calls:     None                                              *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Get Zone
      *
      /COPY GOCPYSRC,GOGETZONE
      *
      ** Key list
      *
     C     GPUTXEK       KLIST
     C                   KFLD                    T_ZONE
     C                   KFLD                    T_MOD
     C                   KFLD                    T_SMOD
     C                   KFLD                    T_TREF
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR
      *********************************************************************
**  CPY@
(c) Finastra International Limited 2006
