     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate Exchange Rate')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMVEXRT - MM Repo Detail Exchange Rate Validation            *
      *                                                               *
      *  Function: This Program Validates Exchange Rate Details       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CSE071             Date 19Jul05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSE006             Date 1JUne99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CSE006 - Repurchase Agreements.                              *
      *                                                               *
      *****************************************************************
 
     FSECTY     IF   E           K DISK
     F                                     INFSR(*PSSR)
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      ** Error message fields received as parameters
     D     Msg1        S                   LIKE(#MsgID)
     D     Msg2        S                   LIKE(#MsgID)
     D     Msg3        S                   LIKE(#MsgID)
 
      ** Error message substitution data received as a parameter
     D MSGDATA         S                   LIKE(#MsgData)
     D MSGDATA2        S                   LIKE(#MsgData)
     D MSGDATA3        S                   LIKE(#MsgData)
 
     D LoanCcy         S              3A
 
      *  A 16 character alphanumeric field to contain numeric input
      *  The field may contain leading and trailing blanks and a
      *  decimal point,and may have up to 15 digits.
     D ZFIELD          S             16A
     D ZFLD15          S             15  0
 
      *  contains the required number of digits before the decimal
      *  point as a constant.
     D ZADEC           S              1P 0
 
      * contains required number of digits before the decimal point as
      * a constant in program.
     D ZADIG           S              2P 0
 
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** EXTERNAL DS FOR CUSTOMER DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short Data Structure for Access Programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Long Data Structure for Access Programs
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
     C
      ** Reset the error flag to prevent problems on subsequent calls
     C                   RESET                   ErrorFound
     C                   RESET                   Msg1
     C                   RESET                   Msg2
     C                   RESET                   Msg3
     C                   RESET                   IFEXCR
     C                   RESET                   ZFIELD
     C                   RESET                   ZFLD15
      *
      ** Acces Security details for security Ccy
      *
     C     IKSECT        CHAIN     SECTY                              99
     C
      *
      ** Send error message if nominal currency differs from security
      ** currency and exchange rate has not been entered.
      *
     C                   IF        NMCY <> LoanCcy and IKEXCR = *Blanks
     C                   MOVE      'MMA0751'     MSG1
     C                   MOVE      'Y'           ErrorFound        1
     C                   ENDIF
     C*
     C** Default exchange rate to 1 if none has been entered and currencies
     C** ar ethe same.
     C                   IF        NMCY = LoanCcy and IKEXCR = *Blanks
     C                   MOVEL     '1'           IKEXCR
     C                   ENDIF
     C
     C                   IF        IKEXCR <> *Blanks
     C                   MOVE      IKEXCR        ZFIELD
     C                   Z-ADD     8             ZADEC
     C                   Z-ADD     5             ZADIG
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok          1
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
      *
      ** Send error message if exchange rate is not a valid format
      *
     C                   IF        ZALIGNok = 'N'
     C                   MOVE      'MMA0753'     MSG2
     C                   MOVE      'Y'           ErrorFound        1
     C                   ELSE
     C                   MOVE      ZFIELD        ZFLD15
     C
     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM                    ZADEC
     C                   PARM      *BLANK        ZECODE            1
     C                   PARM                    ZOUT21           21
     C
     C                   Z-ADD     0             IFEXCR
     C                   MOVE      ZFIELD        IFEXCR
     C                   MOVE      *BLANKS       IKEXCR
     C                   MOVE      ZOUT21        IKEXCR
     C                   ENDIF
     C
     C                   ENDIF
      *
      ** Send error message if exchange rate is zero
      *
     C                   IF        MSG2 = *Blanks
     C                   IF        IFEXCR = 0
     C                   MOVE      'MMA0786'     MSG2
     C                   MOVE      'Y'           ErrorFound        1
     C                   ENDIF
     C                   ENDIF
      *
      ** If currencies are the same exchange rate should be 1 if entered
      *
     C                   IF        NMCY = LoanCcy and IFEXCR <> 1
     C                   MOVE      'MMA0752'     MSG3
     C                   MOVE      'Y'           ErrorFound        1
     C                   ENDIF
      *
     C
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      ReturnCode = 'Error'
     C                   ENDIF
      *
     C                   RETURN
     C********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    MSG2
     C                   PARM                    MSG3
      * Receive exchange rate
     C                   PARM                    IKEXCR           15
      * Receive Security Shortname
     C                   PARM                    IKSECT           10
      * Receive Loan Currency
     C                   PARM                    LoanCcy
      * Receive Security Shortname
     C                   PARM                    IFEXCR           13 8
      *
      **  Move program name into *LDA field.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'MMEXCR'      DBPGM
     C                   OUT       LDA
      *
     C                   ENDSR
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
