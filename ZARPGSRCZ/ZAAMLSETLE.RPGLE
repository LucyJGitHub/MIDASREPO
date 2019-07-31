     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas ZA AML settlement extract for lending module')
      *****************************************************************
      *                                                               *
      *  Midas - Lending Module                                       *
      *                                                               *
      *  ZAAMLSETLE - AML Settlement Extract for Lending Module       *
      *                                                               *
      *  Function:  This program will be used to extract the Lending  *
      *             settlement fields to be used in Account History   *
      *             export in AML.                                    *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL020   *CREATE   Date 12Dec02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL020 - Compliance Watch - Additional A/C Postings          *
      *           Information                                         *
      *                                                               *
      *****************************************************************
 
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
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
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** External Data Structure for Customer Details
 
     D SDCNST        E DS                  EXTNAME(SDCNSTPD)
      ** External Data Structure for Counterparty Nostro
 
     D SDLOCN        E DS                  EXTNAME(SDLOCNPD)
      ** External Data Structure for Location Codes
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Programs, Short Data Structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for Access Programs, Long Data Structure
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Parameters
     D*PROCN****       S              6S 0                                                    CSD027
     D*PROBN****       S              6S 0                                                    CSD027
     D*PPOCN****       S              6S 0                                                    CSD027
     D*PPOBN****       S              6S 0                                                    CSD027
     D PROCN           S              6A                                                      CSD027
     D PROBN           S              6A                                                      CSD027
     D PPOCN           S              6A                                                      CSD027
     D PPOBN           S              6A                                                      CSD027
     D PBENN           S              8A
     D PBENA           S             35A
     D PAWBN           S              8A
     D PAWBA           S             35A
     D PRACT           S             20A
     D PRCTY           S              2A
     D PRBNK           S             20A
     D PRCDE           S             11A
     D PPACT           S             20A
     D PPCTY           S              2A
     D PPBNK           S             20A
     D PPCDE           S             11A
     D PDACT           S             35A
     D PDCTY           S              2A
     D PDBNK           S             20A
 
     D PRTCD           S              7A
     D POPTN           S              7A
     D PKEY1           S             10A
     D PKYST           S              7A
     D WIDX            S              3P 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C                   EXSR      SRINIT
 
     C                   EXSR      SRRECORIGIN
 
     C                   EXSR      SRPAYORIGIN
 
     C                   EXSR      SRDEST
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRECORIGIN - Format Receipt Settlement Output Fields         *
      *                                                               *
      *****************************************************************
 
     C     SRRECORIGIN   BEGSR
 
      ** Format Receipt Origin Bank
 
     C**********         IF        PROBN <> 0                                                 CSD027
     C                   IF        PROBN <> *BLANKS                                           CSD027
     C                   MOVEL     PROBN         PRBNK
     C                   ENDIF
 
     C**********         IF        PROCN <> 0                                                 CSD027
     C                   IF        PROCN <> *BLANKS                                           CSD027
 
      ** Format Receipt Origin Country
 
     C                   EVAL      PKEY1 = *BLANKS
     C                   MOVEL     PROCN         PKEY1
 
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PKEY1
     C                   PARM      *BLANKS       PKYST
     C     SDCUST        PARM      SDCUST        DSSDY
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBKEY = PKEY1
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBASE = 1
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      PRCTY = BBCOLC
     C                   ENDIF
 
      ** Format Receipt Origin Code
 
     C                   IF        BBCSID <> *BLANKS
     C                   EVAL      PRCDE = BBCSID
     C                   ELSE
     C                   MOVEL     PROCN         PRCDE
     C                   ENDIF
 
     C                   GOTO      ENDREC
 
     C                   ENDIF
 
     C**********         IF        PROBN <> 0                                                 CSD027
     C                   IF        PROBN <> *BLANKS                                           CSD027
 
      ** Format Receipt Origin Country
 
     C                   EVAL      PKEY1 = *BLANKS
     C                   MOVEL     PROBN         PKEY1
 
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PKEY1
     C                   PARM      *BLANKS       PKYST
     C     SDCUST        PARM      SDCUST        DSSDY
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBKEY = PKEY1
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBASE = 2
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      PRCTY = BBCOLC
     C                   ENDIF
 
      ** Format Receipt Origin Code
 
     C                   IF        BBCSID <> *BLANKS
     C                   EVAL      PRCDE = BBCSID
     C                   ELSE
     C                   MOVEL     PROBN         PRCDE
     C                   ENDIF
 
     C                   ENDIF
 
     C     ENDREC        ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPAYORIGIN - Format Pay Settlement Output Fields             *
      *                                                               *
      *****************************************************************
 
     C     SRPAYORIGIN   BEGSR
 
      ** Format Pay Origin Bank
 
     C**********         IF        PPOBN <> 0                                                 CSD027
     C                   IF        PPOBN <> *BLANKS                                           CSD027
     C                   MOVEL     PPOBN         PPBNK
     C                   ENDIF
 
     C**********         IF        PPOCN <> 0                                                 CSD027
     C                   IF        PPOCN <> *BLANKS                                           CSD027
 
      ** Format Pay Origin Country
 
     C                   EVAL      PKEY1 = *BLANKS
     C                   MOVEL     PPOCN         PKEY1
 
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PKEY1
     C                   PARM      *BLANKS       PKYST
     C     SDCUST        PARM      SDCUST        DSSDY
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBKEY = PKEY1
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBASE = 3
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      PPCTY = BBCOLC
     C                   ENDIF
 
      ** Format Pay Origin Code
 
     C                   IF        BBCSID <> *BLANKS
     C                   EVAL      PPCDE = BBCSID
     C                   ELSE
     C                   MOVEL     PPOCN         PPCDE
     C                   ENDIF
 
     C                   GOTO      ENDPAY
 
     C                   ENDIF
 
     C**********         IF        PPOBN <> 0                                                 CSD027
     C                   IF        PPOBN <> *BLANKS                                           CSD027
 
      ** Format Pay Origin Country
 
     C                   EVAL      PKEY1 = *BLANKS
     C                   MOVEL     PPOBN         PKEY1
 
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PKEY1
     C                   PARM      *BLANKS       PKYST
     C     SDCUST        PARM      SDCUST        DSSDY
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBKEY = PKEY1
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBASE = 4
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      PPCTY = BBCOLC
     C                   ENDIF
 
      ** Format Pay Origin Code
 
     C                   IF        BBCSID <> *BLANKS
     C                   EVAL      PPCDE = BBCSID
     C                   ELSE
     C                   MOVEL     PPOBN         PPCDE
     C                   ENDIF
 
     C                   ENDIF
 
     C     ENDPAY        ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDEST - Format Destination Fields                            *
      *                                                               *
      *****************************************************************
 
     C     SRDEST        BEGSR
 
      ** Format Destination Account
 
     C                   EVAL      WIDX = 0
 
     C                   IF        PBENA <> *BLANKS
     C                   SELECT
     C                   WHEN      %SUBST(PBENA:1:2) = '//'
     C                   EVAL      WIDX = 3
     C                   WHEN      %SUBST(PBENA:1:1) = '/'
     C                   EVAL      WIDX = 2
     C                   OTHER
     C                   EVAL      WIDX = 1
     C                   ENDSL
     C                   EVAL      PDACT = %SUBST(PBENA:WIDX)
 
     C                   ELSE
     C                   SELECT
     C                   WHEN      %SUBST(PAWBA:1:2) = '//'
     C                   EVAL      WIDX = 3
     C                   WHEN      %SUBST(PAWBA:1:1) = '/'
     C                   EVAL      WIDX = 2
     C                   OTHER
     C                   EVAL      WIDX = 1
     C                   ENDSL
     C                   EVAL      PDACT = %SUBST(PAWBA:WIDX)
     C                   ENDIF
 
      ** Format Destination Country and Destination Bank
 
     C                   IF        PBENN <> *BLANKS
 
     C                   EVAL      PDBNK = PBENN
     C                   EVAL      PKEY1 = *BLANKS
     C                   EVAL      PKEY1 = PBENN
 
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PKEY1
     C                   PARM      *BLANKS       PKYST
     C     SDCUST        PARM      SDCUST        DSSDY
 
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      PDCTY = BBCOLC
     C                   GOTO      ENDDEST
     C                   ENDIF
 
      ** Check if Beneficiary is a Counterparty Nostro
 
     C                   CALL      'AOCNSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PBENN
     C     SDCNST        PARM      SDCNST        DSFDY
 
     C                   IF        PRTCD = *BLANKS
 
     C                   IF        AWSWID <> *BLANKS
     C                   EVAL      PDCTY = (%SUBST(AWSWID:5:2))
     C                   GOTO      ENDDEST
     C                   ENDIF
 
     C                   IF        AWCSN2 <> *BLANKS
 
     C                   CALL      'AOLOCNR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    AWCSN2
     C     SDLOCN        PARM      SDLOCN        DSFDY
 
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      PDCTY = DVCNCD
     C                   GOTO      ENDDEST
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** If Account with Bank is not blank
 
     C                   IF        PAWBN <> *BLANKS
 
     C                   EVAL      PKEY1 = *BLANKS
     C                   EVAL      PKEY1 = PAWBN
 
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PKEY1
     C                   PARM      *BLANKS       PKYST
     C     SDCUST        PARM      SDCUST        DSSDY
 
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      PDCTY = BBCOLC
     C                   ELSE
 
     C                   CALL      'AOCNSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PAWBN
     C     SDCNST        PARM      SDCNST        DSFDY
 
     C                   IF        PRTCD = *BLANKS
 
     C                   IF        AWSWID <> *BLANKS
     C                   EVAL      PDCTY = (%SUBST(AWSWID:5:2))
     C                   ELSE
 
     C                   IF        AWCSN2 <> *BLANKS
 
     C                   CALL      'AOLOCNR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    AWCSN2
     C     SDLOCN        PARM      SDLOCN        DSFDY
 
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      PDCTY = DVCNCD
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        PDCTY <> *BLANKS or PDBNK = *BLANKS
     C                   EVAL      PDBNK = PAWBN
     C                   ENDIF
 
     C                   ENDIF
 
     C     ENDDEST       ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRINIT - Initialisation Subroutine                            *
      *                                                               *
      *****************************************************************
 
     C     SRINIT        BEGSR
 
      ** Initialise output
 
     C                   EVAL      PRACT = *BLANKS
     C                   EVAL      PRCTY = *BLANKS
     C                   EVAL      PRBNK = *BLANKS
     C                   EVAL      PRCDE = *BLANKS
     C                   EVAL      PPACT = *BLANKS
     C                   EVAL      PPCTY = *BLANKS
     C                   EVAL      PPBNK = *BLANKS
     C                   EVAL      PPCDE = *BLANKS
     C                   EVAL      PDACT = *BLANKS
     C                   EVAL      PDCTY = *BLANKS
     C                   EVAL      PDBNK = *BLANKS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation Routine                       *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PROCN
     C                   PARM                    PROBN
     C                   PARM                    PPOCN
     C                   PARM                    PPOBN
     C                   PARM                    PBENN
     C                   PARM                    PBENA
     C                   PARM                    PAWBN
     C                   PARM                    PAWBA
     C                   PARM                    PRACT
     C                   PARM                    PRCTY
     C                   PARM                    PRBNK
     C                   PARM                    PRCDE
     C                   PARM                    PPACT
     C                   PARM                    PPCTY
     C                   PARM                    PPBNK
     C                   PARM                    PPCDE
     C                   PARM                    PDACT
     C                   PARM                    PDCTY
     C                   PARM                    PDBNK
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILENE
 
     C                   RETURN
     C                   ENDSR
      *****************************************************************
