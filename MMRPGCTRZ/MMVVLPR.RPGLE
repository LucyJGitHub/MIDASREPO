     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate value price')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMVVLPR - MM Repo Details Value Price validation             *
      *                                                               *
      *  Function: This Program Validates the value price of          *
      *            entered security                                   *
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
 
     FPRICED    IF   E           K DISK    PREFIX(P_)
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
      ** External DS for bank details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** External DS for customer details
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
      ** External DS for Securities ICD Details
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short Data Structure for Access Programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Long Data Structure for Access Programs
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
 
      ** Numeric Input (also the output)
     D   ZFIELD        S             16A
 
      ** Number of decimal position
     D   ZADEC         S              1P 0
 
      * contains required number of digits before the decimal point as
      * a constant in program.
     D ZADIG           S              2P 0
 
      * returns 'Y' or 'N' depending on whether validation has been successful
     D ZALIGNok        S              1A
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
     C                   RESET                   IFVALP
      *
      ** Access Security details for security Ccy
      *
     C     IKSECT        CHAIN     SECTY                              99
     C*
     C                   IF        *IN99 = *Off
     C
     C     K#VAL         KLIST
     C                   KFLD                    K#SECT           10
     C                   KFLD                    K#PTYP            2
     C                   KFLD                    K#VDAT            5 0
     C*
     C** Set up key to PRICED file
     C                   MOVE      SESN          K#SECT
     C                   MOVEL     'V'           K#PTYP
     C                   MOVE      ValueDate     K#VDAT
      *
      ** Access Price Details
      *
     C     K#VAL         CHAIN     PRICED                             89
     C                   IF        *IN89 = *OFF and P_RECI <> 'D'
     C                   EVAL      *IN89 = *ON
     C                   ENDIF
      *
      ** Send error message if value price is blank and market price does
      ** not exist on either file.
      *
     C                   IF        IKVALP = *BLANKS and MKPR = *ZEROS
     C                             and *IN89 = *ON
     C                   MOVE      'MMA0764'     MSG1
     C                   MOVE      'Y'           ErrorFound        1
     C                   ELSE
     C
     C                   IF        IKVALP = *BLANKS
     C*
     C** Default Market Price form Price File
     C                   IF        *IN89 = *Off
     C                   MOVE      P_PPRC        ZFIELD
     C                   ELSE
     C                   MOVE      MKPR          ZFIELD
     C                   ENDIF
     C*
     C                   MOVE      8             ZADEC
     C
     C                   CALLB     'ZEDIT'
      ** Numeric Input (also the output)
     C                   PARM                    ZFIELD
      ** Number of decimal position
     C                   PARM                    ZADEC
     C*
     C** Set Screen Formatted Value Price
     C                   MOVE      ZFIELD        IKVALP
     C
     C*
     C** Set File Formatted Value Price
     C                   IF        *IN89 = *Off
     C                   Z-ADD     P_PPRC        IFVALP
     C                   ELSE
     C                   Z-ADD     MKPR          IFVALP
     C                   ENDIF
     C
     C                   ELSE
     C
     C                   MOVE      IKVALP        ZFIELD
     C                   MOVE      8             ZADEC
     C                   MOVE      5             ZADIG
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
     C
     C                   IF        ZALIGNok <> 'Y'
     C                   MOVE      'MMA0765'     MSG2
     C                   MOVE      'Y'           ErrorFound        1
     C                   ELSE
     C                   MOVE      ZFIELD        ZFLD15
     C
     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFLD15           15 0
     C                   PARM                    ZADEC
     C                   PARM      *BLANK        ZECODE            1
     C                   PARM                    ZOUT21           21
     C                   MOVE      ZOUT21        IKVALP
     C                   MOVE      ZFIELD        IFVALP
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C
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
      * Receive Control Nominal
     C                   PARM                    IKVALP           16
      * Receive Security Shortname
     C                   PARM                    IKSECT           10
     C                   PARM                    IFVALP           15 8
     C                   PARM                    ValueDate         5 0
      *
      **  Move program name into *LDA field.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'MMEXCR'      DBPGM
     C                   OUT       LDA
      *
      ** Access securities trading details
      *
     C                   CALL      'AOSTRDR0'
     C                   PARM      '*DBERR'      @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDSTRD        PARM      SDSTRD        DSSDY
     C                   ENDSR
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
