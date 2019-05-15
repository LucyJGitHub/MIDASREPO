     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Fee adjustment repair')                       *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LEFEADRPR - Fee Adjustment Repair                            *
      *                                                               *
      *  Function:  This function allows invalid fee adjustments      *
      *             to be 'repaired' and applied to the Midas database*
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CDL094             Date 11Jun14               *
      *                 CLE148             Date 23Jul12               *
      *                 CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE031             Date 26Apr05               *
      *                 CAP086             Date 08Jun05               *
      *                 CLE025             Date 20Oct03               *
      *                 CSC022             Date 24Feb04               *
      *                 BUG1218            Date 01Mar04               *
      *                 CDL018             Date 03Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084             Date 10Mar03               *
      *                 CLE031             Date 10Feb03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP072  *CREATE    Date 21Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE031 - Lending Enhancements - Settlement Currency          *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it                                          *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  BUG1218- Status not shown                                    *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP084 - Valid file changed to match LEFEEAD - recompile     *
      *  CLE031 - Lending Enhancements.                               *
      *           LEFEED & LEFEEAD changed  - recompile               *
      *  CAP072 - Conversion of LE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FZATRNERRL0IF   E           K DISK    INFSR(*PSSR)
 
     FLEIFEADL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LEIFEADD0 : LEIFEADX0)
     FLEIFEADL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** API Invalid log file by Type/FO Id/Time
     FAPILOGL0  UF   E           K DISK    INFSR(*PSSR) USROPN
     F                                     COMMIT
     FLEFEADDDF CF   E             WORKSTN INFSR(*PSSR)
 
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /SPACE 5
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
 
      *  Array for job name                                                                   CSC022
     D ARRJBNAM        S             10A   DIM(10)                                            CSC022
     D #EI             S              1    DIM(25)
 
 
      ** Fee Adjustment Details in screen format
     D FEAD          E DS                  EXTNAME(LEFEADPD)
 
      ** Fee Adjustment Details OK indicator
     D FEAD_OK       E DS                  EXTNAME(LEEFEADPD)
 
 
      ** Fee Adjustment Details in file format
     D LEFEEADFmt    E DS                  EXTNAME(LEFEEAD)
     D**LefeeaREC            124    192                                                       CGL029
     D  LefeeaREC1           124    125                                                       CGL029
     D  LefeeaREC2           138    192                                                       CGL029
     D**LefeeaPAY            193    751                                                       CGL029
     D  LefeeaPAY1           193    194                                                       CGL029
     D  LefeeaPAY2           207    751                                                       CGL029
 
      ** New Fee Adjustment details in file format
     D LEVFEADPD     E DS                  EXTNAME(LEVFEADPD)
     D LEVFEADOURS   E                     EXTFLD(QQOURS)                                     CGL029
 
      * File Receive instructions
     D F_REC         E DS                  EXTNAME(SDESFRPD)
     D**FLREC                  1     69                                                       CGL029
     D  FLREC1                 1      2                                                       CGL029
     D  FLREC2                21     75                                                       CGL029
 
      * File Payment instructions
     D F_PAY         E DS                  EXTNAME(SDESFPPD)
     D**FLPAY                  1    559                                                       CGL029
     D  FLPAY1                 1      2                                                       CGL029
     D  FLPAY2                21    565                                                       CGL029
 
      * File Fra/irs instructions
     D F_FRI         E DS                  EXTNAME(SDESFFPD)
 
      * Screen Receive instructions
     D S_REC         E DS                  EXTNAME(SDESSRPD)
 
      * Screen Payment instructions
     D S_PAY         E DS                  EXTNAME(SDESSPPD)
 
      * Screen Fra/irs instructions
     D S_FRI         E DS                  EXTNAME(SDESSFPD)
 
      ** Current Fee Adjustment Details in screen format
     D C_FEAD        E DS                  EXTNAME(LEFEADPD)
     D                                     PREFIX(C_)
 
      *                                                                                       CSC022
     D SCCMTJOB      E DS           256    DTAARA(SCCMTJOB)                                   CSC022
      ** Midas SC Jobs handling commitment control data area                                  CSC022
     D  COMITNOM               1      3S 0                                                    CSC022
     D  COMITJOB               4    103                                                       CSC022
      *                                                                                       CSC022
 
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
      ** 24X7 status data area
 
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
      ** SD data area
 
      ** Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Module details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      ** Retail details
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
 
      ** API details
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
      ** EXTERNAL DS FOR SAR DETAILS
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D DSFDY         E DS                  EXTNAME(DSFDY)
                                                                                              CAP086
     D InfData       E DS                  EXTNAME(LELEIFPD)                                  CAP086
     D                                     PREFIX(IF_)                                        CAP086
      ** LE (FEAD) Extra Data - File (D/B) format                                             CAP086
 
      ** +--------------------------------------+                                             CSC022
      ** ¦ Use of Indicator                     ¦                                             CSC022
      ** ¦ ================                     ¦                                             CSC022
      ** |                                      |                                             CSC022
      ** | 17      Used by LOOKUP               |                                             CSC022
      ** +--------------------------------------+                                             CSC022
                                                                                              CSC022
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Timestamp
     D @XTMSTSEL       S             26Z
     D @XREPNSEL       S              5S 0
     D CSC011          S              1A   INZ('N')
     D CAP086          S              1A                                                      CAP086
     D KMsgType        S              8A
     D KFrntOffID      S             20A
     D KTimeStamp      S                   LIKE(@XTMSTSEL)
     D PRTCD           S              7A
     D POPTN           S              7A
     D PSARD           S              6A
 
     D CSC022          S              1A   INZ('N')                                           CSC022
      ** Counter variable                                                                     CSC022
     D WCMT01          S              1A                                                      CSC022
      ** Commitment Flag                                                                      CSC022
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
 
      *****************************************************************
      /SPACE 5
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      * DO SCREEN: BROWSE INVALID TRANSACTIONS
     C     @SCRN         IFEQ      'B'
     C                   EXSR      SCRN@B
     C                   END
 
      * READ NEXT BROWSE SUBFILE RECORD
     C     @SCRN         IFEQ      'R'
     C                   EXSR      RDNBRW
     C                   END
 
      * DO WHILE SCREEN: MAIN DETAILS
     C     @SCRN         DOWEQ     'M'
     C                   EXSR      SCRN@M
     C                   END
 
      * SCREEN: WINDOW
     C     @SCRN         IFEQ      'W'
     C                   EXSR      WINDOW
     C                   END
 
      * DO FILE UPDATES
     C     @SCRN         IFEQ      'U'
     C                   EXSR      UPDATS
     C                   END
 
      * TERMINATE PROGRAM
     C     @SCRN         IFEQ      'T'
     C                   MOVE      '1'           *INLR
     C                   END
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * SCRN@B - BROWSE INVALID TRANSACTIONS
      *****************************************************************
     C     SCRN@B        BEGSR
      *
      * RESET READ NEXT BROWSE SUBFILE RECORD
      *
     C                   MOVEL     *BLANK        @RDNB             1
      *
      * BUILD BROWSE SUBFILE
      *
     C                   CALLB     'LEFEADRPB'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * BUILD SUB-FILE
     C                   PARM      'Y'           @BDSFL            1
      *
      * READ SUBFILE RECORD
     C                   PARM      *BLANK        @RDSFL            1
      *
      * Error in update of previous fee adjustment
     C                   PARM                    @ERRUP            1
      *
      * OUTPUT PARAMETERS
      *
      * ERROR MESSAGE
     C                   PARM      *BLANK        @ERRMS            7
      *
      * OPTION SELECTED
     C                   PARM                    @OPSEL            1
      *
      * ACTION SELECTED
     C                   PARM                    @ACSEL            1
      *
      * REPAIR NUMBER OF TRANSACTION SELECTED
     C                   PARM                    @XREPNSEL         5 0
      *
      * TIMESTAMP OF TRANSACTION SELECTED
     C                   PARM                    @XTMSTSEL
      *
      * COMMAND KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
      *
      ** Successful Insert ID
      *
     C                   PARM                    @SIID            15
      *
     C                   PARM                    CSC011
      *
      * If error set on external switches
      *
     C     @ERRMS        IFNE      *BLANK
     C                   MOVE      '1'           *INU6
     C                   END
      *
      * If CK/3 or CK/12 taken in browse, or error message
      * End program
      *
     C     @INKC         IFEQ      '1'
     C     @INKL         OREQ      '1'
     C     @ERRMS        ORNE      *BLANK
     C                   EXSR      ENDP
     C                   GOTO      ESCRN@B
     C                   END
      *
      * Read next browse subfile record
      *
     C                   MOVE      'Y'           @RDNB
     C                   MOVE      'R'           @SCRN
      *
     C     ESCRN@B       ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * RDNBRW - READ NEXT BROWSE SUBFILE RECORD
      *****************************************************************
     C     RDNBRW        BEGSR
      *
      * READ NEXT SUBFILE RECORD
      *
     C                   CALLB     'LEFEADRPB'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * BUILD SUB-FILE
     C                   PARM      *BLANK        @BDSFL            1
      *
      * READ SUBFILE RECORD
     C                   PARM      'Y'           @RDSFL            1
      *
      * Error in update of previous fee adjustment
     C                   PARM                    @ERRUP            1
      *
      * OUTPUT PARAMETERS
      *
      * ERROR MESSAGE
     C                   PARM      *BLANK        @ERRMS            7
      *
      * OPTION SELECTED
     C                   PARM      *BLANK        @OPSEL            1
      *
      * ACTION SELECTED
     C                   PARM      *BLANK        @ACSEL            1
      *
      * REPAIR NUMBER OF TRANSACTION SELECTED
     C                   PARM      *ZERO         @XREPNSEL         5 0
      *
      * TIMESTAMP OF TRANSACTION SELECTED
     C                   PARM                    @XTMSTSEL
      *
      * COMMAND KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
      *
      ** Successful Insert ID
      *
     C                   PARM                    @SIID
      *
     C                   PARM                    CSC011
      *
      * If CK/3 taken within invalid transaction deletion function,
      * End program
      *
     C     @INKC         IFEQ      '1'
     C                   EXSR      ENDP
     C                   GOTO      ERDNBRW
     C                   END
      *
      * IF INVALID TRANSACTION READ FROM SUBFILE
      *
     C     @OPSEL        IFNE      *BLANK
      *
      * BLANK THE MAIN DETAILS SCREEN
      *
     C                   MOVEL     *BLANK        FEAD
     C                   MOVEL     *BLANK        S#STAT
      *
      * RESET ERRORS
      *
     C                   MOVE      *ALL'Y'       FEAD_OK
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   Z-ADD     0             Idx
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
     C                   Z-ADD     0             WIdx
      *
      * Retrieve fee adjustment details
      *
     C     LEIFEADX      CHAIN     LEIFEADX0                          99
 
 
      * Retrieve current transaction
 
     C                   EXSR      RTVTRAN
      *
      * If errors occurred in access of current transaction
      * blank out action code so that the input cannot proceed
      *
     C     Idx           IFNE      0
     C                   MOVEL     *BLANK        S#ACTN
     C                   ENDIF
 
      * Send the error messages to the main details screen
 
     C                   EXSR      SNDM@M
     C                   EXSR      SET_SCEI
      *
      * GO TO MAIN DETAILS SCREEN
      *
     C                   MOVE      'M'           @SCRN
      *
      * ELSE IF NO INVALID DEAL READ FROM SUBFILE
      *
     C                   ELSE
      *
      * GO TO BROWSE SCREEN
      *
     C                   MOVE      'B'           @SCRN
     C                   END
      *
     C     ERDNBRW       ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * SNDM@M - SEND A MESSAGE TO MAIN DETAILS SCREEN
      *****************************************************************
     C     SNDM@M        BEGSR
 
     C                   Z-ADD     Idx           E                 3 0
      *
      ** If there are fundamental errors in this transaction
      ** Identify this fact.
      *
     C     S#ACTN        IFEQ      *BLANK
     C                   ADD       1             E
     C                   MOVEL     '*ANY'        FldNameArr(E)
     C                   MOVEL     'LEX9990'     MsgIdArr(E)
     C                   ENDIF
      *
      ** Initialise error indicators
      *
     C                   MOVEA     FEAD_OK       #EI
      *
      ** Read error messages for transaction
      *
     C                   EVAL      ABFOTRNID  = DDFRNT
     C     ZATRNK        SETLL     ZATRNERRD0
     C     ZATRNK        READE     ZATRNERRD0                             99    *
      *
      ** Add error message to array passed to detail screen
      ** and set OK flag for field to 'N'
      *
     C     *IN99         DOWEQ     '0'
     C                   ADD       1             E
     C                   MOVEL     ABFIELDNAM    FldNameArr(E)
     C                   MOVEL     ABMSGID       MsgIdArr(E)
     C                   Z-ADD     ABFIELDID     F                 3 0
     C     F             IFGE      1
     C     F             ANDLE     13
     C                   MOVE      'N'           #EI(F)
     C                   END
     C     ZATRNK        READE     ZATRNERRD0                             99    *
     C                   END
      *
     C                   MOVEA     #EI           FEAD_OK
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * SCRN@M - PROCESS SCREEN: MAIN DETAILS
      *****************************************************************
     C     SCRN@M        BEGSR
      *
      * Issue rollback to clear any possible updates in window function
      *
     C     BGWDPR        IFEQ      'Y'
     C     CSC022        IFEQ      'N'                                                        CSC022
     C                   ROLBK
     C                   ELSE                                                                 CSC022
     C     WCMT01        IFNE      'Y'                                                        CSC022
     C                   ROLBK                                                                CSC022
     C                   ELSE                                                                 CSC022
     C                   SETON                                        U7U8                    CSC022
     C                   ENDIF                                                                CSC022
     C                   ENDIF                                                                CSC022
     C                   END
      *
      * Enable/disable detail fields on main details screen
      * if changes to the data are allowed
      * (Action code can only be 'I', 'A', 'X', or 'D')
      *
     C     S#ACTN        IFEQ      'I'
     C     @OPSEL        ANDEQ     'U'
     C     S#ACTN        OREQ      'A'
     C     @OPSEL        ANDEQ     'U'
     C                   MOVEL     '0'           *IN67
     C     S#ACTN        IFEQ      'I'
     C                   MOVEL     '0'           *IN69
     C                   ELSE
     C                   MOVEL     '1'           *IN69
     C                   END
     C                   ELSE
     C                   MOVEL     '1'           *IN67
     C                   MOVEL     '1'           *IN69
     C                   END
      *
      * KJ = COMMAND KEY 10 = CONFIRM DELETE
      *
     C     S#ACTN        IFEQ      'D'
     C                   MOVEL     '1'           *IN68
     C                   ELSE
     C                   MOVEL     '0'           *IN68
     C                   END
      *
      * KK = COMMAND KEY 11 = CONFIRM AUTHORISE
      *
     C     S#ACTN        IFEQ      'X'
     C                   MOVEL     '1'           *IN66
     C                   ELSE
     C                   MOVEL     '0'           *IN66
     C                   END
      *
      * WRITE/READ DISPLAY SCREEN
      *
     C                   WRITE     LEFEADF2
     C                   WRITE     LEFEADF1
     C                   WRITE     #MSGCTL
     C                   EXFMT     LEFEADF3
      *
      * RESET ERRORS
      *
     C                   MOVE      *ALL'Y'       FEAD_OK
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   Z-ADD     0             Idx
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
     C                   Z-ADD     0             WIdx
 
      ** Reset screen error indicators
 
     C                   EXSR      RESET_SCEI
 
      **  Clear Message subfile
 
     C                   EXSR      CLEARM
      *
      * CK/3 - END PROGRAM
      *
     C     *INKC         CASEQ     '1'           ENDP
      *
      * CK/12 - CANCEL ON MAIN DETAILS SCREEN
      *
     C     *INKL         CASEQ     '1'           CANC@M
      *
      * VALIDATE INPUT TO MAIN DETAILS SCREEN
      *
     C                   CAS                     VAL@M
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * VAL@M  - VALIDATE INPUT TO MAIN DETAILS SCREEN
      *****************************************************************
     C     VAL@M         BEGSR
      *
      * Retrieve transaction details
      *
     C                   EXSR      RTVTRAN
 
      ** TNLU used in 'record updated by another WS' checking
 
     C                   Z-ADD     FATNLU        H#TNLU
      *
      * If errors returned
      * Re-output screen with error messages on it
      *
     C     Idx           IFNE      0
     C                   EXSR      SET_SCEI
     C                   GOTO      EVAL@M
     C                   END
      *
      *----------------------------------------------------------------
      * IF DELETE
      *
     C     S#ACTN        IFEQ      'D'
      *
      * Update Transaction
      *
     C**********         MOVEL     LefeeaREC     F_REC                                        CGL029
     C                   MOVEL     LefeeaREC1    FLREC1                                       CGL029
     C                   MOVEL     RONS          FLRONS                                       CGL029
     C                   MOVEL     LefeeaREC2    FLREC2                                       CGL029
     C**********         MOVEL     LefeeaPAY     F_PAY                                        CGL029
     C                   MOVEL     LefeeaPAY1    FLPAY1                                       CGL029
     C                   MOVEL     PONS          FLPONS                                       CGL029
     C                   MOVEL     LefeeaPAY2    FLPAY2                                       CGL029
     C                   MOVE      CVMR          FLCVMR
     C                   MOVE      OMDB          FLPOBR
     C                   MOVE      OSDB          FLROBR
     C                   MOVE      FASCCY        FLPSCY
     C                   MOVE      FASCCY        FLRSCY
     C                   MOVE      FAICCY        FLIC72
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     FAREXR        FLREXR                                       CLE031
     C                   Z-ADD     FAPEXR        FLPEXR                                       CLE031
     C                   MOVE      FAREXI        FLREXI                                       CLE031
     C                   MOVE      FAPEXI        FLPEXI                                       CLE031
     C                   MOVE      FASCCY        FLRSCY                                       CLE031
     C                   MOVE      FAPSCY        FLPSCY                                       CLE031
     C                   ENDIF                                                                CLE031
      *
      * IF CK/10 TAKEN, GO ONTO UPDATES
      *
     C     *INKJ         IFEQ      '1'
     C                   MOVEL     'U'           @SCRN
     C                   END
     C                   GOTO      EVAL@M
     C                   END
      *
      *----------------------------------------------------------------
      * IF AUTHORISE
      *
     C     S#ACTN        IFEQ      'X'
      *
      * Update Transaction
      *
     C**********         MOVEL     LefeeaREC     F_REC                                        CGL029
     C                   MOVEL     LefeeaREC1    FLREC1                                       CGL029
     C                   MOVEL     RONS          FLRONS                                       CGL029
     C                   MOVEL     LefeeaREC2    FLREC2                                       CGL029
     C**********         MOVEL     LefeeaPAY     F_PAY                                        CGL029
     C                   MOVEL     LefeeaPAY1    FLPAY1                                       CGL029
     C                   MOVEL     PONS          FLPONS                                       CGL029
     C                   MOVEL     LefeeaPAY2    FLPAY2                                       CGL029
     C                   MOVE      CVMR          FLCVMR
     C                   MOVE      OMDB          FLPOBR
     C                   MOVE      OSDB          FLROBR
     C                   MOVE      FASCCY        FLPSCY
     C                   MOVE      FASCCY        FLRSCY
     C                   MOVE      FAICCY        FLIC72
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     FAREXR        FLREXR                                       CLE031
     C                   Z-ADD     FAPEXR        FLPEXR                                       CLE031
     C                   MOVE      FAREXI        FLREXI                                       CLE031
     C                   MOVE      FAPEXI        FLPEXI                                       CLE031
     C                   MOVE      FASCCY        FLRSCY                                       CLE031
     C                   MOVE      FAPSCY        FLPSCY                                       CLE031
     C                   ENDIF                                                                CLE031
      *
      * IF CK/11 TAKEN, GO ONTO UPDATES
      *
     C     *INKK         IFEQ      '1'
     C                   MOVEL     'U'           @SCRN
     C                   END
     C                   GOTO      EVAL@M
     C                   END
      *
      *----------------------------------------------------------------
      * IF INSERT OR AMEND
      *
     C     S#ACTN        IFEQ      'I'
     C     S#ACTN        OREQ      'A'
      *
      * IF AMEND
      *
     C     S#ACTN        IFEQ      'A'
      *
      * Validate whether non-amendable fields have been changed
      *
     C                   CALLB     'LEFEADCVT'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM      *BLANK        RetCodeIn
      *
      * Fee Adjustment details in file format
     C                   PARM                    LEFEEADFmt
      *
      * OUTPUTS
      *
      * Fee Adjustment Details in screen format
     C                   PARM                    C_FEAD
 
      * Customer details
     C                   PARM                    S#CNUM            6
     C                   PARM                    S#CSNM           10
     C                   PARM                    S#CRNM           20
     C                   PARM                    S#CRTN           10
 
      * Fee currency and decimal places
     C*******            PARM                    S#FCCY            3                          CAP084
     C                   PARM                    FecyNBDP          1 0
 
      * Adjustment amount edited
     C                   PARM                    S#SADE           19
 
      * Record status
     C                   PARM                    S#STAT           10
 
     C                   CALLB     'LEFEADAMD'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM      *BLANK        RetCodeIn
      *
      * New fee adjustment in Screen Format
     C                   PARM                    FEAD
      *
      * Current fee adjustment in Screen Format
     C                   PARM                    C_FEAD
      *
      * Current fee adjustment in File Format
     C                   PARM                    LEFEEADFmt
      *
      * OUTPUTS
      *
      * Field OK flags (DS) from/to caller
     C                   PARM                    FEAD_OK
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Idx               3 0
      *
      * Amendments OK
     C                   PARM                    AmendOk           1
      *
      * Reset of Fields in Error Required (Y/N)
     C                   PARM      'Y'           ResetErrs         1
      *
      * If errors returned
      * set screen error indicators (and send messages to the screen)
      *
     C     Idx           IFNE      0
     C                   EXSR      SET_SCEI
     C                   GOTO      EVAL@M
     C                   END
     C                   END
      *
      * Validate details
      *
     C                   CALLB     'LEFEADVAL'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM      *BLANK        RetCodeIn
 
      * Mode
     C                   PARM                    P#MODE            1
 
      * Fee Adjustment Details in screen format
     C                   PARM                    FEAD
 
      * Fee currency and decimal places
     C*******            PARM                    S#FCCY            3                          CAP084
     C                   PARM                    FecyNBDP          1 0
 
      * Facility amount
      * Facility branch
      * Facility branch details
      * Facility currency
      * Facility currency decimal places
     C                   PARM                    W#FAMT           13 0
     C                   PARM                    FcbrBranch        3
     C                   PARM                    FcbrBICN          6
     C                   PARM                    FcbrMQSM         10
     C**********         PARM                    FcbrSYCU          6 0                        CSD027
     C                   PARM                    FcbrSYCU          6                          CSD027
     C                   PARM                    FccyFCCY          3
     C                   PARM                    FccyNBDP          1 0
 
      * Front Office Inputs (if mode = 'B')
     C                   PARM                    F5PCOB            3
     C                   PARM                    F5TNRF           15
      *
      * OUTPUTS
      * Status                                                                  BUG1218
     C                   PARM                    S#STAT           10            BUG1218
 
      * Adjustment amount
     C                   PARM                    W#SADJ           13 0
 
      * Adjustment amount edited
     C                   PARM                    S#SADE           19
 
      * Field OK flags
     C                   PARM                    FEAD_OK
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      *zero         Idx               3 0
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      *zero         WIdx              3 0
 
      * Valid Fee Adjustment
     C                   PARM                    LEVFEADPD
      *
      * If errors returned
      * set screen error indicators (and send messages to the screen)
      *
     C     Idx           IFNE      0
     C                   EXSR      SET_SCEI
     C                   GOTO      EVAL@M
     C                   END
                                                                                              CAP086
      ** Setup Automatic Authorisation flag on the Valid file                                 CAP086
                                                                                              CAP086
     C                   IF        CAP086 = 'Y'                                               CAP086
     C                   EVAL      ADAUTH = F5AUTH                                            CAP086
     C                   ENDIF                                                                CAP086
      *
      * If windows processing on, call window routine
      * otherwise, continue to updates
      *
     C     BGWDPR        IFEQ      'Y'
     C                   MOVEL     'W'           @SCRN
     C                   ELSE
     C                   MOVEL     'U'           @SCRN
     C                   END
      *
     C                   END
      *----------------------------------------------------------------
     C     EVAL@M        ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * WINDOW - CALL WINDOW MANAGER
      *****************************************************************
     C     WINDOW        BEGSR
      *
     C/COPY QWINDSRC,LEFEADSMV1
      *
     C                   CALL      'WN0010'
     C                   PARM      'LEFEADRPR'   #PGM             10
     C                   PARM                    FKEY              2
     C                   PARM      S#ACTN        ACTION            1
     C                   PARM                    DATA           1024
     C                   PARM      *BLANKS       #RTRN             7
     C                   PARM                    SPAREW          256
      *
      * Process returned command keys
      *
     C     #RTRN         IFEQ      'Y2U9999'
     C                   EXSR      ENDP
     C                   ELSE
      *
      *  If Cmd12 pressed, return to main details screen;
      *  otherwise, go to updates
      *
     C     #RTRN         IFEQ      'USR0790'
     C     @RDNB         IFEQ      'Y'
     C                   EVAL      @SCRN = 'R'
     C                   ELSE
     C                   EVAL      @SCRN = 'M'
     C                   END
     C                   ELSE
     C                   EVAL      @SCRN = 'U'
     C                   ENDIF
     C                   ENDIF
      *
     C     WIND          ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * CANC@M - CANCEL ON MAIN DETAILS SCREEN
      *****************************************************************
     C     CANC@M        BEGSR
      *
      * IF RECORDS ARE STILL TO BE READ FROM THE SUBFILE, READ THEM
      *
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ELSE
      *
      * ELSE, RETURN TO THE BROWSE SCREEN
      *
     C                   MOVEL     'B'           @SCRN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * UPDATS - UPDATES
      *****************************************************************
     C     UPDATS        BEGSR
      *
      * Include Header fields that need to be o/p to the valid file
      * If there is no front office ID, use the PCREF created by LEASGNVAL.
     C     DDFRNT        Ifeq      *Blank
     C                   MOVEL     ADPCRF        ADFRNT
     C                   Else
     C                   MOVEL     DDFRNT        ADFRNT
     C                   EndIf
 
     C                   EVAL      ADAFRT = DDAFRT
     C                   EVAL      ADREPA = DDREPA
     C                   EVAL      ADSTMP = XTMST
      *
      * DATABASE UPDATES
      *
     C                   CALLB     'LEFEADUPD'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM      *BLANK        RetCodeOut
 
      * Mode
     C                   PARM                    P#MODE            1
 
      * Action code
     C                   PARM                    S#ACTN            1
 
      * Fee Adjustment Details in file format
     C                   PARM                    LEVFEADPD
 
      * Fee currency
     C                   PARM                    S#FCCY            3
 
      * Adjustment amount
     C                   PARM                    W#SADJ           13 0
 
      * Settlement adjustment due date
     C                   PARM                    W#SADD            5 0
 
      * Participant Fee Indicator
     C                   PARM                    W#PTFI            1
 
      * TNLU of fee adjustment record on LEFEEAD
     C                   PARM                    H#TNLU            5 0
 
      * Facility amount
      * Facility branch
      * Facility branch details
      * Facility currency
      * Facility currency decimal places
     C                   PARM                    W#FAMT           13 0
     C                   PARM                    FcbrBranch        3
     C                   PARM                    FcbrBICN          6
     C                   PARM                    FcbrMQSM         10
     C**********         PARM                    FcbrSYCU          6 0                        CSD027
     C                   PARM                    FcbrSYCU          6                          CSD027
     C                   PARM                    FccyFCCY          3
     C                   PARM                    FccyNBDP          1 0
 
      * Front office inputs (if mode = 'B')
     C                   PARM                    F5PCOB            3
     C                   PARM                    F5TNRF           15
     C                   PARM                    F5IUSR           10
     C                   PARM                    F5XUSR           10
     C                   PARM                    F5AUSR           10
      *
      * OUTPUTS
      *
      * Field OK flags
     C                   PARM                    FEAD_OK
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      *zero         Idx               3 0
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      *zero         WIdx              3 0
      *
      * IF THERE WERE ANY ERRORS IN THE UPDATE FUNCTIONS, ROLLBACK ANY
      * UPDATES AND END THIS PROGRAM.
      * OTHERWISE DELETE THE INVALID TRANSACTION & COMMIT THE UPDATES
      *
     C     RetCodeOut    IFNE      *BLANK
     C     CSC022        IFEQ      'N'                                                        CSC022
     C                   ROLBK
     C                   ELSE                                                                 CSC022
     C     WCMT01        IFNE      'Y'                                                        CSC022
     C                   ROLBK                                                                CSC022
     C                   ELSE                                                                 CSC022
     C                   SETON                                        U7U8                    CSC022
     C                   ENDIF                                                                CSC022
     C                   ENDIF                                                                CSC022
     C     RetCodeOut    IFNE      '*RECUPD'
     C                   EXSR      *PSSR
     C                   ENDIF
     C
     C                   ELSE
     C     LEIFEADK      CHAIN     LEIFEADD0                          99
     C  N99              DELETE    LEIFEADD0
      ** Delete invalid record from the log file
 
     C                   IF        CSC011 = 'Y' AND
     C                             S1SUPP = LIBR
 
     C                   EVAL      KMsgType = 'LEFEAD'
     C                   EVAL      KFrntOffID = DDFRNT
     C                   EVAL      KTimeStamp = XTMST
 
     C     KAPLOG        CHAIN     APILOGL0                           99
 
     C                   IF        *IN99 = *OFF
     C                   DELETE    APILOGL0
     C                   ENDIF
 
     C                   ENDIF
 
     C     CSC022        IFEQ      'N'                                                        CSC022
     C     WCMT01        OREQ      'N'                                                        CSC022
     C     CSC022        ANDEQ     'Y'                                                        CSC022
     C                   COMMIT
     C                   ENDIF                                                                CSC022
     C                   END
      *
      * If error occurred in updating last transaction set on flag to
      * display message on 'browse' screen.
     C     RetCodeOut    IFEQ      '*RECUPD'
     C                   MOVE      'Y'           @ERRUP
     C                   ELSE
     C                   MOVE      'N'           @ERRUP
     C                   END
     C
      * IF RECORDS ARE STILL TO BE READ FROM THE SUBFILE, READ THEM
      *
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ELSE
      *
      * ELSE, RETURN TO THE BROWSE SCREEN
      *
     C                   MOVEL     'B'           @SCRN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * ENDP - END PROGRAM
      *****************************************************************
     C     ENDP          BEGSR
 
     C                   MOVEL     'T'           @SCRN
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * RTVTRAN - RETRIEVE TRANSACTION
      *****************************************************************
     C     RTVTRAN       BEGSR
 
     C                   CALLB     'LEFEADRTV'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM      *BLANK        RetCodeIn
 
      * Mode
     C                   PARM                    P#MODE            1
 
      * Response Code
     C                   PARM      'S'           RESPMODE          1
 
      * Action, customer, facility type, facility number
      * and fee sequence number
     C                   PARM                    S#ACTN            1
     C                   PARM                    S#CSSN           10
     C                   PARM                    S#FACT            3
     C                   PARM                    S#FCNO            2
     C                   PARM                    S#FSEQ            2
      *
      * OUTPUTS
 
      * Fee Adjustment Details in file format
     C                   PARM                    LEFEEADFmt
 
      * Action, customer, facility type, facility number
      * and fee sequence number OK indicators
     C                   PARM                    S#ACTNok          1
     C                   PARM                    S#CSSNok          1
     C                   PARM                    S#FACTok          1
     C                   PARM                    S#FCNOok          1
     C                   PARM                    S#FSEQok          1
 
      * Customer number
     C                   PARM                    S#CNUM            6
 
      * Fee currency and decimal places
     C                   PARM                    S#FCCY            3
     C                   PARM                    FecyNBDP          1 0
 
      * Fee type, fee code, fee narrative, total fee accrued to date
     C                   PARM                    S#FTYP           10
     C                   PARM                    S#FCOD            2
     C                   PARM                    S#FENV           20
     C                   PARM                    S#ACCD           18
 
      * Settlement adjustment due date
     C                   PARM                    W#SADD            5 0
 
      * Participant Fee Indicator
     C                   PARM                    W#PTFI            1
 
      * Facility amount
      * Facility branch
      * Facility branch details
      * Facility currency
      * Facility currency decimal places
     C                   PARM                    W#FAMT           13 0
     C                   PARM                    FcbrBranch        3
     C                   PARM                    FcbrBICN          6
     C                   PARM                    FcbrMQSM         10
     C**********         PARM                    FcbrSYCU          6 0                        CSD027
     C                   PARM                    FcbrSYCU          6                          CSD027
     C                   PARM                    FccyFCCY          3
     C                   PARM                    FccyNBDP          1 0
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM      *zero         Idx               3 0
      *
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      *zero         WIdx              3 0
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Set screen error indicators                                   *
      *****************************************************************
     C     SET_SCEI      BEGSR
 
      * Move 'OK' flags into array (for checking)
 
     C                   MOVEA     FEAD_OK       #EI
 
      * Set screen error indicators according to status of 'OK' flags
 
     C                   Z-ADD     1             #C                2 0
     C                   Z-ADD     40            #E                2 0
      *
     C     #C            DOUGT     25
     C     #EI(#C)       IFEQ      'N'
     C     #EI(#C)       OREQ      'W'
     C                   MOVEL     '1'           *IN(#E)
     C                   END
     C                   ADD       1             #C
     C                   ADD       1             #E
     C                   END
 
      *  Do while error messages found
      *  Write error messages to subfile
 
     C                   Z-ADD     1             #C
     C     #C            DOWLE     ArrayMax
     C     FldNameArr(#C)ANDNE     *BLANKS
     C                   MOVEL     MsgIdArr(#C)  ZAMSID
     C                   EXSR      ZASNMS
     C                   ADD       1             #C
     C                   ENDDO
 
      *  Do while warning messages found
      *  Write warning messages to subfile
 
     C                   Z-ADD     1             #C
     C     #C            DOWLE     ArrayMax
     C     WFldNamArr(#C)ANDNE     *BLANKS
     C                   MOVEL     WMsgIdArr(#C) ZAMSID
     C                   EXSR      ZASNMS
     C                   ADD       1             #C
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Reset screen error indicators                                 *
      *****************************************************************
     C     RESET_SCEI    BEGSR
     C                   SETOFF                                       40
     C                   SETOFF                                       414243
     C                   SETOFF                                       444546
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Clear the message queue                                       *
      *****************************************************************
     C     CLEARM        BEGSR
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM      PSProcName    ZAPGM            10
     C                   PARM      '*SAME'       ZAPGRL            5
      *
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      *  Send messages to the program's message queue                 *
      *****************************************************************
     C     ZASNMS        BEGSR
      *
     C     ZAPGMQ        IFEQ      *BLANK
     C                   MOVEL     PSProcName    ZAPGMQ
     C                   END
 
     C                   CALL      'Y2SNMGC'                            9999
     C                   PARM                    ZAPGMQ           10
     C                   PARM                    ZAPGRL            5
     C                   PARM                    ZAMSID            7
     C                   PARM                    ZAMSGF           10
     C                   PARM                    ZAMSDA          132
     C                   PARM                    ZAMSTP            7
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Initialise program name
      *
     C                   MOVEL     'LEFEADRPR'   DBPGM
      *
      ** Mode
      *
     C                   MOVEL     'B'           P#MODE
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      ** Access Module Details
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   MOVEL     '902'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      ** Access retail details
      *
     C     BGRTBN        IFEQ      'Y'
     C                   CALL      'AORETLR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDRETL        PARM      SDRETL        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDRETLPD'    DBFILE
     C                   MOVEL     '903'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *
      ** Access API ICD Details
      *
     C                   CALLB     'AOAPIR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDAPI         PARM      SDAPI         DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDAPIPD '    DBFILE
     C                   MOVEL     '904'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      * Start on Browse Screen
      *
     C                   MOVEL     'B'           @SCRN             1
 
      * Screen fields
     C                   MOVE      PSUser        S#USER
     C                   MOVE      PSJobName     S#WSID
     C                   MOVE      BJMRDT        S#RUNA
     C                   MOVE      PSProcName    ##PGM
 
      * Subfile indicators
     C                   MOVE      *ON           *IN25
 
      * Message file
     C                   MOVEL     'LERMSGF   '  ZAMSGF
 
      ** Message Type
     C                   MOVEL     'FEAD'        @MSGTYPE          4
 
      ** Check if CSC011 is installed
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSC011'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRTCD = *Blanks
 
     C                   EVAL      CSC011 = 'Y'
 
     C                   OPEN      APILOGL0
 
     C                   IN        SC24X7
     C                   IN        SDSTAT
 
     C                   ELSE
 
      ** Database error
 
     C                   IF        PRTCD <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = 'CSC011'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 904
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
      *
      * Key Lists
      *
     C     ZATRNK        KLIST
     C                   KFLD                    ABFOTRNID
     C                   KFLD                    @XTMSTSEL
     C     LEIFEADK      KLIST
     C                   KFLD                    @XREPNSEL
     C                   KFLD                    @XTMSTSEL
 
     C     LEIFEADX      KLIST
     C                   KFLD                    @XTMSTSEL
     C                   KFLD                    @XREPNSEL
 
     C     KAPLOG        KLIST
     C                   KFLD                    KMsgType
     C                   KFLD                    KFrntOffID
     C                   KFLD                    KTimeStamp
 
      * Determine if CSC022 is switched on                                                    CSC022
                                                                                              CSC022
     C                   CALLB     'AOSARDR0'                                                 CSC022
     C                   PARM      *BLANKS       PRTCD                                        CSC022
     C                   PARM      '*VERIFY'     POPTN                                        CSC022
     C                   PARM      'CSC022'      PSARD                                        CSC022
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC022
     C                   IF        PRTCD = *BLANK                                             CSC022
     C                   EVAL      CSC022 ='Y'                                                CSC022
     C                   EVAL      WCMT01 ='N'                                                CSC022
      * SCCMTJOB data area                                                                    CSC022
     C                   IN        SCCMTJOB                                                   CSC022
      * Move data area to commitment array                                                    CSC022
     C                   IF        COMITNOM > 0                                               CSC022
     C                   MOVEA     COMITJOB      ARRJBNAM                                     CSC022
      * Check if PSJOBNAME exist.                                                             CSC022
     C     PSJOBNAME     LOOKUP    ARRJBNAM                               17                  CSC022
     C                   IF        *IN17 = *ON                                                CSC022
     C                   EVAL      WCMT01= 'Y'                                                CSC022
     C                   ENDIF                                                                CSC022
     C                   ENDIF                                                                CSC022
      *                                                                                       CSC022
     C                   ELSE                                                                 CSC022
      * @rtcd not found                                                                       CSC022
     C                   IF        PRTCD <> '*NRF'                                            CSC022
     C     *LOCK         IN        LDA                                                        CSC022
     C                   EVAL      DBPGM = 'LEFEADRPR'                                        CSC022
     C                   EVAL      DBKEY = 'CSC022'                                           CSC022
     C                   EVAL      DBFILE ='SCSARDPD'                                         CSC022
     C                   EVAL      DBASE  = 905                                               CSC022
     C                   OUT       LDA                                                        CSC022
     C                   EXSR      *PSSR                                                      CSC022
     C                   ENDIF                                                                CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CAP086
      ** Access SAR details file to determine if                                              CAP086
      ** Automatic Authorisation is installed                                                 CAP086
                                                                                              CAP086
     C                   EVAL      CAP086 = 'N'                                               CAP086
     C                   CALL      'AOSARDR0'                                                 CAP086
     C                   PARM      *BLANKS       @RTCD                                        CAP086
     C                   PARM      '*VERIFY'     @OPTN                                        CAP086
     C                   PARM      'CAP086'      @SARD                                        CAP086
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP086
                                                                                              CAP086
     C                   IF        @RTCD <> *BLANKS AND                                       CAP086
     C                             @RTCD <> '*NRF'                                            CAP086
     C     *LOCK         IN        LDA                                                        CAP086
     C                   EVAL      DBPGM = 'LEFEADRPR'                                        CAP086
     C                   EVAL      DBKEY = 'CAP086'                                           CAP086
     C                   EVAL      DBFILE ='SCSARDPD'                                         CAP086
     C                   EVAL      DBASE  = 906                                               CAP086
     C                   OUT       LDA                                                        CAP086
     C                   EXSR      *PSSR                                                      CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
     C                   IF        @RTCD = *BLANK                                             CAP086
     C                   EVAL      CAP086 = 'Y'                                               CAP086
     C                   ENDIF                                                                CAP086
      *                                                                                       CSC022
      ** Determine if Settlement Currency is installed                                        CLE031
                                                                                              CLE031
     C                   MOVE      'N'           CLE031            1                          CLE031
     C                   CALLB     'AOSARDR0'                                                 CLE031
     C                   PARM      *BLANKS       PRTCD                                        CLE031
     C                   PARM      '*VERIFY'     POPTN                                        CLE031
     C                   PARM      'CLE031'      PSARD                                        CLE031
                                                                                              CLE031
     C     PRTCD         IFEQ      *BLANKS                                                    CLE031
     C                   MOVE      'Y'           CLE031                                       CLE031
     C                   ENDIF                                                                CLE031
                                                                                              CLE031
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2002
