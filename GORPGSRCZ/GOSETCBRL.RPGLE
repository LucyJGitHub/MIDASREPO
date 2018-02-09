     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Setup Equation Consumer Loan TRAP Records')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOSETCBRL - Setup Equation Consumer Loan TRAP Records        *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. BUG14101           Date 19Jun07               *
      *                 CRE026  *CREATE    Date 24May06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG14101 - Background job EQ_ONL_SYN is generated errors     *
      *             and looping                                       *
      *  CRE026 - Consumer Banking                                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *    XX    - Function of Indicator                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *PSSR      -  Program exception error routine                *
      *  *INZSR     -  Initialisation Subroutine                      *
      *   SETUP_TRAP-  Subroutine to Setup Transaction Index Record  *
      *                                                               *
      *  The *INZSR subroutine will only get called automatically     *
      *  on entry to the module the first time it is run              *
      *  (unless you end the program with LR on).  Similarly          *
      *  D-spec initialisation only happens the first time.  Use      *
      *  RESET for subsequent passes.                                 *
      *                                                               *
      *****************************************************************
 
     FGPUTXEL0  IF A E           K DISK    INFSR(*PSSR)
 
      **Equation Branch Code Extension File by equation by Sub-Ledger
      **Branch(BXSBRC)
 
     FSDBRCXL1  IF A E           K DISK    INFSR(*PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
 
     D EQDL          E DS                  EXTNAME(OSPF)
 
 
      ** T R A N S A C T I O N    D E T A I L S
     D T_TRAP        E DS                  EXTNAME(GPETRAPPD)
 
      ** Define work variable for Deal Branch Mnemonic,
     D W_OSBRNM        S              3A
      ** Work variable for Start and End date
     D W_DAT1          S              6A
     D W_DAT1_7        S              7A                                                    BUG14101
     D W_DAT2          S              6A
     D W_DAT3          S              6A
     D W_DAT3_7        S              7A                                                    BUG14101
     D W_DAT4          S              6A
      **
     D PDaynoOut       S              5P 0
      * Work variable for Date format indicator,
     D W_FMTIND        S              1A
     D ErrorFlag       S              1A
 
     D I#RTCD          S              7A
     D I#ERMS          S             50A
     D OTCCY           S              3A
     D OTSDTE          S              7  0
     D OTMDT           S              7  0
     D T_PRRN          S              5  0
      *
      ** Entry Parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD
     C                   PARM                    I#ERMS
      *
      ** Inputs
      *
     C                   PARM                    EQDL
     C                   PARM                    OTCCY
     C                   PARM                    OTSDTE
     C                   PARM                    OTMDT
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
     C                   EVAL      T_SMOD = 'CBRL'
      *
      ** Customer number
      *
     C                   EVAL      T_CNUM = OSCUS
      *
      ** Portfolio reference
      *
     C                   EVAL      T_PTFR = *Blank
      *
      ** Booking Branch
      *
     C                   EVAL      W_OSBRNM = OSBRNM
      *
     C     W_OSBRNM      CHAIN     SDBRCXL1
     C                   IF        %FOUND (SDBRCXL1)
     C                   EVAL      T_BRCA = BXBRCD
 
     C                   ELSE
     C**********         EVAL      I#ERMS = 'BRANCH ' + W_OSBRNM +' NOT FOUND '+            BUG14101
     C**********                   'IN EQUATION BRANCH EXT FILE'                            BUG14101
     C**********         EXSR      *PSSR                                                    BUG14101
     C                   EVAL      I#RTCD = '*NOEXT*'                                       BUG14101
     C                   RETURN                                                             BUG14101
     C                   ENDIF
      *
      ** Book
      *
     C                   EVAL      T_BOOK = *Blank
      *
      ** Account Currency
      *
     C                   EVAL      T_ACCY = OTCCY
      *
      ** Transaction Reference
      *
     C                   EVAL      T_TREF = OSDLR
      *
      ** Identifier
      *
     C     GPUTXEK       CHAIN     GPUTXED0
     C                   IF        NOT %FOUND(GPUTXEL0)
      /COPY GOCPYSRC,GOGETNTID
     C                   EVAL      XEZONE = T_ZONE
     C                   EVAL      XEMOD  = T_MOD
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
     C                   EVAL      T_TRTP = OSDLP
      *
      ** Convert Start Date from 7S 0 to Midas Day Number (5P 0)
      *
     C**********         Move      OTSDTE        W_DAT1                                     BUG14101
     C                   Move      OTSDTE        W_DAT1_7                                   BUG14101
     C                   Move      W_DAT1_7      W_DAT1                                     BUG14101
      *
     C                   EVAL      W_DAT2 = %SUBST(((W_DAT1)):5:2) +
     C                                      %SUBST((W_DAT1):3:2)  +
     C                                      %SUBST((W_DAT1):1:2)
      *
     C                   EVAL      W_FMTIND = 'D'
      *
     C                   CALLB     'ZDATE1'
     C                   PARM                    W_DAT2
     C                   PARM      *ZERO         PDaynoOut
     C                   PARM                    W_FMTIND
     C                   PARM      *BLANK        ErrorFlag
 
     C                   IF        ErrorFlag = 'Y'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO ZDATE1'
     C                   EXSR      *PSSR
      *
     C                   ELSE
      *
      ** Start Date
      *
     C                   EVAL      T_SDAT = PDaynoOut
 
     C                   ENDIF
      *
      ** Convert End Date from 7S 0 to Midas Day Number (5P 0)
      *
     C**********         Move      OTMDT         W_DAT3                                     BUG14101
     C                   Move      OTSDTE        W_DAT3_7                                   BUG14101
     C                   Move      W_DAT3_7      W_DAT3                                     BUG14101
      *
     C                   EVAL      W_DAT4 = %SUBST(((W_DAT3)):5:2) +
     C                                      %SUBST((W_DAT3):3:2)  +
     C                                      %SUBST((W_DAT3):1:2)
      *
     C                   CALLB     'ZDATE1'
     C                   PARM                    W_DAT4
     C                   PARM      *ZERO         PDaynoOut
     C                   PARM                    W_FMTIND
     C                   PARM      *BLANK        ErrorFlag
 
     C                   IF        ErrorFlag = 'Y'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO ZDATE1'
     C                   EXSR      *PSSR
      *
     C                   ELSE
      *
      ** End Date
      *
     C                   EVAL      T_EDAT = PDaynoOut
     C                   ENDIF
      *
      ** Industry Code
      *
     C                   EVAL      T_LICD = *Blank
      *
      ** Country Code
      *
     C                   EVAL      T_CNCD = *Blank
      *
      ** Action
      *
     C                   EVAL      T_ACTN = *Blank
     C                   ENDSR
      **
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
