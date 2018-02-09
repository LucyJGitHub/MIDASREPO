     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas ZA AML settlement extract for retail module')
      *****************************************************************
      *                                                               *
      *  Midas - Common Programs                                      *
      *                                                               *
      *  ZAAMLSETRE - AML Settlement Extract for Retail Module        *
      *                                                               *
      *  Function:  This program will be used to extract the Retail   *
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
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for Access Programs, Long Data Structure
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Parameters
     D*PROCN****       S              6S 0                                                    CSD027
     D*PBENN****       S              6S 0                                                    CSD027
     D PROCN           S              6                                                       CSD027
     D PBENN           S              6                                                       CSD027
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
     D WRUN            S              1A
 
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
 
     C                   EXSR      SRORIGIN
 
     C                   EXSR      SRDEST
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRORIGIN - Format Receipt Settlement Output Fields            *
      *                                                               *
      *****************************************************************
 
     C     SRORIGIN      BEGSR
 
      ** Format Receipt Origin Country
 
     C                   EVAL      PKEY1 = *BLANKS
     C                   MOVE      PROCN         PKEY1
 
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PKEY1
     C                   PARM      *BLANKS       PKYST
     C     SDCUST        PARM      SDCUST        DSSDY
 
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = PKEY1
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBASE = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      PRCTY = BBCOLC
     C                   EVAL      PPCTY = BBCOLC
     C                   ENDIF
 
      ** Format Receipt Origin Bank
 
     C                   MOVEL     PROCN         PRBNK
     C                   MOVEL     PROCN         PPBNK
 
      ** Format Receipt Origin Code
 
     C                   IF        BBCSID <> *BLANKS
     C                   EVAL      PRCDE = BBCSID
     C                   EVAL      PPCDE = BBCSID
     C                   ELSE
     C                   MOVEL     PROCN         PRCDE
     C                   MOVEL     PROCN         PPCDE
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDEST - Format Destination Fields                            *
      *                                                               *
      *****************************************************************
 
     C     SRDEST        BEGSR
 
      ** Format Destination Country and Destination Bank
 
     C                   MOVEL     PBENN         PDBNK
     C                   EVAL      PKEY1 = *BLANKS
     C                   MOVE      PBENN         PKEY1
 
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PKEY1
     C                   PARM      *BLANKS       PKYST
     C     SDCUST        PARM      SDCUST        DSSDY
 
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = PKEY1
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBASE = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      PDCTY = BBCOLC
     C                   ENDIF
 
     C                   ENDSR
 
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
     C                   PARM                    PBENN
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
      *                                                               *
      * *PSSR  - Program Exception Error Routine                      *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   IF        WRUN = *BLANKS
     C                   EVAL      WRUN = 'Y'
     C                   DUMP
 
     C                   CALL      'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
