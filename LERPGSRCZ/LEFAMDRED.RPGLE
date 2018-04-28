     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Facility amendement read')
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LEFAMDRED - Facility Amendement Read                         *
      *                                                               *
      *  Function:  This module reads forwards and backwards          *
      *             through the Facility files                        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CAP086             Date 07Jul05               *
      *                 CSW037A            Date 02May05               *
      *                 CLE041             Date 11Oct04               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CAP084   *CREATE   Date 21Jun02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it (Recompile)                              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CLE041 - Collateralised Lending Phase 2B                     *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CAP084 Developped for LEFAMDR                                *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FLEFCAML3  IF   E           K DISK
     F                                     RENAME(LEFCAMPF:LEFCAMP3)
     F                                     PREFIX(FA_)
                                                                                              CLE041
     FLEAGAML4  IF   E           K DISK    INFSR(*PSSR)                                       CLE041
     F                                     RENAME(LEFCAMPF:LEAGAMD3)                          CLE041
     F                                     PREFIX(FA_)                                        CLE041
 
      *****************************************************************
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
 
      ** Include the FX standard declares
     D/COPY FXCPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
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
     DOutCustShtNm     S                   LIKE(S#CSSN)
     DOutFacility      S                   LIKE(S#FACT)
     DOutFctyNumb      S                   LIKE(S#FCNO)
     DOutFctyType      S                   LIKE(S#FATP)
     DOutValueDte      S                   LIKE(S#VLDT)
     DOutSeqNumb       S                   LIKE(S#SQNO)
 
     D*K#CNUM***       S              6  0                                                    CSD027
     D K#CNUM          S              6A                                                      CSD027
     D K#FACT          S              3  0
     D K#FCNO          S              2  0
     D K#VLDT          S              5  0
     D K#SQNO          S              3  0
                                                                                              CLE041
     D CLE025          S              1    INZ('N')                                           CLE041
                                                                                              CLE041
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
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
      *
      * INITIALIZE OUTPUTS
      *
     C                   MOVEL     *BLANK        @ERRMS
     C                   MOVEL     *BLANK        OutCustShtNm
     C                   MOVEL     *BLANK        OutFacility
     C                   MOVEL     *BLANK        OutFctyNumb
     C                   MOVEL     *BLANK        OutFctyType
     C                   MOVEL     *BLANK        OutValueDte
     C                   MOVEL     *BLANK        OutSeqNumb
      *
      * Check for user authority to browse if not multi-branching
      *
     C     BJSBRC        IFNE      *BLANK
     C                   EXSR      CHAUTN
     C                   END
      *
      * Validate customer, facility type and facility number
      *
     C                   EXSR      VLCFTFN
      *
      * READ FORWARDS
      *
     C     @RDFWD        IFEQ      'Y'
     C                   EXSR      RDFWD
     C                   ELSE
      *
      * READ BACKWARDS
      *
     C     @RDBCK        IFEQ      'Y'
     C                   EXSR      RDBCK
     C                   END
     C                   END
      *
      * Return
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDFWD - READ FORWARDS THROUGH DEALS FILE
      *****************************************************************
     C     RDFWD         BEGSR
      *
      * Position to current record on file
      *
     C                   EXSR      INIKEY
     C                   IF        CLE025 = 'Y'                                               CLE041
     C     FCAMK         SETGT     LEAGAML4                                                   CLE041
     C                   ELSE                                                                 CLE041
     C     FCAMK         SETGT     LEFCAML3
     C                   ENDIF                                                                CLE041
      *
      * Read until end of file or a valid record is found or an error
      *
     C     *IN99         DOUEQ     '1'
     C     @@ERR         OREQ      0
     C                   Z-ADD     0             @@ERR
      *
     C                   IF        CLE025 = 'Y'                                               CLE041
     C                   READ      LEAGAML4                               99                  CLE041
     C                   ELSE                                                                 CLE041
     C                   READ      LEFCAML3                               99
     C                   ENDIF                                                                CLE041
      *
      * If multi-branching, check if authorized to look at facility (based
      * on branch) but if invalid continue searching for valid branch
      *
     C     BJSBRC        IFEQ      *BLANK
     C                   CALL      'ZVACTBU'
     C                   PARM      'E'           ZACTN
     C                   PARM                    FA_BRCA
     C                   PARM                    @@ERR
     C                   END
      *
      * Select only the non authorised facilities if action code is
      * authorisation
     C     S#ACTN        IFEQ      'X'
     C     FA_ASTS       ANDEQ     'A'
     C                   Z-ADD     1             @@ERR
     C                   ENDIF
      *
     C                   ENDDO
      *
      * If end of file was encountered, report this fact
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     'LEF0304'     @ERRMS
      *
      * Else, return the facility read
      *
     C                   ELSE
     C                   EXSR      MapOutput
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIKEY - Initialise Key field  DEALS FILE
      *****************************************************************
     C     INIKEY        BEGSR
     C                   MOVEL     S#CSSN        K#CNUM
     C                   MOVEL     S#FACT        K#FACT
     C                   MOVEL     S#FCNO        K#FCNO
     C                   MOVEL     S#SQNO        K#SQNO
 
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     S#VLDT        ZFIELD
     C                   Z-ADD     0             ZADEC
     C                   Z-ADD     6             ZADIG
     C                   EXSR      ZALIGN
     C     ZALIGNok      IFEQ      'Y'
     C                   MOVE      ZFIELD        ZDATEI
     C                   EXSR      ZDATE1
     C                   END
     C     ZALIGNok      IFEQ      'N'
     C     ErrorFlag     OREQ      'Y'
     C                   Z-ADD     *ZERO         K#VLDT
     C                   ELSE
     C                   Z-ADD     ZDAYNO        K#VLDT
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ZDATE1 - Convert to Midas day number
      *****************************************************************
     C     ZDATE1        BEGSR
     C                   CALLB     'ZDATE1'
     C                   PARM                    ZDATEI            6
     C                   PARM      *ZEROS        ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM      'N'           ErrorFlag         1
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDBCK - READ BACKWARDS THROUGH DEALS FILE
      *****************************************************************
     C     RDBCK         BEGSR
      *
      * Position to current record on file
      *
     C                   EXSR      INIKEY
     C                   IF        CLE025 = 'Y'                                               CLE041
     C     FCAMK         SETLL     LEAGAML4                                                   CLE041
     C                   ELSE                                                                 CLE041
     C     FCAMK         SETLL     LEFCAML3
     C                   ENDIF                                                                CLE041
      *
      * Read until end of file or a valid record is found or an error
      *
     C     *IN99         DOUEQ     '1'
     C     @@ERR         OREQ      0
     C                   Z-ADD     0             @@ERR
      *
     C                   IF        CLE025 = 'Y'                                               CLE041
     C                   READP     LEAGAML4                               99                  CLE041
     C                   ELSE                                                                 CLE041
     C                   READP     LEFCAML3                               99
     C                   ENDIF                                                                CLE041
      *
      * If multi-branching, check if authorized to look at facility (based
      * on branch) but if invalid continue searching for valid branch
      *
     C     BJSBRC        IFEQ      *BLANK
     C                   CALL      'ZVACTBU'
     C                   PARM      'E'           ZACTN
     C                   PARM                    FA_BRCA
     C                   PARM                    @@ERR
     C                   END
      *
      * Select only the non authorised facilities if action code is
      * authorisation
     C     S#ACTN        IFEQ      'X'
     C     FA_ASTS       ANDEQ     'A'
     C                   Z-ADD     1             @@ERR
     C                   ENDIF
      *
     C                   ENDDO
      *
      * If end of file was encountered, report this fact
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     'LEF0304'     @ERRMS
      *
      * Else, return the facility read
      *
     C                   ELSE
     C                   EXSR      MapOutput
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CHAUTN - CHECK FOR USER AUTHORITY IF NOT MULTI-BRANCHING
      *****************************************************************
     C     CHAUTN        BEGSR
      *
     C                   CALL      'ZVACTU'
     C                   PARM      'E'           ZACTN             1
     C                   PARM                    @@ERR             1 0
      *
      * RETURN ERROR MESSAGE
      *
     C     @@ERR         IFEQ      1
     C                   MOVEL     'LEF0001'     @ERRMS
     C                   RETURN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      ***********************************************************
      * Validate customer, facility type and facility number
      ***********************************************************
     C     VLCFTFN       BEGSR
 
     C     S#CSSN        IFEQ      *BLANKS
     C                   MOVEL     '000000'      S#CSSN
 
     C                   ELSE
 
      ** Customer number must refer to a valid customer
 
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY    '    @OPTN             7
     C                   PARM      S#CSSN        @KEY1            10
     C                   PARM                    @KYST             7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     'LEF0214'     @ERRMS
     C                   ELSE
 
     C                   MOVEL     *BLANK        S#CSSN
     C                   MOVEL     BBCUST        S#CSSN
     C                   ENDIF
 
     C                   ENDIF
 
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     S#FACT        ZFIELD
     C                   Z-ADD     0             ZADEC
     C                   Z-ADD     3             ZADIG
     C                   EXSR      ZALIGN
 
     C     ZALIGNok      IFNE      'Y'
     C                   MOVEL     'LEF0004'     @ERRMS
     C                   ELSE
     C                   MOVE      ZFIELD        S#FACT
     C                   ENDIF
 
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     S#FCNO        ZFIELD
     C                   Z-ADD     0             ZADEC
     C                   Z-ADD     2             ZADIG
     C                   EXSR      ZALIGN
 
     C     ZALIGNok      IFNE      'Y'
     C                   MOVEL     'LEF0005'     @ERRMS
     C                   ELSE
     C                   MOVE      ZFIELD        S#FCNO
     C                   ENDIF
 
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     S#SQNO        ZFIELD
     C                   Z-ADD     0             ZADEC
     C                   Z-ADD     3             ZADIG
     C                   EXSR      ZALIGN
 
     C     ZALIGNok      IFNE      'Y'
     C                   MOVEL     'LEF0225'     @ERRMS
     C                   ELSE
     C                   MOVE      ZFIELD        S#SQNO
     C                   ENDIF
 
      ** Exit the program if any problem
     C     @ERRMS        IFNE      *BLANK
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C     ZDATE2        BEGSR
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM      *ZEROS        ZDATE             6 0
     C                   PARM                    ZADATE            7
     C                   ENDSR
      *****************************************************************
      /EJECT
     C     MapOutput     BEGSR
     C                   Z-ADD     FA_VLDT       ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZDATE         OutValueDte
     C                   MOVE      FA_SQNO       OutSeqNumb
     C                   MOVE      FA_FACT       OutFacility
     C                   MOVE      FA_FCNO       OutFctyNumb
     C                   MOVEL     FA_FATP       OutFctyType
     C                   MOVEL     FA_CNUM       OutCustShtNm
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C     ZALIGN        BEGSR
     C                   CALLB     'ZALIGN'
     C                   PARM      'Y'           ZALIGNok          1
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
     C                   PARM                    ZADIG             2 0
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      * Parameters
      *
     C     *ENTRY        PLIST
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM                    RetCodeIn
      *
      * Action, customer, facility type, facility number, facility
      * amendment type, value date and sequence number
     C                   PARM                    S#ACTN            1
     C                   PARM                    S#CSSN           10
     C                   PARM                    S#FACT            3
     C                   PARM                    S#FCNO            2
     C                   PARM                    S#FATP            2
     C                   PARM                    S#VLDT            6
     C                   PARM                    S#SQNO            3
      *
      * Read Forward
     C                   PARM                    @RDFWD            1
      *
      * Read Backward
     C                   PARM                    @RDBCK            1
      *
      * OUTPUT PARAMETERS
      *
      * Error Message
     C                   PARM                    @ERRMS            7
      *
      * Facility number read
     C                   PARM                    OutCustShtNm
     C                   PARM                    OutFacility
     C                   PARM                    OutFctyNumb
     C                   PARM                    OutFctyType
     C                   PARM                    OutValueDte
     C                   PARM                    OutSeqNumb
      *
      ** Initialize program name
      *
     C                   MOVEL     'LEFAMDRED'   DBPGM
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE                         ************
     C                   MOVEL     '901'         DBASE                          * DBERR 901*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
                                                                                              CLE041
      ** Access Switchable SAR details for the existence of CLE025                            CLE041
                                                                                              CLE041
     C                   CALLB     'AOSARDR0'                                                 CLE041
     C                   PARM      *BLANK        @RTCD                                        CLE041
     C                   PARM      '*VERIFY'     @OPTN                                        CLE041
     C                   PARM      'CLE025'      @SARD                                        CLE041
                                                                                              CLE041
     C                   IF        @RTCD = *BLANK                                             CLE041
     C                   EVAL      CLE025 = 'Y'                                               CLE041
     C                   ENDIF                                                                CLE041
                                                                                              CLE041
      ** Database Error                                                                       CLE041
                                                                                              CLE041
     C                   IF        @RTCD <> *BLANKS AND                                       CLE041
     C                             @RTCD <> '*NRF   '                                         CLE041
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CLE041
     C                   EVAL      DBASE  = 902                                               CLE041
     C                   EVAL      DBKEY  = @SARD                                             CLE041
     C                   EXSR      *PSSR                                                      CLE041
     C                   ENDIF                                                                CLE041
      *
     C     FCAMK         KLIST
     C                   KFLD                    K#CNUM
     C                   KFLD                    K#FACT
     C                   KFLD                    K#FCNO
     C                   KFLD                    K#VLDT
     C                   KFLD                    K#SQNO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2002
