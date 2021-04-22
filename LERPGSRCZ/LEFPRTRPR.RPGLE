     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Funding participant repair')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LEFPRTRPR - Funding Participant Repair                       *
      *                                                               *
      *  Function:  This function allows invalid funding participants *
      *             to be 'repaired' and applied to the Midas database*
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CLE148             Date 23Jul12               *
      *                 CLE064             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE031             Date 10Feb03               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 222373             Date 04Nov03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CLE023             Date 12Apr02               *
      *                 CAP068  *CREATE    Date 20Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE148 - Alpha Loan Reference                                *
      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE031 - Lending Enhancements - Settlement Currency          *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222373 - Parameter Mismatch                                  *
      *  CLE023 - Recompiled due to changes to LEVFCLNPD.             *
      *  CAP068 - Conversion of LE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FZATRNERRL0IF   E           K DISK    INFSR(*PSSR)

     FLEIFPRTL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LEIFPRTD0 : LEIFPRTX0)
     FLEIFPRTL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT

     FAPILSETL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(APILSETD0:APILSETX0)
     FAPILSETL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT

      ** API Invalid log file by Type/FO Id/Time
     FAPILOGL0  UF   E           K DISK    INFSR(*PSSR) USROPN
     F                                     COMMIT

     FLEFPRTDDF CF   E             WORKSTN INFSR(*PSSR)

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

     D #EI             S              1    DIM(25)


      ** Funding Participant Details in screen format
     D FPRT          E DS                  EXTNAME(LEFPRTPD)

      ** Funding Participant Details OK indicator
     D FPRT_OK       E DS                  EXTNAME(LEEFPRTPD)


      ** Funding Participant Details in file format
     D FCLTYFMFmt    E DS                  EXTNAME(FCLTYFM)
     D***FcltyREC             455    523                                                      CGL029
     D***FcltyPAY             524   1082                                                      CGL029
     D  FcltyREC             469    523                                                       CGL029
     D  FcltyPAY             538   1082                                                       CGL029
     D  FcltyRECEx          1182   1199                                                       CGL029
     D  FcltyPAYEx          1200   1217                                                       CGL029

      ** New Funnding Participant Details in file format record 'A'
     D LEVFCLMPD     E DS                  EXTNAME(LEVFCLMPD)
     D***V_REC**              455    523                                                      CGL029
     D***V_PAY**              524   1082                                                      CGL029
     D  V_REC                469    523                                                       CGL029
     D  V_PAY                538   1082                                                       CGL029
     D  V_RECEx             1176   1193                                                       CGL029
     D  V_PAYEx             1194   1211                                                       CGL029

      ** New Funnding Participant Details in file format record 'B'
     D LEVFCLNPD     E DS                  EXTNAME(LEVFCLNPD)

      ** Settlement Details in file format
     D APILSETPDFmt  E DS                  EXTNAME(APILSETPD)
     D***APILSETREC           100    174                                                      CGL029
     D***APILSETPAY           175    743                                                      CGL029
     D  APILSETREC           100    180                                                       CGL029
     D  APILSETPAY           181    755                                                       CGL029

      * File Receive instructions
     D F_REC         E DS                  EXTNAME(SDESFRPD) PREFIX(F_)
     D  F_RECEx               21     81                                                       CGL029

      * File Payment instructions
     D F_PAY         E DS                  EXTNAME(SDESFPPD) PREFIX(F_)
     D  F_PayEx               21    575                                                       CGL029


      ** Current Funding Participant Details in screen format
     D C_FPRT        E DS                  EXTNAME(LEFPRTPD)
     D                                     PREFIX(C_)

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
     D                                     PREFIX(SC_)

      ** Override Database Table
     D ##OX1           S              1    DIM(50) CTDATA PERRCD(50)

      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D DSFDY         E DS                  EXTNAME(DSFDY)


      ** Data structure for passing a parameter to synon screen
      ** handling program.
     D SETLIB        E DS                  EXTNAME(SETLIAB) INZ
     D QQRONS1       E                     EXTFLD(QQRONS)                                     CGL029
     D QQPONS1       E                     EXTFLD(QQPONS)                                     CGL029

      ** Data structure for passing a parameter to synon screen
      ** handling program.
     D SETLIZ        E DS                  EXTNAME(SETLIAZ)
                                                                                              222373
     D P@ARM3        E DS                  EXTNAME(SDSETLPD)                                  222373

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Timestamp
     D @XTMSTSEL       S             26Z
     D @XREPNSEL       S              5S 0
     D CSC011          S              1A   INZ('N')
     D KMsgType        S              8A
     D KFrntOffID      S             20A
     D KTimeStamp      S                   LIKE(@XTMSTSEL)
     D PRTCD           S              7A
     D POPTN           S              7A
     D PSARD           S              6A


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

      * DO WHILE SCREEN: SETTLEMENT DETAILS
     C     @SCRN         DOWEQ     'S'
     C                   EXSR      SCRN@S
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
     C                   CALLB     'LEFPRTRPB'
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
      * Error in update of previous funding participant
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
     C                   PARM                    @XREPNSEL
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
     C                   CALLB     'LEFPRTRPB'
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
      * Error in update of previous funding participant
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
     C                   PARM      *ZERO         @XREPNSEL
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
     C                   MOVEL     *BLANK        FPRT
     C                   MOVEL     *BLANK        S#CNUM
     C                   MOVEL     *BLANK        S#SRNM
     C                   MOVEL     *BLANK        S#SRTN
     C                   MOVEL     *BLANK        S#IRNM
     C                   MOVEL     *BLANK        S#IRTN
      *
      * RESET ERRORS
      *
     C                   MOVE      *ALL'Y'       FPRT_OK
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   Z-ADD     0             Idx
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
     C                   Z-ADD     0             WIdx
      *
      * Retrieve funding participant details
      *
     C     LEIFPRTX      CHAIN     LEIFPRTX0                          99
      *
      * Access invalid lending settlement instructions
      *
     C                   CLEAR                   F_REC
     C                   CLEAR                   F_PAY
     C     APILSETX      CHAIN     APILSETX0                          99

      ** Funding Participant settlement instructions

     C                   MOVEL     APILSETREC    F_REC
     C                   MOVEL     APILSETPAY    F_PAY

     C                   EXSR      SET_FL2SC

      * Access primary facility

     C                   EXSR      ACSPFA
     C                   MOVEL     FcbrBranch    S#BRCA
     C                   MOVEL     FccyFCCY      S#FCCY
      *
      * If errors occurred in access of primary facility
      * blank out action code so that the input cannot proceed
      * and send the error messages to the main details screen
      *
     C     Idx           IFNE      0
     C                   MOVEL     *BLANK        S#ACTN
     C                   ELSE

      * Retrive current transaction

     C                   EXSR      RTVTRAN
      *
      * If errors occurred in access of current transaction
      * blank out action code so that the input cannot proceed
      *
     C     Idx           IFNE      0
     C                   MOVEL     *BLANK        S#ACTN
     C                   ENDIF
     C                   ENDIF

      * Send the error messages to the main details screen

     C                   EXSR      SNDM@M
     C                   EXSR      SET_SCEI

      * Reset Settlement Screen Setup indicator

     C                   MOVE      'N'           SSCR_SetUp
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
      ** Initialize error indicators
      *
     C                   MOVEA     FPRT_OK       #EI
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
     C     F             IFLT      1
     C     F             ORGT      19
     C                   Z-ADD     1             F
     C                   END
     C                   MOVE      'N'           #EI(F)
     C     ZATRNK        READE     ZATRNERRD0                             99    *
     C                   END
      *
     C                   MOVEA     #EI           FPRT_OK
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
     C                   ROLBK
     C                   END
      *
      * Enable/disable detail fields on main details screen
      * if changes to the data are allowed
      * (Action code can only be 'I', 'A', or 'R')
      *
     C     S#ACTN        IFEQ      'I'
     C     @OPSEL        ANDEQ     'U'
     C     S#ACTN        OREQ      'A'
     C     @OPSEL        ANDEQ     'U'
     C                   MOVEL     '0'           *IN67
     C                   ELSE
     C                   MOVEL     '1'           *IN67
     C                   END

     C     S#ACTN        IFEQ      'I'
     C                   MOVEL     '1'           *IN09
     C                   ELSE
     C                   MOVEL     '0'           *IN09
     C                   END
      *
      * KJ = COMMAND KEY 10 = CONFIRM REVERSE
      *
     C     S#ACTN        IFEQ      'R'
     C                   MOVEL     '1'           *IN68
     C                   ELSE
     C                   MOVEL     '0'           *IN68
     C                   END
      *
      * WRITE/READ DISPLAY SCREEN
      *
     C                   WRITE     LEFPRTF2
     C                   WRITE     LEFPRTF1
     C                   WRITE     #MSGCTL
     C                   EXFMT     LEFPRTF3
      *
      * RESET ERRORS
      *
     C                   MOVE      *ALL'Y'       FPRT_OK
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

     C                   Z-ADD     TNLU          H#TNLU
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
      * IF REVERSE
      *
     C     S#ACTN        IFEQ      'R'
      *
      * Update Transaction
      *
     C**********         MOVEL     FcltyREC      F_REC                                        CGL029
     C**********         MOVEL     FcltyPAY      F_PAY                                        CGL029
     C                   MOVEL     FcltyREC      F_RECEx                                      CGL029
     C                   MOVEL     FcltyPAY      F_PAYEx                                      CGL029
     C                   MOVEL     FcltyRECEx    F_FLRONS                                     CGL029
     C                   MOVEL     FcltyPAYEx    F_FLPONS                                     CGL029
     C                   MOVEL     RSTM          F_FLRSTM                                     CGL029
     C                   MOVEL     PSTM          F_FLPSTM                                     CGL029
     C                   MOVE      CVMR          F_FLCVMR
     C                   MOVE      OMDB          F_FLPOBR
     C                   MOVE      OSDB          F_FLROBR
     C                   MOVE      SCCY          F_FLPSCY
     C                   MOVE      SCCY          F_FLRSCY
     C                   MOVE      ICCY          F_FLIC72
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     REXR          F_FLREXR                                     CLE031
     C                   Z-ADD     PEXR          F_FLPEXR                                     CLE031
     C                   MOVE      REXI          F_FLREXI                                     CLE031
     C                   MOVE      PEXI          F_FLPEXI                                     CLE031
     C                   MOVE      SCCY          F_FLRSCY                                     CLE031
     C                   MOVE      PSCY          F_FLPSCY                                     CLE031
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
      * IF INSERT OR AMEND
      *
     C     S#ACTN        IFEQ      'I'
     C     S#ACTN        OREQ      'A'
      *
      * IF AMEND
      *
     C     S#ACTN        IFEQ      'A'
      *
      * Validate whether non-amenable fields have been changed
      *
     C                   CALLB     'LEFPRTCVT'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM      *BLANK        RetCodeIn
      *
      * Funding participant facility details in file format
     C                   PARM                    FCLTYFMFmt
      *
      * OUTPUTS
      *
      * Funding Participant Facility Details in screen format
     C                   PARM                    C_FPRT

      * Syndicate member details
     C                   PARM                    S#CNUM            6
     C                   PARM                    S#CSNM           10
     C                   PARM                    S#SRNM           20
     C                   PARM                    S#SRTN           10

      * Introducing customer details
     C                   PARM                    S#IRNM           20
     C                   PARM                    S#IRTN           10

     C                   CALLB     'LEFPRTAMD'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM                    RetCodeIn
      *
      * New funding participant in Screen Format
     C                   PARM                    FPRT
      *
      * Current funding participant in Screen Format
     C                   PARM                    C_FPRT
      *
      * Current funding participant in File Format
     C                   PARM                    FCLTYFMFmt
      *
      * OUTPUTS
      *
      * Field OK flags (DS) from/to caller
     C                   PARM                    FPRT_OK
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
      * Validate deal details
      *
     C                   CALLB     'LEFPRTVAL'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM      *BLANK        RetCodeIn

      * Mode
     C                   PARM                    P#MODE            1

      * Funding Participant Details in screen format
     C                   PARM                    FPRT

      * Agent number
     C                   PARM                    S#ANUM            6

      * Prime Facility amount
      * Prime Facility branch
      * Prime Facility branch details
      * Prime Facility currency
      * Prime Facility currency decimal places
     C                   PARM                    W#FAMT           13 0
     C                   PARM                    FcbrBranch        3
     C                   PARM                    FcbrBICN          6
     C                   PARM                    FcbrMQSM         10
     C**********         PARM                    FcbrSYCU          6 0                        CSD027
     C                   PARM                    FcbrSYCU          6                          CSD027
     C                   PARM                    FccyFCCY          3
     C                   PARM                    FccyNBDP          1 0

      * TNLU of funding participant record on FCLTYFM/FN
     C                   PARM                    H#TNLU

      * Front office inputs (if mode = 'B')
     C                   PARM                    F1PCOB            3
     C                   PARM                    F1TNRF           15
     C                   PARM                    F1IUSR           10
     C                   PARM                    F1XUSR           10
     C                   PARM                    F1AUSR           10

      * OUTPUTS

      * Field OK flags
     C                   PARM                    FPRT_OK
      *
      * Syndicate customer number
     C                   PARM                    S#CNUM            6
      * Syndicate member customer name/town
     C                   PARM                    S#SRNM           20
     C                   PARM                    S#SRTN           10
      * Introducing customer name/town
     C                   PARM                    S#IRNM           20
     C                   PARM                    S#IRTN           10
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

      * Valid Funding Participant Record 'A'
     C                   PARM                    LEVFCLMPD
      * Valid Funding Participant Record 'B'
     C                   PARM                    LEVFCLNPD
      *
      * If errors returned
      * set screen error indicators (and send messages to the screen)
      *
     C     Idx           IFNE      0
     C                   EXSR      SET_SCEI
     C                   GOTO      EVAL@M
     C                   END
      *
      * If windows processing on, call window routine
      * otherwise, continue to settlements screen
      *
     C     BGWDPR        IFEQ      'Y'
     C                   MOVEL     'W'           @SCRN
     C                   ELSE
     C                   MOVEL     'S'           @SCRN
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
     C/COPY QWINDSRC,LEFPRTSMV1
      *
     C                   CALL      'WN0010'
     C                   PARM      'LEFPRTRPR'   #PGM             10
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
      *  otherwise, go to settlements screen
      *
     C     #RTRN         IFEQ      'USR0790'
     C     @RDNB         IFEQ      'Y'
     C                   EVAL      @SCRN = 'R'
     C                   ELSE
     C                   EVAL      @SCRN = 'M'
     C                   END
     C                   ELSE
     C                   EVAL      @SCRN = 'S'
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
      * SCRN@S - PROCESS SCREEN: SETTLEMENT DETAILS
      *****************************************************************
     C     SCRN@S        BEGSR

      ** Setup the settlement screen fields (SETLIAB/SETLIAZ)

     C     SSCR_SetUp    IFEQ      'N'
     C                   EXSR      SETUP_SSCR
     C                   MOVE      'Y'           SSCR_SetUp        1
     C                   ENDIF

      ** Call extended settlements input

     C                   CALL      'SD2400'
     C                   PARM                    @RTCD
     C                   PARM                    SETLIB
     C                   PARM                    SETLIZ
     C**********         PARM                    SLNREF            6 0                 222373 CLE148
     C                   PARM                    SLNREF            6                          CLE148
     C                   PARM                    P@ARM3                                       222373

      ** Terminate the program if database error returned

     C     PMDBSE        IFNE      *ZERO
     C                   MOVEL     PMDBFL        DBFILE
     C                   MOVE      PMDBSE        DBASE
     C                   MOVEL     PMDBKY        DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   MOVE      'N'           PMFRST

      ** If CF/3 taken in settlements screen, end the program

     C     PMCMDP        IFEQ      '03'
     C                   MOVE      '1'           *INKC
      *
     C                   ELSE

      ** If settlement details not valid (or no validation done)
      ** return to the main screen and send a message
      ** Otherwise, update the file fields with the screen fields

     C     PMSDTV        IFNE      'Y'

     C                   MOVE      '1'           *INKL
     C     PMERCD        IFNE      *BLANK
     C                   MOVEL     'LEA1020'     ZAMSID
     C                   ELSE
     C                   MOVEL     'LEX9991'     ZAMSID
     C                   ENDIF
     C                   EXSR      ZASNMS

     C                   ELSE
     C                   EXSR      SET_SC2FL
     C                   ENDIF

     C                   ENDIF
      *
      * CK/3 - END PROGRAM
      *
     C     *INKC         CASEQ     '1'           ENDP
      *
      * CK/12 - CANCEL ON SETTLEMENT DETAILS
      *
     C     *INKL         CASEQ     '1'           CANC@S
      *
      * EXIT FROM SETTLEMENT DETAILS
      *
     C                   CAS                     EXIT@S
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * CANC@S - CANCEL ON SETTLEMENT DETAILS SCREEN
      *****************************************************************
     C     CANC@S        BEGSR
      *
      * Return to Main Details Screen
      *
     C                   MOVEL     'M'           @SCRN
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * EXIT@S - EXIT FROM SETTLEMENT DETAILS SCREEN
      *****************************************************************
     C     EXIT@S        BEGSR
      *
      * DO UPDATES
      *
     C                   MOVEL     'U'           @SCRN
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
      * If there is no front office ID, use the PCREF created by LEFPRTVAL.
     C     DDFRNT        Ifeq      *Blank
     C                   MOVEL     FPPCRF        FPFRNT
     C                   Else
     C                   MOVEL     DDFRNT        FPFRNT
     C                   EndIf

     C                   EVAL      FPAFRT = DDAFRT
     C                   EVAL      FPREPA = DDREPA
     C                   EVAL      FPSTMP = XTMST
      *
      * DATABASE UPDATES
      *
     C                   CALLB     'LEFPRTUPD'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM      *BLANK        RetCodeOut

      * Mode
     C                   PARM                    P#MODE            1

      * Action Code
     C                   PARM                    S#ACTN            1

      * TNLU of funding participant record on FCLTYFM/FN
     C                   PARM                    H#TNLU            5 0

      * Funding Participant Details in file format record 'A'
     C                   PARM                    LEVFCLMPD
      * Funding Participant Details in file format record 'B'
     C                   PARM                    LEVFCLNPD
      *
      * OUTPUTS
      *
      * Field OK flags
     C                   PARM                    FPRT_OK
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      *zero         Idx
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      *zero         WIdx
      * Facility sequence assigned

     C                   PARM                    A_FCNO            2
      *
      * IF THERE WERE ANY ERRORS IN THE UPDATE FUNCTIONS, ROLLBACK ANY
      * UPDATES AND END THIS PROGRAM.
      * OTHERWISE DELETE THE INVALID TRANSACTION & COMMIT THE UPDATES
      *
     C     RetCodeOut    IFNE      *BLANK
     C                   ROLBK
     C     RetCodeOut    IFNE      '*RECUPD'
     C                   EXSR      *PSSR
     C                   ENDIF
     C
     C                   ELSE
     C     LEIFPRTK      CHAIN     LEIFPRTD0                          99
     C  N99              DELETE    LEIFPRTD0
     C     APILSETK      CHAIN     APILSETD0                          99
     C  N99              DELETE    APILSETD0

      ** Delete invalid record from the log file

     C                   IF        CSC011 = 'Y' AND
     C                             S1SUPP = LIBR

     C                   EVAL      KMsgType = 'LEFPRT'
     C                   EVAL      KFrntOffID = DDFRNT
     C                   EVAL      KTimeStamp = XTMST

     C     KAPLOG        CHAIN     APILOGL0                           99

     C                   IF        *IN99 = *OFF
     C                   DELETE    APILOGL0
     C                   ENDIF

     C                   ENDIF

     C                   COMMIT
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

      ** Close the extended settlements program and end processing

     C                   MOVE      'T'           PMTERM
     C                   CALL      'SD2400'
     C                   PARM                    @RTCD
     C                   PARM                    SETLIB
     C                   PARM                    SETLIZ
     C**********         PARM                    SLNREF            6 0                 222373 CLE148
     C                   PARM                    SLNREF            6                          CLE148
     C                   PARM                    P@ARM3                                       222373

     C                   MOVEL     'T'           @SCRN
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Setup the settlement screen fields (SETLIAB/SETLIAZ)          *
      *****************************************************************
     C     SETUP_SSCR    BEGSR

      ** Set action, customer, currencies and branch for settlement screen

     C                   MOVE      S#ACTN        PMACTC
     C                   MOVE      'LEND'        PMCPGM
     C                   MOVEL     S#CNUM        PMCSNM
     C                   Z-ADD     BJRDNB        PMDTRC
     C                   Z-ADD     BJRDNB        PMDTPY
     C                   MOVE      FccyFCCY      PMRCCY
     C                   MOVE      FccyFCCY      PMPCCY
     C                   MOVE      *BLANK        PMFFND
     C                   MOVE      FcbrBranch    PMBRCA
     C                   MOVE      *BLANK        PMCMDP
     C                   Z-ADD     0             PMDBSE
     C                   MOVE      *BLANKS       PMERCD
     C                   MOVE      'Y'           PMFRST
     C                   MOVE      'N'           PMVALO
     C                   Z-ADD     BJRDNB        PMRUND

      ** Determine if pay & receive settlement screen will be protected

     C     @OPSEL        IFEQ      'N'
     C                   MOVE      'Y'           PMPRCV
     C                   MOVE      'Y'           PMPPAY
     C                   ELSE
     C                   MOVE      'N'           PMPRCV
     C                   MOVE      'N'           PMPPAY
     C                   ENDIF

      ** Set settlement details valid flag

     C                   MOVE      'N'           PMSDTV

      ** Move settlement file fields to screen fields

     C                   EXSR      SET_FL2SC
      *
     C     EDETP@S       ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Move settlement file fields to screen fields (SETLIAB/SETLIAZ)*
      *****************************************************************
     C     SET_FL2SC     BEGSR

     C                   CALLB     'LESTFL2SC'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM                    RetCodeIn

      * File Receive instructions
     C                   PARM                    F_REC

      * File Payment instructions
     C                   PARM                    F_PAY
      *
      * OUTPUTS
      *
      * Screen receive and payment instructions
     C                   PARM                    SETLIB
     C                   PARM                    SETLIZ

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Move settlement screen fields to file fields                  *
      *****************************************************************
     C     SET_SC2FL     BEGSR

     C                   CALLB     'LESTSC2FL'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM                    RetCodeIn

      * Screen receive and payment instructions
     C                   PARM                    SETLIB
     C                   PARM                    SETLIZ
      *
      * OUTPUTS
      *

      * File Receive instructions
     C                   PARM                    F_REC

      * File Payment instructions
     C                   PARM                    F_PAY

     C**********         MOVEL     F_REC         V_REC                                        CGL029
     C**********         MOVEL     F_PAY         V_PAY                                        CGL029
     C                   MOVEL     F_RECEx       V_REC                                        CGL029
     C                   MOVEL     F_FLRSTM      FPRSTM                                       CGL029
     C                   MOVEL     F_FLRONS      V_RECEx                                      CGL029
     C                   MOVEL     F_PayEx       V_PAY                                        CGL029
     C                   MOVEL     F_FLPSTM      FPPSTM                                       CGL029
     C                   MOVEL     F_FLPONS      V_PayEx                                      CGL029
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     F_FLREXR      FPREXR                                       CLE031
     C                   Z-ADD     F_FLPEXR      FPPEXR                                       CLE031
     C                   MOVE      F_FLREXI      FPREXI                                       CLE031
     C                   MOVE      F_FLPEXI      FPPEXI                                       CLE031
     C                   MOVE      F_FLRSCY      FPSCCY                                       CLE031
     C                   MOVE      F_FLPSCY      FPPSCY                                       CLE031
     C                   ENDIF                                                                CLE031

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Access Primary Facility                                       *
      *****************************************************************
     C     ACSPFA        BEGSR

     C                   CALLB     'LE002510'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM      *BLANK        RetCodeIn

      * Mode
     C                   PARM                    P#MODE            1

      * Primary facility customer, type & number
     C                   PARM                    S#PMFC            6
     C                   PARM                    S#PMFT            3
     C                   PARM                    S#PMFN            2
      *
      * OUTPUTS
      *

      * Prime Facility amount
      * Prime Facility branch
      * Prime Facility branch details
      * Prime Facility currency
      * Prime Facility currency decimal places
      * Prime Facility tranche/credit agreement ind
      * Prime Facility credit agreement customer, type & number
     C                   PARM                    W#FAMT           13 0
     C                   PARM                    FcbrBranch        3
     C                   PARM                    FcbrBICN          6
     C                   PARM                    FcbrMQSM         10
     C**********         PARM                    FcbrSYCU          6 0                        CSD027
     C                   PARM                    FcbrSYCU          6                          CSD027
     C                   PARM                    FccyFCCY          3
     C                   PARM                    FccyNBDP          1 0
     C                   PARM                    FctrTRCA          2
     C**********         PARM                    FccaCANM          6 0                        CSD027
     C                   PARM                    FccaCANM          6                          CSD027
     C                   PARM                    FccaCAFT          3 0
     C                   PARM                    FccaCAFN          2 0

      * Primary customer name & town
     C                   PARM                    S#PRNM           20
     C                   PARM                    S#PRTN           10

      * Agent customer number, name & town
     C                   PARM                    S#ANUM            6
     C                   PARM                    S#CRNM           20
     C                   PARM                    S#CRTN           10

      * Primary facility amount edited
     C                   PARM                    S#FAMT           14

      * Field OK flags
     C                   PARM                    S#PMFCOK          1
     C                   PARM                    S#PMFTOK          1
     C                   PARM                    S#PMFNOK          1
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      *zero         Idx
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      *zero         WIdx

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * RTVTRAN - RETRIVE TRANSACTION
      *****************************************************************
     C     RTVTRAN       BEGSR

     C                   CALLB     'LEFPRTRTV'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM      *BLANK        RetCodeIn

      * Mode
     C                   PARM                    P#MODE            1
      * Response mode
     C                   PARM      'S'           RESPMODE          1

      * Action, customer, facility type and facility number
     C                   PARM                    S#ACTN
     C                   PARM                    S#CSSN
     C                   PARM                    S#FACT
     C                   PARM                    S#FCNO

      * Primary facility customer, type & number
     C                   PARM                    S#PMFC
     C                   PARM                    S#PMFT
     C                   PARM                    S#PMFN
      *
      * OUTPUTS

      * Facility Details in file format
     C                   PARM                    FCLTYFMFmt

      * Action, customer, facility type and facility number OK indicators
     C                   PARM                    S#ACTNok
     C                   PARM                    S#CSSNok
     C                   PARM                    S#FACTok
     C                   PARM                    S#FCNOok

      * Customer number
     C                   PARM                    S#CNUM            6
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM      *zero         Idx

      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Set screen error indicators                                   *
      *****************************************************************
     C     SET_SCEI      BEGSR

      * Move 'OK' flags into array (for checking)

     C                   MOVEA     FPRT_OK       #EI

      * Set screen error indicators according to status of 'OK' flags

     C                   Z-ADD     2             #C                2 0
     C                   Z-ADD     41            #E                2 0
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
     C                   SETOFF                                       414243
     C                   SETOFF                                       444546
     C                   SETOFF                                       474849
     C                   SETOFF                                       505152
     C                   SETOFF                                       535455
     C                   SETOFF                                       565758
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
      ** Initialize program name
      *
     C                   MOVEL     'LEFPRTRPR'   DBPGM
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

     C* Override FCLTYXFN
     C                   Z-ADD     50            MESLEN           15 5
     C                   CALL      'QCMDEXC'
     C                   PARM                    ##OX1
     C                   PARM                    MESLEN
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

      * Disable settlements screen
     C                   MOVE      *OFF          *IN69

      ** SETLIAZ parameters

     C                   MOVE      BGRTBN        PMRETP
     C                   MOVE      BMRANR        PMRETS

      * Message file
     C                   MOVEL     'LERMSGF   '  ZAMSGF

      ** Message Type
     C                   MOVEL     'FPRT'        @MSGTYPE          4
     C                   MOVEL     'LEFPRT'      @XMSGTYP         32

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
      *                                                                                       CLE031
      ** Determine if Settlement Currency is installed                                        CLE031
      *                                                                                       CLE031
     C                   MOVE      'N'           CLE031            1                          CLE031
     C                   CALLB     'AOSARDR0'                                                 CLE031
     C                   PARM      *BLANKS       PRTCD                                        CLE031
     C                   PARM      '*VERIFY'     POPTN                                        CLE031
     C                   PARM      'CLE031'      PSARD             6                          CLE031
                                                                                              CLE031
     C     PRTCD         IFEQ      *BLANKS                                                    CLE031
     C                   MOVE      'Y'           CLE031                                       CLE031
     C                   ENDIF                                                                CLE031
      *
      * Key Lists
      *
     C     ZATRNK        KLIST
     C                   KFLD                    ABFOTRNID
     C                   KFLD                    @XTMSTSEL
     C     LEIFPRTK      KLIST
     C                   KFLD                    @XREPNSEL
     C                   KFLD                    @XTMSTSEL
     C     LEIFPRTX      KLIST
     C                   KFLD                    @XREPNSEL
     C                   KFLD                    @XTMSTSEL
     C     APILSETK      KLIST
     C                   KFLD                    @XMSGTYP
     C                   KFLD                    @XTMSTSEL
     C                   KFLD                    DDFRNT
     C     APILSETX      KLIST
     C                   KFLD                    @XMSGTYP
     C                   KFLD                    DDFRNT
     C                   KFLD                    @XTMSTSEL

     C     KAPLOG        KLIST
     C                   KFLD                    KMsgType
     C                   KFLD                    KFrntOffID
     C                   KFLD                    KTimeStamp

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
** ##OX1
OVRDBF FILE(FCLTYXFN) TOFILE(FCLTY) SHARE(*NO)
