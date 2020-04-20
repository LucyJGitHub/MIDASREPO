     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Outgoing payments read')                      *
      *****************************************************************
      *                                                               *
      *  Midas - API Funds Transfer Module                            *
      *                                                               *
      *  FTOPAYRED - Outgoing Payments READ                           *
      *                                                               *
      *  Function:  This module reads forwards and backwards          *
      *             through the Outgoing Payments file.               *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD048836           Date 07Dec17               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 AR787620           Date 10Jun11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CFT032             Date 11Sep06               *
      *                 CDL049             Date 06Jul06               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 15Nov00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 175479             Date 23May00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP031  *CREATE    Date 17May99               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD048836 - Function buttons are not working after F8 or F7   *
      *             are clicked/pressed on OPAY screen                *
      *  MD046248 - Finastra Rebranding                               *
      *  AR787620 - Hooks Incorporation                               *
      *             WNCPYSRC,FTH00055                                 *
      *             WNCPYSRC,FTH00056                                 *
      *             WNCPYSRC,FTH00057                                 *
      *             WNCPYSRC,FTH00058                                 *
      *  CFT032 - Account Line in Field 50X in MT103 (Recompile)      *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CFT009 - Funds Transfer Fees and Charges - recompile         *
      *  175479 - Recompile over changes in outgoing payment file     *
      *  CAP031 - Conversion of FT inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      * Trades file
     FOTPAY     IF   E           K DISK    INFSR(*PSSR)

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
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
 
     D                 DS
     D*     REDEFINE IPREF FOR VALIDATION
     D  IPREF                  1     15
     D  P                      1      1
     D  Rundate                2      7
     D  PaymtRef               8     11
     D  PmntType              12     13
     D  StmtType              14     15
     D*
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D/COPY WNCPYSRC,FTH00055
 
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
     C                   MOVEL     *BLANK        @PRRED
      *
      * CHECK FOR USER AUTHORITY TO BROWSE IF NOT MULTI-BRANCHING
      *
     C     BJSBRC        IFNE      *BLANK
     C                   EXSR      CHAUTN
     C                   END
      *
      * VALIDATE PAYMENT REF. (FOR POINTER)
      *
     C                   EXSR      VALPRF
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
      * RDFWD - READ FORWARDS THROUGH OUTGOING PAYMENTS FILE
      *****************************************************************
     C     RDFWD         BEGSR
      *
      * Position to current record on file
      *
     C     @@PREF        SETGT     OTPAY
      *
      * Read until end of file or a valid record is found or an error
      *
     C     *IN99         DOUEQ     '1'
     C     @@ERR         OREQ      *ZERO                                                    MD048836
     C*****PREF*         ORNE      *BLANKS                                                  MD048836
     C*****@@ERR         ANDEQ     *ZERO                                                    MD048836
     C*****AUIN*         ANDNE     'Y'                                                      MD048836
     C*****RECI*         ANDEQ     'D'                                                      MD048836
      *
      * Read
     C                   READ      OTPAY                                  99
      *
      * If multi-branching, check if authorized to look at trade (based
      *  on branch) but if invalid continue searching for valid branch
      *
     C     BJSBRC        IFEQ      *BLANK
     C                   CALL      'ZVACTBU'
     C                   PARM      'E'           ZACTN
     C                   PARM                    BRCA
     C                   PARM                    @@ERR
     C                   END
      *
     C                   END
      *
      * If end of file was encountered, report this fact
      *
     C     *IN99         IFEQ      '1'
     C     SPREF         IFEQ      *BLANKS
     C                   MOVEL     'MMM1006'     @ERRMS
     C                   ELSE
     C                   MOVEL     'MMM1002'     @ERRMS
     C                   END
      *
      * Else, return the payment reference read
      *
     C                   ELSE
     C                   MOVE      PREF          @PRRED
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDBCK - READ BACKWARDS THROUGH TRADES FILE
      *****************************************************************
     C     RDBCK         BEGSR
      *
      * Position to current record on file
      *
     C     @@PREF        SETLL     OTPAY
      *
      * Read until end of file or a valid record is found or an error
      *
     C     *IN99         DOUEQ     '1'
     C     @@ERR         OREQ      *ZERO                                                    MD048836
     C*****PREF*         ORNE      *BLANKS                                                  MD048836
     C*****@@ERR         ANDEQ     *ZERO                                                    MD048836
     C*****AUIN*         ANDNE     'Y'                                                      MD048836
     C*****RECI*         ANDEQ     'D'                                                      MD048836
      *
      * Read file
      *
     C                   READP     OTPAY                                  99
      *
      * If multi-branching, check if authorized to look at trade (based
      *  on branch) but if invalid continue searching for valid branch
      *
     C     BJSBRC        IFEQ      *BLANK
     C                   CALL      'ZVACTBU'
     C                   PARM      'E'           ZACTN
     C                   PARM                    BRCA
     C                   PARM                    @@ERR
     C                   END
      *
     C                   END
      *
      * If start of file was encountered, report this fact
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     'MMM1003'     @ERRMS
      *
      * Else, return the trade reference read
      *
     C                   ELSE
     C                   MOVE      PREF          @PRRED
     C                   END
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
     C                   MOVEL     'FXM0292'     @ERRMS
     C                   RETURN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALPRF - VALIDATE TRADE REFERENCE POINTER
      *****************************************************************
     C     VALPRF        BEGSR
      *
      **  Validate that the Payment ref is correct format or blank.
      *
     C     SPREF         IFNE      *BLANKS
     C/COPY WNCPYSRC,FTH00332
      *
     C                   MOVE      SPREF         IPREF
      *
     C/COPY WNCPYSRC,FTH00056
     C                   TESTN                   Rundate              96
     C                   TESTN                   PaymtRef             97
     C                   TESTN                   StmtType             98
      *
     C     P             IFNE      'P'
     C     PmntType      ORNE      'OP'
     C     PmntType      ANDNE     'RP'
     C     *IN96         ORNE      '1'
     C     *IN97         ORNE      '1'
     C     *IN98         ORNE      '1'
      *
     C                   MOVEL     'MMA1066'     @ERRMS
     C                   RETURN
     C                   END
     C/COPY WNCPYSRC,FTH00057
      *
     C                   END
      *
     C                   MOVE      SPREF         @@PREF           15
      *
     C                   ENDSR
     C********************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      *
     C     *ENTRY        PLIST
      *
      * INPUT PARAMETERS :
      * Return Code
      * Action Code
      * Trade Ref. pointer
      * Read Forwards
      * Read Backwards
     C                   PARM                    RetCodeIn
     C                   PARM                    SACTION           1
     C                   PARM                    SPREF            15
     C                   PARM                    @RDFWD            1
     C                   PARM                    @RDBCK            1
      * OUTPUT PARAMETERS :
      * Error meassage
      * Trade Ref. Read
     C                   PARM                    @ERRMS            7
     C                   PARM                    @PRRED           15
      *
      ** Initialize program name
      *
     C                   MOVEL     'FTOPAYRED'   DBPGM
     C/COPY WNCPYSRC,FTH00333
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
     C/COPY WNCPYSRC,FTH00058
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
(c) Finastra International Limited 2001
